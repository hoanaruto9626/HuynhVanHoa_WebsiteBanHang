using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Helpers;
using System.Web.Mvc;
using WebsiteBanHang.Connect;
using WebsiteBanHang.Models;
using BCrypt.Net;

namespace WebsiteBanHang.Areas.Admin.Controllers
{
    public class UserController : Controller
    {
        WebsiteBanHangEntities dbUser = new WebsiteBanHangEntities();
        // GET: Admin/User
        public ActionResult Index()
        {
            var lstUser = dbUser.Users.ToList();
            return View(lstUser);
        }

        // GET: Admin/User/Details
        public ActionResult Details(int id)
        {
            var users = dbUser.Users.Where(n => n.Id == id).FirstOrDefault();
            return View(users);
        }

        [HttpGet]
        public ActionResult Edit(int? id)
        {
            var users = dbUser.Users.Where(n => n.Id == id).FirstOrDefault();
            return View(users);
        }

        // POST: Admin/User/Edit
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit(UserEditViewModel userViewModel)
        {
            if (!ModelState.IsValid)
            {
                return View(userViewModel);
            }

            var user = await dbUser.Users.FindAsync(userViewModel.Id);

            if (user == null)
            {
                return HttpNotFound();
            }

            // Kiểm tra trùng lặp username (nếu có cập nhật)
            if (!string.IsNullOrEmpty(userViewModel.UserName) && userViewModel.UserName != user.UserName)
            {
                if (dbUser.Users.Any(u => u.UserName == userViewModel.UserName))
                {
                    ModelState.AddModelError("UserName", "Tên đăng nhập đã tồn tại.");
                    return View(user);
                }
            }

            // Kiểm tra trùng lặp email (nếu có cập nhật)
            if (!string.IsNullOrEmpty(userViewModel.Email) && userViewModel.Email != user.Email)
            {
                if (dbUser.Users.Any(u => u.Email == userViewModel.Email))
                {
                    ModelState.AddModelError("Email", "Email đã tồn tại.");
                    return View(user);
                }
            }

            user.UserName = string.IsNullOrEmpty(userViewModel.UserName) ? user.UserName : userViewModel.UserName;
            user.Email = string.IsNullOrEmpty(userViewModel.Email) ? user.Email : userViewModel.Email;
            user.FirstName = userViewModel.FirstName;
            user.LastName = userViewModel.LastName;
            user.PhoneNumber = userViewModel.PhoneNumber;
            user.IsAdmin = userViewModel.IsAdmin;

            // Check if password needs to be updated
            if (!string.IsNullOrEmpty(userViewModel.Password))
            {
                var hashedPassword = GetMD5(userViewModel.Password);
                user.Password = hashedPassword;
            }

            await dbUser.SaveChangesAsync();

            return RedirectToAction("Index");
        }

        // GET: Admin/User/Delete
        [HttpGet]
        public ActionResult Delete(int id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Connect.User users = dbUser.Users.Find(id);
            if (users == null)
            {
                return HttpNotFound();
            }
            return View(users);
        }

        // GET: Admin/User/Delete
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            try
            {
                // Tìm danh mục cần xóa
                Connect.User users = dbUser.Users.Find(id);
                if (users == null)
                {
                    return HttpNotFound();
                }

                // Kiểm tra nếu danh mục đang được liên kết với sản phẩm
                var linkedOrders = dbUser.Orders.Where(p => p.UserId == id).ToList();
                if (linkedOrders.Any())
                {
                    // Hiển thị thông báo lỗi nếu danh mục đang được sử dụng
                    ModelState.AddModelError("", "Không thể xóa người dùng vì nó đang có đơn hàng.");
                    return View(users);
                }

                // Xóa danh mục khỏi cơ sở dữ liệu
                dbUser.Users.Remove(users);
                dbUser.SaveChanges();

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "Không thể xóa: " + ex.Message);
                return RedirectToAction("Index");
            }
        }

        [HttpGet]
        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(Connect.User user)
        {
            if (ModelState.IsValid)
            {
                if (dbUser.Users.Any(u => u.UserName == user.UserName))
                {
                    ModelState.AddModelError("UserName", "Tên đăng nhập đã tồn tại.");
                    return View(user); // Trả về view với thông báo lỗi
                }

                //Kiểm tra xem Email đã tồn tại chưa
                if (dbUser.Users.Any(u => u.Email == user.Email))
                {
                    ModelState.AddModelError("Email", "Email đã tồn tại.");
                    return View(user); // Trả về view với thông báo lỗi
                }

                if (string.IsNullOrWhiteSpace(user.Password)) // Sử dụng IsNullOrWhiteSpace để kiểm tra cả khoảng trắng
                {
                    ModelState.AddModelError("Password", "Vui lòng nhập mật khẩu."); // Thêm lỗi vào ModelState
                    return View(user); // Trả về View để hiển thị thông báo lỗi
                }
                // Mã hóa mật khẩu trước khi lưu
                user.Password = GetMD5(user.Password);

                // Add logic to save user to the database
                dbUser.Users.Add(user);
                dbUser.SaveChanges();

                TempData["Message"] = "User created successfully!";
                return RedirectToAction("Index");
            }

            return View(user);
        }

        //create a string MD5
        public static string GetMD5(string str)
        {
            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] fromData = Encoding.UTF8.GetBytes(str);
            byte[] targetData = md5.ComputeHash(fromData);
            string byte2String = null;

            for (int i = 0; i < targetData.Length; i++)
            {
                byte2String += targetData[i].ToString("x2");

            }
            return byte2String;
        }
    }
}