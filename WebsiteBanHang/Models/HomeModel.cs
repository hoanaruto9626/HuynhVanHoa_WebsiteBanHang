using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebsiteBanHang.Connect;

namespace WebsiteBanHang.Models
{
    public class HomeModel
    {
        public List<category> categories { get; set; }
        public List<product> products {  get; set; }
    }
}