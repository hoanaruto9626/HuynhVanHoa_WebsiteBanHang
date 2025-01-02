using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebsiteBanHang.Connect;

namespace WebsiteBanHang.Models
{
    public class CartModel
    {
        public product product { get; set; }
        public int Quantity { get; set; }
    }
}