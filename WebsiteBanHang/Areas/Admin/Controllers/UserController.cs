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

            // Mã hóa mật khẩu trước khi lưu

            user.UserName = userViewModel.UserName;
            user.Email = userViewModel.Email;
            user.FirstName = userViewModel.FirstName;
            user.LastName = userViewModel.LastName;
            user.PhoneNumber = userViewModel.PhoneNumber;
            user.IsAdmin = userViewModel.IsAdmin;
            user.Password = GetMD5(userViewModel.Password);

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