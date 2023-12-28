-- QUAN LY BAN HANG --
--- Cau 1
create database QLBH
use QLBH
--- Create table ---
create table NHANVIEN (
	MANV char(4) not null,
	HOTEN varchar(40),
	SODT varchar(20),
	NGVL smalldatetime
)
create table SANPHAM (
	MASP char(4) not null,
	TENSP varchar(40),
	DVT varchar(20),
	NUOCSX varchar(40),
	GIA money
)
create table HOADON (
	SOHD int not null,
	NGHD smalldatetime,
	MAKH char(4),
	MANV char(4),
	TRIGIA money,
)
create table CTHD (
	SOHD int not null,
	MASP char(4),
	SL int
)
create table KHACHHANG(
	MAKH char(4) not null,
	HOTEN varchar(40),
	SODT varchar(20),
	NGSINH smalldatetime,
	DOANHSO money,
	NGDK smalldatetime
)
--- Create primary key ---
alter table NHANVIEN add constraint KEY_MANV primary key (MANV)
alter table SANPHAM add constraint KEY_MASP primary key (MASP)
alter table HOADON add constraint KEY_SOHD primary key (SOHD)
alter table CTHD alter column MASP char(4) not null
alter table CTHD add constraint KEY_SOHD_MASP primary key (SOHD,MASP)
---Create foreign key---
alter table CTHD add constraint FKEY_CTHD_HOADON_SOHD foreign key (SOHD) references HOADON(SOHD)
alter table CTHD add constraint FKEY_CTHD_SANPHAM_MASP foreign key (MASP) references SANPHAM(MASP)
alter table HOADON add constraint FKEY_HOADON_KHACHHANG_MAKH foreign key (MAKH) references KHACHHANG(MAKH)
alter table HOADON add constraint FKEY_HOADON_NHANVIEN_MANV foreign key (MANV) references NHANVIEN(MANV)
--Cau 2:
alter table SANPHAM add GHICHU varchar(20)
---Cau 3:
alter table KHACHHANG add LOAIKH tinyint
--Cau 4:
alter table SANPHAM alter column GHICHU varchar(100)
--Cau 5:
alter table SANPHAM drop column GHICHU
--Cau 6:
alter table KHACHHANG alter column LOAIKH varchar(100)
alter table KHACHHANG add constraint DONVI check (LOAIKH='Vang lai' OR LOAIKH='Thuong xuyen' OR LOAIKH='VIP')
--Cau 7:
alter table SANPHAM add constraint KTDONVI check (DVT='cay' or DVT='hop' or DVT='cai' or DVT='quyen' or DVT='chuc')
--Cau 8:
alter table SANPHAM add constraint MUCGIA check (GIA>=500)
--Cau 9:
alter table HOADON add constraint DIEUKIENMUAHANG check (TRIGIA>=0)
--Cau 10:
alter table KHACHHANG add constraint DIEUKIENNGAYDANGKY check (NGDK > NGSINH)
------------------------------------------------------------------------LAB02--------------------------------------------------------------------------------
--II. Ngon ngu thao tac du lieu
--Cau 1:
--Nhap du lieu bang KHACHHANG
INSERT INTO KHACHHANG VALUES('KH01','Nguyen Van A','731 Tran Hung Dao, Q5, TpHCM','08823451','10/22/1960','7/22/2006',13060000)
INSERT INTO KHACHHANG VALUES('KH02','Tran Ngoc Han','23/5 Nguyen Trai, Q5, TpHCM','0908256478','4/3/1974','7/30/2006',280000)
INSERT INTO KHACHHANG VALUES('KH03','Tran Ngoc Linh','45 Nguyen Canh Chan, Q1, TpHCM','0938776266','6/12/1980','8/5/2006',3860000)
INSERT INTO KHACHHANG VALUES('KH04','Tran Minh Long','50/34 Le Dai Hanh, Q10, TpHCM','0917325476','3/9/1965','2/10/2006',250000)
INSERT INTO KHACHHANG VALUES('KH05','Le Nhat Minh','34 Truong Dinh, Q3, TpHCM','08246108','3/10/1950','10/28/2006',21000)
INSERT INTO KHACHHANG VALUES('KH06','Le Hoai Thuong','227 Nguyen Van Cu, Q5, TpHCM','08631738','12/31/1981','11/24/2006',915000)
INSERT INTO KHACHHANG VALUES('KH07','Nguyen Van Tam','32/3 Tran Binh Trong, Q5, TpHCM','0916783565','4/6/1971','12/01/2006',12500)
INSERT INTO KHACHHANG VALUES('KH08','Phan Thi Thanh','45/2 An Duong Vuong, Q5, TpHCM','0938435756','1/10/1971','12/13/2006',365000)
INSERT INTO KHACHHANG VALUES('KH09','Le Ha Vinh','873 Le Hong Phong, Q5, TpHCM','08654763','3/9/1979','01/14/2007',70000)
INSERT INTO KHACHHANG VALUES('KH10','Ha Duy Lap','34/34B Nguyen Trai, Q1, TpHCM','08768904','5/2/1983','1/16/2007',67500)
-- Nhap du lieu bang NHANVIEN
INSERT INTO NHANVIEN VALUES('NV01','Nguyen Nhu Nhut','0927345678','4/13/2006')
INSERT INTO NHANVIEN VALUES('NV02','Le Thi Phi Yen','0987567390','4/21/2006')
INSERT INTO NHANVIEN VALUES('NV03','Nguyen Van B','0997047382','4/27/2006')
INSERT INTO NHANVIEN VALUES('NV04','Ngo Thanh Tuan','0913758498','6/24/2006')
INSERT INTO NHANVIEN VALUES('NV05','Nguyen Thi Truc Thanh','0918590387','7/20/2006')
---Nhap du lieu bang SANPHAM
INSERT INTO SANPHAM VALUES('BC01','But chi','cay','Singapore',3000)
INSERT INTO SANPHAM VALUES('BC02','But chi','cay','Singapore',5000)
INSERT INTO SANPHAM VALUES('BC03','But chi','cay','Viet Nam',3500)
INSERT INTO SANPHAM VALUES('BC04','But chi','hop','Viet Nam',30000)
INSERT INTO SANPHAM VALUES('BB01','But bi','cay','Viet Nam',5000)
INSERT INTO SANPHAM VALUES('BB02','But bi','cay','Trung Quoc',7000)
INSERT INTO SANPHAM VALUES('BB03','But bi','hop','Thai Lan',100000)
INSERT INTO SANPHAM VALUES('TV01','Tap 100 giay mong','quyen','Trung Quoc',2500)
INSERT INTO SANPHAM VALUES('TV02','Tap 200 giay mong','quyen','Trung Quoc',4500)
INSERT INTO SANPHAM VALUES('TV03','Tap 100 giay tot','quyen','Viet Nam',3000)
INSERT INTO SANPHAM VALUES('TV04','Tap 200 giay tot','quyen','Viet Nam',5500)
INSERT INTO SANPHAM VALUES('TV05','Tap 100 trang','chuc','Viet Nam',23000)
INSERT INTO SANPHAM VALUES('TV06','Tap 200 trang','chuc','Viet Nam',53000)
INSERT INTO SANPHAM VALUES('TV07','Tap 100 trang','chuc','Trung Quoc',34000)
INSERT INTO SANPHAM VALUES('ST01','So tay 500 trang','quyen','Trung Quoc',40000)
INSERT INTO SANPHAM VALUES('ST02','So tay loai 1','quyen','Viet Nam',55000)
INSERT INTO SANPHAM VALUES('ST03','So tay loai 2','quyen','Viet Nam',51000)
INSERT INTO SANPHAM VALUES('ST04','So tay','quyen','Thai Lan',55000)
INSERT INTO SANPHAM VALUES('ST05','So tay mong','quyen','Thai Lan',20000)
INSERT INTO SANPHAM VALUES('ST06','Phan viet bang','hop','Viet Nam',5000)
INSERT INTO SANPHAM VALUES('ST07','Phan khong bui','hop','Viet Nam',7000)
INSERT INTO SANPHAM VALUES('ST08','Bong bang','cai','Viet Nam',1000)
INSERT INTO SANPHAM VALUES('ST09','But long','cay','Viet Nam',5000)
INSERT INTO SANPHAM VALUES('ST10','But long','cay','Trung Quoc',7000)
--Nhap du lieu bang HOADON
INSERT INTO HOADON VALUES(1001,'7/23/2006','KH01','NV01',320000)
INSERT INTO HOADON VALUES(1002,'8/12/2006','KH01','NV02',840000)
INSERT INTO HOADON VALUES(1003,'8/23/2006','KH02','NV01',100000)
INSERT INTO HOADON VALUES(1004,'9/1/2006','KH02','NV01',180000)
INSERT INTO HOADON VALUES(1005,'10/20/2006','KH01','NV02',3800000)
INSERT INTO HOADON VALUES(1006,'10/16/2006','KH01','NV03',2430000)
INSERT INTO HOADON VALUES(1007,'10/28/2006','KH03','NV03',510000)
INSERT INTO HOADON VALUES(1008,'10/28/2006','KH01','NV03',440000)
INSERT INTO HOADON VALUES(1009,'10/28/2006','KH03','NV04',200000)
INSERT INTO HOADON VALUES(1010,'11/01/2006','KH01','NV01',5200000)
INSERT INTO HOADON VALUES(1011,'11/4/2006','KH04','NV03',250000)
INSERT INTO HOADON VALUES(1012,'11/30/2006','KH05','NV03',21000)
INSERT INTO HOADON VALUES(1013,'12/12/2006','KH06','NV01',5000)
INSERT INTO HOADON VALUES(1014,'12/31/2006','KH03','NV02',3150000)
INSERT INTO HOADON VALUES(1015,'01/01/2007','KH06','NV01',910000)
INSERT INTO HOADON VALUES(1016,'01/01/2007','KH07','NV02',12500)
INSERT INTO HOADON VALUES(1017,'01/02/2007','KH08','NV03',35000)
INSERT INTO HOADON VALUES(1018,'1/13/2007','KH08','NV03',330000)
INSERT INTO HOADON VALUES(1019,'1/13/2007','KH01','NV03',30000)
INSERT INTO HOADON VALUES(1020,'1/14/2007','KH09','NV04',70000)
INSERT INTO HOADON VALUES(1021,'1/16/2007','KH10','NV03',67500)
INSERT INTO HOADON VALUES(1022,'1/16/2007',Null,'NV03',7000)
INSERT INTO HOADON VALUES(1023,'1/17/2007',Null,'NV01',330000)
--Nhap du lieu bang CTHD
INSERT INTO CTHD VALUES(1001,'TV02',10)
INSERT INTO CTHD VALUES(1001,'ST01',5)
INSERT INTO CTHD VALUES(1001,'BC01',5)
INSERT INTO CTHD VALUES(1001,'BC02',10)
INSERT INTO CTHD VALUES(1001,'ST08',10)
INSERT INTO CTHD VALUES(1002,'BC04',20)
INSERT INTO CTHD VALUES(1002,'BB01',20)
INSERT INTO CTHD VALUES(1002,'BB02',20)
INSERT INTO CTHD VALUES(1003,'BB03',10)
INSERT INTO CTHD VALUES(1004,'TV01',20)
INSERT INTO CTHD VALUES(1004,'TV02',10)
INSERT INTO CTHD VALUES(1004,'TV03',10)
INSERT INTO CTHD VALUES(1004,'TV04',10)
INSERT INTO CTHD VALUES(1005,'TV05',50)
INSERT INTO CTHD VALUES(1005,'TV06',50)
INSERT INTO CTHD VALUES(1006,'TV07',20)
INSERT INTO CTHD VALUES(1006,'ST01',30)
INSERT INTO CTHD VALUES(1006,'ST02',10)
INSERT INTO CTHD VALUES(1007,'ST03',10)
INSERT INTO CTHD VALUES(1008,'ST04',8)
INSERT INTO CTHD VALUES(1009,'ST05',10)
INSERT INTO CTHD VALUES(1010,'TV07',50)
INSERT INTO CTHD VALUES(1010,'ST07',50)
INSERT INTO CTHD VALUES(1010,'ST08',100)
INSERT INTO CTHD VALUES(1010,'ST04',50)
INSERT INTO CTHD VALUES(1010,'TV03',100)
INSERT INTO CTHD VALUES(1011,'ST06',50)
INSERT INTO CTHD VALUES(1012,'ST07',3)
INSERT INTO CTHD VALUES(1013,'ST08',5)
INSERT INTO CTHD VALUES(1014,'BC02',80)
INSERT INTO CTHD VALUES(1014,'BB02',100)
INSERT INTO CTHD VALUES(1014,'BC04',60)
INSERT INTO CTHD VALUES(1014,'BB01',50)
INSERT INTO CTHD VALUES(1015,'BB02',30)
INSERT INTO CTHD VALUES(1015,'BB03',7)
INSERT INTO CTHD VALUES(1016,'TV01',5)
INSERT INTO CTHD VALUES(1017,'TV02',1)
INSERT INTO CTHD VALUES(1017,'TV03',1)
INSERT INTO CTHD VALUES(1017,'TV04',5)
INSERT INTO CTHD VALUES(1018,'ST04',6)
INSERT INTO CTHD VALUES(1019,'ST05',1)
INSERT INTO CTHD VALUES(1019,'ST06',2)
INSERT INTO CTHD VALUES(1020,'ST07',10)
INSERT INTO CTHD VALUES(1021,'ST08',5)
INSERT INTO CTHD VALUES(1021,'TV01',7)
INSERT INTO CTHD VALUES(1021,'TV02',10)
INSERT INTO CTHD VALUES(1022,'ST07',1)
INSERT INTO CTHD VALUES(1023,'ST04',6)
--Cau 2:
select * into SANPHAM1 from SANPHAM
select * into KHACHHANG1 from KHACHHANG
--Cau 3:
update SANPHAM1 set GIA = 105*GIA/100 where (NUOCSX='Thai Lan')
--Cau 4:
update SANPHAM1 set GIA = 95*GIA/100 where (NUOCSX='Trung Quoc' and GIA <=10000)
--Cau 5:
update KHACHHANG1 set LOAIKH='Vip' where (
(DOANHSO >= 10000000 and NGDK < '1/1/2007')
)
or (DOANHSO >= 2000000 and NGDK >= '1/1/2007')
--III. Ngon ngu truy van du lieu co cau truc:
--Cau 1:
select MASP, TENSP from SANPHAM where NUOCSX='Trung Quoc'
--Cau 2:
select MASP, TENSP from SANPHAM where DVT='cay' or DVT='quyen'
--Cau 3:
select MASP, TENSP from SANPHAM where LEFT(MASP,1)='B' and RIGHT(MASP,2)='01'
--Cau 4:
select MASP, TENSP from SANPHAM where (
NUOCSX='Trung Quoc'
and GIA >=30000 and GIA <=40000
)
--Cau 5:
select MASP, TENSP from SANPHAM where (
NUOCSX='Trung Quoc' or NUOCSX='Thai Lan'
and GIA >=30000 and GIA <=40000
)
--Cau 6:
select SOHD, TRIGIA from HOADON where NGHD >= '1/1/2007' and NGHD <= '1/2/2007'
--Cau 7:
select SOHD, TRIGIA from HOADON where (
NGHD >= '1/1/2007' and NGHD < '1/2/2007'
)
order by NGHD ASC, TRIGIA DESC
--Cau 8:
select MAKH, HOTEN from KHACHHANG where MAKH in (
select MAKH from HOADON where NGHD='1/1/2007'
)
--Cau 9:
select SOHD, TRIGIA from HOADON where NGHD='10/28/2006' and MANV in (
select MANV from NHANVIEN where HOTEN='Nguyen Van B'
)


