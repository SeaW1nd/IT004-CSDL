--Đề thi cuối kỳ năm học 2017-2018
-- Đề 1:
--Câu 1:

create database QLTK
use QLTK
create table KhachHang (
		MAKH char(4) not null,
		HoTen varchar(40),
		NgaySinh smalldatetime,
		DiaChi varchar(40),
		SoDT varchar(20),
		CMND varchar(20)
)
create table LoaiTaiKhoan (
	MaLTK char(4) not null,
	TenLTK varchar(40),
	MoTa varchar(100)
)
create table TaiKhoan (
	SoTK char(4) not null,
	MaKH char(4),
	MaLTK char(4),
	NgayMo smalldatetime,
	SoDu numeric,
	LaiSuat numeric,
	TrangThai varchar(10)
)
create table LoaiGiaoDich (
	MaLGD char(4) not null,
	TenLGB varchar(40),
	MoTa varchar(100)
)
create table GiaoDich (
	MaGD char(4) not null,
	SoTK char(4),
	MALGD char(4),
	NgayGD smalldatetime,
	SoTien numeric,
	NoiDung varchar(100)
)

alter table KhachHang add constraint PK_KhachHang primary key (MAKH)
alter table LoaiTaiKhoan add constraint PK_LoaiTaiKhoan primary key (MaLTK)
alter table TaiKhoan add constraint PK_TaiKhoan primary key (SoTK)
alter table LoaiGiaoDich add constraint PK_LoaiGiaoDich primary key (MaLGD)
alter table GiaoDich add constraint PK_GiaoDich primary key (MaGD)

alter table TaiKhoan 
add constraint FK_TaiKhoan_KhachHang_MaKH
foreign key (MAKH) references KhachHang(MaKH)
alter table TaiKhoan 
add constraint FK_TaiKhoan_LoaiTaiKhoan_MaLTK
foreign key (MALTK) references LoaiTaiKhoan(MaLTK) 
alter table GiaoDich
add constraint FK_GiaoDich_LoaiGiaoDich
foreign key (MaLGD) references LoaiGiaoDich(MaLGD)
alter table GiaoDich
add constraint FK_GiaoDich_TaiKhoan
foreign key (SoTK) references TaiKhoan(SoTK)
--Phần 2:
--Câu a: Hiển thị thông tin các tài khoản của các khách hàng (SoTK, TrangThai, SoDu) đã mở tài khoản vào ngày ‘01/01/2017’ (NgayMo) và sắp xếp kết quả theo số dư tăng dần.
select SoTK, TrangThai, SoDu 
from TaiKhoan 
where NgayMo='2017-01-01' 
order by SoDu asc
--Câu b: Liệt kê mã loại giao dịch (MaLGD) cùng với tổng số tiền (SoTien) giao dịch của từng loại giao dịch.
select MALGD, sum(SoTien) as TongTienLGD 
from GiaoDich 
group by MALGD
--Câu c: Cho biết những khách hàng (MaKH, HoTen, CMND) đã mở cả hai loại tài khoản: tiết kiệm (TenLTK= ‘Tiết kiệm’) và thanh toán (TenLTK= ‘Thanh toán’).
select MAKH, HoTen, CMND 
from KhachHang
where MaKH in (
	select MaKH from TaiKhoan where MaLTK in (select MaLTK from LoaiTaiKhoan where TenLTK='Tiet kiem')
)
intersect
select MAKH, HoTen, CMND 
from KhachHang
where MaKH in (
	select MaKH from TaiKhoan where MaLTK in (select MaLTK from LoaiTaiKhoan where TenLTK='Thanh toan')
)
--Câu d: Liệt kê thông tin các giao dịch (MaGD, SoTK, MaLGD, NgayGD, SoTien, NoiDung) có số tiền lớn nhất trong tháng 12 năm 2017.
select * 
from GiaoDich 
where month(NgayGD)=12 
and year(NgayGD)=2017 
and SoTien>=all(select SoTien from GiaoDich)
--Câu e: Liệt kê danh sách các khách hàng (MaKH, HoTen, SoDT) đã mở tất cả các loại tài khoản.
select MAKH, HoTen, SoDT 
from KhachHang 
where not exists (
	select *
	from LoaiTaiKhoan
	where not exists (
		select * from TaiKhoan
		where KhachHang.MAKH=TaiKhoan.MaKH
		and LoaiTaiKhoan.MaLTK=TaiKhoan.MaLTK
		)
)
--Câu f: Liệt kê những loại tài khoản (MaLTK, TenLTK) được mở nhiều nhất trong năm 2016.
select LTK.MaLTK, TenLTK, count(SoTK) SoLanMo
from LoaiTaiKhoan LTK join TaiKhoan TK on LTK.MaLTK=TK.MaLTK
where year(NgayMo)=2016
group by LTK.MaLTK, TenLTK
having count(SoTK) = (select top 1 count(SoTK) SoLanMo
from LoaiTaiKhoan LTK join TaiKhoan TK on LTK.MaLTK=TK.MaLTK
where year(NgayMo)=2016
group by LTK.MaLTK
order by SoLanMo desc
)

