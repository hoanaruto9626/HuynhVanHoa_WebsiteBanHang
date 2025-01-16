using PayPal.Api;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsiteBanHang.Connect;
using WebsiteBanHang.Models;

namespace WebsiteBanHang.Controllers
{
    public class ShoppingCartController : Controller
    {
        WebsiteBanHangEntities _dbContext = new WebsiteBanHangEntities();
        // GET: ShoppingCart
        public ActionResult Index()
        {
            if (Session["idUser"] == null)
            {
                return RedirectToAction("Login", "Home");
            }
            else
            {
                if (Session["cart"] == null || ((List<CartModel>)Session["cart"]).Count == 0)
                {
                    TempData["EmptyCartMessage"] = "Giỏ hàng của bạn đang trống.";
                    return RedirectToAction("Index", "Cart");  // Redirect to Home with message
                }

                //lấy thông tin từ giỏ hàng từ biến session
                var lstCart = (List<CartModel>)Session["cart"];
                decimal totalAmount = (decimal)lstCart.Sum(item => item.Quantity * item.product.Price ?? 0m);

                // Tạo đối tượng thanh toán qua PayPal
                var apiContext = PaypalConfiguration.GetAPIContext();

                try
                {
                    // URL để PayPal callback
                    string baseURI = Request.Url.Scheme + "://" + Request.Url.Authority + "/shoppingcart/PaymentWithPaypal?";
                    var guid = Convert.ToString((new Random()).Next(100000));
                    var createdPayment = CreatePayment(apiContext, baseURI + "guid=" + guid);

                    // Lấy URL để chuyển hướng đến PayPal
                    var links = createdPayment.links.GetEnumerator();
                    string paypalRedirectUrl = null;
                    while (links.MoveNext())
                    {
                        Links lnk = links.Current;
                        if (lnk.rel.ToLower().Trim().Equals("approval_url"))
                        {
                            paypalRedirectUrl = lnk.href;
                        }
                    }

                    // Lưu thông tin thanh toán vào session
                    Session.Add(guid, createdPayment.id);
                    return Redirect(paypalRedirectUrl); // Chuyển hướng tới PayPal để thực hiện thanh toán
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Có lỗi xảy ra khi thực hiện thanh toán qua PayPal.";
                    return RedirectToAction("Index", "Cart");
                }
            }
        }

        // Hàm xử lý sau khi thanh toán PayPal thành công hoặc hủy
        public ActionResult PaymentWithPaypal(string Cancel = null)
        {
            var apiContext = PaypalConfiguration.GetAPIContext();

            try
            {
                string payerId = Request.Params["PayerID"];
                if (string.IsNullOrEmpty(payerId))
                {
                    TempData["ErrorMessage"] = "Thanh toán không thành công hoặc bị hủy.";
                    return RedirectToAction("Index", "Cart");
                }
                else
                {
                    var guid = Request.Params["guid"];
                    var executedPayment = ExecutePayment(apiContext, payerId, Session[guid] as string);

                    if (executedPayment.state.ToLower() != "approved")
                    {
                        TempData["ErrorMessage"] = "Thanh toán không thành công.";
                        return RedirectToAction("Index", "Cart");
                    }

                    // Thanh toán thành công, lưu thông tin đơn hàng vào cơ sở dữ liệu
                    var lstCart = (List<CartModel>)Session["cart"];
                    decimal totalAmount = lstCart.Sum(item => item.Quantity * item.product.Price ?? 0m);

                    var order = new Connect.Order
                    {
                        UserId = Convert.ToInt32(Session["idUser"]),
                        OrderDate = DateTime.Now,
                        TotalAmount = totalAmount,
                        Status = "1",
                        ShippingAddress = "Địa chỉ giao hàng mặc định",
                        Name = "DonHang" + DateTime.Now.ToString("yyyyMMddHHmmss")
                    };

                    // Lưu thông tin đơn hàng vào cơ sở dữ liệu
                    _dbContext.Orders.Add(order);
                    _dbContext.SaveChanges();

                    // Lưu thông tin các sản phẩm trong đơn hàng
                    foreach (var item in lstCart)
                    {
                        var orderItem = new OrderItem
                        {
                            OrderId = order.Id,
                            ProductId = item.product.Id,
                            Quantity = item.Quantity,
                            Price = item.product.Price ?? 0m
                        };
                        _dbContext.OrderItems.Add(orderItem);
                    }

                    _dbContext.SaveChanges();

                    // Xử lý thông tin đơn hàng sau khi thanh toán thành công
                    Session["cart"] = null;
                    Session["count"] = null;
                    return View("Index"); // Hiển thị trang thanh toán thành công
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Có lỗi xảy ra trong quá trình thanh toán.";
                return RedirectToAction("Index", "Cart");
            }
        }

        private Payment CreatePayment(APIContext apiContext, string redirectUrl)
        {
            var itemList = new ItemList() { items = new List<Item>() };
            var lstCart = (List<CartModel>)Session["cart"];

            // Tỷ giá chuyển đổi từ VNĐ sang USD
            const decimal EXCHANGE_RATE_VND_TO_USD = 23500m;

            foreach (var item in lstCart)
            {
                // Chuyển đổi giá từ VNĐ sang USD
                decimal priceInUSD = Math.Round((item.product.Price ?? 0m) / EXCHANGE_RATE_VND_TO_USD, 2);

                itemList.items.Add(new Item()
                {
                    name = item.product.Name,
                    currency = "USD",
                    price = priceInUSD.ToString(),  // Sử dụng giá đã chuyển đổi sang USD
                    quantity = item.Quantity.ToString(),
                    sku = "sku"
                });
            }

            // Tính tổng số tiền bằng USD
            decimal subtotalInUSD = Math.Round(lstCart.Sum(i => (i.Quantity * (i.product.Price ?? 0m)) / EXCHANGE_RATE_VND_TO_USD), 2);

            var payer = new Payer() { payment_method = "paypal" };
            var redirUrls = new RedirectUrls()
            {
                cancel_url = redirectUrl + "&Cancel=true",
                return_url = redirectUrl
            };

            var details = new Details()
            {
                tax = "0",
                shipping = "0",
                subtotal = subtotalInUSD.ToString()  // Sử dụng tổng tiền bằng USD
            };

            var amount = new Amount()
            {
                currency = "USD",
                total = subtotalInUSD.ToString(),  // Tổng tiền bằng USD
                details = details
            };

            var transactionList = new List<Transaction>();
            transactionList.Add(new Transaction()
            {
                description = "Mô tả đơn hàng",
                invoice_number = DateTime.Now.Ticks.ToString(),
                amount = amount,
                item_list = itemList
            });

            var payment = new Payment()
            {
                intent = "sale",
                payer = payer,
                transactions = transactionList,
                redirect_urls = redirUrls
            };

            return payment.Create(apiContext);
        }

        private Payment ExecutePayment(APIContext apiContext, string payerId, string paymentId)
        {
            var paymentExecution = new PaymentExecution() { payer_id = payerId };
            var payment = new Payment() { id = paymentId };
            return payment.Execute(apiContext, paymentExecution);
        }
    }
}