--Cau 10:
select MASP, TENSP from  SANPHAM where MASP in (
select MASP from CTHD where SOHD in (
	select SOHD from HOADON where NGHD >= '10/1/2006' and NGHD < '11/1/2006' and MAKH in (
		select MAKH from KHACHHANG where HOTEN='Nguyen Van A'
		)
	)
)
--Cau 11:
select SOHD from CTHD where MASP ='BB01' or MASP='BB02'  
--------------------------------------------------------------------LAB03----------------------------------------------------------------------------------
--III. Ngon ngu truy van du lieu co cau truc:
--Cau 12:
select SOHD from CTHD where MASP = 'BB01' and SL between 10 and 20
union all
select SOHD from CTHD where MASP = 'BB02' and SL between 10 and 20
--Cau 13:
select SOHD from CTHD where MASP = 'BB01' and SL between 10 and 20
INTERSECT select SOHD from CTHD where MASP = 'BB02' and SL between 10 and 20
--Cau 14:
select MASP, TENSP from SANPHAM where NUOCSX = 'Trung Quoc'
union
select MASP, TENSP from SANPHAM where MASP in (
	select MASP from CTHD where SOHD in (
		select SOHD from HOADON where NGHD = '1/1/2007'
		)
	)
--Cau 15: Can phai xem lai?

