--Đề 1 năm 2018-2019
--Câu 1:
create database QLDH
use QLDH
create table MatHang (
	MaMH char(5) not null,
	TenMH varchar(50),
	DVT char(10),
	NuocSX varchar(20)
)
create table NhaCC (
	MaCC char(5) not null,
	TenCC varchar(50),
	DiaChiCC varchar(100)
)
create table CungCap (
	MaCC char(5) not null,
	MaMH char(5) not null,
	TuNgay smalldatetime
)
create table DonDH (
	MaDH char(5) not null,
	NgayDH smalldatetime,
	MaCC char(5),
	TongTriGia numeric,
	SoMH int
)
create table ChiTiet (
	MaDH char(5) not null,
	MaMH char(5) not null,
	SoLuong int,
	DonGia int,
	TriGia int
)

alter table MatHang add constraint PK_MatHang primary key (MaMH)
alter table NhaCC add constraint PK_NhaCC primary key (MaCC)
alter table CungCap add constraint PK_CungCap primary key (MaCC,MaMH)
alter table DonDH add constraint PK_DonDH primary key (MaDH)
alter table ChiTiet add constraint PK_ChiTiet primary key (MaDH,MaMH)

alter table CungCap add constraint FK_CungCap_NhaCC foreign key (MaCC) references NhaCC(MaCC)
alter table CungCap add constraint FK_CungCap_MatHang foreign key (MaMH) references MatHang(MaMH)
alter table DonDH add constraint FK_DonHang_NhaCC foreign key (MaCC) references NhaCC(MaCC)
alter table ChiTiet add constraint FK_ChiTiet_DonDH foreign key (MaDH) references DonDH(MaDH)
alter table ChiTiet add constraint FK_ChiTiet_MatHang foreign key (MaMH) references MatHang(MaMH)


--Phần 2:
--Câu a: Liệt kê danh sách các đơn hàng (MADH, NGAYDH, TONGTRIGIA) của tên nhà cung cấp ‘Vinamilk’ có tổng trị giá lớn hơn 1.000.000 đồng.
select MaDH, NgayDH, TongTriGia  
from DonDH
join NhaCC on NhaCC.MaCC=DonDH.MaCC
where TenCC='Vinamilk'
and TongTriGia>=1000000
--Câu b: Tính tổng số lượng sản phẩm có mã mặt hàng (MAMH) là ‘MH001’ đã đặt hàng trong năm 2018.
select DonDH.MaDH, sum(SoLuong) as TongSLSanPham
from DonDH
join ChiTiet on DonDH.MaDH=ChiTiet.MaDH
where DonDH.MaDH='MH001'
and year(NgayDH)=2018
group by DonDH.MaDH
--Câu c: Liệt kê những nhà cung cấp (MACC, TENCC) có thể cung cấp những mặt hàng do ‘Việt Nam’ sản xuất mà không cung cấp những mặt hàng do ‘Trung Quốc’ sản xuất.
select NhaCC.MaCC, TenCC
from NhaCC
join CungCap on CungCap.MaCC=NhaCC.MaCC
join MatHang on CungCap.MaMH=MatHang.MaMH
where NuocSX='Viet Nam'
except
select NhaCC.MaCC, TenCC
from NhaCC
join CungCap on CungCap.MaCC=NhaCC.MaCC
join MatHang on CungCap.MaMH=MatHang.MaMH
where NuocSX='Trung Quoc'
--Câu d: Tính tổng số mặt hàng (SOMH) của tất cả các đơn đặt hàng theo từng năm. Thông tin hiển thị: Năm đặt hàng, Tổng số mặt hàng.
select year(NgayDH) as NamDatHang, sum(SoMH) as TongSoMatHang
from DonDH
join ChiTiet on ChiTiet.MaDH=DonDH.MaDH
group by year(NgayDH)
--Câu e: Tìm những mã đơn đặt hàng (MADH) đã đặt tất cả các mặt hàng của nhà cung cấp có tên là ‘Vissan’ (TENCC).
select MaDH
from DonDH
where not exists (
	select * from MatHang
	where not exists (
		select * from NhaCC
		where TenCC='Vissan'
		and not exists (
			select * from CungCap
			where DonDH.MaCC=NhaCC.MaCC
			and NhaCC.MaCC=CungCap.MaCC
			and MatHang.MaMH=CungCap.MaMH
		)
	)
)
--Câu f: Tìm những mặt hàng (MAMH, TENMH) có số lượng đặt hàng nhiều nhất trong năm 2018.
select MatHang.MaMH, TenMH, sum(SoLuong) as SoLuongDatHang
from MatHang
join ChiTiet on ChiTiet.MaMH=MatHang.MaMH
join DonDH on ChiTiet.MaDH=DonDH.MaDH
where year(NgayDH)=2018
group by MatHang.MaMH, TenMH
having sum(SoLuong)>=all (
	select sum(SoLuong)
	from MatHang
	join ChiTiet on ChiTiet.MaMH=MatHang.MaMH
	join DonDH on ChiTiet.MaDH=DonDH.MaDH
	where year(NgayDH)=2018
	group by MatHang.MaMH
)



