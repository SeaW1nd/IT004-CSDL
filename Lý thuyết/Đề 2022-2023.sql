create database QLCanHoTraGop
use QLCanHoTraGop

create table KhachHang(
	MaKH char(10) not null,
	TenKH varchar(100),
	NgaySinh smalldatetime,
	DiaChi varchar(100),
	CMND varchar(15)
)
create table LoaiCH(
	MaLCH char(10) not null,
	TenLCH varchar(100),
	NhomCC varchar(30)
)
create table CanHo(
	MaCH char(10) not null,
	TenCH varchar(100),
	MaLCH char(10),
	DienTich numeric,
	ViTri varchar(50),
	SoPhong int,
	Gia numeric
)
create table HinhThucTG(
	MaHT char(10) not null,
	TenHT varchar(100),
	PhanTramTT numeric,
	LaiSuat numeric,
	KyHan int
)
create table TraGop(
	MaTG char(10) not null,
	MaCH char(10),
	MaKH char(10),
	MaHT char(10),
	NgayMua smalldatetime,
	SoTienTT numeric
)

alter table KhachHang add constraint PK_KhachHang primary key (MaKH)
alter table LoaiCH add constraint PK_LoaiCH primary key (MaLCH)
alter table CanHo add constraint PK_CanHo primary key (MaCH)
alter table HinhThucTG add constraint PK_HinhThucTG primary key (MaHT)
alter table TraGop add constraint PK_TraGop primary key (MaTG)

alter table CanHo add constraint FK_CanHo_LoaiCH foreign key (MaLCH) references LoaiCH(MaLCH)
alter table TraGop add constraint FK_TraGop_CanHo foreign key (MaCH) references CanHo(MaCH)
alter table TraGop add constraint FK_TraGop_KhachHang foreign key (MaKH) references KhachHang(MaKH)
alter table TraGop add constraint FK_TraGop_HinhThucTG foreign key (MaHT) references HinhThucTG(MaHT)

--Phần 2:
--Câu a: Tìm thông tin những khách hàng (MAKH, TENKH, DIACHI) có năm sinh từ 1980 đến 1985 đã mua trả góp căn hộ vào ngày ‘1/2/2023’ (NGAYMUA).
select KhachHang.MaKH, TenKH, DiaChi
from KhachHang
join TraGop on TraGop.MaKH=KhachHang.MaKH
where year(NgaySinh) >=1980 and year(NgaySinh)<=1985
and NgayMua='2023-02-01'
--Câu b: Liệt kê thông tin các khách hàng (TENKH, DIACHI) mua trả góp căn hộ có diện tích trên 80m2. Kết quả xuất ra theo tên khách hàng có thứ tự giảm dần.
select TenKH, DiaChi
from KhachHang
join TraGop on TraGop.MaKH=KhachHang.MaKH
join CanHo on TraGop.MaCH=CanHo.MaCH
where DienTich>80
order by TenKH desc
--Câu c: Liệt kê mã loại căn hộ (MALCH), tên loại căn hộ (TENLCH) và số lượng căn hộ trong từng loại căn hộ.
select LoaiCH.MaLCH,TenLCH, count(MaCH) as SLCanHo
from LoaiCH
left join CanHo on CanHo.MaLCH=LoaiCH.MaLCH
group by LoaiCH.MaLCH, TenLCH
--Câu d: Cho biết khách hàng (MAKH, TENKH) đang trả góp nhóm chung cư (NHOMCC) ‘cao cấp’ nhưng không trả góp nhóm chung cư ‘trung cấp’.
select KhachHang.MaKH, TenKH
from KhachHang
join TraGop on TraGop.MaKH=KhachHang.MaKH
join CanHo on TraGop.MaCH=CanHo.MaCH
join LoaiCH on CanHo.MaLCH=LoaiCH.MaLCH
where NhomCC='Cao cap'
except
select KhachHang.MaKH, TenKH
from KhachHang
join TraGop on TraGop.MaKH=KhachHang.MaKH
join CanHo on TraGop.MaCH=CanHo.MaCH
join LoaiCH on CanHo.MaLCH=LoaiCH.MaLCH
where NhomCC='Trung cap'
--Câu e: Tìm khách hàng (TENKH) đã mua trả góp tất cả các căn hộ loại ‘penthouse’ của nhóm chung cư ‘cao cấp’.
select TenKH
from KhachHang
where not exists (
	select * from CanHo, LoaiCH
	where CanHo.MaLCH=LoaiCH.MaLCH
	and TenLCH='penthouse' and NhomCC='Cao cap'
	and not exists (
		select * from TraGop
		where KhachHang.MaKH=TraGop.MaKH
		and CanHo.MaCH=TraGop.MaCH
		)
	)
--Câu f: Trong năm 2022, loại căn hộ nào (MALCH, TENLCH) thuộc nhóm chung cư 'cao cấp' có số lượt bán trả góp nhiều hơn 10.
select LoaiCH.MaLCH, TenLCH, count(MaTG) as SoLuotBan
from LoaiCH
join CanHo on LoaiCH.MaLCH=CanHo.MaLCH
join TraGop on TraGop.MaCH=CanHo.MaCH
where NhomCC='Cao cap'
having count(MaTG)>10