select MASP, TENSP from SANPHAM where MASP in (
	select MASP from SANPHAM except select distinct MASP from CTHD where exists (select MASP from SANPHAM)
)

--select MASP from CTHD order by MASP asc
--Cau 16: Can phai xem lai?

select MASP, TENSP from SANPHAM where MASP in (
select MASP from SANPHAM except select distinct MASP from CTHD where SOHD in (
	select SOHD from HOADON where YEAR(NGHD)=2006
	)
)



--Cau 17:
select MASP, TENSP from SANPHAM where NUOCSX='Trung Quoc' and MASP in (
select MASP from SANPHAM except select distinct MASP from CTHD where SOHD in (
	select SOHD from HOADON where YEAR(NGHD)=2006
	)
)



--Cau 18:
select distinct SOHD from CTHD where MASP in (
	select MASP from SANPHAM where NUOCSX='Singapore'
) 
except 
select SOHD from (
select SOHD, MASP from SANPHAM  cross join (
	select distinct SOHD from CTHD where MASP in (
		select MASP from SANPHAM where NUOCSX='Singapore'
		)
	) as Combine where NUOCSX='Singapore' except 
select distinct SOHD, MASP from CTHD where MASP in (
	select MASP from SANPHAM where NUOCSX='Singapore'
)
) as EXTRACTED
select SOHD from HOADON where not exists(
select * from SANPHAM where NUOCSX='Singapore' and not exists (select * from CTHD where CTHD.MASP = SANPHAM.MASP and CTHD.SOHD=HOADON.SOHD)
)
--Cau 19:
select SOHD from HOADON where YEAR(NGHD) =2006 and not exists (
	select * from SANPHAM where NUOCSX='Singapore' and not exists (
		select * from CTHD where CTHD.MASP = SANPHAM.MASP and CTHD.SOHD=HOADON.SOHD
		)
	)