--Đề 2:
--Câu 1:
create database QLDH2
use QLDH2
create table MatHang (
	MaMH char(5) not null,
	TenMH varchar(50),
	DVT char(10),
	NuocSX varchar(20)
)
create table NhaCC (
	MaCC char(5) not null,
	TenCC varchar(50),
	DiaChiCC varchar(100)
)
create table CungCap (
	MaCC char(5) not null,
	MaMH char(5) not null,
	TuNgay smalldatetime
)
create table DonDH (
	MaDH char(5) not null,
	NgayDH smalldatetime,
	MaCC char(5),
	TriGia numeric,
	SoMH int
)
create table ChiTiet (
	MaDH char(5) not null,
	MaMH char(5) not null,
	SoLuong int,
	DonGia int,
	ThanhTien int
)

alter table MatHang add constraint PK_MatHang primary key (MaMH)
alter table NhaCC add constraint PK_NhaCC primary key (MaCC)
alter table CungCap add constraint PK_CungCap primary key (MaCC,MaMH)
alter table DonDH add constraint PK_DonDH primary key (MaDH)
alter table ChiTiet add constraint PK_ChiTiet primary key (MaDH,MaMH)

alter table CungCap add constraint FK_CungCap_NhaCC foreign key (MaCC) references NhaCC(MaCC)
alter table CungCap add constraint FK_CungCap_MatHang foreign key (MaMH) references MatHang(MaMH)
alter table DonDH add constraint FK_DonHang_NhaCC foreign key (MaCC) references NhaCC(MaCC)
alter table ChiTiet add constraint FK_ChiTiet_DonDH foreign key (MaDH) references DonDH(MaDH)
alter table ChiTiet add constraint FK_ChiTiet_MatHang foreign key (MaMH) references MatHang(MaMH)
--Phần 2:
--Câu a: Liệt kê danh sách các nhà cung cấp (MACC, TENCC, TUNGAY) có thể cung cấp mã mặt hàng ‘MH0001’ từ ngày ‘1/1/2018’ trở về sau.
select *
from CungCap
where MaMH='MH0001'
and TuNgay>='2018-01-01'
--Câu b: Tính tổng thành tiền của đơn đặt hàng có mã mặt hàng là ‘MH014’ từ nhà cung cấp có mã là ‘NCC007’.
select DonDH.MaDH, sum(ChiTiet.ThanhTien)
from DonDH
join ChiTiet on ChiTiet.MaDH=DonDH.MaDH
where MaMH='MH014'
and MaCC='NCC007'
--Câu c: Liệt kê những nhà cung cấp (MACC, TENCC) có thể cung cấp những mặt hàng do ‘Mỹ’ sản xuất mà không cung cấp những mặt hàng do ‘Hàn Quốc’ sản xuất.
select NhaCC.MaCC, TenCC
from NhaCC
join CungCap on CungCap.MaCC=NhaCC.MaCC
join MatHang on CungCap.MaMH=MatHang.MaMH
where NuocSX='My'
except
select NhaCC.MaCC, TenCC
from NhaCC
join CungCap on CungCap.MaCC=NhaCC.MaCC
join MatHang on CungCap.MaMH=MatHang.MaMH
where NuocSX='Han Quoc'
--Câu d: Tính tổng trị giá của tất cả các đơn đặt hàng theo từng năm. Thông tin hiển thị: Năm đặt hàng, Tổng trị giá.
select year(NgayDH) as NamDatHang, sum(TriGia) as TongTriGia
from DonDH
group by year(NgayDH)
--Câu e: Tìm những mã đơn đặt hàng (MADH) đã đặt tất cả các mặt hàng của nhà cung cấp có tên ‘Vinamilk’ (TENCC).
select MaDH
from DonDH
where not exists (
	select * from MatHang
	where not exists (
		select * from NhaCC
		where TenCC='Vinamilk'
		and not exists (
			select * from CungCap
			where DonDH.MaCC=NhaCC.MaCC
			and NhaCC.MaCC=CungCap.MaCC
			and MatHang.MaMH=CungCap.MaMH
		)
	)
)
--Câu f: Tìm những mặt hàng (MAMH, TENMH) có số lượng đặt hàng ít nhất trong năm 2018.
select MatHang.MaMH, TenMH, sum(SoLuong) as SoLuongDatHang
from MatHang
join ChiTiet on ChiTiet.MaMH=MatHang.MaMH
join DonDH on ChiTiet.MaDH=DonDH.MaDH
where year(NgayDH)=2018
group by MatHang.MaMH, TenMH
having sum(SoLuong)<=all (
	select sum(SoLuong)
	from MatHang
	join ChiTiet on ChiTiet.MaMH=MatHang.MaMH
	join DonDH on ChiTiet.MaDH=DonDH.MaDH
	where year(NgayDH)=2018
	group by MatHang.MaMH, TenMH
)
