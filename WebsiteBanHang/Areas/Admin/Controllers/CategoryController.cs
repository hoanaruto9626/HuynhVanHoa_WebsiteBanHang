using PagedList;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsiteBanHang.Connect;
using WebsiteBanHang.Models;

namespace WebsiteBanHang.Areas.Admin.Controllers
{
    public class CategoryController : Controller
    {
        WebsiteBanHangEntities objWebsiteBanHangEntities = new WebsiteBanHangEntities();
        // GET: Admin/Category
        public ActionResult Index(string SearchString, string currentFilter, int? page)
        {
            var lstCategories = new List<category>();
            if (SearchString != null)
            {
                page = 1;
            }
            else
            {
                SearchString = currentFilter;
            }
            if (!string.IsNullOrEmpty(SearchString))
            {
                lstCategories = objWebsiteBanHangEntities.categories.Where(n => n.name.Contains(SearchString)).ToList();
            }
            else
            {
                lstCategories = objWebsiteBanHangEntities.categories.ToList();
            }
            ViewBag.CurrentFilter = SearchString;
            int pageSize = 4;
            int pageNumber = (page ?? 1);
            lstCategories = lstCategories.OrderByDescending(n => n.id).ToList();
            return View(lstCategories.ToPagedList(pageNumber, pageSize));
        }

        public ActionResult Details(int id)
        {
            var objCategory = objWebsiteBanHangEntities.categories.Where(n => n.id == id).FirstOrDefault();
            return View(objCategory);
        }

        [HttpGet]
        public ActionResult Create()
        {
            ViewBag.CategoryList = new SelectList(objWebsiteBanHangEntities.categories.ToList().OrderBy(n => n.name), "id", "name");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(category category, HttpPostedFileBase ImageUpload)
        {
            if (ImageUpload == null)
            {
                ViewBag.Thongbao = "Vui lòng chọn ảnh.";
                return View();
            }
            else
            {
                if (ModelState.IsValid)
                {
                    try
                    {
                        // Xử lý file upload (nếu có)
                        if (ImageUpload != null)
                        {
                            // Lấy tên file gốc
                            string fileName = Path.GetFileName(ImageUpload.FileName);

                            // Lưu file vào thư mục trên server (không lưu đường dẫn)
                            string savePath = Path.Combine(Server.MapPath("~/Content/images/items/"), fileName);
                            ImageUpload.SaveAs(savePath);

                            // Chỉ lưu tên file vào objProduct
                            category.image = fileName;
                        }

                        // Thêm sản phẩm vào cơ sở dữ liệu
                        objWebsiteBanHangEntities.categories.Add(category);
                        objWebsiteBanHangEntities.SaveChanges();

                        return RedirectToAction("Index");
                    }
                    catch (Exception ex)
                    {
                        ModelState.AddModelError("", "Có lỗi xảy ra: " + ex.Message);
                    }
                }
                return View(category);
            }
        }

    }
}