using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebsiteBanHang.Models
{
    public class UserEditViewModel
    {
        public int Id { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PhoneNumber { get; set; }
        public bool IsAdmin { get; set; }
        public string PasswordHash { get; set; }
    }
}