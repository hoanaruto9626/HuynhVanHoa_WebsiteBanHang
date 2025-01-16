using PagedList;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using WebsiteBanHang.Connect;
using WebsiteBanHang.Models;

namespace WebsiteBanHang.Areas.Admin.Controllers
{
    public class ProductController : Controller
    {
        WebsiteBanHangEntities objWebsiteBanHangEntities = new WebsiteBanHangEntities();
        // GET: Admin/Product
        public ActionResult Index(string SearchString, string currentFilter, int? page, int? size)
        {
            if (SearchString == null)
            {
                SearchString = currentFilter;
            }

            ViewBag.CurrentFilter = SearchString;

            var products = objWebsiteBanHangEntities.Products.AsQueryable();

            if (!string.IsNullOrEmpty(SearchString))
            {
                products = products.Where(n => n.Name.Contains(SearchString));
            }

            products = products.OrderByDescending(n => n.Id);

            // Thiết lập danh sách số lượng sản phẩm hiển thị trên một trang
            var pageSizeOptions = new List<SelectListItem>
            {
                new SelectListItem { Text = "5", Value = "5" },
                new SelectListItem { Text = "10", Value = "10" },
                new SelectListItem { Text = "20", Value = "20" },
                new SelectListItem { Text = "25", Value = "25" },
                new SelectListItem { Text = "50", Value = "50" },
                new SelectListItem { Text = "100", Value = "100" },
                new SelectListItem { Text = "200", Value = "200" }
            };

            // Đánh dấu lựa chọn kích thước trang hiện tại
            foreach (var item in pageSizeOptions)
            {
                if (item.Value == size.ToString())
                {
                    item.Selected = true;
                }
            }

            ViewBag.Size = pageSizeOptions;

            // Thiết lập kích thước trang và trang hiện tại
            int pageSize = size ?? 5; // Nếu size là null, mặc định là 5
            int pageNumber = page ?? 1; // Nếu page là null, mặc định là trang 1

            ViewBag.CurrentSize = pageSize;
            ViewBag.Page = pageNumber;

            // Kiểm tra tổng số trang
            int totalPages = (int)Math.Ceiling((double)products.Count() / pageSize);

            // Đảm bảo số trang hiện tại không vượt quá tổng số trang
            if (pageNumber > totalPages) pageNumber = totalPages > 0 ? totalPages : 1;

            return View(products.ToPagedList(pageNumber, pageSize));
        }

        //GET: Admin/Product/Details
        public ActionResult Details(int id)
        {
            var objProduct = objWebsiteBanHangEntities.Products.Where(n => n.Id == id).FirstOrDefault();
            //objProduct.Details = StripHtml(objProduct.Details);
            //objProduct.Description = StripHtml(objProduct.Description);
            return View(objProduct);
        }

        //GET: Admin/Product/Create
        [HttpGet]
        public ActionResult Create()
        {
            //lấy dữ liệu danh mục
            ViewBag.CategoryList = new SelectList(objWebsiteBanHangEntities.Categories.ToList().OrderBy(n=>n.Name),"Id", "Name");
            //lấy dữ liệu thương hiệu
            ViewBag.BrandList = new SelectList(objWebsiteBanHangEntities.Brands.ToList().OrderBy(n => n.Name), "Id", "Name");

            //loại sản phẩm
            ViewBag.ProductType = new SelectList(new List<ProductType>
            {
                new ProductType { Id = 1, Name = "Giảm giá sốc" },
                new ProductType { Id = 2, Name = "Đề xuất" }
            }, "Id", "Name");

            return View();
        }

        //POST: Admin/Product/Create
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Create(Product objProduct, HttpPostedFileBase ImageUpload, ProductViewModel model)
        {
            ViewBag.CategoryList = new SelectList(objWebsiteBanHangEntities.Categories.ToList().OrderBy(n => n.Name), "Id", "Name");
            ViewBag.BrandList = new SelectList(objWebsiteBanHangEntities.Brands.ToList().OrderBy(n => n.Name), "Id", "Name");

            //loại sản phẩm
            ViewBag.ProductType = new SelectList(new List<ProductType>
            {
                new ProductType { Id = 1, Name = "Giảm giá sốc" },
                new ProductType { Id = 2, Name = "Đề xuất" }
            }, "Id", "Name");

            if (ImageUpload == null)
            {
                ViewBag.Thongbao = "Vui lòng chọn ảnh.";
                return View();
            }

            // Nhận giá trị TypeId từ form
            var typeId = Request["TypeId"]; // Lấy giá trị TypeId
            if (string.IsNullOrEmpty(typeId))
            {
                ViewBag.Thongbao = "Vui lòng chọn loại sản phẩm.";
                return View();
            }

            objProduct.TypeId = int.Parse(typeId); // Gán TypeId cho sản phẩm

            string fileName = Path.GetFileName(ImageUpload.FileName);
            string savePath = Path.Combine(Server.MapPath("~/Content/images/product/"), fileName);

            if (System.IO.File.Exists(savePath))
            {
                ViewBag.Thongbao = "Hình ảnh đã tồn tại.";
                return View();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    ImageUpload.SaveAs(savePath);
                    // Chỉ lưu tên file vào objProduct
                    objProduct.Images = fileName;
                    // Thêm sản phẩm vào cơ sở dữ liệu
                    objWebsiteBanHangEntities.Products.Add(objProduct);
                    objWebsiteBanHangEntities.SaveChanges();

                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", "Có lỗi xảy ra: " + ex.Message);
                }
            }

