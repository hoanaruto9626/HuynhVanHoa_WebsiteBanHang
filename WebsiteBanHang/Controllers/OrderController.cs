using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsiteBanHang.Connect;
using WebsiteBanHang.Models;

namespace WebsiteBanHang.Controllers
{
    public class OrderController : Controller
    {
        WebsiteBanHangEntities dbWebsite = new WebsiteBanHangEntities();
        // GET: Order
        public ActionResult Index()
        {
            if (Session["idUser"] == null)
            {
                return RedirectToAction("Login", "Home");
            }
            else
            {
                int userId = Convert.ToInt32(Session["idUser"]);
                //var orderIds = dbWebsite.Orders.Where(ord => ord.UserId == userId).Select(ord => ord.Id).ToList();
                var order = dbWebsite.Orders
                    .Where(item => item.UserId == userId)
                    .Select(item => new OrderViewModel
                    {
                        OrderId = item.Id,
                        OrderName = item.Name,
                        CustomerName = item.User.UserName,
                        CustomerEmail = item.User.Email,
                        CustomerPhone = item.User.PhoneNumber,
                        CustomerAddress = item.ShippingAddress,
                        TotalAmount = item.TotalAmount,
                        OrderItems = item.OrderItems.Select(oi => new OrderItemViewModel
                        {
                            ProductName = oi.Product.Name,
                            ProductImage = oi.Product.Images,
                            Quantity = oi.Quantity,
                            Price = oi.Price,
                            SubTotal = oi.Quantity * oi.Price
                        }).ToList()
                    }).ToList();
                
                return View(order);
            }            
        }
    }
}