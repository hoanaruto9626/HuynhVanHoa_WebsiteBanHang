using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsiteBanHang.Connect;
using WebsiteBanHang.Models;

namespace WebsiteBanHang.Controllers
{
    public class CartController : Controller
    {
        WebsiteBanHangEntities objWebsiteBanHangEntities = new WebsiteBanHangEntities();
        // GET: Cart
        public ActionResult Index()
        {
            return View((List<CartModel>)Session["cart"]);
        }

        public ActionResult AddToCart(int id, int quantity)
        {
            var product = objWebsiteBanHangEntities.Products.Find(id);
            if (product == null)
            {
                return Json(new { Message = "Sản phẩm không tồn tại", JsonRequestBehavior.AllowGet });
            }
            var brand = objWebsiteBanHangEntities.Brands.FirstOrDefault(n => n.Id == product.BrandId);
            var stock = objWebsiteBanHangEntities.Stocks.FirstOrDefault(s => s.ProductId == product.Id);

            if (Session["cart"] == null)
            {
                List<CartModel> cart = new List<CartModel>();
                cart.Add(new CartModel { product = objWebsiteBanHangEntities.Products.Find(id), brands = brand, stocks = stock, Quantity = quantity });
                Session["cart"] = cart;
                Session["count"] = 1;
            }
            else
            {
                List<CartModel> cart = (List<CartModel>)Session["cart"];
                //kiểm tra sản phẩm có tồn tại trong giỏ hàng chưa???
                int index = isExist(id);
                if (index != -1)
                {
                    //nếu sp tồn tại trong giỏ hàng thì cộng thêm số lượng
                    cart[index].Quantity += quantity;
                }
                else
                {
                    //nếu không tồn tại thì thêm sản phẩm vào giỏ hàng
                    cart.Add(new CartModel { product = objWebsiteBanHangEntities.Products.Find(id), brands = brand, stocks = stock, Quantity = quantity });
                    //Tính lại số sản phẩm trong giỏ hàng
                    Session["count"] = Convert.ToInt32(Session["count"]) + 1;
                }
                Session["cart"] = cart;
            }
            return Json(new { Message = "Thành công", JsonRequestBehavior.AllowGet });
        }
        private int isExist(int id)
        {
            List<CartModel> cart = (List<CartModel>)Session["cart"];
            for (int i = 0; i < cart.Count; i++)
                if (cart[i].product.Id.Equals(id))
                    return i;
            return -1;
        }

        //xóa sản phẩm khỏi giỏ hàng theo id
        public ActionResult Remove(int Id)
        {
            List<CartModel> li = (List<CartModel>)Session["cart"];
            li.RemoveAll(x => x.product.Id == Id);
            Session["cart"] = li;
            Session["count"] = Convert.ToInt32(Session["count"]) - 1;
            return Json(new { Message = "Thành công", JsonRequestBehavior.AllowGet });
        }

        [HttpPost]
        public JsonResult UpdateQuantity(int productId, int quantity)
        {
            if (quantity < 1)
            {
                return Json(new { Message = "Số lượng không hợp lệ", JsonRequestBehavior.AllowGet });
            }

            List<CartModel> cart = (List<CartModel>)Session["cart"];
            if (cart != null)
            {
                var cartItem = cart.FirstOrDefault(item => item.product.Id == productId);
                if (cartItem != null)
                {
                    cartItem.Quantity = quantity;
                    Session["cart"] = cart; // Cập nhật lại giỏ hàng trong session
                    return Json(new { Message = "Cập nhật thành công", JsonRequestBehavior.AllowGet });
                }
            }
            return Json(new { Message = "Sản phẩm không tồn tại trong giỏ hàng", JsonRequestBehavior.AllowGet });
        }
    }
}