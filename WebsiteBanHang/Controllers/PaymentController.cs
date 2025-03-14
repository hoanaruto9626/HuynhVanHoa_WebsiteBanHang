﻿using PayPal.Api;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsiteBanHang.Connect;
using WebsiteBanHang.Models;

namespace WebsiteBanHang.Controllers
{
    public class PaymentController : Controller
    {
        WebsiteBanHangEntities objWebsiteBanHangEntities = new WebsiteBanHangEntities();
        // GET: Payment
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
                // Tính tổng tiền đơn hàng
                decimal totalAmount = (decimal)lstCart.Sum(item => item.Quantity * item.product.Price ?? 0m);
                //Gán dữ liệu cho Order
                Connect.Order order = new Connect.Order();
                order.UserId = int.Parse(Session["idUser"].ToString());
                order.OrderDate = DateTime.Now;
                order.TotalAmount = totalAmount;
                order.Status = "1";
                order.ShippingAddress = "Địa chỉ giao hàng mặc định";
                order.Name = "DonHang" + DateTime.Now.ToString("yyyyMMddHHmmss");
                objWebsiteBanHangEntities.Orders.Add(order);
                //lưu thông tin dữ liệu vào bảng order
                objWebsiteBanHangEntities.SaveChanges();

                //Lấy OrderId vừa mới tạo để lưu vào bảng OrderItem
                int intOrderId = order.Id;
                List<OrderItem> lstOrderItem = new List<OrderItem>();

                foreach (var item in lstCart)
                {
                    OrderItem obj = new OrderItem();
                    obj.OrderId = intOrderId;
                    obj.ProductId = item.product.Id;
                    obj.Quantity = item.Quantity;
                    obj.Price = (decimal)item.product.Price;
                    lstOrderItem.Add(obj);
                }
                objWebsiteBanHangEntities.OrderItems.AddRange(lstOrderItem);
                objWebsiteBanHangEntities.SaveChanges();
                Session["cart"] = null;
                Session["count"] = null;
            }
            return View();
        }
    }
}