-----------------------------------------------------------------------LAB04---------------------------------------------------------------------------------------
--III. Ngon ngu truy van du lieu co cau truc:
--Cau 20:
select count(*) as 'Số hóa đơn không phải khách hàng thành viên mua' from HOADON where MAKH is null group by MAKH
--Cau 21:
select count(Results.Soluongban2006) as 'Số lượng sản phẩm khác nhau bán trong 2006' from (
select distinct MASP as Soluongban2006 from CTHD where exists (
	select * from HOADON where CTHD.SOHD=HOADON.SOHD and YEAR(NGHD)=2006
)
group by MASP
) as Results
--Cau 22:
select max(TRIGIA) as 'Trị giá hóa đơn cao nhất', min(TRIGIA) as 'Trị giá hóa đơn thấp nhất' from HOADON
--Cau 23:
select avg(TRIGIA) as 'Trị giá trung bình' from HOADON where YEAR(NGHD)=2006
--Cau 24:
select sum(TRIGIA) as 'Doanh thu bán hàng' from HOADON where YEAR(NGHD)=2006
--Cau 25:
select SOHD from HOADON where TRIGIA>=all(select TRIGIA from HOADON)
--Cau 26:
select distinct HOTEN from KHACHHANG where exists (
	select * from HOADON where TRIGIA>=all(select TRIGIA from HOADON) 
	and HOADON.MAKH=KHACHHANG.MAKH
)
--Cau 27:
select top 3 MAKH ,HOTEN from KHACHHANG order by DOANHSO desc
--Cau 28:
select MASP, TENSP from SANPHAM  where GIA in (select distinct top 3 GIA from SANPHAM order by GIA desc)
--Cau 29:
select MASP, TENSP from SANPHAM  where GIA in (select distinct top 3 GIA from SANPHAM order by GIA desc) and NUOCSX='Thai Lan'
--Cau 30:
select MASP, TENSP from SANPHAM  where GIA in (select distinct top 3 GIA from SANPHAM where NUOCSX='Trung Quoc' order by GIA desc) and NUOCSX='Trung Quoc'
--Cau 31: 
select top 3 * from KHACHHANG order by DOANHSO desc
--Cau 32: 
select distinct count(NUOCSX) as 'Tổng số sản phẩm Trung Quốc sản xuất' from SANPHAM where NUOCSX='Trung Quoc' group by NUOCSX
--Cau 33:
select NUOCSX, count(*) as 'Số sản phẩm' from SANPHAM group by NUOCSX
--Cau 34:
select NUOCSX, max(GIA) as MaxGia, min(GIA) as MinGia, avg(GIA) as GiaTrungBinh from SANPHAM group by NUOCSX
--Cau 35:
select NGHD, sum(TRIGIA) as DoanhThu from HOADON group by NGHD
--Cau 36:
select SOHD, sum(SL) as TongSoLuong from CTHD where exists (
	select * from HOADON where CTHD.SOHD=HOADON.SOHD and month(NGHD)=10 and year(NGHD)=2006
) group by SOHD
--Cau 37:
select month(NGHD) as Thang, sum(TRIGIA) as DoanhThuThang from HOADON where year(NGHD)=2006 group by month(NGHD)
--Cau 38:
select * from HOADON where exists(
	select * from(
		select SOHD, count(MASP) as SoLuongSanPhamDaMua from CTHD group by SOHD
		) as Result where Result.SOHD=HOADON.SOHD and SoLuongSanPhamDaMua >=4
)
--Cau 39:
select * from HOADON where exists (
select * from (
	select SOHD, count(MASP) as SLSanPhamVietNam from CTHD where MASP in (
		select MASP from SANPHAM where NUOCSX='Viet Nam'
	) group by SOHD
) as Results where Results.SLSanPhamVietNam>=3 and HOADON.SOHD=Results.SOHD
)
--Cau 40:
select MAKH, HOTEN from KHACHHANG where MAKH in (
	select MAKH from (
		select MAKH, count(MAKH) as SoLanKhachMuaHang from HOADON group by MAKH 
	) KetQua where KetQua.SoLanKhachMuaHang>=all(select count(MAKH) as SoLanKhachMuaHang from HOADON group by MAKH)
)
--Cau 41:
select KetQua.Thang, KetQua.DoanhThuThang from (
	select month(NGHD) as Thang, sum(TRIGIA) as DoanhThuThang from HOADON where year(NGHD)=2006 group by month(NGHD)
) as KetQua where KetQua.DoanhThuThang>=all(select sum(TRIGIA) as DoanhThuThang from HOADON where year(NGHD)=2006 group by month(NGHD))
--Cau 42:
select MASP, TENSP from SANPHAM where exists (
	select * from (
		select MASP, sum(SL) as SLBanRa from CTHD where MASP in
		(
			select MASP from HOADON where year(NGHD)=2006
		)
		group by MASP
	) as KetQua
	where KetQua.MASP=SANPHAM.MASP and KetQua.SLBanRa<=all(select sum(SL) from CTHD where MASP in (select MASP from HOADON where year(NGHD)=2006) group by MASP)
)

