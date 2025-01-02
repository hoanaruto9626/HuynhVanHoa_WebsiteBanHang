using PagedList;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using WebsiteBanHang.Connect;

namespace WebsiteBanHang.Areas.Admin.Controllers
{
    public class ProductController : Controller
    {
        WebsiteBanHangEntities objWebsiteBanHangEntities = new WebsiteBanHangEntities();
        // GET: Admin/Product
        public ActionResult Index(string SearchString, string currentFilter, int? page)
        {
            var lstProduct = new List<product>();
            if(SearchString != null)
            {
                page = 1;
            }
            else
            {
                SearchString = currentFilter;
            }
            if(!string.IsNullOrEmpty(SearchString))
            {
                lstProduct = objWebsiteBanHangEntities.products.Where(n => n.name.Contains(SearchString)).ToList();
            }
            else
            {
                lstProduct = objWebsiteBanHangEntities.products.ToList();
            }
            ViewBag.CurrentFilter = SearchString;
            int pageSize = 4;
            int pageNumber = (page ?? 1);
            lstProduct = lstProduct.OrderByDescending(n => n.id).ToList();
            return View(lstProduct.ToPagedList(pageNumber, pageSize));
        }

        public ActionResult Details(int id)
        {
            var objProduct = objWebsiteBanHangEntities.products.Where(n => n.id == id).FirstOrDefault();
            return View(objProduct);
        }

        [HttpGet]
        public ActionResult Create()
        {
            //lấy dữ liệu danh mục
            ViewBag.CategoryList = new SelectList(objWebsiteBanHangEntities.categories.ToList().OrderBy(n=>n.name),"id", "name");
            //lấy dữ liệu thương hiệu
            ViewBag.BrandList = new SelectList(objWebsiteBanHangEntities.brands.ToList().OrderBy(n => n.name), "id", "name");
            return View();
        }

        [HttpPost]
        public ActionResult Create(product objProduct, HttpPostedFileBase ImageUpload)
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
                            string savePath = Path.Combine(Server.MapPath("~/Content/images/product/"), fileName);
                            ImageUpload.SaveAs(savePath);

                            // Chỉ lưu tên file vào objProduct
                            //objProduct.product_images = fileName;
                        }

                        // Thêm sản phẩm vào cơ sở dữ liệu
                        objWebsiteBanHangEntities.products.Add(objProduct);
                        objWebsiteBanHangEntities.SaveChanges();

                        return RedirectToAction("Index");
                    }
                    catch (Exception ex)
                    {
                        ModelState.AddModelError("", "Có lỗi xảy ra: " + ex.Message);
                    }
                }
                return View(objProduct);
            }
        }
    }
}