using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebsiteBanHang.Models
{
    public class CategoryModel
    {
        public bool status { get; set; } = false;
        public int category_id { get; set; }
        public string name { get; set; }
        public int id { get; set; }
        public int? parent_id { get; set; }
    }
}