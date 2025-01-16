using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using WebsiteBanHang.Connect;

namespace WebsiteBanHang.Controllers
{
    public class ProductController : Controller
    {
        WebsiteBanHangEntities objWebsiteBanHangEntities = new WebsiteBanHangEntities();
        // GET: Product
        public ActionResult Detail(int id)
        {
            try
            {
                var product = objWebsiteBanHangEntities.Products.FirstOrDefault(p => p.Id == id);
                if (product == null)
                {
                    TempData["ErrorMessage"] = $"Không tìm thấy sản phẩm với ID: {id}";
                    return RedirectToAction("Index");
                }
                //product.Details = StripHtml(product.Details);
                //product.Description = StripHtml(product.Description);
                return View(product);
            }
            catch (Exception ex)
            {
                // Ghi log lỗi
                System.Diagnostics.Debug.WriteLine($"Lỗi: {ex.Message}");
                return View("Error");
            }
        }

        // Phương thức loại bỏ thẻ HTML
        public string StripHtml(string input)
        {
            return Regex.Replace(input, "<.*?>", String.Empty); // Loại bỏ thẻ HTML
        }
    }
}