-- Đề 2:
--Câu 1:
create database QLTK2
use QLTK2
create table KhachHang (
		MAKH char(4) not null,
		HoTen varchar(40),
		NgaySinh smalldatetime,
		DiaChi varchar(40),
		SoDT varchar(20),
		CMND varchar(20)
)
create table LoaiTaiKhoan (
	MaLTK char(4) not null,
	TenLTK varchar(40),
	MoTa varchar(100)
)
create table TaiKhoan (
	SoTK char(4) not null,
	MaKH char(4),
	MaLTK char(4),
	NgayMo smalldatetime,
	SoDu numeric,
	LaiSuat numeric,
	TrangThai varchar(10)
)
create table LoaiGiaoDich (
	MaLGD char(4) not null,
	TenLGB varchar(40),
	MoTa varchar(100)
)
create table GiaoDich (
	MaGD char(4) not null,
	SoTK char(4),
	MALGD char(4),
	NgayGD smalldatetime,
	SoTien numeric,
	NoiDung varchar(100)
)

alter table KhachHang add constraint PK_KhachHang primary key (MAKH)
alter table LoaiTaiKhoan add constraint PK_LoaiTaiKhoan primary key (MaLTK)
alter table TaiKhoan add constraint PK_TaiKhoan primary key (SoTK)
alter table LoaiGiaoDich add constraint PK_LoaiGiaoDich primary key (MaLGD)
alter table GiaoDich add constraint PK_GiaoDich primary key (MaGD)

alter table TaiKhoan 
add constraint FK_TaiKhoan_KhachHang_MaKH
foreign key (MAKH) references KhachHang(MaKH)
alter table TaiKhoan 
add constraint FK_TaiKhoan_LoaiTaiKhoan_MaLTK
foreign key (MALTK) references LoaiTaiKhoan(MaLTK) 
alter table GiaoDich
add constraint FK_GiaoDich_LoaiGiaoDich
foreign key (MaLGD) references LoaiGiaoDich(MaLGD)
alter table GiaoDich
add constraint FK_GiaoDich_TaiKhoan
foreign key (SoTK) references TaiKhoan(SoTK)
--Phần 2:
--Câu a:Hiển thị danh sách các giao dịch (MaGD, SoTK, SoTien) đã thực hiện giao dịch vào ngày ‘01/01/2017’ (NgayGD) và sắp xếp kết quả theo thứ tự giảm dần số tiền.
select MaGD, SoTK, SoTien 
from GiaoDich
where NgayGD='2017-01-01'
order by SoTien desc
--Câu b: Liệt kê mã loại tài khoản (MaLTK) cùng với tổng số dư (SoDu) của từng loại tài khoản.
select MaLTK, sum(SoDu) as TongSoDu
from TaiKhoan
group by MaLTK
--Câu c: Cho biết những khách hàng (MaKH, HoTen, CMND) đã mở cả hai loại tài khoản: thanh toán (TenLTK= ‘Thanh toán’) và vay (TenLTK= ‘Vay’).
select MAKH,HoTen,CMND 
from KhachHang
where MAKH in (
	select MaKH from TaiKhoan
	where MaLTK in (select MaLTK from LoaiTaiKhoan where TenLTK='Thanh toan')
)
intersect
select MAKH,HoTen,CMND 
from KhachHang
where MAKH in (
	select MaKH from TaiKhoan
	where MaLTK in (select MaLTK from LoaiTaiKhoan where TenLTK='Vay')
)
--Câu d: Liệt kê các tài khoản (SoTK, MaKH, MaLTK, NgayMo, SoDu, LaiSuat, TrangThai) mở trong tháng 12 năm 2017 có số dư lớn nhất.
select *
from TaiKhoan
where month(NgayMo)=12 and year(NgayMo)=2017
and SoDu>=all(select SoDu from TaiKhoan)
--Câu e: Liệt kê danh sách các tài khoản (SoTK, SoDu, TrangThai) đã thực hiện tất cả các loại giao dịch.
select SoTK, SoDu, TrangThai 
from TaiKhoan
where not exists (
	select * from LoaiGiaoDich
	where not exists (
		select * from GiaoDich
		where GiaoDich.SoTK=TaiKhoan.SoTK
		and GiaoDich.MALGD=LoaiGiaoDich.MaLGD
	)
)
--Câu f: Liệt kê các khách hàng (MaKH, HoTen) có số lượng tài khoản ‘chưa kích hoạt’ nhiều nhất.
select KhachHang.MAKH, HoTen, count(TaiKhoan.SoTK) as SLTaiKhoan
from KhachHang
join TaiKhoan
on TaiKhoan.MaKH=KhachHang.MAKH
where TrangThai='Chua kich hoat'
group by KhachHang.MAKH, HoTen
having count(TaiKhoan.SoTK)>=all (
	select count(TaiKhoan.SoTK) as SLTaiKhoan
	from KhachHang
	join TaiKhoan
	on TaiKhoan.MaKH=KhachHang.MAKH
	where TrangThai='Chua kich hoat'
	group by KhachHang.MAKH, HoTen
)