--Đề 2:
--Câu 1:
create database QLCanHoTraGop2
use QLCanHoTraGop2

create table KhachHang(
	MaKH char(10) not null,
	TenKH varchar(100),
	NgaySinh smalldatetime,
	DiaChi varchar(100),
	CMND varchar(15)
)
create table LoaiCH(
	MaLCH char(10) not null,
	TenLCH varchar(100),
	NhomCC varchar(30)
)
create table CanHo(
	MaCH char(10) not null,
	TenCH varchar(100),
	MaLCH char(10),
	DienTich numeric,
	ViTri varchar(50),
	SoPhong int,
	Gia numeric
)
create table HinhThucTG(
	MaHT char(10) not null,
	TenHT varchar(100),
	PhanTramTT numeric,
	LaiSuat numeric,
	KyHan int
)
create table TraGop(
	MaTG char(10) not null,
	MaCH char(10),
	MaKH char(10),
	MaHT char(10),
	NgayMua smalldatetime,
	SoTienTT numeric
)

alter table KhachHang add constraint PK_KhachHang primary key (MaKH)
alter table LoaiCH add constraint PK_LoaiCH primary key (MaLCH)
alter table CanHo add constraint PK_CanHo primary key (MaCH)
alter table HinhThucTG add constraint PK_HinhThucTG primary key (MaHT)
alter table TraGop add constraint PK_TraGop primary key (MaTG)

alter table CanHo add constraint FK_CanHo_LoaiCH foreign key (MaLCH) references LoaiCH(MaLCH)
alter table TraGop add constraint FK_TraGop_CanHo foreign key (MaCH) references CanHo(MaCH)
alter table TraGop add constraint FK_TraGop_KhachHang foreign key (MaKH) references KhachHang(MaKH)
alter table TraGop add constraint FK_TraGop_HinhThucTG foreign key (MaHT) references HinhThucTG(MaHT)
--Phần 2:
--Câu a: Tìm các căn hộ (MACH, TENCH) thuộc loại ‘shophouse’ (TENLCH) có giá bán (GIA) từ 1.500.000 đồng đến 2.000.000 đồng.
select MaCH, TenCH
from CanHo
join LoaiCH on CanHo.MaLCH=LoaiCH.MaLCH
where TenLCH='shophouse'
and Gia >=1500000 and Gia<=2000000
--Câu b: Liệt kê những căn hộ (TENCH, MALCH) thực hiện trả góp trong kỳ hạn lớn hơn 120 tháng? Kết quả trả về sắp xếp theo thứ tự kỳ hạn giảm dần.
select TenCH, MaLCH
from CanHo
join TraGop on TraGop.MaCH=CanHo.MaCH
join HinhThucTG on TraGop.MaHT=HinhThucTG.MaHT
where KyHan>120
order by KyHan desc
--Câu c: Liệt kê mã hình thức trả góp (MAHT), tên hình thức trả góp (TENHT) và số lượng căn hộ trả góp trong từng hình thức trả góp.
select HinhThucTG.MaHT, TenHT, count(TraGop.MaCH) as SLCanHoTraGop
from HinhThucTG
left join TraGop on TraGop.MaHT=HinhThucTG.MaHT
group by HinhThucTG.MaHT, TenHT
--Câu d: Cho biết khách hàng (MAKH, TENKH) đang trả góp tên loại căn hộ là (TENLCH) ‘penthouse’ và tên loại căn hộ là ‘duplex’.
select KhachHang.MaKH, TenKH
from KhachHang
join TraGop on TraGop.MaKH=KhachHang.MaKH
join CanHo on TraGop.MaCH=CanHo.MaCH
join LoaiCH on CanHo.MaLCH=LoaiCH.MaLCH
where TenLCH='penthouse'
union
select KhachHang.MaKH, TenKH
from KhachHang
join TraGop on TraGop.MaKH=KhachHang.MaKH
join CanHo on TraGop.MaCH=CanHo.MaCH
join LoaiCH on CanHo.MaLCH=LoaiCH.MaLCH
where TenLCH='duplex'
--Câu e: Tìm khách hàng (TENKH) đã mua trả góp tất cả các căn hộ loại duplex của nhóm chung cư cao cấp.
select TenKH
from KhachHang
where not exists (
	select * from CanHo
	where not exists (
		select * from LoaiCH
		where TenLCH='duplex' and NhomCC='Cao cap'
		and not exists (
			select * from TraGop
			where KhachHang.MaKH=TraGop.MaKH
			and CanHo.MaCH=TraGop.MaCH
			and CanHo.MaLCH=LoaiCH.MaLCH
		)
	)
)
--Câu f: Trong năm 2019, khách hàng nào (MAKH, TENKH) có tổng tiền phải trả trước cho việc mua trả góp căn hộ 4 phòng là lớn hơn 900.000.000.
select KhachHang.MaKH, TenKH, sum(SoTienTT) as TongTienTraTruoc
from KhachHang
join TraGop on TraGop.MaKH=KhachHang.MaKH
join CanHo on CanHo.MaCH=TraGop.MaCH
where year(NgayMua)=2019
and SoPhong=4
group by KhachHang.MaKH, TenKH
having sum(SoTienTT)>900000000