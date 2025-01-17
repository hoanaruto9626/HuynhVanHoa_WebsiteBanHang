USE [master]
GO
/****** Object:  Database [WebsiteBanHang]    Script Date: 1/17/2025 6:05:00 PM ******/
CREATE DATABASE [WebsiteBanHang]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WebsiteBanHang', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\WebsiteBanHang.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WebsiteBanHang_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\WebsiteBanHang_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [WebsiteBanHang] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WebsiteBanHang].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WebsiteBanHang] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET ARITHABORT OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [WebsiteBanHang] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WebsiteBanHang] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WebsiteBanHang] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET  ENABLE_BROKER 
GO
ALTER DATABASE [WebsiteBanHang] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WebsiteBanHang] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [WebsiteBanHang] SET  MULTI_USER 
GO
ALTER DATABASE [WebsiteBanHang] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WebsiteBanHang] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WebsiteBanHang] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WebsiteBanHang] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WebsiteBanHang] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [WebsiteBanHang] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [WebsiteBanHang] SET QUERY_STORE = ON
GO
ALTER DATABASE [WebsiteBanHang] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [WebsiteBanHang]
GO
/****** Object:  Table [dbo].[Brands]    Script Date: 1/17/2025 6:05:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brands](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Image] [nvarchar](255) NULL,
	[Status] [bit] NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 1/17/2025 6:05:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[ParentId] [int] NULL,
	[Image] [nvarchar](255) NULL,
	[Status] [bit] NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 1/17/2025 6:05:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 1/17/2025 6:05:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[OrderDate] [datetime] NULL,
	[TotalAmount] [decimal](10, 2) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[ShippingAddress] [nvarchar](max) NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[Name] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 1/17/2025 6:05:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Details] [nvarchar](max) NULL,
	[Price] [decimal](18, 2) NULL,
	[CategoryId] [int] NOT NULL,
	[BrandId] [int] NOT NULL,
	[Images] [nvarchar](255) NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[TypeId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShoppingCarts]    Script Date: 1/17/2025 6:05:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCarts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stocks]    Script Date: 1/17/2025 6:05:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stocks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Size] [nvarchar](50) NOT NULL,
	[Color] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Price] [decimal](10, 2) NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 1/17/2025 6:05:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[FirstName] [nvarchar](255) NOT NULL,
	[LastName] [nvarchar](255) NOT NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[IsAdmin] [bit] NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Wishlists]    Script Date: 1/17/2025 6:05:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wishlists](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Brands] ON 

INSERT [dbo].[Brands] ([Id], [Name], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (1, N'Apple', N'apple.png', 1, NULL, NULL)
INSERT [dbo].[Brands] ([Id], [Name], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (2, N'Samsung', N'samsung.png', 1, CAST(N'2025-01-07T08:46:24.747' AS DateTime), CAST(N'2025-01-07T08:46:24.747' AS DateTime))
INSERT [dbo].[Brands] ([Id], [Name], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (3, N'Dell', N'dell-pro-laptops-category-image-800x620.png', 1, NULL, NULL)
INSERT [dbo].[Brands] ([Id], [Name], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (4, N'Asus', N'03_g_16_l_2_1_1_1_1.png', 1, NULL, NULL)
INSERT [dbo].[Brands] ([Id], [Name], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (5, N'Anker', N'823c148a6ee64fd3848e98a6dc738be5_e039b0651d1c4b31b340a86ea35226ef_grande.png', 1, NULL, NULL)
INSERT [dbo].[Brands] ([Id], [Name], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (6, N'Lenovo', N'm1jnssoporjtlmma8zqy3ssoour2yj992790.png', 1, NULL, NULL)
INSERT [dbo].[Brands] ([Id], [Name], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (7, N'HP', N'4301FDW.png', 1, NULL, NULL)
INSERT [dbo].[Brands] ([Id], [Name], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (8, N'Huawei', N'huawei-watch-gt-5-kv-2x.jpg', 1, NULL, NULL)
INSERT [dbo].[Brands] ([Id], [Name], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (9, N'Logitech', N'keys-to-go-2-graphite-gallery-1.png', 1, NULL, NULL)
INSERT [dbo].[Brands] ([Id], [Name], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (16, N'Tablet', N'honor-pad-x8a-xam-5-638711656179617043-750x500.jpg', 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Brands] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([Id], [Name], [ParentId], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (1, N'Điện thoại', NULL, N'1.png', 1, CAST(N'2025-01-07T08:46:09.507' AS DateTime), CAST(N'2025-01-07T08:46:09.507' AS DateTime))
INSERT [dbo].[Categories] ([Id], [Name], [ParentId], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (2, N'Laptop', NULL, N'2.png', 1, CAST(N'2025-01-07T08:46:09.507' AS DateTime), CAST(N'2025-01-07T08:46:09.507' AS DateTime))
INSERT [dbo].[Categories] ([Id], [Name], [ParentId], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (3, N'Âm thanh', NULL, N'3.png', 1, NULL, NULL)
INSERT [dbo].[Categories] ([Id], [Name], [ParentId], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (4, N'Đồng hồ', NULL, N'4.png', 1, CAST(N'2025-01-07T08:46:09.507' AS DateTime), CAST(N'2025-01-07T08:46:09.507' AS DateTime))
INSERT [dbo].[Categories] ([Id], [Name], [ParentId], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (5, N'Phụ kiện', NULL, N'5.png', 1, CAST(N'2025-01-07T08:46:09.507' AS DateTime), CAST(N'2025-01-07T08:46:09.507' AS DateTime))
INSERT [dbo].[Categories] ([Id], [Name], [ParentId], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (6, N'Tivi', NULL, N'6.png', 1, NULL, NULL)
INSERT [dbo].[Categories] ([Id], [Name], [ParentId], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (21, N'Camera', NULL, N'camera-ip-360-do-3mp-imou-ta32-trang-1-750x500.jpg', 1, NULL, NULL)
INSERT [dbo].[Categories] ([Id], [Name], [ParentId], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (22, N'iPad', NULL, N'honor-pad-x8a.jpg', 1, NULL, NULL)
INSERT [dbo].[Categories] ([Id], [Name], [ParentId], [Image], [Status], [CreatedAt], [UpdatedAt]) VALUES (23, N'Phần mềm', NULL, N'windows-10-home-32-bit.png', 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderItems] ON 

INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Quantity], [Price], [CreatedAt], [UpdatedAt]) VALUES (39, 33, 42, 1, CAST(4690000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Quantity], [Price], [CreatedAt], [UpdatedAt]) VALUES (40, 33, 39, 1, CAST(16990000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Quantity], [Price], [CreatedAt], [UpdatedAt]) VALUES (41, 34, 42, 6, CAST(4690000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Quantity], [Price], [CreatedAt], [UpdatedAt]) VALUES (47, 38, 39, 3, CAST(16990000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Quantity], [Price], [CreatedAt], [UpdatedAt]) VALUES (48, 38, 38, 1, CAST(13990000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Quantity], [Price], [CreatedAt], [UpdatedAt]) VALUES (49, 39, 1, 1, CAST(33190000.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[OrderItems] ([Id], [OrderId], [ProductId], [Quantity], [Price], [CreatedAt], [UpdatedAt]) VALUES (50, 39, 3, 1, CAST(21290000.00 AS Decimal(10, 2)), NULL, NULL)
SET IDENTITY_INSERT [dbo].[OrderItems] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([Id], [UserId], [OrderDate], [TotalAmount], [Status], [ShippingAddress], [CreatedAt], [UpdatedAt], [Name]) VALUES (33, 15, CAST(N'2025-01-17T13:18:52.477' AS DateTime), CAST(21680000.00 AS Decimal(10, 2)), N'1', N'Địa chỉ giao hàng mặc định', NULL, NULL, N'DonHang20250117131852')
INSERT [dbo].[Orders] ([Id], [UserId], [OrderDate], [TotalAmount], [Status], [ShippingAddress], [CreatedAt], [UpdatedAt], [Name]) VALUES (34, 15, CAST(N'2025-01-17T13:22:07.387' AS DateTime), CAST(28140000.00 AS Decimal(10, 2)), N'1', N'Địa chỉ giao hàng mặc định', NULL, NULL, N'DonHang20250117132207')
INSERT [dbo].[Orders] ([Id], [UserId], [OrderDate], [TotalAmount], [Status], [ShippingAddress], [CreatedAt], [UpdatedAt], [Name]) VALUES (38, 16, CAST(N'2025-01-17T17:40:23.123' AS DateTime), CAST(64960000.00 AS Decimal(10, 2)), N'1', N'Địa chỉ giao hàng mặc định', NULL, NULL, N'DonHang20250117174023')
INSERT [dbo].[Orders] ([Id], [UserId], [OrderDate], [TotalAmount], [Status], [ShippingAddress], [CreatedAt], [UpdatedAt], [Name]) VALUES (39, 17, CAST(N'2025-01-17T17:52:21.517' AS DateTime), CAST(54480000.00 AS Decimal(10, 2)), N'1', N'Địa chỉ giao hàng mặc định', NULL, NULL, N'DonHang20250117175221')
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (1, N'iPhone 16 Pro Max | Chính hãng VN/A', N'Máy mới 100% , chính hãng Apple Việt Nam.
CellphoneS hiện là đại lý bán lẻ uỷ quyền iPhone chính hãng VN/A của Apple Việt Nam', N'iPhone 16 Pro Max sở hữu màn hình 6.9 inch với công nghệ ProMotion, mang lại trải nghiệm hiển thị mượt mà và sắc nét, lý tưởng cho giải trí và làm việc. Với chip A18 Pro mạnh mẽ, mẫu iPhone đời mới này cung cấp hiệu suất vượt trội, giúp xử lý mượt mà các tác vụ nặng như chơi game hay edit video. Chiếc điện thoại iPhone 16 mới này còn sở hữu hệ thống camera Ultra Wide 48MP cho khả năng chụp ảnh cực kỳ chi tiết, mang đến chất lượng hình ảnh ấn tượng trong mọi tình huống.', CAST(33190000.00 AS Decimal(18, 2)), 1, 1, N'iphone-16-pro-max.png', NULL, NULL, NULL)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (2, N'Laptop ASUS Gaming VivoBook GO 15 E1504FA', N'Laptop Asus Gaming VivoBook K3605ZC-RP564W - Laptop sở hữu màn hình bắt mắt và hiệu suất tản nhiệt vượt trội ', N'Laptop Asus Gaming VivoBook K3605ZC-RP564W là lựa chọn đáng tham khảo dành cho cộng đồng game thủ. Với vi xử lý và card đồ họa thế hệ mới, chiếc laptop nhà Asus có khả năng xử lý mượt mà mọi tác vụ hàng ngày. Đặc biệt hơn, thiết bị laptop Vivobook gaming này còn tích hợp công nghệ tản nhiệt nhằm đảm bảo hiệu suất hoạt động luôn ổn định. ', CAST(18190000.00 AS Decimal(18, 2)), 2, 4, N'text_ng_n_24__3_26.png', NULL, NULL, NULL)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (3, N'iPhone 16 128GB | Chính hãng VN/A', N'iPhone 16 thường là thế hệ điện thoại Apple năm 2024 với nhiều nâng cấp về thiết kế và tính năng. Vậy cụ thể thế hệ iPhone mới này có gì nổi bật, cùng tìm hiểu sau đây.', N'Điện thoại iPhone 16 thường 128GB sở hữu nút Điều Khiển Camera mới. Theo đó nút điều khiển camera giúp người dùng có thể truy cập nhanh vào các công cụ điều khiển camera. Với các thao tác đơn giản như trượt ngón tay để thay đổi các chức năng như chiều sâu trường ảnh, độ phơi sáng. Hay thao tác chuyển đổi qua lại giữa các ống kính tiện lợi. Khi chưa ở trong ứng dụng camera, người dùng chỉ cần bấm để truy cập và thêm 1 thao tác bấm để có thể chụp ảnh ngay.', CAST(21290000.00 AS Decimal(18, 2)), 1, 1, N'iphone-16-1.png', NULL, NULL, 1)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (4, N'iPhone 14 128GB | Chính hãng VN/A', N'iPhone 14 128GB sở hữu màn hình Retina XDR OLED kích thước 6.1 inch cùng độ sáng vượt trội lên đến 1200 nits. Máy cũng được trang bị camera kép 12 MP phía sau cùng cảm biến điểm ảnh lớn, đạt 1.9 micron giúp cải thiện khả năng chụp thiếu sáng. Mẫu iPhone 14 mới cũng mang trong mình con chip Apple A15 Bionic phiên bản 5 nhân mang lại hiệu suất vượt trội.', N'iPhone 14 vàng là phiên bản màu sắc mới được Apple cập nhật vào tháng 3/2023. Điện thoại iPhone 14 vàng chanh này được hoàn thiệt mặt sau bằng kinh và cạnh viền nhôm màu vàng rực rõ. Các chi tiết khác sẽ giống những mẫu iPhone 14 phiên bản màu khác. Cụ thể, iPhone 14 vàng được trang bị màn hình OLED 6.1 inch siêu sắc nét. Hiệu năng vượt trội tới từ chipset đầu bảng - A15 Bionic. Hệ thống camera với nhiều cải tiến mới cùng dung lượng pin 3279mAh giúp nâng cao trải nghiệm của người dùng.', CAST(15990000.00 AS Decimal(18, 2)), 1, 1, N'iphone-14_1.png', NULL, NULL, NULL)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (5, N'iPhone 13 256GB | Chính hãng VN/A', N'Máy mới 100% , chính hãng Apple Việt Nam.
CellphoneS hiện là đại lý bán lẻ uỷ quyền iPhone chính hãng VN/A của Apple Việt Nam', N'Hiệu năng vượt trội - Chip Apple A15 Bionic mạnh mẽ, hỗ trợ mạng 5G tốc độ cao.
Không gian hiển thị sống động - Màn hình 6.1" Super Retina XDR độ sáng cao, sắc nét.
Trải nghiệm điện ảnh đỉnh cao - Camera kép 12MP, hỗ trợ ổn định hình ảnh quang học.
Tối ưu điện năng - Sạc nhanh 20 W, đầy 50% pin trong khoảng 30 phút.', CAST(17090000.00 AS Decimal(18, 2)), 1, 1, N'11_3_12_2_1_6.png', NULL, NULL, NULL)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (6, N'iPhone 12 Pro 256GB | Chính hãng VN/A', N'<p>Mẫu iPhone 2020 mới nhất của Apple được thiết kế khung viền vu&ocirc;ng sang trọng được nhiều người d&ugrave;ng y&ecirc;u th&iacute;ch. Trong đ&oacute;, phi&ecirc;n bản iPhone 12 Pro 256GB ch&iacute;nh h&atilde;ng VNA hứa hẹn l&agrave; một trong những sự lựa chọn l&yacute; tưởng.</p>
', N'<p>Điện thoại iPhone kh&ocirc;ng hỗ trợ thẻ nhớ n&ecirc;n lựa chọn phi&ecirc;n bản bộ nhớ trong n&agrave;o được kh&aacute; nhiều người d&ugrave;ng quan t&acirc;m.</p>

<p>Nếu phi&ecirc;n bản 64GB hơi nhỏ th&igrave; 512 lại kh&aacute; lớn. Do đ&oacute;, iPhone 12 Pro 256GB ch&iacute;nh h&atilde;ng VNA hứa hẹn sẽ l&agrave; phi&ecirc;n bản được nhiều người d&ugrave;ng quan t&acirc;m.</p>

<p>iPhone 12 Pro 256GB ch&iacute;nh h&atilde;ng VNA được thiết kế với khung viền vu&ocirc;ng vắn &ndash; sang trọng. Thiết kế mang hơi hướng của c&aacute;c sản phẩm iPhone 4, 5 trước đ&oacute;.</p>

<p>M&aacute;y hỗ trợ kết nối 4G, mang đến tốc độ lướt web nhanh ch&oacute;ng.</p>
', CAST(24990000.00 AS Decimal(18, 2)), 1, 1, N'iphone-12-pro-256gb.png', NULL, NULL, 2)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (7, N'iPhone 15 Pro 128GB | Chính hãng VN/A', N'<p>Điện thoại iPhone 15 Pro l&agrave; 1 trong 2 điện thoại cao cấp nhất trong series iPhone 15 năm 2023. Một số điểm được cải tiến nổi bật tr&ecirc;n IP 15 Pro c&oacute; thể kể đến như: m&agrave;n h&igrave;nh mỏng hơn, chip A17 Pro mới, dung lượng pin n&acirc;ng cấp, thiết kế chất liệu titanium, camera n&acirc;ng cấp v&agrave; 4 m&agrave;u sắc mới ho&agrave;n to&agrave;n.</p>
', N'<p>Điện thoại iPhone 15 Pro được trang bị m&agrave;n h&igrave;nh mới Dynamic Island với k&iacute;ch thước 6.1 inch c&ugrave;ng c&ocirc;ng nghệ ProMotion v&agrave; t&iacute;nh năng Always On Display.</p>

<p>Thiết bị cũng c&oacute; nhiều thay đổi trong thiết kế với n&uacute;t h&agrave;nh động c&ugrave;ng cổng sạc USB-C, khung viền titan sang trọng.</p>

<p>Thế hệ điện thoại iPhone 15 mới n&agrave;y được trang bị 04 m&agrave;u sắc mới như Titan tự nhi&ecirc;n, titan đen, titan trắng v&agrave; titan xanh.</p>
', CAST(24890000.00 AS Decimal(18, 2)), 1, 1, N'iphone-15-pro-max_4.png', NULL, NULL, 1)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (8, N'Điện thoại Samsung Galaxy S24 FE 5G 8GB/128GB', N'<p>Trải nghiệm đỉnh cao với hiệu năng mạnh mẽ từ vi xử l&yacute; t&acirc;n tiến, kết hợp c&ugrave;ng RAM 12GB cho khả năng đa nhiệm mượt m&agrave;.</p>
', N'<p>Samsung S24 Ultra l&agrave; si&ecirc;u phẩm smartphone đỉnh cao mở đầu năm 2024 đến từ nh&agrave; Samsung với chip Snapdragon 8 Gen 3 For Galaxy mạnh mẽ, c&ocirc;ng nghệ tương lai Galaxy AI c&ugrave;ng khung viền Titan đẳng cấp hứa hẹn sẽ mang tới nhiều sự thay đổi lớn về mặt thiết kế v&agrave; cấu h&igrave;nh.</p>

<p>SS Galaxy S24 bản Ultra sở hữu m&agrave;n h&igrave;nh 6.8 inch Dynamic AMOLED 2X tần số qu&eacute;t 120Hz.</p>

<p>M&aacute;y cũng sở hữu camera ch&iacute;nh 200MP, camera zoom quang học 50MP, camera tele 10MP v&agrave; camera g&oacute;c si&ecirc;u rộng 12MP.</p>
', CAST(25490000.00 AS Decimal(18, 2)), 1, 2, N'samsung-galaxy-s24-fe-mint-1-638642565652751047-750x500.jpg', NULL, NULL, 2)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (9, N'Samsung Galaxy A16 5G 8GB 128GB', N'Samsung A16 sở hữu màn hình Super AMOLED 6.7 inch, tần số quét 90Hz với vi xử lý Dimensity 6300 (6nm) và viên pin đạt đến 5000mAh. Hệ thống camera đa ống kính với camera chính 50MP, camera góc siêu rộng 5MP và camera macro 2MP. Máy sẽ chạy trên hệ điều hành Android cùng các tính năng khác như SIM kép, hỗ trợ 5G, cảm biến vân tay, Bluetooth 5.3,...', N'Màn hình Super AMOLED 6.7 inch, tần số quét 90Hz, giúp hiển thị màu sắc rực rỡ và hình ảnh mượt mà.
Bộ ba camera bao gồm camera chính 50 MP, camera góc siêu rộng 5 MP và camera macro 2 MP, cho phép chụp ảnh đa dạng và chi tiết​.
Chip MediaTek Dimensity 6300(6nm) đảm bảo xử lý tác vụ mượt mà và khả năng chơi game ổn định​.
Pin dung lượng 5000 mAh hỗ trợ sạc nhanh 25W, cung cấp thời gian sử dụng lâu dài và sạc nhanh chóng​.', CAST(6090000.00 AS Decimal(18, 2)), 1, 2, N'samsung-a16-5g_2_.png', NULL, NULL, NULL)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (10, N'Samsung Galaxy A05S 4GB 128GB', N'Samsung Galaxy A05s được trang bị con chip Qualcomm Snapdragon 680 cùng với đó là dung lượng pin lớn 5000mAh, công nghệ sạc nhanh 25W và màn hình 6.7 inch chất lượng. Đặc biệt, hãng còn nâng cấp cả camera sau lên tới 50MP và camera selfie 13MP để mang tới cho người dùng trải nghiệm trọn vẹn nhất. Hứa hẹn đây sẽ là mẫu smartphone trong tầm giá giúp người dùng thoải mái khám phá thế giới đầy sắc màu.', N'Hiển thị sống động từng thước phim - Màn hình lớn 6.7" IPS hiển thị sắc nét.
Vận hành tác vụ mượt mà như mong đợi - Xử lí tốt hơn với chip Snapdragon 680 và RAM 4GB.
Sử dụng thoải mái cả ngày dài - Pin lớn 5000mAh và hỗ trợ sạc nhanh 25W.
Ghi lại trọn vẹn mọi khoảnh khắc - Camera sau đến 50MP đi kèm nhiều chế độ chụp và tính năng cải tiến.', CAST(2790000.00 AS Decimal(18, 2)), 1, 2, N'samsung-galaxy-a05sl.png', NULL, NULL, NULL)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (11, N'Samsung Galaxy S24 8GB 256GB', N'Điện thoại Samsung Galaxy S24 được trang bị bộ xử lý Exynos 2400 do Samsung tự sản xuất với 10 nhân CPU cùng bộ nhớ RAM 8GB, bộ nhớ trong 256GB. Màn hình thiết bị với kích thước 6.2 inch với khung viền siêu mỏng cùng công nghệ Dynamic AMOLED 2X. Phía sau điện thoại là cụm ba camera 50MP + 10MP + 12MP. Cùng với đó, Samsung S24 sở hữu nhiều tính năng AI hữu ích như dịch thuật trực tiếp, tìm kiếm bằng hình ảnh,...', N'Khai phá tiềm năng sáng tạo không giới hạn với tính năng AI - Phiên dịch cuộc gọi, trợ lí chỉnh ảnh.
Sắc nét từng chi tiết - Camera 50MP với với công nghệ ProVisual, chụp đêm và siêu thu phóng.
Pin tối ưu thông minh cho cả ngày tràn đầy năng lượng - Viên pin 4000mAh cho phép bạn xem video liên tục đến 29 giờ.
Nâng cấp màn hình trải nghiệm tuyệt đỉnh - Màn hình 6.2" inch Dynamic AMOLED 2X cùng tần số quét 120Hz.', CAST(17990000.00 AS Decimal(18, 2)), 1, 2, N'samsung-galaxy-s24_7_.png', NULL, NULL, 1)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (12, N'Samsung Galaxy S21 FE 8GB 128GB', N'<p>Samsung S21 FE 8GB 128GB sở hữu chipset Exynos 2100 mạnh mẽ c&oacute; thể chơi mượt m&agrave;, RAM 8GB v&agrave; ROM 128GB cho khả năng đa nhiệm v&agrave; lưu trữ ổn định. Th&ecirc;m v&agrave;o đ&oacute; cụm camera chất lượng, cho h&igrave;nh ảnh sắc n&eacute;t: 12MP+12MP+8MP v&agrave; camera selfie 32MP. Kh&ocirc;ng chỉ vậy, c&aacute;c phi&ecirc;n bản m&agrave;u sắc thanh lịch, thời thượng gi&uacute;p sản phẩm nổi bật hơn giữa h&agrave;ng loạt c&aacute;c thương hiệu kh&aacute;c.</p>
', N'<p>Thiết kế cao cấp - Vẻ đẹp tinh tế c&ugrave;ng nhiều m&agrave;u sắc thời thượng.</p>

<p>Trọn vẹn từng khung h&igrave;nh - M&agrave;n h&igrave;nh 6.4&quot;, độ s&aacute;ng cao c&ugrave;ng tần số qu&eacute;t 120Hz.</p>

<p>Sắc n&eacute;t từng khung h&igrave;nh - Bộ ba camera 12MP, hỗ trợ quay video 4K, chống rung điện từ EIS.</p>

<p>Mượt m&agrave; mọi t&aacute;c vụ - Chip Exynos 2100 tiến tr&igrave;nh 5nm mạnh mẽ.</p>
', CAST(8800000.00 AS Decimal(18, 2)), 1, 2, N'sm-g990_s21fe_backfront_zw.png', NULL, NULL, 2)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (13, N'Samsung Galaxy S22 Ultra (8GB - 128GB)', N'Thiết kế nguyên khối - kính sang trọng với độ bền tối ưu.
Ống kính 108MP mang lại khả năng chụp ảnh không giới hạn.', N'Vi xử lý mạnh mẽ nhất Galaxy - Snapdragon 8 Gen 1 (4 nm).
Camera mắt thần bóng đêm Nightography - Chụp đêm cực đỉnh.
S Pen đầu tiên trên Galaxy S - Độ trễ thấp, dễ thao tác.
Dung lượng pin bất chấp ngày đêm - Viên pin 5000mAh, sạc nhanh 45W.', CAST(30990000.00 AS Decimal(18, 2)), 1, 2, N'sm-s908_galaxys22ultra_front_green_211119.png', NULL, NULL, NULL)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (14, N'Tai nghe Bluetooth True Wireless Samsung', N'Chống ồn ANC thông minh, thoải mái đàm thoại.
Loa hai chiều mang lại trải nghiệm âm thanh chất lượng.', N'Thiết kế chuẩn công thái học phong cách, ôm khít vào tai, hạn chế rơi khi di chuyển.
Đắm chìm trong không gian âm nhạc riêng với tính năng chống ồn ANC và 360 Audio.
Không ngại mưa rơi hay tập luyện cường độ cao khi sở hữu chuẩn kháng nước IPX7.
Đạt chuẩn Bluetooth 5.3 mới nhất cho kết nối ổn định, nhận diện thiết bị nhanh chóng.', CAST(2490000.00 AS Decimal(18, 2)), 3, 2, N'samsung-galaxy-buds-2-pro-_8_.png', NULL, NULL, NULL)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (15, N'Tai nghe Bluetooth True Wireless Gaming', N'<p>Tai nghe kh&ocirc;ng d&acirc;y ROG Cetra - Tiện lợi, &acirc;m thanh sống động ROG Cetra th&iacute;ch hợp cho mọi độ tuổi đặc biệt l&agrave; giới trẻ thường xuy&ecirc;n học h&agrave;nh, l&agrave;m việc v&agrave; giải tr&iacute;. Tai nghe gi&uacute;p cho người d&ugrave;ng c&oacute; nhiều kh&ocirc;ng gian ri&ecirc;ng tư, t&iacute;ch hợp c&ocirc;ng nghệ chống ồn th&ocirc;ng minh.</p>
', N'<p>Độ trễ thấp hỗ trợ đồng bộ h&oacute;a &acirc;m thanh với video tốt, cho bạn c&oacute; th&ecirc;m lợi thế khi chơi game.</p>

<p>C&ocirc;ng nghệ chống ồn k&eacute;p ANC c&oacute; thể ph&aacute;t hiện, lọc tiếng ồn b&ecirc;n ngo&agrave;i v&agrave; b&ecirc;n trong tai nghe.</p>

<p>Thời lượng pin ấn tượng đến 27 giờ, t&iacute;ch hợp c&ocirc;ng nghệ sạc nhanh v&agrave; sạc kh&ocirc;ng d&acirc;y tiện lợi.</p>

<p>Tinh chỉnh EQ, &acirc;m thanh ảo 7.1 tuỳ theo sở th&iacute;ch c&aacute; nh&acirc;n th&ocirc;ng qua ứng dụng Armory Crate.</p>
', CAST(1590000.00 AS Decimal(18, 2)), 3, 4, N'rog_cetra_1.png', NULL, NULL, 2)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (16, N'Tai nghe chụp tai Gaming Asus TUF H1', N'Tai nghe Gaming ASUS TUF H1 - Đắm chìm vào âm thanh vòm
ASUS TUF H1 Gaming Headset là lựa chọn lý tưởng cho game thủ tìm kiếm sự kết hợp hoàn hảo giữa âm thanh sống động và thiết kế bền bỉ. Với khả năng tái hiện âm thanh rõ ràng, sắc nét, chiếc tai nghe này mang đến trải nghiệm chơi game đỉnh cao, giúp người dùng cảm nhận trọn vẹn từng chi tiết trong mỗi trận đấu. TUF H1 không chỉ nâng tầm hiệu suất mà còn mang đến sự thoải mái tối đa cho người sử dụng.', N'Màng loa kích thước lớn 40mm mang đến chất lượng âm thanh sống động, chi tiết và sắc nét.
Hỗ trợ đa nền tảng giúp dễ dàng kết nối với đa dạng thiết bị như PC, MAC, Nintendo Switch,...
Thiết kế chụp tai cùng trọng lượng nhẹ chỉ 287 gram và khung treo đảm bảo thoải mái cả ngày.
Trang bị trình điều khiển ASUS Essence cùng công nghệ buồng kín cho âm thanh đắm chìm.', CAST(790000.00 AS Decimal(18, 2)), 3, 4, N'27_2_36.png', NULL, NULL, 2)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (17, N'Đồng hồ Orient Contemporary 40 mm Nam PABLO RAEZ', N'Thương hiệu của Nhật Bản.', N'Orient là thương hiệu đồng hồ lâu năm, uy tín và chất lượng, Orient luôn luôn cải tiến trong chất lượng và đa dạng về kiểu dáng thiết kế. ', CAST(6037000.00 AS Decimal(18, 2)), 4, 5, N'orient-ra-tx0306s10b-nam-1-638654690360620523-750x500.jpg', NULL, NULL, NULL)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (18, N'Pin sạc dự phòng Aukey 10000MAH PD 20W', N'<p>Mới, đầy đủ phụ kiện từ nh&agrave; sản xuất. Sạc dự ph&ograve;ng, Cáp sạc USB-C, Sách hướng d&acirc;̃n.</p>
', N'<p>K&iacute;ch thước nhỏ nằm gọn trong l&ograve;ng b&agrave;n tay, chất liệu bền bỉ gi&uacute;p linh hoạt khi di chuyển.</p>

<p>Cổng USB-C PD 3.0 hỗ trợ sạc nhanh cho iPhone 12 l&ecirc;n 50% pin chỉ vỏn vẹn 30 ph&uacute;t.</p>

<p>Bảo vệ thiết bị chống sạc đoản mạch, qu&aacute; d&ograve;ng, qu&aacute; tải gi&uacute;p an to&agrave;n hơn khi sử dụng.</p>

<p>Sạc được cho điện thoại, tai nghe, đồng hồ,... nhiều lần với dung lượng pin 10.000mAh.</p>
', CAST(490000.00 AS Decimal(18, 2)), 5, 9, N'n83s_3_1.png', NULL, NULL, 1)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (19, N'Smart Tivi Samsung QLED 4K 55 inch', N'<p>Smart Tivi Samsung QLED 55Q60D 4K 55 inch 2024 &ndash; Trải nghiệm m&agrave;n ảnh rực rỡ Smart Tivi Samsung QLED 55Q60D 4K 55 inch 2024 t&aacute;i hiện mọi nội dung chuẩn 4K tr&ecirc;n khung h&igrave;nh rộng. Với thiết kế thanh mảnh c&ugrave;ng loạt c&ocirc;ng nghệ h&igrave;nh ảnh chuy&ecirc;n nghiệp, mẫu tivi Samsung 55 inch n&agrave;y rất th&iacute;ch hợp để n&acirc;ng tầm giải tr&iacute; tại gia.</p>
', N'<p>C&ocirc;ng nghệ QLED sử dụng Quantum Dot để tạo ra dải m&agrave;u rộng hơn v&agrave; m&agrave;u sắc rực rỡ hơn.</p>

<p>Hỗ trợ ALLM (Auto Low Latency Mode): Giảm độ trễ đầu v&agrave;o cho trải nghiệm chơi game mượt m&agrave; hơn.</p>

<p>Giao diện trực quan, dễ sử dụng, truy cập h&agrave;ng ng&agrave;n ứng dụng giải tr&iacute;, điều khiển bằng giọng n&oacute;i th&ocirc;ng minh th&ocirc;ng qua Bixby.</p>

<p>Hỗ trợ Dolby Atmos: Cung cấp &acirc;m thanh v&ograve;m 3D ấn tượng, cho bạn cảm gi&aacute;c như đang ở trong rạp chiếu phim.</p>
', CAST(12990000.00 AS Decimal(18, 2)), 6, 2, N'smart-tivi-samsung-qled-85q80d-4k-85-inch-2024_12__1_1.png', NULL, NULL, NULL)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (34, N'Laptop Acer Aspire 3 Spin A3SP14-31PT-387Z', N'<p><strong>Laptop Acer Aspire 3 Spin 14 A3SP14-31PT-387Z</strong>&nbsp;với chip Intel Core i3-N305, 8GB RAM v&agrave; SSD 512GB, mang lại hiệu năng ổn định cho c&aacute;c t&aacute;c vụ, kể cả đồ hoạ.</p>
', N'<ul>
	<li>Thiết kế 2-trong-1 linh hoạt, kết hợp giữa laptop v&agrave; m&aacute;y t&iacute;nh bảng với m&agrave;n h&igrave;nh cảm ứng xoay 360 độ.</li>
	<li>M&agrave;n h&igrave;nh 14 inch Full HD+ cung cấp h&igrave;nh ảnh sắc n&eacute;t v&agrave; g&oacute;c nh&igrave;n rộng, ph&ugrave; hợp cho cả c&ocirc;ng việc v&agrave; giải tr&iacute;.</li>
	<li>Bộ vi xử l&yacute; Intel Core i3-N305 thế hệ mới đảm bảo hiệu suất ổn định cho c&aacute;c t&aacute;c vụ h&agrave;ng ng&agrave;y v&agrave; đa nhiệm nhẹ.</li>
	<li>Với 8GB RAM v&agrave; ổ cứng SSD 512GB, m&aacute;y cho ph&eacute;p khởi động nhanh, mở ứng dụng mượt m&agrave; v&agrave; lưu trữ dữ liệu đủ d&ugrave;ng.</li>
	<li>Thiết kế m&agrave;u x&aacute;m trang nh&atilde; kết hợp với khung m&aacute;y mỏng nhẹ, gi&uacute;p dễ d&agrave;ng mang theo khi di chuyển.</li>
</ul>
', CAST(9490000.00 AS Decimal(18, 2)), 2, 4, N'text_ng_n_38__6_4.png', NULL, NULL, 1)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (35, N'Vòng đeo tay thông minh Xiaomi Mi Band 9 Pro', N'<p><strong>V&ograve;ng đeo tay th&ocirc;ng minh Xiaomi Mi Band 9 Pro&nbsp;</strong>sở hữu m&agrave;n h&igrave;nh AMOLED 1,74 inch độ s&aacute;ng đến 1.200 nits, mang lại trải nghiệm hiển thị tuyệt vời ngay dưới &aacute;nh s&aacute;ng mạnh.</p>
', N'<ul>
	<li>M&agrave;n h&igrave;nh AMOLED rộng r&atilde;i, v&ograve;ng tay cung cấp h&igrave;nh ảnh sắc n&eacute;t v&agrave; dễ đọc, ngay cả dưới &aacute;nh s&aacute;ng mạnh.</li>
	<li>T&iacute;ch hợp nhiều cảm biến để theo d&otilde;i nhịp tim, giấc ngủ, v&agrave; c&aacute;c chỉ số sức khỏe kh&aacute;c, gi&uacute;p người d&ugrave;ng quản l&yacute; t&igrave;nh trạng sức khỏe tốt hơn.</li>
	<li>Hỗ trợ nhiều chế độ tập luyện, từ chạy bộ đến bơi lội, gi&uacute;p người d&ugrave;ng theo d&otilde;i hiệu quả tập luyện.</li>
	<li>Pin c&oacute; thể sử dụng l&ecirc;n đến 21 ng&agrave;y, người d&ugrave;ng kh&ocirc;ng cần lo lắng về việc sạc thường xuy&ecirc;n.</li>
</ul>
', CAST(1790000.00 AS Decimal(18, 2)), 4, 2, N'text_ng_n_1__7_26.png', NULL, NULL, 2)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (36, N'Smart Tivi LG 4K 65 inch LED 2024 (65UT7350)', N'<p><strong>Smart Tivi LG 65UT7350 LED 4K 65 inch&nbsp;</strong>sở hữu m&agrave;n h&igrave;nh LED với độ ph&acirc;n giải 4K (3840 x 2160) Ultra HD cho h&igrave;nh ảnh ch&acirc;n thật, r&otilde; n&eacute;t gấp 4 lần Full HD.</p>
', N'<ul>
	<li>Độ ph&acirc;n giải 4K cho h&igrave;nh ảnh sắc n&eacute;t, chi tiết gấp 4 lần Full HD.</li>
	<li>M&agrave;n h&igrave;nh 65 inch lớn cho tầm nh&igrave;n rộng r&atilde;i, ph&ugrave; hợp với mọi kh&ocirc;ng gian ph&ograve;ng kh&aacute;ch.</li>
	<li>&Acirc;m thanh v&ograve;m 360 độ, loa t&iacute;ch hợp c&ocirc;ng suất lớn, cho trải nghiệm &acirc;m thanh ch&acirc;n thực v&agrave; sống động.</li>
	<li>HDMI, USB, LAN, Wi-Fi 6, Bluetooth 5.0, kết nối Tivi với nhiều thiết bị kh&aacute;c nhau.</li>
</ul>
', CAST(11900000.00 AS Decimal(18, 2)), 6, 2, N'smart-tivi-lg-oled-evo-97g4psa-4k-91-inch-2024_13__1.png', NULL, NULL, 2)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (37, N'Phần mềm Windows 10 Home 32-bit/64-bit', N'<p><strong><a href="https://cellphones.com.vn/windows-10-pro-32-bit-64-bit.html" target="_blank">Phần mềm Windows 10 Home</a></strong>32-bit/64-bit bản quyền đ&atilde; thay đổi ho&agrave;n to&agrave;n kh&aacute;i niệm về một chiếc&nbsp;PC&nbsp;với thiết kế nhẹ hơn, mỏng hơn v&agrave; đẳng cấp hơn cả về bề ngo&agrave;i lẫn hiệu năng.</p>
', N'<ul>
	<li>Hệ điều h&agrave;nh Windows 10 mới với giao diện th&acirc;n thiện</li>
	<li>Tr&igrave;nh duyệt mới toanh Microsoft Edge, gi&uacute;p người d&ugrave;ng nhanh ch&oacute;ng đọc, duyệt, chia sẻ v&agrave; đ&aacute;nh dấu trang</li>
	<li>T&iacute;ch hợp trợ l&yacute; ảo Cortana c&oacute; khả năng t&igrave;m kiếm đ&uacute;ng th&ocirc;ng tin v&agrave;o đ&uacute;ng thời điểm</li>
	<li>Windows Update sẽ tự động cập nhật từ Microsoft cho thiết bị</li>
</ul>
', CAST(500000.00 AS Decimal(18, 2)), 23, 3, N'windows-10-home-32-bit-64-bit-all-languages-kw9-0-cava-600x600.png', NULL, NULL, 2)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (38, N'iPad mini 7 2024 Wifi 128GB | Chính hãng Apple', N'<p><strong>iPad mini 7&nbsp;</strong>cung cấp khả năng hiển thị với độ ch&acirc;n thực, sống động cao nhờ được ưu &aacute;i trang bị tấm nền m&agrave;n h&igrave;nh&nbsp;<strong>Liquid Retina 8.3 inch&nbsp;</strong>thế hệ mới.</p>
', N'<ul>
	<li>iPad Mini 7 2024 sở hữu thiết kế si&ecirc;u nhỏ gọn v&agrave; nhẹ, với m&agrave;n h&igrave;nh Retina 8.3 inch sắc n&eacute;t v&agrave; hỗ trợ True Tone.</li>
	<li>Được trang bị chip A17 Pro mạnh mẽ, iPad Mini 7 đảm bảo hiệu suất ổn định cho mọi t&aacute;c vụ từ lướt web, xem phim đến chơi game.</li>
	<li>Dung lượng lưu trữ 128GB cung cấp đủ kh&ocirc;ng gian để lưu trữ c&aacute;c t&agrave;i liệu, ảnh, video v&agrave; ứng dụng y&ecirc;u th&iacute;ch của người d&ugrave;ng.</li>
	<li>Camera 12MP ở mặt trước v&agrave; camera 12MP ở mặt sau gi&uacute;p chụp ảnh, quay video chất lượng cao phục vụ c&ocirc;ng việc cũng như chia sẻ tr&ecirc;n mạng x&atilde; hội.</li>
</ul>
', CAST(13990000.00 AS Decimal(18, 2)), 1, 1, N'text_ng_n_13_7.png', NULL, NULL, 2)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (39, N'Laptop Gaming Acer Nitro V ANV15-51-58AN', N'<p><strong>Laptop Acer Nitro V&nbsp;</strong>mang một thiết kế gaming mạnh mẽ, m&agrave;n h&igrave;nh 15.6&rdquo; 144Hz FHD, cấu h&igrave;nh c&acirc;n mọi tựa game với chip i5-13420H từ Intel.</p>
', N'<ul>
	<li>CPU Intel Core i5-13420H c&acirc;n mọi tựa game từ AAA đến game Esport.</li>
	<li>GPU GeForce RTX 2050 mới nhất cho đồ họa cực đỉnh, chiến mọi tựa game với mức c&agrave;i đặt cao.</li>
	<li>RAM 8 GB DDR5 5200Mhz, khả năng xử l&yacute; đa nhiệm v&agrave; đa t&aacute;c vụ của m&aacute;y c&agrave;ng được tăng tốc tối đa.</li>
	<li>M&agrave;n h&igrave;nh 15.6 inch Full HD, tần số qu&eacute;t chuẩn chiến game 144Hz.</li>
	<li>Ổ cứng&nbsp;512GB PCIE rộng r&atilde;i, lưu mọi tựa game dễ d&agrave;ng.</li>
</ul>
', CAST(16990000.00 AS Decimal(18, 2)), 2, 9, N'text_ng_n_9__4_4.png', NULL, NULL, 2)
INSERT [dbo].[Products] ([Id], [Name], [Description], [Details], [Price], [CategoryId], [BrandId], [Images], [CreatedAt], [UpdatedAt], [TypeId]) VALUES (42, N'Máy tính bảng HONOR Pad X8a WiFi 4GB/64GB', N'<p>Bộ sản phẩm gồm: Hộp m&aacute;y, S&aacute;ch hướng dẫn, Củ sạc nhanh rời đầu Type C, C&aacute;p Type C - Type C</p>
', N'<p><strong>C&ocirc;ng nghệ m&agrave;n h&igrave;nh:&nbsp;</strong><a href="https://www.thegioididong.com/hoi-dap/man-hinh-ips-lcd-la-gi-905752" target="_blank">IPS LCD</a></p>

<p><strong>Độ ph&acirc;n giải:&nbsp;</strong>1200 x 1920 Pixels</p>

<p><strong>M&agrave;n h&igrave;nh rộng:</strong>&nbsp;11&quot; - Tần số qu&eacute;t&nbsp;<a href="https://www.thegioididong.com/hoi-dap/tan-so-quet-tren-dien-thoai-la-gi-co-phai-la-xu-hu-1343818" target="_blank">90 Hz</a></p>
', CAST(4690000.00 AS Decimal(18, 2)), 22, 16, N'honor-pad-x8a-xam-5-638711656179617043-750x500.jpg', NULL, NULL, 2)
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FirstName], [LastName], [PhoneNumber], [IsAdmin], [CreatedAt], [UpdatedAt]) VALUES (15, N'hoanaruto9626', N'25d55ad283aa400af464c76d713c07ad', N'hoanaruto@gmail.com', N'Hòa', N'Huỳnh', N'0345160314', 0, NULL, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FirstName], [LastName], [PhoneNumber], [IsAdmin], [CreatedAt], [UpdatedAt]) VALUES (16, N'TrungTuan', N'25f9e794323b453885f5181f1b624d0b', N'TrungTuan@gmail.com', N'Tuấn', N'Nguyễn', N'7897567435', 1, NULL, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FirstName], [LastName], [PhoneNumber], [IsAdmin], [CreatedAt], [UpdatedAt]) VALUES (17, N'LeHa123', N'25d55ad283aa400af464c76d713c07ad', N'LeHa@gmail.com', N'Hà', N'Lê', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D10534E32184C6]    Script Date: 1/17/2025 6:05:01 PM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__C9F28456E0DCEC84]    Script Date: 1/17/2025 6:05:01 PM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Brands] ADD  DEFAULT (NULL) FOR [Image]
GO
ALTER TABLE [dbo].[Brands] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Brands] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Brands] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT (NULL) FOR [Image]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[OrderItems] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[OrderItems] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT (getdate()) FOR [OrderDate]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (NULL) FOR [Images]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[ShoppingCarts] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ShoppingCarts] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Stocks] ADD  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[Stocks] ADD  DEFAULT (NULL) FOR [Price]
GO
ALTER TABLE [dbo].[Stocks] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Stocks] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [IsAdmin]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Wishlists] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Wishlists] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Categories]  WITH CHECK ADD  CONSTRAINT [FK_ParentCategory] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Categories] CHECK CONSTRAINT [FK_ParentCategory]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_Order] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItem_Order]
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK_OrderItem_Product]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Order_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Order_User]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Brand_Product] FOREIGN KEY([BrandId])
REFERENCES [dbo].[Brands] ([Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Brand_Product]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Category_Product] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Category_Product]
GO
ALTER TABLE [dbo].[ShoppingCarts]  WITH CHECK ADD  CONSTRAINT [FK_Cart_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[ShoppingCarts] CHECK CONSTRAINT [FK_Cart_Product]
GO
ALTER TABLE [dbo].[ShoppingCarts]  WITH CHECK ADD  CONSTRAINT [FK_Cart_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ShoppingCarts] CHECK CONSTRAINT [FK_Cart_User]
GO
ALTER TABLE [dbo].[Stocks]  WITH CHECK ADD  CONSTRAINT [FK_Product_Stock] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[Stocks] CHECK CONSTRAINT [FK_Product_Stock]
GO
ALTER TABLE [dbo].[Wishlists]  WITH CHECK ADD  CONSTRAINT [FK_Wishlist_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[Wishlists] CHECK CONSTRAINT [FK_Wishlist_Product]
GO
ALTER TABLE [dbo].[Wishlists]  WITH CHECK ADD  CONSTRAINT [FK_Wishlist_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Wishlists] CHECK CONSTRAINT [FK_Wishlist_User]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Giảm giá sốc, 2: Đề xuất' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Products', @level2type=N'COLUMN',@level2name=N'TypeId'
GO
USE [master]
GO
ALTER DATABASE [WebsiteBanHang] SET  READ_WRITE 
GO
