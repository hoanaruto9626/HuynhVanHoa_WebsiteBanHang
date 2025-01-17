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
using WebsiteBanHang.Models;

namespace WebsiteBanHang.Areas.Admin.Controllers
{
    public class CategoryController : Controller
    {
        WebsiteBanHangEntities objWebsiteBanHangEntities = new WebsiteBanHangEntities();
        // GET: Admin/Category
        public ActionResult Index(string SearchString, string currentFilter, int? page)
        {
            if (SearchString == null)
            {
                SearchString = currentFilter;
            }

            ViewBag.CurrentFilter = SearchString;

            var categories = objWebsiteBanHangEntities.Categories.AsQueryable();
            if (!string.IsNullOrEmpty(SearchString))
            {
                categories = categories.Where(n => n.Name.Contains(SearchString));
            }

            categories = categories.OrderByDescending(n => n.Id);

            int pageSize = 4;
            int pageNumber = (page ?? 1);

            return View(categories.ToPagedList(pageNumber, pageSize));
        }

        public ActionResult Details(int id)
        {
            var objCategory = objWebsiteBanHangEntities.Categories.Where(n => n.Id == id).FirstOrDefault();
            return View(objCategory);
        }

        [HttpGet]
        public ActionResult Create()
        {
            // Tạo SelectList cho ParentId (chỉ lấy các danh mục không phải là con của chính nó)
            var categories = objWebsiteBanHangEntities.Categories.Where(c => c.ParentId == null).OrderBy(n => n.Name).ToList();
            ViewBag.ParentId = new SelectList(categories, "Id", "Name");

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Category category, HttpPostedFileBase Image)
        {
            if (Image == null)
            {
                ViewBag.Thongbao = "Vui lòng chọn ảnh.";
                return View();
            }
            string fileName = Path.GetFileName(Image.FileName);
            string savePath = Path.Combine(Server.MapPath("~/Content/images/categories/"), fileName);
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
                    // Lưu ảnh vào thư mục trên server
                    Image.SaveAs(savePath);

                    // Lưu thông tin danh mục và tên file ảnh vào cơ sở dữ liệu
                    category.Image = fileName;
                    objWebsiteBanHangEntities.Categories.Add(category);
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
        // GET: Category/Edit/5
        [HttpGet]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            Category category = objWebsiteBanHangEntities.Categories.Find(id);
            if (category == null)
            {
                return HttpNotFound();
            }
            // Tạo SelectList cho ParentId (chỉ lấy các danh mục không phải là con của chính nó)
            var categories = objWebsiteBanHangEntities.Categories.Where(c => c.Id != id && c.ParentId == null).OrderBy(n => n.Name).ToList();
            // Thêm mục tùy chọn trống vào danh sách
            categories.Insert(0, new Category { Id = 0, Name = "--- Chọn danh mục cha ---" });
            ViewBag.ParentId = new SelectList(categories, "Id", "Name", category.ParentId);

            return View(category);
        }

        // POST: Category/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Category category, HttpPostedFileBase Image)
        {
            var categories = objWebsiteBanHangEntities.Categories.Where(c => c.Id != category.Id && c.ParentId == null).OrderBy(n => n.Name).ToList();
            ViewBag.ParentId = new SelectList(categories, "Id", "Name", category.ParentId);
            if (ModelState.IsValid)
            {
                try
                {
                    // Đường dẫn tới thư mục chứa ảnh
                    string imagePath = Server.MapPath("~/Content/images/categories/");

                    // Lấy ảnh cũ từ form
                    string oldFileName = Request.Form["oldimage"];
                    string newFileName = null;

                    // Nếu người dùng upload ảnh mới
                    if (Image != null)
                    {
                        // Lấy tên file ảnh mới
                        newFileName = Path.GetFileName(Image.FileName);

                        // Đường dẫn ảnh mới
                        string newFilePath = Path.Combine(imagePath, newFileName);

                        // Kiểm tra nếu ảnh mới đã tồn tại
                        if (System.IO.File.Exists(newFilePath))
                        {
                            // Thông báo lỗi nếu ảnh mới đã tồn tại
                            ModelState.AddModelError("", "Ảnh đã tồn tại. Vui lòng chọn ảnh khác!");
                            category.Image = oldFileName;
                            return View(category); // Trả lại view để người dùng sửa
                        }

                        // Lưu ảnh mới vào thư mục
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
                        // Gán tên file ảnh mới cho category
                        category.Image = newFileName;
                    }
                    else
                    {
                        // Không upload ảnh mới, giữ nguyên ảnh cũ
                        category.Image = oldFileName;
                    }
                    // Cập nhật thông tin danh mục
                    objWebsiteBanHangEntities.Entry(category).State = EntityState.Modified;
                    objWebsiteBanHangEntities.SaveChanges();

                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", "Cập nhật không thành công: " + ex.Message);
                }
            }
            return View(category);
        }

        // GET: Admin/Category/Delete/5
        [HttpGet]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Category category = objWebsiteBanHangEntities.Categories.Find(id);
            if (category == null)
            {
                return HttpNotFound();
            }
            return View(category);
        }

        // POST: Admin/Category/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            try
            {
                // Tìm danh mục cần xóa
                Category category = objWebsiteBanHangEntities.Categories.Find(id);
                if (category == null)
                {
                    return HttpNotFound();
                }

                // Kiểm tra nếu danh mục đang được liên kết với sản phẩm
                var linkedProducts = objWebsiteBanHangEntities.Products.Where(p => p.CategoryId == id).ToList();
                if (linkedProducts.Any())
                {
                    // Hiển thị thông báo lỗi nếu danh mục đang được sử dụng
                    ModelState.AddModelError("", "Không thể xóa danh mục vì nó đang được liên kết với sản phẩm.");
                    return View(category);
                }

                // Lấy đường dẫn ảnh của danh mục
                string imagePath = Server.MapPath("~/Content/images/categories/");
                string imageFile = category.Image;

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
                objWebsiteBanHangEntities.Categories.Remove(category);
                objWebsiteBanHangEntities.SaveChanges();

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "Không thể xóa danh mục: " + ex.Message);
                return RedirectToAction("Index");
            }
        }
    }
}