--Cau 43:
select NUOCSX,MASP, TENSP from SANPHAM where exists (
	select * from (
	select NUOCSX, max(GIA) as GiaCaoNhat from SANPHAM group by NUOCSX
	) as DieuKien
	where DieuKien.NUOCSX=SANPHAM.NUOCSX and DieuKien.GiaCaoNhat=SANPHAM.GIA
)

--Cau 44:
select KetQua.NUOCSX from (
	select DieuKien.NUOCSX, count(DieuKien.NUOCSX) as SanPhamGiaBanKhacNhau from (
		select NUOCSX, GIA from SANPHAM group by NUOCSX, GIA
		) as DieuKien group by DieuKien.NUOCSX
) as KetQua where KetQua.SanPhamGiaBanKhacNhau>=3
--Cau 45:
select top 10 * from KHACHHANG where MAKH in
(
	select MAKH from (
		select MAKH, count(MAKH) as SoLanKhachMuaHang from HOADON group by MAKH 
	) KetQua where KetQua.SoLanKhachMuaHang>=all(select count(MAKH) as SoLanKhachMuaHang from HOADON group by MAKH)

)
order by DOANHSO desc

--------------------------------------------------------------------LAB05-------------------------------------------------------------------------------------
--I.Ngôn ngữ định nghĩa dữ liệu
--Câu 11:
go
create trigger check_HOADON_insert
on HOADON
after insert
as 
	if (update(NGHD) or update(MAKH))
	begin
		declare @ngaymuahang smalldatetime
		declare @ngaydangky smalldatetime
		select @ngaymuahang=NGHD, @ngaydangky=NGDK
		from inserted, KHACHHANG
		where inserted.MAKH=KHACHHANG.MAKH
		if @ngaymuahang<@ngaydangky
		begin
			rollback transaction
			print 'Loi. Ngay mua hang khong duoc nho hon ngay dang ky'
		end
	end