            return View(model);
        }

        // GET: Admin/Product/Edit/5
        [HttpGet]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            Product product = objWebsiteBanHangEntities.Products.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }

            //lấy dữ liệu danh mục
            ViewBag.CategoryList = new SelectList(objWebsiteBanHangEntities.Categories.ToList().OrderBy(n => n.Name), "Id", "Name");
            //lấy dữ liệu thương hiệu
            ViewBag.BrandList = new SelectList(objWebsiteBanHangEntities.Brands.ToList().OrderBy(n => n.Name), "Id", "Name");

            //loại sản phẩm
            ViewBag.ProductType = new SelectList(new List<ProductType>
            {
                new ProductType { Id = 1, Name = "Giảm giá sốc" },
                new ProductType { Id = 2, Name = "Đề xuất" }
            }, "Id", "Name");
            return View(product);
        }

        // POST: Admin/Product/Edit
        [HttpPost]
        [ValidateInput(false)]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Product product, HttpPostedFileBase ImageUpload, ProductViewModel model)
        {
            // Nếu không thành công, hiển thị lại view với dữ liệu cần thiết
            ViewBag.CategoryList = new SelectList(objWebsiteBanHangEntities.Categories.ToList().OrderBy(n => n.Name), "Id", "Name", product.CategoryId);
            ViewBag.BrandList = new SelectList(objWebsiteBanHangEntities.Brands.ToList().OrderBy(n => n.Name), "Id", "Name", product.BrandId);
            //loại sản phẩm
            ViewBag.ProductType = new SelectList(new List<ProductType>
            {
                new ProductType { Id = 1, Name = "Giảm giá sốc" },
                new ProductType { Id = 2, Name = "Đề xuất" }
            }, "Id", "Name");
            if (ModelState.IsValid)
            {
                try
                {
                    // Đường dẫn tới thư mục chứa ảnh
                    string imagePath = Server.MapPath("~/Content/images/product/");
                    string oldFileName = Request.Form["oldimage"];
                    string newFileName = null;
                    // Nếu người dùng upload ảnh mới
                    if (ImageUpload != null)
                    {
                        // Lấy tên file gốc của ảnh mới
                        newFileName = Path.GetFileName(ImageUpload.FileName);

                        // Đường dẫn lưu ảnh mới
                        string newFilePath = Path.Combine(imagePath, newFileName);

                        // Kiểm tra nếu ảnh mới đã tồn tại
                        if (System.IO.File.Exists(newFilePath))
                        {
                            // Thông báo lỗi nếu ảnh mới đã tồn tại
                            ModelState.AddModelError("", "Ảnh đã tồn tại. Vui lòng chọn ảnh khác!");
                            product.Images = oldFileName;
                            return View(product); // Trả lại view để người dùng sửa
                        }

                        // Lưu ảnh mới vào thư mục trên máy chủ
                        ImageUpload.SaveAs(newFilePath);

                        if (!string.IsNullOrEmpty(oldFileName))
                        {
                            string oldFilePath = Path.Combine(imagePath, oldFileName);
                            if (System.IO.File.Exists(oldFilePath))
                            {
                                System.IO.File.Delete(oldFilePath); // Xóa ảnh cũ
                            }
                        }

                        // Cập nhật thông tin file ảnh mới vào đối tượng
                        product.Images = newFileName;
                    }
                    else
                    {
                        product.Images = Request.Form["oldimage"];
                    }
                    // Cập nhật thông tin danh mục
                    objWebsiteBanHangEntities.Entry(product).State = EntityState.Modified;
                    objWebsiteBanHangEntities.SaveChanges();

                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", "Cập nhật không thành công: " + ex.Message);
                }
                return RedirectToAction("Index");
            }
            return View(product);
        }

        // GET: Admin/Product/Delete/5
        [HttpGet]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Product product = objWebsiteBanHangEntities.Products.Find(id);
            if (product == null)
            {
                return HttpNotFound();
            }
            return View(product);
        }

        // POST: Admin/Product/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            try
            {
                // Tìm danh mục cần xóa
                Product product = objWebsiteBanHangEntities.Products.Find(id);
                if (product == null)
                {
                    return HttpNotFound();
                }

                // Lấy đường dẫn ảnh của danh mục
                string imagePath = Server.MapPath("~/Content/images/product/");
                string imageFile = product.Images;

                // Kiểm tra và xóa file ảnh nếu tồn tại
                if (!string.IsNullOrEmpty(imageFile))
                {
                    string fullPath = Path.Combine(imagePath, imageFile);
                    if (System.IO.File.Exists(fullPath))
                    {
                        System.IO.File.Delete(fullPath); // Xóa ảnh
                    }
                }

                // Xóa danh mục khỏi cơ sở dữ liệu
                objWebsiteBanHangEntities.Products.Remove(product);
                objWebsiteBanHangEntities.SaveChanges();

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "Không thể xóa sản phẩm: " + ex.Message);
                return RedirectToAction("Index");
            }
        }

        // Phương thức loại bỏ thẻ HTML
        public string StripHtml(string input)
        {
            return Regex.Replace(input, "<.*?>", String.Empty); // Loại bỏ thẻ HTML
        }

        public class ProductType
        {
            public int Id { get; set; }
            public string Name { get; set; }
        }
    }
}