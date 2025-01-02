using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsiteBanHang.Connect;

namespace WebsiteBanHang.Controllers
{
    public class CategoryController : Controller
    {
        WebsiteBanHangEntities objWebsiteBanHangEntities = new WebsiteBanHangEntities();
        // GET: Category
        public ActionResult Index()
        {
            var lstcategory = objWebsiteBanHangEntities.categories.ToList();
            return View(lstcategory);
        }
        public ActionResult ProductCategory(int id)
        {
            var listProduct = objWebsiteBanHangEntities.products.Where(n => n.id == id).ToList();
            return View(listProduct);
        }
    }
}