go

create trigger nghd_makh_HOADON_update
on HOADON
after update
as 
	if(update(NGHD) or update(MAKH))
	begin
		declare @ngaymuahang smalldatetime
		declare @ngaydangky smalldatetime
		select @ngaymuahang=NGHD, @ngaydangky=NGDK
		from inserted, KHACHHANG
		where KHACHHANG.MAKH=inserted.MAKH
		if @ngaymuahang<@ngaydangky
		begin
			rollback transaction
			print 'Loi. Ngay mua hang phai lon hon ngay dang ky'
		end
	end
go

create trigger nghd_ngdk_khachhang_update
on KHACHHANG
after update
as 
	declare @ngaydangky smalldatetime, @makhachhang char(4)
	select @ngaydangky=NGDK, @makhachhang=MAKH
	from inserted
	if (update(NGDK))
	begin
		if (exists (select * from HOADON where MAKH=@makhachhang and @ngaydangky>NGHD))
		begin
			rollback transaction
			print'Loi. Phai cap nhat ngay dang ky khach hang nho hon ngay mua hang'
		end
	end
go
--Câu 12:
go
create trigger nghd_HOADON_insert
on HOADON
after insert 
as 
	declare @ngaybanhang smalldatetime
	declare @ngayvaolam smalldatetime
	select @ngaybanhang=NGHD, @ngayvaolam=NGVL
	from inserted, NHANVIEN
	where inserted.MANV=NHANVIEN.MANV
	if @ngaybanhang < @ngayvaolam
	begin
		rollback transaction
		print 'Loi. Ngay ban hang cua nhan vien do phai lon hon hoac bang ngay nhan vien do vao lam'
	end
go

create trigger nghd_manv_HOADON_update
on HOADON
after update 
as 
	if(update(NGHD) or update(MANV))
	begin
		declare @ngaybanhang smalldatetime
		declare @ngayvaolam smalldatetime
		select @ngaybanhang=NGHD, @ngayvaolam=NGVL
		from inserted, NHANVIEN
		where NHANVIEN.MANV=inserted.MANV
		if @ngaybanhang < @ngayvaolam
		begin
			rollback transaction
			print 'Loi. Phai cap nhat ngay vao lam nho hon hoac bang ngay ban hang cua nhan vien'
		end
	end
go

create trigger ngvl_NHANVIEN_update
on NHANVIEN
after update
as
	declare @ngayvaolam smalldatetime
	declare @manhanvien char(4)
	select @ngayvaolam=NGVL, @manhanvien=MANV
	from inserted
	if (update(NGVL))
		begin
			if (exists (select * from HOADON where MAKH=@manhanvien and @ngayvaolam>NGHD))
			begin
				rollback transaction
				print'Loi. Phai cap nhat ngay vao lam nhan vien nho hon ngay ban hang cua nhan vien do'
			end
		end
go
--Câu 13:
go
create trigger CTHD_delete
on CTHD
after delete
as 
	declare @mahoadon char(4)
	declare @soluongconlai int
	select @mahoadon=deleted.SOHD, @soluongconlai=count(CTHD.SOHD)
	from deleted, CTHD
	where deleted.SOHD=CTHD.SOHD
	group by deleted.SOHD
		if @soluongconlai< 1
		begin
			rollback transaction
			print'Loi. Moi hoa don phai co it nhat 1 chi tiet hoa don'
		end
go
--Câu 14:
--Bảng tầm ảnh hưởng:
-- Hóa đơn: Sửa
-- CTHD: insert, delete, update(SL)
go
create trigger CTHD_HOADON_insert_14
on CTHD
after insert
as 
	declare @TongGiaTri money, @SoLuong int
	declare @SoHD int
	declare @MaSP char(4)
	
	select @SOHD=inserted.SOHD, @SoLuong=inserted.SL, @MaSP=inserted.MASP
	from inserted
	set @TongGiaTri=0
	declare TongGiaTri_Cursor 
	cursor for (select MASP, SL from CTHD where SOHD=@SoHD)
	Open TongGiaTri_Cursor
	Fetch next from TongGiaTri_Cursor
	into @MaSP, @SoLuong
	while (@@FETCH_STATUS=0)
	begin
		set @TongGiaTri=@TongGiaTri+@SoLuong*(select GIA from SANPHAM where MASP=@MaSP)
		Fetch next from TongGiaTri_Cursor
		into @MaSP, @SoLuong
	end
	Close TongGiaTri_Cursor
	Deallocate TongGiaTri_Cursor
	update HOADON
	set TRIGIA = @TongGiaTri
	where SOHD=@SoHD
