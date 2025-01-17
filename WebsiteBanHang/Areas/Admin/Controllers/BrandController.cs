using PagedList;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using WebsiteBanHang.Connect;

namespace WebsiteBanHang.Areas.Admin.Controllers
{
    public class BrandController : Controller
    {
        WebsiteBanHangEntities objWebsiteBanHangEntities = new WebsiteBanHangEntities();
        // GET: Admin/Brand
        public ActionResult Index(string SearchString, string currentFilter, int? page)
        {
            if (SearchString == null)
            {
                SearchString = currentFilter;
            }
            
            ViewBag.CurrentFilter = SearchString;

            var brands = objWebsiteBanHangEntities.Brands.AsQueryable();

            if (!string.IsNullOrEmpty(SearchString))
            {
                brands = brands.Where(n => n.Name.Contains(SearchString));
            }

            brands = brands.OrderByDescending(n => n.Id);

            int pageSize = 4;
            int pageNumber = (page ?? 1);
            return View(brands.ToPagedList(pageNumber, pageSize));
        }

        // GET: Admin/Brand/Details
        public ActionResult Details(int id)
        {
            var objBrand = objWebsiteBanHangEntities.Brands.Where(n => n.Id == id).FirstOrDefault();
            return View(objBrand);
        }

        [HttpGet]
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/Brand/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Brand brand, HttpPostedFileBase Image)
        {
            if (Image == null)
            {
                ViewBag.Thongbao = "Vui lòng chọn ảnh.";
                return View();
            }
            string fileName = Path.GetFileName(Image.FileName);
            string savePath = Path.Combine(Server.MapPath("~/Content/images/brand/"), fileName);
            if (System.IO.File.Exists(savePath))
            {
                // Nếu file tồn tại, hiển thị thông báo và không thêm danh mục
                ViewBag.Thongbao = $"Hình ảnh '{fileName}' đã tồn tại. Vui lòng chọn ảnh khác.";
                return View();
            }
            if (ModelState.IsValid)
            {
                try
                {
                    Image.SaveAs(savePath);

                    // Thêm sản phẩm vào cơ sở dữ liệu
                    brand.Image = fileName;
                    objWebsiteBanHangEntities.Brands.Add(brand);
                    objWebsiteBanHangEntities.SaveChanges();

                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", "Có lỗi xảy ra: " + ex.Message);
                }
            }
            return View();
        }

        // GET: Admin/Brand/Edit
        [HttpGet]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            Brand brand = objWebsiteBanHangEntities.Brands.Find(id);
            if (brand == null)
            {
                return HttpNotFound();
            }

            return View(brand);
        }

        // POST: Admin/Brand/Edit
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Brand brand, HttpPostedFileBase Image)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    // Đường dẫn tới thư mục chứa ảnh
                    string imagePath = Server.MapPath("~/Content/images/brand/");

                    string oldFileName = Request.Form["oldimage"];
                    string newFileName = null;
                    // Nếu người dùng upload ảnh mới
                    if (Image != null)
                    {
                        // Lấy tên file gốc của ảnh mới
                        newFileName = Path.GetFileName(Image.FileName);

                        // Đường dẫn lưu ảnh mới
                        string newFilePath = Path.Combine(imagePath, newFileName);
                        
                        // Kiểm tra nếu ảnh mới đã tồn tại
                        if (System.IO.File.Exists(newFilePath))
                        {
                            // Thông báo lỗi nếu ảnh mới đã tồn tại
                            ModelState.AddModelError("", "Ảnh đã tồn tại. Vui lòng chọn ảnh khác!");
                            brand.Image = oldFileName;
                            return View(brand); // Trả lại view để người dùng sửa
                        }

                        // Lưu ảnh mới vào thư mục trên máy chủ
                        Image.SaveAs(newFilePath);

                        // Xóa ảnh cũ nếu tồn tại
                        if (!string.IsNullOrEmpty(oldFileName))
                        {
                            string oldFilePath = Path.Combine(imagePath, oldFileName);
                            if (System.IO.File.Exists(oldFilePath))
                            {
                                System.IO.File.Delete(oldFilePath); // Xóa ảnh cũ
                            }
                        }

                        // Cập nhật thông tin file ảnh mới vào đối tượng
                        brand.Image = newFileName;
                    }
                    else
                    {
                        brand.Image = Request.Form["oldimage"];
                    }
                    // Cập nhật thông tin danh mục
                    objWebsiteBanHangEntities.Entry(brand).State = EntityState.Modified;
                    objWebsiteBanHangEntities.SaveChanges();

                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", "Cập nhật không thành công: " + ex.Message);
                }
            }
            return View(brand);
        }

        // GET: Admin/Brand/Delete/5
        [HttpGet]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Brand brand = objWebsiteBanHangEntities.Brands.Find(id);
            if (brand == null)
            {
                return HttpNotFound();
            }
            return View(brand);
        }

        // POST: Admin/Brand/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            try
            {
                // Tìm thương hiệu cần xóa
                Brand brand = objWebsiteBanHangEntities.Brands.Find(id);
                if (brand == null)
                {
                    return HttpNotFound();
                }

                // Kiểm tra nếu thương hiệu đang được liên kết với sản phẩm
                var linkedProducts = objWebsiteBanHangEntities.Products.Where(p => p.BrandId == id).ToList();
                if (linkedProducts.Any())
                {
                    // Hiển thị thông báo lỗi nếu thương hiệu đang được sử dụng
                    ModelState.AddModelError("", "Không thể xóa thương hiệu vì nó đang được liên kết với sản phẩm.");
                    return View(brand);
                }

                // Lấy đường dẫn ảnh của thương hiệu
                string imagePath = Server.MapPath("~/Content/images/brand/");
                string imageFile = brand.Image;

                // Kiểm tra và xóa file ảnh nếu tồn tại
                if (!string.IsNullOrEmpty(imageFile))
                {
                    string fullPath = Path.Combine(imagePath, imageFile);
                    if (System.IO.File.Exists(fullPath))
                    {
                        System.IO.File.Delete(fullPath); // Xóa ảnh
                    }
                }

                // Xóa thương hiệu khỏi cơ sở dữ liệu
                objWebsiteBanHangEntities.Brands.Remove(brand);
                objWebsiteBanHangEntities.SaveChanges();

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "Không thể xóa thương hiệu: " + ex.Message);
                return RedirectToAction("Index");
            }
        }
    }
}