using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using WebsiteBanHang.Connect;
using WebsiteBanHang.Models;

namespace WebsiteBanHang.Areas.Admin.Controllers
{
    public class OrderController : Controller
    {
        WebsiteBanHangEntities dbWebsite = new WebsiteBanHangEntities();
        // GET: Admin/Order
        public ActionResult Index()
        {
            // Lấy danh sách đơn hàng
            var order = dbWebsite.Orders
                .Select(item => new OrderViewModel
                {
                    OrderId = item.Id,
                    CustomerName = item.User.UserName,
                    CustomerEmail = item.User.Email,
                    CustomerPhone = item.User.PhoneNumber,
                    CustomerAddress = item.ShippingAddress,
                    TotalAmount = item.TotalAmount,
                    CreatedDate = (DateTime)item.OrderDate, // Ngày đặt hàng
                    Status = item.Status,
                    OrderItems = item.OrderItems.Select(oi => new OrderItemViewModel
                    {
                        ProductName = oi.Product.Name,
                        ProductImage = oi.Product.Images, // Lấy ảnh đầu tiên
                        Quantity = oi.Quantity,
                        Price = oi.Price,
                        SubTotal = oi.Quantity * oi.Price // Thành tiền
                    }).ToList()
                }).ToList();
            // Ánh xạ trạng thái thành chuỗi và lớp CSS sau khi lấy dữ liệu
            foreach (var o in order)
            {
                // Kiểm tra xem Status có phải là số hợp lệ trước khi chuyển đổi
                if (int.TryParse(o.Status.ToString(), out int status))
                {
                    o.Status = GetStatusText(status);  // Ánh xạ trạng thái thành chuỗi
                    o.StatusClass = GetStatusClass(status);  // Ánh xạ trạng thái thành lớp CSS
                }
                else
                {
                    // Xử lý khi Status không hợp lệ
                    o.Status = "Unknown";
                    o.StatusClass = "badge-secondary";
                }
            }
            return View(order);
        }

        // GET: Admin/Orders/Details/5
        public ActionResult Details(int id)
        {
            //var orderId = dbWebsite.Orders.Where(n => n.Id == id).FirstOrDefault();

            // Lấy chi tiết đơn hàng từ cơ sở dữ liệu dựa trên OrderId
            var order = dbWebsite.Orders
                .Where(item => item.Id == id)
                .Select(item => new OrderViewModel
                {
                    OrderId = item.Id,
                    OrderName = item.Name,
                    CustomerName = item.User.UserName,
                    CustomerEmail = item.User.Email,
                    CustomerPhone = item.User.PhoneNumber,
                    CustomerAddress = item.ShippingAddress,
                    TotalAmount = item.TotalAmount,
                    CreatedDate = (DateTime)item.OrderDate,
                    //Status = GetStatusText(Convert.ToInt32(item.Status)),
                    //StatusClass = GetStatusClass(Convert.ToInt32(item.Status)),
                    OrderItems = item.OrderItems.Select(oi => new OrderItemViewModel
                    {
                        ProductName = oi.Product.Name,
                        ProductImage = oi.Product.Images,
                        Quantity = oi.Quantity,
                        Price = oi.Price,
                        SubTotal = oi.Quantity * oi.Price
                    }).ToList()
                }).FirstOrDefault();

            return View(order);
        }

        // GET: Admin/Order/Delete/5
        [HttpGet]
        public ActionResult Delete(int? id)
        {
            var order = dbWebsite.Orders
                .Where(item => item.Id == id)
                .Select(item => new OrderViewModel
                {
                    OrderId = item.Id,
                    OrderName = item.Name,
                    CustomerName = item.User.UserName,
                    CustomerEmail = item.User.Email,
                    CustomerPhone = item.User.PhoneNumber,
                    CustomerAddress = item.ShippingAddress,
                    TotalAmount = item.TotalAmount,
                    CreatedDate = (DateTime)item.OrderDate,
                    //Status = GetStatusText(Convert.ToInt32(item.Status)),
                    //StatusClass = GetStatusClass(Convert.ToInt32(item.Status)),
                    OrderItems = item.OrderItems.Select(oi => new OrderItemViewModel
                    {
                        ProductName = oi.Product.Name,
                        ProductImage = oi.Product.Images,
                        Quantity = oi.Quantity,
                        Price = oi.Price,
                        SubTotal = oi.Quantity * oi.Price
                    }).ToList()
                }).FirstOrDefault();

            return View(order);
        }

        // POST: Admin/Order/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            // Lấy đơn hàng từ cơ sở dữ liệu
            var order = dbWebsite.Orders
                .Where(item => item.Id == id)
                .FirstOrDefault();

            // Kiểm tra nếu không tìm thấy đơn hàng
            if (order == null)
            {
                return HttpNotFound();
            }

            // Xóa các mục trong đơn hàng trước khi xóa đơn hàng
            var orderItems = order.OrderItems.ToList();
            foreach (var orderItem in orderItems)
            {
                dbWebsite.OrderItems.Remove(orderItem); // Xóa từng mục trong đơn hàng
            }

            // Xóa đơn hàng
            dbWebsite.Orders.Remove(order);

            // Lưu thay đổi vào cơ sở dữ liệu
            dbWebsite.SaveChanges();

            // Chuyển hướng đến danh sách đơn hàng hoặc trang khác
            return RedirectToAction("Index");
        }

        // Hàm ánh xạ trạng thái thành chuỗi
        private string GetStatusText(int status)
        {
            switch (status)
            {
                case 1:
                    return "Pending";     // Trạng thái Pending
                case 2:
                    return "Processing";  // Trạng thái Processing
                case 3:
                    return "Completed";   // Trạng thái Completed
                case 4:
                    return "Cancelled";   // Trạng thái Cancelled
                default:
                    return "Unknown";     // Trạng thái Unknown nếu không phải 1-4
            }
        }

        // Hàm ánh xạ trạng thái thành chuỗi CSS class
        private string GetStatusClass(int status)
        {
            switch (status)
            {
                case 1:
                    return "badge-warning";  // Pending
                case 2:
                    return "badge-info";     // Processing
                case 3:
                    return "badge-success";  // Completed
                case 4:
                    return "badge-danger";   // Cancelled
                default:
                    return "badge-secondary"; // Unknown
            }
        }
    }
}