go


go 
create trigger CTHD_HOADON_delete_14
on CTHD
after delete
as 
	declare @TongGiaTri money, @SoLuong int
	declare @SoHD int
	declare @MaSP char(4)
	select @SOHD=deleted.SOHD, @SoLuong=deleted.SL, @MaSP=deleted.MASP
	from deleted
	set @TongGiaTri=0
	declare TongGiaTri_Cursor 
	cursor for (select MASP, SL from CTHD where SOHD=@SoHD)
	Open TongGiaTri_Cursor
	Fetch next from TongGiaTri_Cursor
	into @MaSP, @SoLuong
	while (@@FETCH_STATUS=0)
	begin
		set @TongGiaTri=@TongGiaTri+@SoLuong*(select GIA from SANPHAM where MASP=@MaSP)
		Fetch next from TongGiaTri_Cursor
		into @MaSP, @SoLuong
	end
	Close TongGiaTri_Cursor
	Deallocate TongGiaTri_Cursor
	update HOADON
	set TRIGIA = @TongGiaTri
	where SOHD=@SoHD
go

go
create trigger CTHD_HOADON_update_14
on CTHD
after update
as 
	declare @TongGiaTri money, @SoLuong int
	declare @SoHD int
	declare @MaSP char(4)
	if (update(SL))
	begin
		select @SOHD=inserted.SOHD
		from inserted
		set @TongGiaTri=0
		declare TongGiaTri_Cursor 
		cursor for (select MASP, SL from CTHD where SOHD=@SoHD)
		Open TongGiaTri_Cursor
		Fetch next from TongGiaTri_Cursor
		into @MaSP, @SoLuong
		while (@@FETCH_STATUS=0)
		begin
			set @TongGiaTri=@TongGiaTri+@SoLuong*(select GIA from SANPHAM where MASP=@MaSP)
			Fetch next from TongGiaTri_Cursor
			into @MaSP, @SoLuong
		end
		Close TongGiaTri_Cursor
		Deallocate TongGiaTri_Cursor
		update HOADON
		set TRIGIA = @TongGiaTri
		where HOADON.SOHD=@SoHD
	end
go

go
create trigger HOADON_insert_C14
on HOADON
after insert
as
	declare @SoHD int
	select @SoHD=inserted.SOHD
	from inserted
	update HOADON
	set TRIGIA=0
	where SOHD=@SoHD
go

go
create trigger HOADON_update_C14
on HOADON
after update
as 
	declare @TriGiaMoi money, @TriGiaCu money
	declare @MaSPMoi char(4), @SoLuong int
	declare @SoHD int
	select @TriGiaMoi=inserted.TRIGIA, @SoHD=inserted.SOHD
	from inserted
	if (update(TRIGIA) and exists (select SOHD from HOADON where SOHD=@SoHD))
	begin
		set @TriGiaCu=0
		declare Custom_Cursor2
		cursor for (select MASP, SL from CTHD where SOHD=@SoHD)
		Open Custom_Cursor2
		Fetch next from Custom_Cursor2
		into @MaSPMoi, @SoLuong
		while (@@FETCH_STATUS=0)
		begin
			set @TriGiaCu=@TriGiaCu+(@SoLuong*(select GIA from SANPHAM where MASP=@MaSPMoi))
			print'Calculating...' + @MASPMoi
			fetch next from Custom_Cursor2
			into @MaSPMoi, @SoLuong
		end
		if @TriGiaCu!=@TriGiaMoi
			begin
				rollback transaction
				print'Loi. Tri gia cua hoa don la tong thanh tien cua chi tiet thuoc hoa don do.'
			end
		close Custom_Cursor2
		Deallocate Custom_Cursor2
	end
go

--go
--create trigger SANPHAM_update_C14
--on SANPHAM
--after update
--as 
--	declare @GiaMoi money
--	declare @GiaCu money, @SoHD int, @MaSP char(4), @SoLuong int
	
--	select @GiaMoi=inserted.GIA, @MaSP=inserted.MASP
--	from inserted
--	select @GiaCu=deleted.GIA
--	from deleted
--	if (update(GIA) and exists (select MASP from CTHD where MASP=@MaSP))
--	begin
--		declare Custom_Cursor 
--		cursor for select SOHD, SL from CTHD 
--		where exists (
--			select * from (
--				select distinct SOHD,CTHD.MASP
--				from SANPHAM, CTHD
--				where SANPHAM.MASP=CTHD.MASP
--				and CTHD.MASP=@MaSP
--				group by CTHD.MASP, SOHD
--			) 
--			as A 
--			where A.MASP=CTHD.MASP and A.SOHD=CTHD.SOHD
--		)
--		Open Custom_Cursor
--		Fetch next from Custom_Cursor 
--		into @SoHD, @SoLuong
--		while (@@FETCH_STATUS=0)
--			begin
--				update HOADON
--				set TRIGIA= TRIGIA+((@GiaMoi-@GiaCu)*@SoLuong)
--				where SOHD=@SOHD
--				Fetch next from Custom_Cursor 
--				into @SoHD, @SoLuong
--		end
--		Close Custom_Cursor
--		Deallocate Custom_Cursor
--	end
--go
--drop trigger SANPHAM_update_C14

--Câu 15:
go
create trigger HOADON_insert_C15
on HOADON
after insert
as
	declare @DoanhThuMoi money, @MaKH char(4), @TriGiaMoi money
	declare @DoanhSoMoi money
	select @DoanhThuMoi=inserted.TRIGIA, @MaKH=inserted.MAKH
	from inserted
	set @DoanhSoMoi=0
	declare DoanhThuMoi_Cursor 
	cursor for (select TRIGIA from HOADON where MAKH=@MaKH)
	Open DoanhThuMoi_Cursor
	Fetch next from DoanhThuMoi_Cursor
	into @TriGiaMoi

	while(@@FETCH_STATUS=0)
	begin
		set @DoanhSoMoi=@DoanhSoMoi+@TriGiaMoi
		Fetch next from DoanhThuMoi_Cursor
		into @TriGiaMoi
	end
	Close DoanhThuMoi_Cursor
	Deallocate DoanhThuMoi_Cursor
	update KHACHHANG
	set DOANHSO=@DoanhSoMoi
	where MAKH=@MaKH
go

create trigger HOADON_delete_C15
on HOADON
after delete 
as 
	declare @DoanhThuMoi money, @MaKH char(4), @TriGiaMoi money
	declare @DoanhSoMoi money
	select @DoanhThuMoi=deleted.TRIGIA, @MaKH=deleted.MAKH
	from deleted
	set @DoanhSoMoi=0
	declare DoanhThuMoi_Cursor 
	cursor for (select TRIGIA from HOADON where MAKH=@MaKH)
	Open DoanhThuMoi_Cursor
	Fetch next from DoanhThuMoi_Cursor
	into @TriGiaMoi

	while(@@FETCH_STATUS=0)
	begin
		set @DoanhSoMoi=@DoanhSoMoi+@TriGiaMoi
		Fetch next from DoanhThuMoi_Cursor
		into @TriGiaMoi
	end
	Close DoanhThuMoi_Cursor
	Deallocate DoanhThuMoi_Cursor
	update KHACHHANG
	set DOANHSO=@DoanhSoMoi
	where MAKH=@MaKH
go

create trigger HOADON_update_C15
on HOADON
after update
as 
	declare @DoanhThuMoi money, @MaKH char(4), @TriGiaMoi money
	declare @DoanhSoMoi money
	select @DoanhThuMoi=inserted.TRIGIA, @MaKH=inserted.MAKH
	from inserted
	if (update(TRIGIA) and exists (select MAKH from KHACHHANG where MAKH=@MaKH))
	set @DoanhSoMoi=0
	declare DoanhThuMoi_Cursor 
	cursor for (select TRIGIA from HOADON where MAKH=@MaKH)
	Open DoanhThuMoi_Cursor
	Fetch next from DoanhThuMoi_Cursor
	into @TriGiaMoi

	while(@@FETCH_STATUS=0)
	begin
		set @DoanhSoMoi=@DoanhSoMoi+@TriGiaMoi
		Fetch next from DoanhThuMoi_Cursor
		into @TriGiaMoi
	end
	Close DoanhThuMoi_Cursor
	Deallocate DoanhThuMoi_Cursor
	update KHACHHANG
	set DOANHSO=@DoanhSoMoi
	where MAKH=@MaKH
go


go
create trigger KHACHHANG_insert_C15
on KHACHHANG
after insert
as
	declare @MaKH char(4)
	select @MaKH=inserted.MAKH
	from inserted
	update KHACHHANG
	set DOANHSO=0
	where MAKH=@MaKH
go

go
create trigger KHACHHANG_update_C15
on KHACHHANG
after update
as 
	declare @DoanhSoMoi money, @DoanhSoCu money
	declare @TriGiaMoi money, @MaKH char(4)
	select @DoanhSoMoi=inserted.DOANHSO, @MaKH=inserted.MAKH
	from inserted
	if (update(DOANHSO))
		begin
			declare DoanhSoMoi_Cursor
			cursor for (select TRIGIA from HOADON where MAKH=@MaKH)
			open DoanhSoMoi_Cursor
			fetch next from DoanhSoMoi_Cursor
			into @TriGiaMoi
			set @DoanhSoCu=0
			while (@@FETCH_STATUS=0)
			begin
				set @DoanhSoCu=@DoanhSoCu+@TriGiaMoi
				fetch next from DoanhSoMoi_Cursor
				into @TriGiaMoi
			end
			close DoanhSoMoi_Cursor
			deallocate DoanhSoMoi_Cursor
			if (@DoanhSoMoi!=@DoanhSoCu)
			begin
				rollback transaction
				print'Loi. Doanh so cua khach hang phai la tong tri gia cac hoa don ma khach hang thanh vien do da mua'
			end
		end
go


