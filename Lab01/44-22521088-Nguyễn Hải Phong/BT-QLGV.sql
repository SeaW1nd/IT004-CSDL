--Cau 1:
create database QLGV
use QLGV
--- Create table ---
create table KHOA (
	MAKHOA varchar(4) not null,
	TENKHOA varchar(40),
	NGTLAP smalldatetime,
	TRGKHOA char(4)
)
create table MONHOC (
	MAMH varchar(10),
	TENMH varchar(40),
	TCLT tinyint,
	TCTH tinyint,
	MAKHOA varchar(4),
)
create table DIEUKIEN (
	MAMH varchar(10) not null,
	MAMH_TRUOC varchar(10) not null
)
create table GIAOVIEN (
	MAGV char(4) not null,
	HOTEN varchar(40),
	HOCVI varchar(10),
	HOCHAM varchar(10),
	GIOITINH varchar(3),
	NGSINH smalldatetime,
	NGVL smalldatetime,
	HESO numeric(4,2),
	MUCLUONG money,
	MAKHOA varchar(4)
)
create table LOP (
	MALOP char(3) not null,
	TENLOP varchar(40),
	TRGLOP char(5),
	SISO tinyint,
	MAGVCN char(4)
)
create table HOCVIEN (
	MAHV char(5) not null,
	HO varchar(40),
	TEN varchar(10),
	NGSINH smalldatetime,
	GIOITINH varchar(3),
	NOISINH varchar(40),
	MALOP char(3)
)
create table GIANGDAY (
	MALOP char(3) not null,
	MAMH varchar(10) not null,
	MAGV char(4),
	HOCKY tinyint,
	NAM smallint,
	TUNGAY smalldatetime,
	DENNGAY smalldatetime
)
create table KETQUATHI (
	MAHV char(5) not null,
	MAMH varchar(10) not null,
	LANTHI tinyint not null,
	NGTHI smalldatetime,
	DIEM numeric(4,2),
	KQUA varchar(10)
)
--- Create primary keys ---
alter table KHOA add constraint KEY_MAKHOA primary key (MAKHOA)
alter table MONHOC add constraint KEY_MAMH primary key (MAMH)
alter table GIAOVIEN add constraint KEY_MAGV primary key (MAGV)
alter table LOP add constraint KEY_MALOP primary key (MALOP)
alter table HOCVIEN add constraint KEY_MAHV primary key (MAHV)
alter table DIEUKIEN add constraint KEY_MAMH_MAMH_TRUOC primary key (MAMH,MAMH_TRUOC)
alter table GIANGDAY add constraint KEY_MALOP_MAMH primary key (MALOP,MAMH)
alter table KETQUATHI add constraint KEY_MAHV_MAMH_LANTHI primary key(MAHV,MAMH,LANTHI)
--- Create foreign keys ---
alter table HOCVIEN add constraint FKEY_HOCVIEN_LOP_MALOP foreign key (MALOP) references LOP(MALOP)
alter table LOP add constraint FKEY_LOP_GIAOVIEN_MAGVCN foreign key (MAGVCN) references GIAOVIEN(MAGV)
alter table LOP add constraint FKEY_LOP_HOCVIEN_TRGLOP foreign key (TRGLOP) references HOCVIEN(MAHV)
alter table KHOA add constraint FKEY_KHOA_GIAOVIEN_TRGKHOA foreign key (TRGKHOA) references GIAOVIEN(MAGV)
alter table MONHOC add constraint FKEY_MONHOC_KHOA_MAKHOA foreign key (MAKHOA) references KHOA(MAKHOA)
alter table DIEUKIEN add constraint FKEY_DIEUKIEN_MONHOC_MAMH foreign key (MAMH) references MONHOC(MAMH)
alter table DIEUKIEN add constraint FKEY_DIEUKIEN_MONHOC_MAMH_TRUOC foreign key (MAMH_TRUOC) references MONHOC(MAMH)
alter table GIAOVIEN add constraint FKEY_GIAOVIEN_KHOA_MAKHOA foreign key (MAKHOA) references KHOA(MAKHOA)
alter table GIANGDAY add constraint FKEY_GIANGDAY_LOP_MALOP foreign key (MALOP) references LOP(MALOP)
alter table GIANGDAY add constraint FKEY_GIANGDAY_MONHOC_MAMH foreign key (MAMH) references MONHOC(MAMH)
alter table GIANGDAY add constraint FKEY_GIANGDAY_GIAOVIEN_MAGV foreign key (MAGV) references GIAOVIEN(MAGV)
alter table KETQUATHI add constraint FKEY_KETQUATHI_HOCVIEN_MAHV foreign key (MAHV) references HOCVIEN(MAHV)
alter table KETQUATHI add constraint FKEY_KETQUATHI_MONHOC_MAMH foreign key (MAMH) references MONHOC(MAMH)

--Them 3 thuoc tinh
alter table HOCVIEN add GHICHU varchar(40)
alter table HOCVIEN add DIEMTB numeric(4,2)
alter table HOCVIEN add XEPLOAI varchar(10)
--Cau 2:
go
CREATE FUNCTION CHECK_LAST_TWO_NUMBERS (@MALOP_HV char(3),@MAHV char(5))
returns int
as
begin
	IF(cast(right(@MAHV,2) as tinyint) >=1 and cast(right(@MAHV,2) as tinyint) <= (select SISO from LOP where MALOP=@MALOP_HV))
		return 1
	return 0
end
go
alter table HOCVIEN add constraint CHECK_MAHV check (
len(MAHV)= 5
and substring(MAHV,1,3)= MALOP
and dbo.CHECK_LAST_TWO_NUMBERS(MALOP,MAHV)=1
)
--Cach khac: 
alter table HOCVIEN add constraint CK_MANV check (MAHV like 'K[0-9][0-9][0-9][0-9]')

--Cau 3:
alter table HOCVIEN add constraint CHECK_GIOITINH_HOCVIEN check (GIOITINH='Nam' OR GIOITINH='Nu')
alter table GIAOVIEN add constraint CHECK_GIOITINH_GIAOVIEN check (GIOITINH='Nam' OR GIOITINH='Nu')
--Cau 4:
alter table KETQUATHI add constraint CHECK_DIEM check (
len(substring(cast(DIEM as varchar(10)),charindex(cast(DIEM as varchar(10)),'.'),100))>=2
and DIEM>=0 
and DIEM<=10
)
alter table KETQUATHI drop constraint CHECKDIEM
--Cau 5:
alter table KETQUATHI add constraint CHECK_DIEM_KETQUATHIDAU check (DIEM >=5 and DIEM <=10 and KQUA='Dat'
or DIEM <5 and KQUA='Khong dat'
)
--Cau 6: 
alter table KETQUATHI add constraint GIOIHANTHI check (LANTHI>0 and LANTHI<=3)
--Cau 7:
alter table GIANGDAY add constraint CHECK_HOCKY check (HOCKY >=1 and HOCKY <=3)
--Cau 8:
alter table GIAOVIEN add constraint CHECK_HOCVI check (HOCVI='CN' or HOCVI='KS' or HOCVI='Ths' or HOCVI='TS' or HOCVI='PTS')


-------------------------------------------------------------------LAB02-----------------------------------------------------------------------
--Nhap du lieu cho QLGV:

--Nhap du lieu bang KHOA
insert into KHOA values('KHMT','Khoa hoc may tinh','6/7/2005','GV01')
insert into KHOA values('HTTT','He thong thong tin','6/7/2005','GV02')
insert into KHOA values('CNPM','Cong nghe phan mem','6/7/2005','GV04')
insert into KHOA values('MTT','Mang va truyen thong','10/20/2005','GV03')
insert into KHOA values('KTMT','Ky thuat may tinh','12/20/2005',NULL)
--Nhap du lieu bang GIAOVIEN
insert into GIAOVIEN values('GV01','Ho Thanh Son','PTS','GS','Nam','5/2/1950','1/11/2004',5.00,2250000,'KHMT')
insert into GIAOVIEN values('GV02','Tran Tam Thanh','TS','PGS','Nam','12/17/1965','4/20/2004',4.50,2025000,'HTTT')
insert into GIAOVIEN values('GV03','Do Nghiem Phung','TS','GS','Nu','8/1/1950','9/23/2004',4.00,1800000,'CNPM')
insert into GIAOVIEN values('GV04','Tran Nam Son','TS','PGS','Nam','2/22/1961','1/12/2005',4.50,2025000,'KTMT')
insert into GIAOVIEN values('GV05','Mai Thanh Danh','ThS','GV','Nam','3/12/1958','1/12/2005',3.00,1350000,'HTTT')
insert into GIAOVIEN values('GV06','Tran Doan Hung','TS','GV','Nam','3/11/1953','1/12/2005',4.50,2025000,'KHMT')
insert into GIAOVIEN values('GV07','Nguyen Minh Tien','ThS','GV','Nam','11/23/1971','3/1/2005',4.00,1800000,'KHMT')
insert into GIAOVIEN values('GV08','Le Thi Tran','KS','','Nu','3/26/1974','3/1/2005',1.69,760500,'KHMT')
insert into GIAOVIEN values('GV09','Nguyen To Lan','ThS','GV','Nu','12/31/1966','3/1/2005',4.00,1800000,'HTTT')
insert into GIAOVIEN values('GV10','Le Tran Anh Loan','KS','','Nu','7/17/1972','3/1/2005',1.86,837000,'CNPM')
insert into GIAOVIEN values('GV11','Ho Thanh Tung','CN','GV','Nam','1/12/1980','5/15/2005',2.67,1201500,'MTT')
insert into GIAOVIEN values('GV12','Tran Van Anh','CN','','Nu','3/29/1981','5/15/2005',1.69,760500,'CNPM')
insert into GIAOVIEN values('GV13','Nguyen Linh Dan','CN','','Nu','5/23/1980','5/15/2005',1.69,760500,'KTMT')
insert into GIAOVIEN values('GV14','Truong Minh Chau','ThS','GV','Nu','11/30/1976','5/15/2005',3.00,1350000,'MTT')
insert into GIAOVIEN values('GV15','Le Ha Thanh','ThS','GV','Nam','5/4/1978','5/15/2005',3.00,1350000,'KHMT')
--Nhap du lieu bang MONHOC:
insert into MONHOC values('THDC','Tin hoc dai cuong',4,1,'KHMT')
insert into MONHOC values('CTRR','Cau truc roi rac',5,0,'KHMT')
insert into MONHOC values('CSDL','Co so du lieu',3,1,'HTTT')
insert into MONHOC values('CTDLGT','Cau truc du lieu va giai thuat',3,1,'KHMT')
insert into MONHOC values('PTTKTT','Phan tich thiet ke thuat toan',3,0,'KHMT')
insert into MONHOC values('DHMT','Do hoa may tinh',3,1,'KHMT')
insert into MONHOC values('KTMT','Kien truc may tinh',3,0,'KTMT')
insert into MONHOC values('TKCSDL','Thiet ke co so du lieu',3,1,'HTTT')
insert into MONHOC values('PTTKHTTT','Phan tich thiet ke he thong thong tin',4,1,'HTTT')
insert into MONHOC values('HDH','He dieu hanh',4,0,'KTMT')
insert into MONHOC values('NMCNPM','Nhap mon cong nghe phan mem',3,0,'CNPM')
insert into MONHOC values('LTCFW','Lap trinh C for win',3,1,'CNPM')
insert into MONHOC values('LTHDT','Lap trinh huong doi tuong',3,1,'CNPM')
--Nhap du lieu bang LOP:
insert into LOP values('K11','Lop 1 khoa 1','K1108',11,'GV07')
insert into LOP values('K12','Lop 2 khoa 1','K1205',12,'GV09')
insert into LOP values('K13','Lop 3 khoa 1','K1305',12,'GV14')
--Nhap du lieu bang HOCVIEN:
insert into HOCVIEN values('K1101','Nguyen Van','A','1/27/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1102','Tran Ngoc','Han','3/1/1986','Nu','Kien Giang','K11')
insert into HOCVIEN values('K1103','Ha Duy','Lap','4/18/1986','Nam','Nghe An','K11')
insert into HOCVIEN values('K1104','Tran Ngoc','Linh','3/30/1986','Nu','Tay Ninh','K11')
insert into HOCVIEN values('K1105','Tran Minh','Long','2/27/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1106','Le Nhat','Minh','1/24/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1107','Nguyen Nhu','Nhut','1/27/1986','Nam','Ha Noi','K11')
insert into HOCVIEN values('K1108','Nguyen Manh','Tam','2/27/1986','Nam','Kien Giang','K11')
insert into HOCVIEN values('K1109','Phan Thi Thanh','Tam','1/27/1986','Nu','Vinh Long','K11')
insert into HOCVIEN values('K1110','Le Hoai','Thuong','2/5/1986','Nu','Can Tho','K11')
insert into HOCVIEN values('K1111','Le Ha','Vinh','12/25/1986','Nam','Vinh Long','K11')
insert into HOCVIEN values('K1201','Nguyen Van','B','2/11/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1202','Nguyen Thi Kim','Duyen','1/18/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1203','Tran Thi Kim','Duyen','9/17/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1204','Truong My','Hanh','5/19/1986','Nu','Dong Nai','K12')
insert into HOCVIEN values('K1205','Nguyen Thanh','Nam','4/17/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1206','Nguyen Thi Truc','Thanh','3/4/1986','Nu','Kien Giang','K12')
insert into HOCVIEN values('K1207','Tran Thi Bich','Thuy','2/8/1986','Nu','Nghe An','K12')
insert into HOCVIEN values('K1208','Huynh Thi Kim','Trieu','4/8/1986','Nu','Tay Ninh','K12')
insert into HOCVIEN values('K1209','Pham Thanh','Trieu','2/23/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1210','Ngo Thanh','Tuan','2/14/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1211','Do Thi','Xuan','3/9/1986','Nu','Ha Noi','K12')
insert into HOCVIEN values('K1212','Le Thi Phi','Yen','3/12/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1301','Nguyen Thi Kim','Cuc','6/9/1986','Nu','Kien Giang','K13')
insert into HOCVIEN values('K1302','Truong Thi My','Hien','3/18/1986','Nu','Nghe An','K13')
insert into HOCVIEN values('K1303','Le Duc','Hien','3/12/1986','Nam','Tay Ninh','K13')
insert into HOCVIEN values('K1304','Le Quang','Hien','4/18/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1305','Le Thi','Huong','3/27/1986','Nu','TpHCM','K13')
insert into HOCVIEN values('K1306','Nguyen Thai','Huu','3/30/1986','Nam','Ha Noi','K13')
insert into HOCVIEN values('K1307','Tran Minh','Man','5/28/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1308','Nguyen Hieu','Nghia','4/8/1986','Nam','Kien Giang','K13')
insert into HOCVIEN values('K1309','Nguyen Trung','Nghia','1/18/1987','Nam','Nghe An','K13')
insert into HOCVIEN values('K1310','Tran Thi Hong','Tham','4/22/1986','Nu','Tay Ninh','K13')
insert into HOCVIEN values('K1311','Tran Minh','Thuc','4/4/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1312','Nguyen Thi Kim','Yen','9/7/1986','Nu','TpHCM','K13')
--Nhap du lieu bang GIANGDAY:
insert into GIANGDAY values('K11','THDC','GV07',1,2006,'1/2/2006','5/12/2006')
insert into GIANGDAY values('K12','THDC','GV06',1,2006,'1/2/2006','5/12/2006')
insert into GIANGDAY values('K13','THDC','GV15',1,2006,'1/2/2006','5/12/2006')
insert into GIANGDAY values('K11','CTRR','GV02',1,2006,'1/9/2006','5/17/2006')
insert into GIANGDAY values('K12','CTRR','GV02',1,2006,'1/9/2006','5/17/2006')
insert into GIANGDAY values('K13','CTRR','GV08',1,2006,'1/9/2006','5/17/2006')
insert into GIANGDAY values('K11','CSDL','GV05',2,2006,'6/1/2006','7/15/2006')
insert into GIANGDAY values('K12','CSDL','GV09',2,2006,'6/1/2006','7/15/2006')
insert into GIANGDAY values('K13','CTDLGT','GV15',2,2006,'6/1/2006','7/15/2006')
insert into GIANGDAY values('K13','CSDL','GV05',3,2006,'8/1/2006','12/15/2006')
insert into GIANGDAY values('K13','DHMT','GV07',3,2006,'8/1/2006','12/15/2006')
insert into GIANGDAY values('K11','CTDLGT','GV15',3,2006,'8/1/2006','12/15/2006')
insert into GIANGDAY values('K12','CTDLGT','GV15',3,2006,'8/1/2006','12/15/2006')
insert into GIANGDAY values('K11','HDH','GV04',1,2007,'1/2/2007','2/18/2007')
insert into GIANGDAY values('K12','HDH','GV04',1,2007,'1/2/2007','3/20/2007')
insert into GIANGDAY values('K11','DHMT','GV07',1,2007,'2/18/2007','3/20/2007')
--Nhap du lieu bang DIEUKIEN:
insert into DIEUKIEN values('CSDL','CTRR')
insert into DIEUKIEN values('CSDL','CTDLGT')
insert into DIEUKIEN values('CTDLGT','THDC')
insert into DIEUKIEN values('PTTKTT','THDC')
insert into DIEUKIEN values('PTTKTT','CTDLGT')
insert into DIEUKIEN values('DHMT','THDC')
insert into DIEUKIEN values('LTHDT','THDC')
insert into DIEUKIEN values('PTTKHTTT','CSDL')
--Nhap du lieu bang KETQUATHI:
insert into KETQUATHI values('K1101','CSDL',1,'7/20/2006',10.00,'Dat')
insert into KETQUATHI values('K1101','CTDLGT',1,'12/28/2006',9.00,'Dat')
insert into KETQUATHI values('K1101','THDC',1,'5/20/2006',9.00,'Dat')
insert into KETQUATHI values('K1101','CTRR',1,'5/13/2006',9.50,'Dat')
insert into KETQUATHI values('K1102','CSDL',1,'7/20/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1102','CSDL',2,'7/27/2006',4.25,'Khong dat')
insert into KETQUATHI values('K1102','CSDL',3,'8/10/2006',4.50,'Khong dat')
insert into KETQUATHI values('K1102','CTDLGT',1,'12/28/2006',4.50,'Khong dat')
insert into KETQUATHI values('K1102','CTDLGT',2,'1/5/2007',4.00,'Khong dat')
insert into KETQUATHI values('K1102','CTDLGT',3,'1/15/2007',6.00,'Dat')
insert into KETQUATHI values('K1102','THDC',1,'5/20/2006',5.00,'Dat')
insert into KETQUATHI values('K1102','CTRR',1,'5/13/2006',7.00,'Dat')
insert into KETQUATHI values('K1103','CSDL',1,'7/20/2006',3.50,'Khong dat')
insert into KETQUATHI values('K1103','CSDL',2,'7/27/2006',8.25,'Dat')
insert into KETQUATHI values('K1103','CTDLGT',1,'12/28/2006',7.00,'Dat')
insert into KETQUATHI values('K1103','THDC',1,'5/20/2006',8.00,'Dat')
insert into KETQUATHI values('K1103','CTRR',1,'5/13/2006',6.50,'Dat')
insert into KETQUATHI values('K1104','CSDL',1,'7/20/2006',3.75,'Khong dat')
insert into KETQUATHI values('K1104','CTDLGT',1,'12/28/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1104','THDC',1,'5/20/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1104','CTRR',1,'5/13/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1104','CTRR',2,'5/20/2006',3.50,'Khong dat')
insert into KETQUATHI values('K1104','CTRR',3,'6/30/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1201','CSDL',1,'7/20/2006',6.00,'Dat')
insert into KETQUATHI values('K1201','CTDLGT',1,'12/28/2006',5.00,'Dat')
insert into KETQUATHI values('K1201','THDC',1,'5/20/2006',8.50,'Dat')
insert into KETQUATHI values('K1201','CTRR',1,'5/13/2006',9.00,'Dat')
insert into KETQUATHI values('K1202','CSDL',1,'7/20/2006',8.00,'Dat')
insert into KETQUATHI values('K1202','CTDLGT',1,'12/28/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1202','CTDLGT',2,'1/5/2007',5.00,'Dat')
insert into KETQUATHI values('K1202','THDC',1,'5/20/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1202','THDC',2,'5/27/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1202','CTRR',1,'5/13/2006',3.00,'Khong dat')
insert into KETQUATHI values('K1202','CTRR',2,'5/20/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1202','CTRR',3,'6/30/2006',6.25,'Dat')
insert into KETQUATHI values('K1203','CSDL',1,'7/20/2006',9.25,'Dat')
insert into KETQUATHI values('K1203','CTDLGT',1,'12/28/2006',9.50,'Dat')
insert into KETQUATHI values('K1203','THDC',1,'5/20/2006',10.00,'Dat')
insert into KETQUATHI values('K1203','CTRR',1,'5/13/2006',10.00,'Dat')
insert into KETQUATHI values('K1204','CSDL',1,'7/20/2006',8.50,'Dat')
insert into KETQUATHI values('K1204','CTDLGT',1,'12/28/2006',6.75,'Dat')
insert into KETQUATHI values('K1204','THDC',1,'5/20/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1204','CTRR',1,'5/13/2006',6.00,'Dat')
insert into KETQUATHI values('K1301','CSDL',1,'12/20/2006',4.25,'Khong dat')
insert into KETQUATHI values('K1301','CTDLGT',1,'7/25/2006',8.00,'Dat')
insert into KETQUATHI values('K1301','THDC',1,'5/20/2006',7.75,'Dat')
insert into KETQUATHI values('K1301','CTRR',1,'5/13/2006',8.00,'Dat')
insert into KETQUATHI values('K1302','CSDL',1,'12/20/2006',6.75,'Dat')
insert into KETQUATHI values('K1302','CTDLGT',1,'7/25/2006',5.00,'Dat')
insert into KETQUATHI values('K1302','THDC',1,'5/20/2006',8.00,'Dat')
insert into KETQUATHI values('K1302','CTRR',1,'5/13/2006',8.50,'Dat')
insert into KETQUATHI values('K1303','CSDL',1,'12/20/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1303','CTDLGT',1,'7/25/2006',4.50,'Khong dat')
insert into KETQUATHI values('K1303','CTDLGT',2,'8/7/2006',4.00,'Khong dat')
insert into KETQUATHI values('K1303','CTDLGT',3,'8/15/2006',4.25,'Khong dat')
insert into KETQUATHI values('K1303','THDC',1,'5/20/2006',4.50,'Khong dat')
insert into KETQUATHI values('K1303','CTRR',1,'5/13/2006',3.25,'Khong dat')
insert into KETQUATHI values('K1303','CTRR',2,'5/20/2006',5.00,'Dat')
insert into KETQUATHI values('K1304','CSDL',1,'12/20/2006',7.75,'Dat')
insert into KETQUATHI values('K1304','CTDLGT',1,'7/25/2006',9.75,'Dat')
insert into KETQUATHI values('K1304','THDC',1,'5/20/2006',5.50,'Dat')
insert into KETQUATHI values('K1304','CTRR',1,'5/13/2006',5.00,'Dat')
insert into KETQUATHI values('K1305','CSDL',1,'12/20/2006',9.25,'Dat')
insert into KETQUATHI values('K1305','CTDLGT',1,'7/25/2006',10.00,'Dat')
insert into KETQUATHI values('K1305','THDC',1,'5/20/2006',8.00,'Dat')
insert into KETQUATHI values('K1305','CTRR',1,'5/13/2006',10.00,'Dat')
--I. Ngon ngu dinh nghia du lieu:
--Cau 11:
alter table HOCVIEN add constraint CHECK_TUOI check (GETDATE()-NGSINH >=18)
--Cau 12:
alter table GIANGDAY add constraint CHECK_NGAY check (DATEPART(day,TUNGAY) < DATEPART(day,DENNGAY))
--Cau 13:
alter table GIAOVIEN add constraint CHECK_TUOI_GV check (GETDATE()-NGSINH >=18)
--Cau 14:
alter table MONHOC add constraint CHECK_TINCHI check (ABS(TCLT-TCTH) <=5)
---III. Ngon ngu truy van du lieu:
--Cau 1:
select MAHV, HO, TEN, NGSINH, MALOP from HOCVIEN where MAHV in (
	select TRGLOP from LOP
)
--Cau 2:
select KETQUATHI.MAHV, HO, TEN, MAMH, LANTHI, DIEM from KETQUATHI, HOCVIEN where KETQUATHI.MAHV in (
select MAHV from HOCVIEN where MALOP='K12') and MAMH='CTRR' order by TEN, HO
--Cau 3:
select HOCVIEN.MAHV, HO, TEN, MAMH from HOCVIEN, KETQUATHI where HOCVIEN.MAHV in (
SELECT MAHV from KETQUATHI where LANTHI=1 and KQUA='Dat'
)
--Cau 4:
select MAHV, HO, TEN from HOCVIEN where MALOP='K11' and MAHV in (
select MAHV from KETQUATHI where LANTHI=1 and MAMH='CTRR' and KQUA='Khong dat'
)
--Cau 5:
select MAHV, HO, TEN from HOCVIEN where LEFT(MALOP,1)='K' and MAHV in (
select MAHV from KETQUATHI where MAMH='CTRR' EXCEPT select MAHV from KETQUATHI where MAMH='CTRR' and KQUA='Dat'
)
-------------------------------------------------------LAB03------------------------------------------------------------------
--II.
--Cau1:
update GIAOVIEN set HESO = HESO + 0.2 where MAGV in (select TRGKHOA from KHOA) 
--Cau 2: 
update HOCVIEN set DIEMTB = (
	select AVG(DIEM) as AVERAGEPOINTS from KETQUATHI as FINAL_RESULT where HOCVIEN.MAHV=FINAL_RESULT.MAHV and exists (
	select LANTHICUOICUNG from (select MAHV, MAMH, MAX(LANTHI) as LANTHICUOICUNG  from KETQUATHI
	group by MAHV, MAMH) as DTB where FINAL_RESULT.MAHV=DTB.MAHV and FINAL_RESULT.MAMH = DTB.MAMH and FINAL_RESULT.LANTHI = DTB.LANTHICUOICUNG) group by MAHV 
)


--Cau3:
update HOCVIEN set GHICHU='Cam thi' where MAHV in (select MAHV from KETQUATHI where (LANTHI=3 and DIEM < 5))

--Cau4:
update HOCVIEN set XEPLOAI='XS' where MAHV in (select MAHV from KETQUATHI where (DIEM >=9)) 

update HOCVIEN set XEPLOAI='G' where MAHV in (select MAHV from KETQUATHI where (DIEM >=8 and DIEM < 9)) 

update HOCVIEN set XEPLOAI='K' where MAHV in (select MAHV from KETQUATHI where (DIEM >=6.5 and DIEM < 8)) 

update HOCVIEN set XEPLOAI='TB' where MAHV in (select MAHV from KETQUATHI where (DIEM >=5 and DIEM < 6.5)) 

update HOCVIEN set XEPLOAI='Y' where MAHV in (select MAHV from KETQUATHI where (DIEM < 5)) 
--III.
--Cau 6:
select TENMH from MONHOC where MAMH in (
	select MAMH from GIANGDAY where HOCKY=1 and NAM=2006 and MAGV in (
		select MAGV from GIAOVIEN where HOTEN='Tran Tam Thanh'
		)
	)
--Cau 7:
select MAMH, TENMH from MONHOC where MAMH in (
	select MAMH from GIANGDAY where HOCKY=1 and NAM=2006 and MAGV in (
		select MAGVCN from LOP where MALOP='K11'
		)
	)
--Cau 8:
select HO, TEN from HOCVIEN where MAHV in (
	select TRGLOP from LOP where MALOP in (
		select MALOP from GIANGDAY where MAGV in (select MAGV from GIAOVIEN where HOTEN='Nguyen To Lan') 
		and MAMH in (select MAMH from MONHOC where TENMH='Co so du lieu')
		)	
)
--Cau 9:
select MAMH, TENMH from MONHOC where MAMH in (
	select MAMH_TRUOC from DIEUKIEN where DIEUKIEN.MAMH in (
		select MAMH from MONHOC where TENMH='Co so du lieu'
		)
)
--Cau 10:
select MAMH, TENMH from MONHOC where MAMH in (
	select MAMH from DIEUKIEN where MAMH_TRUOC in (
		select MAMH from MONHOC where TENMH='Cau truc roi rac'
		)
)
--Cau 11:
select HOTEN from GIAOVIEN where MAGV in (
	select MAGV from GIANGDAY where HOCKY=1 and NAM=2006 and MALOP='K11' and MAMH='CTRR'
)
intersect
select HOTEN from GIAOVIEN where MAGV in (
	select MAGV from GIANGDAY where HOCKY=1 and NAM=2006 and MALOP='K12' and MAMH='CTRR'
)
--Cau 12:
select MAHV, HO, TEN from HOCVIEN where MAHV in(
select MAHV from KETQUATHI where exists (

select * from (select * from 
(select MAHV, MAMH, MAX(LANTHI) as Max_Lan_Thi from KETQUATHI where MAMH='CSDL' group by MAHV, MAMH) 
as TEMP where Max_Lan_Thi = 1) as DieuKien
where DieuKien.MAHV=KETQUATHI.MAHV and DieuKien.MAMH=KETQUATHI.MAMH and DieuKien.Max_Lan_Thi=KETQUATHI.LANTHI)
and KQUA='Khong dat'
)
--Cau 13:
select MAGV, HOTEN from GIAOVIEN where not exists (
	select * from GIANGDAY where GIANGDAY.MAGV = GIAOVIEN.MAGV
)
--Cau 14: Can xem lai
select MAGV, HOTEN from GIAOVIEN where not exists (
	select * from MONHOC where MONHOC.MAKHOA=GIAOVIEN.MAKHOA and not exists (
		select * from GIANGDAY where GIANGDAY.MAMH = MONHOC.MAMH and GIANGDAY.MAGV=GIAOVIEN.MAGV
		)
)
--Cau 15:
select HO, TEN from HOCVIEN where MALOP='K11' and exists (
	select * from KETQUATHI where LANTHI=2 and MAMH='CTRR' and DIEM=5 and KETQUATHI.MAHV=HOCVIEN.MAHV
)
UNION
select HO,TEN from HOCVIEN where MALOP='K11' and exists (

select * from (
select * from KETQUATHI where exists (
	select * from (
	select * from (select MAHV, MAMH, MAX(LANTHI) as Max_Lan_Thi from KETQUATHI group by MAHV, MAMH) as Temp where (Max_Lan_Thi>3)
	) as Results where Results.MAHV = KETQUATHI.MAHV and Results.MAMH=KETQUATHI.MAMH and Results.Max_Lan_Thi=KETQUATHI.LANTHI
) and KQUA='Khong dat'
) as Final where Final.MAHV=HOCVIEN.MAHV
)

--Cau 16:
select HOTEN from GIAOVIEN where exists (
select MAGV, COUNT(MALOP) as 'Số lớp CTRR' from GIANGDAY where MAMH='CTRR' and GIANGDAY.MAGV=GIAOVIEN.MAGV group by MAGV,HOCKY,NAM having COUNT(MALOP)>1
)
--Cau 17:
select HV.*, DIEM as 'Điểm thi CSDL sau cùng' from HOCVIEN HV 
join KETQUATHI on KETQUATHI.MAHV = HV.MAHV where exists (
	select * from (
	select MAHV, MAMH, DIEM, LANTHI from KETQUATHI where exists (
		select * from (
			select * from (
				select MAHV, MAMH, MAX(LANTHI) as Max_Lan_Thi from KETQUATHI where MAMH='CSDL' group by MAHV, MAMH)as Temp) 
				as DieuKien where DieuKien.MAHV = KETQUATHI.MAHV and DieuKien.Max_Lan_Thi = KETQUATHI.LANTHI and KETQUATHI.MAMH = DieuKien.MAMH
	)  
	) as Final where Final.MAHV=HV.MAHV and KETQUATHI.LANTHI=Final.LANTHI and KETQUATHI.MAMH=Final.MAMH
)

--Cau 18:
select HV.*, DIEM as 'Điểm thi CSDL cao nhất' from HOCVIEN HV 
join KETQUATHI on KETQUATHI.MAHV = HV.MAHV where exists (
	select * from (
	select MAHV, MAMH, DIEM, LANTHI from KETQUATHI where exists (
		select * from (
			select * from (
				select MAHV, MAMH, MAX(DIEM) as Max_Diem_Thi from KETQUATHI where MAMH in (select MAMH from MONHOC where MONHOC.TENMH='Co so du lieu') 
				group by MAHV, MAMH)as Temp) 
				as DieuKien where DieuKien.MAHV = KETQUATHI.MAHV and DieuKien.Max_Diem_Thi=KETQUATHI.DIEM and KETQUATHI.MAMH = DieuKien.MAMH 
	)  
	) as Final where Final.MAHV=HV.MAHV and KETQUATHI.LANTHI=Final.LANTHI and KETQUATHI.MAMH=Final.MAMH
)
------------------------------------------------------------------------LAB04--------------------------------------------------------------------------------
--III. Ngon ngu truy van du lieu co cau truc: Tu 19 -> 35
--Cau 19:
select MAKHOA, TENKHOA from KHOA where NGTLAP<=all(select NGTLAP from KHOA)
--Cau 20:
select HOCHAM, count(HOCHAM) as SoLuongGiaoVien from GIAOVIEN where HOCHAM in ('GS','PGS') group by HOCHAM
--Cau 21:
select MAKHOA, count(HOCVI) as SoLuongGiaoVienMoiKhoa from GIAOVIEN where HOCVI in ('CN','KS','ThS','TS','PTS') group by MAKHOA
--Cau 22:
select KETQUATHI.MAMH, KQUA, count(KQUA) as SoLuongHocSinh from KETQUATHI 
group by KQUA, KETQUATHI.MAMH
--Cau 23:
select MAGV, HOTEN from GIAOVIEN where MAGV in (
	select MAGVCN from LOP where exists (
		select * from GIANGDAY where LOP.MALOP=GIANGDAY.MALOP and LOP.MAGVCN=GIANGDAY.MAGV
	)
)
--Cau 24:
select HO, TEN from HOCVIEN where MAHV in (
	select TRGLOP from LOP where MALOP in (
		select  MALOP from (
			select MALOP, count(MALOP) as SoLuongSinhVien from HOCVIEN group by MALOP
		) as ThongKe where SoLuongSinhVien>=all(select count(MALOP) from HOCVIEN group by MALOP)
	)
)
--Cau 25:
select HO, TEN from HOCVIEN where MAHV in (
	select TRGLOP from LOP where TRGLOP in (
		select MAHV from (
			select MAHV, count(*) as SoMonDat from KETQUATHI where KQUA='Dat' group by MAHV
			) as KetQuaDat where KetQuaDat.SoMonDat <= 3
		)
)
--Sửa bài:
select HO, TEN from HOCVIEN where MAHV in (
	select TRLOP from LOP where TRGLOP in (
		select MAHV, count(*) as SoMonKhongDat
		from KETQUATHI
		where KQUA='Khong dat'
		and LANTHI=(
--Cau 26:
select MAHV, HO, TEN from HOCVIEN where MAHV in (

	select MAHV from (

		select MAHV, count(MAHV) as SoLuongDiem9_10 from KETQUATHI where DIEM>=9 group by MAHV

	) as ThongKe where ThongKe.SoLuongDiem9_10>=all(select count(MAHV) from KETQUATHI where DIEM>=9 group by MAHV)
)
--Cau 27:
select MALOP, MAHV, HO, TEN from HOCVIEN where MAHV in (

	select ThongKe3.MAHV from (
		select MALOP, max(ThongKe.SoLuongDiem9_10) as SoLuongDiem9_10CaoNhat from LOP 
		left join
		(
		select * from (
				select MAHV, count(MAHV) as SoLuongDiem9_10 from KETQUATHI where DIEM>=9 group by MAHV
			) as ThongKe2
		) ThongKe
		on left(ThongKe.MAHV,3)=LOP.MALOP
		group by MALOP
		) 
	as Result
	join 
	(
		select * from (
				select MAHV, count(MAHV) as SoLuongDiem9_10 from KETQUATHI where DIEM>=9 group by MAHV
			) as ThongKe2
		) ThongKe3
	on ThongKe3.SoLuongDiem9_10=Result.SoLuongDiem9_10CaoNhat and Result.MALOP=left(ThongKe3.MAHV,3)
)

--Cau 28:
select MAGV, HOCKY, NAM, count(distinct MALOP) as SoLopDay, count(distinct MAMH) as SoMonDay from GIANGDAY group by MAGV, HOCKY, NAM order by NAM asc, HOCKY asc
--Cau 29:
select distinct HOCKY, NAM, GIAOVIEN.MAGV, HOTEN from GIAOVIEN, GIANGDAY where exists (
	select * from (
		select * from (
			select MAGV, HOCKY, NAM, count(distinct MALOP) as SoLopDay
			from GIANGDAY 
			group by MAGV, HOCKY, NAM 
		) as A
		where exists (
			select * from (
				select KetQua.HOCKY, KetQua.NAM, max(KetQua.SoLopDay) as GiangDayNhieuNhat from (
					select MAGV, HOCKY, NAM, count(distinct MALOP) as SoLopDay, count(distinct MAMH) as SoMonDay 
					from GIANGDAY 
					group by MAGV, HOCKY, NAM 
				) as KetQua 
				group by HOCKY,NAM 
			) as B 
			where A.HOCKY=B.HOCKY and A.NAM=B.NAM and A.SoLopDay=B.GiangDayNhieuNhat
		)
	) as DieuKien
	where DieuKien.HOCKY=GIANGDAY.HOCKY and DieuKien.NAM=GIANGDAY.NAM 
	and DieuKien.MAGV=GIAOVIEN.MAGV
)
order by NAM asc, HOCKY asc
--Cau 30:
select MAMH, TENMH from MONHOC where MAMH in (
	select MAMH from (
		select MAMH, count(MAMH) as SoHocVienKhongDat from KETQUATHI where LANTHI=1 and KQUA='Khong dat' group by MAMH 
	) as ThongKe where ThongKe.SoHocVienKhongDat>=all(select count(MAMH) from KETQUATHI where LANTHI=1 and KQUA='Khong dat' group by MAMH)
 )

 --Cau 31:
 select MAHV, HO, TEN from HOCVIEN where MAHV in (
	 select distinct MAHV from KETQUATHI where LANTHI=1
	 except
	 select distinct MAHV from KETQUATHI where LANTHI=1 and KQUA='Khong dat' 
)
--Cau 32:
 select MAHV, HO, TEN from HOCVIEN where MAHV in (
	select distinct MAHV from KETQUATHI where exists (
		select * from (
			select MAHV, MAMH, max(LANTHI) as LanThiCuoi from KETQUATHI group by MAHV, MAMH
		) as DieuKien 
		where DieuKien.MAHV=KETQUATHI.MAHV and DieuKien.MAMH=KETQUATHI.MAMH and DieuKien.LanThiCuoi=KETQUATHI.LANTHI
	) 
	except 
	select distinct MAHV from KETQUATHI where exists (
		select * from (
			select MAHV, MAMH, max(LANTHI) as LanThiCuoi from KETQUATHI group by MAHV, MAMH
		) as DieuKien 
		where DieuKien.MAHV=KETQUATHI.MAHV and DieuKien.MAMH=KETQUATHI.MAMH and DieuKien.LanThiCuoi=KETQUATHI.LANTHI
	) and KQUA='Khong dat'
)
--Cau 33: Cach 2:
select MAHV, HO, TEN from HOCVIEN
where MAHV in (
	select MAHV from (
		select MAHV, count(distinct MAMH) as SoMonThiDauLan1 from KETQUATHI where MAHV in (
			 select distinct MAHV from KETQUATHI where LANTHI=1
			 except
			 select distinct MAHV from KETQUATHI where LANTHI=1 and KQUA='Khong dat' 
		)
		group by MAHV
	) as SinhVienThiDauLan1
	where SinhVienThiDauLan1.SoMonThiDauLan1=(select count(distinct MAMH) from MONHOC)
)

--Cau 34:
 select MAHV, HO, TEN from HOCVIEN 
 where MAHV in (
	select MAHV from (
		select MAHV, count(distinct MAMH) as SoMonThiDau from KETQUATHI where MAHV in(
			select distinct MAHV from KETQUATHI where exists (
				select * from (
					select MAHV, MAMH, max(LANTHI) as LanThiCuoi from KETQUATHI group by MAHV, MAMH
				) as DieuKien 
				where DieuKien.MAHV=KETQUATHI.MAHV and DieuKien.MAMH=KETQUATHI.MAMH and DieuKien.LanThiCuoi=KETQUATHI.LANTHI
			) 
			except 
			select distinct MAHV from KETQUATHI where KQUA='Khong dat' and exists (
				select * from (
					select MAHV, MAMH, max(LANTHI) as LanThiCuoi from KETQUATHI group by MAHV, MAMH
				) as DieuKien 
				where DieuKien.MAHV=KETQUATHI.MAHV and DieuKien.MAMH=KETQUATHI.MAMH and DieuKien.LanThiCuoi=KETQUATHI.LANTHI
			) 
		) group by MAHV
	)
	as SinhVienThiDauLanCuoi
	where SinhVienThiDauLanCuoi.SoMonThiDau=(select count(distinct MAMH) from MONHOC)
)
--Cau 35:
select MaMH, MaHV, HoTen
from
(
	select MaMH, HocVien.MaHV, (Ho+' '+Ten) HoTen, rank() over (partition by MaMH order by MAX(Diem) desc) as XepHang
	from HocVien, KetQuaThi
	where HocVien.MaHV = KetQuaThi.MaHV
	and LanThi = (select MAX(LanThi) from KetQuaThi where MaHV = HocVien.MaHV group by MaHV)
	group by MaMH, HocVien.MaHV, Ho, Ten
) as A
where XepHang=1
--------------------------------------------------------------------LAB05-------------------------------------------------------------------------------------
--I.Ngôn ngữ định nghĩa dữ liệu
--Câu 9:
go
create trigger LOP_insert_C9
on LOP
after insert
as
	declare @MaTrgLop char(5), @MaLopTrgLop char(5)
	declare @MaLop char(3)
	select @MaTrgLop=inserted.TRGLOP, @MaLop=inserted.MALOP
	from inserted
	select @MaLopTrgLop=MALOP
	from HOCVIEN
	where MAHV=@MaTrgLop
	if (@MaLopTrgLop!=@MaLop)
	begin
		rollback transaction
		print'Loi. Lop truong cua mot lop phai la hoc vien cua lop do.'
	end
go

insert into LOP values('K14','Lop 4 khoa 1', 'K1308', Null, Null)

go
create trigger LOP_update_C9
on LOP
after update
as
	if (update(TRGLOP))
	begin
		declare @MaTrgLop char(5), @MaLopTrgLop char(5)
		declare @MaLop char(3)
		select @MaTrgLop=inserted.TRGLOP
		from inserted
		select @MaLop=deleted.MALOP
		from deleted
		select @MaLopTrgLop=MALOP
		from HOCVIEN
		where MAHV=@MaTrgLop
		if (@MaLopTrgLop!=@MaLop)
		begin
			rollback transaction
			print'Loi. Lop truong cua mot lop phai la hoc vien cua lop do.'
		end
	end
go

--Câu 10:
go
create trigger KHOA_insert_C10
on KHOA
after insert
as 
	declare @MaTrgKhoa char(4), @MaKhoaTrgKhoa char(4)
	declare @HocVi varchar(10), @MaKhoa char(4)
	select @MaTrgKhoa=inserted.TRGKHOA, @MaKhoa=inserted.MAKHOA
	from inserted
	select @MaKhoaTrgKhoa=MAKHOA, @HocVi=HOCVI
	from GIAOVIEN
	where MAGV=@MaTrgKhoa
	if (@MaKhoaTrgKhoa!=@MaKhoa)
	begin
		rollback transaction
		print'Loi. Truong khoa phai la giao vien thuoc khoa do'
	end
	else if (@HocVi!='TS' and @HocVi!='PTS')
	begin
		rollback transaction
		print'Loi. Truong khoa phai co hoc vi TS hoac PTS'
	end
go

go
create trigger KHOA_C10
on KHOA
after update
as 
	declare @MaTrgKhoa char(4), @MaKhoaTrgKhoa char(4)
	declare @HocVi varchar(10), @MaKhoa char(4)
	select @MaTrgKhoa=inserted.TRGKHOA
	from inserted
	select  @MaKhoa=deleted.MAKHOA
	from deleted
	select @MaKhoaTrgKhoa=MAKHOA, @HocVi=HOCVI
	from GIAOVIEN
	where MAGV=@MaTrgKhoa
	if (@MaKhoaTrgKhoa!=@MaKhoa)
	begin
		rollback transaction
		print'Loi. Truong khoa phai la giao vien thuoc khoa do'
	end
	else if (@HocVi!='TS' and @HocVi!='PTS')
	begin
		rollback transaction
		print'Loi. Truong khoa phai co hoc vi TS hoac PTS'
	end
go
--Cáu 15
go
create trigger KETQUATHI_insert_C15
on KETQUATHI
after insert
as 
	declare @MaHV char(5), @MaLop char(3)
	declare @MaMH varchar(10)
	select @MaMH=inserted.MAMH, @MaHV=inserted.MAHV
	from inserted
	select @MaLop=MALOP
	from HOCVIEN
	where MAHV=@MaHV
	if (not exists(select * from GIANGDAY where MALOP=@MaLop and MAMH=@MaMH))
	begin
		rollback transaction
		print'Loi. Hoc vien chi duoc thi mon hoc khi lop cua hoc vien do da hoc xong mon nay'
	end
go

go
create trigger KETQUATHI_update_C15
on KETQUATHI
after update
as 
	if(update(MAMH))
	begin
		declare @MaHV char(5), @MaLop char(3)
		declare @MaMH varchar(10)
		select @MaMH=inserted.MAMH, @MaHV=inserted.MAHV
		from inserted
		select @MaLop=MALOP
		from HOCVIEN
		where MAHV=@MaHV
		if (not exists(select * from GIANGDAY where MALOP=@MaLop and MAMH=@MaMH))
		begin
			rollback transaction
			print'Loi. Hoc vien chi duoc thi mon hoc khi lop cua hoc vien do da hoc xong mon nay'
		end
	end
go

go
create trigger GIANGDAY_delete_C15
on GIANGDAY
after delete
as
	declare @MaMH varchar(10), @MaLop char(3)
	select @MaMH=deleted.MAMH, @MaLop=deleted.MALOP
	from deleted
	if (exists(select * from KETQUATHI where MAMH=@MaMH and MAHV in(select MAHV from HOCVIEN where MALOP=@MaLop)))
	begin
		rollback transaction
		print'Loi. Lop cua hoc vien da hoc xong mon nay va co hoc vien dang thi.'
	end
go

go
create trigger GIANGDAY_update_C15
on GIANGDAY
after update
as
	if(update(MAMH))
	begin
		declare @MaMH varchar(10), @MaLop char(3)
		select @MaMH=deleted.MAMH, @MaLop=deleted.MALOP
		from deleted
		if (exists(select * from KETQUATHI where MAMH=@MaMH and MAHV in(select MAHV from HOCVIEN where MALOP=@MaLop)))
		begin
			rollback transaction
			print'Loi. Lop cua hoc vien da hoc xong mon nay va co hoc vien dang thi.'
		end
	end
go

--Câu 16
go
create trigger GIANGDAY_insert_C16
on GIANGDAY
after insert
as
	declare @MaLop varchar(10), @HocKy tinyint, @Nam smallint, @SLMonHoc int
	set @SLMonHoc=0
	select distinct @MaLop=inserted.MALOP, @HocKy=inserted.HOCKY, @Nam=inserted.NAM, @SLMonHoc=count(*)
	from inserted, GIANGDAY
	where inserted.MALOP=GIANGDAY.MALOP and inserted.HOCKY=GIANGDAY.HOCKY and inserted.NAM=GIANGDAY.NAM
	group by inserted.MALOP, inserted.HOCKY, inserted.NAM
	if @SLMonHoc>3
	begin
		rollback transaction
		print'Loi. Moi hoc ky cua mot nam, mot lop chi duoc hoc toi da 3 mon'
	end
go

go
create trigger GIANGDAY_update_C16
on GIANGDAY
after update
as
	if (update(HOCKY) or UPDATE(NAM))
	begin
		declare @MaLop varchar(10), @HocKy tinyint, @Nam smallint, @SLMonHoc int
		set @SLMonHoc=0
		select distinct @MaLop=inserted.MALOP, @HocKy=inserted.HOCKY, @Nam=inserted.NAM, @SLMonHoc=count(*)
		from inserted, GIANGDAY
		where inserted.MALOP=GIANGDAY.MALOP and inserted.HOCKY=GIANGDAY.HOCKY and inserted.NAM=GIANGDAY.NAM
		group by inserted.MALOP, inserted.HOCKY, inserted.NAM
		if @SLMonHoc>3
		begin
			rollback transaction
			print'Loi. Moi hoc ky cua mot nam, mot lop chi duoc hoc toi da 3 mon'
		end
	end
go
--Câu 17
go
create trigger HOCVIEN_insert_C17
on HOCVIEN
after insert
as 
	declare @SiSo int, @MaLop char(3), @DemSiSo int
	select @MaLop=inserted.MALOP, @DemSiSo=count(*)
	from inserted, HOCVIEN
	where inserted.MALOP=HOCVIEN.MALOP
	group by inserted.MALOP
	update LOP
	set SISO=@DemSiSo
	where MALOP=@MaLop
go

go
create trigger HOCVIEN_delete_C17
on HOCVIEN
after delete
as 
	declare @SiSo int, @MaLop char(3), @DemSiSo int
	select @MaLop=deleted.MALOP, @DemSiSo=count(*)
	from deleted, HOCVIEN
	where deleted.MALOP=HOCVIEN.MALOP
	group by deleted.MALOP
	update LOP
	set SISO=@DemSiSo
	where MALOP=@MaLop
go

go
create trigger HOCVIEN_update_C17
on HOCVIEN
after update
as
	if (update(MALOP))
	begin
		declare @DemSiSoMoi int, @MaLopMoi char(3)
		declare @DemSiSoCu int, @MaLopCu char(3)
		select @MaLopMoi=inserted.MALOP, @DemSiSoMoi=count(*)
		from inserted, HOCVIEN
		where inserted.MALOP=HOCVIEN.MALOP
		group by inserted.MALOP

		select @MaLopCu=deleted.MALOP, @DemSiSoCu=count(*)
		from deleted, HOCVIEN
		where deleted.MALOP=HOCVIEN.MALOP
		group by deleted.MALOP

		update LOP
		set SISO=@DemSiSoMoi
		where MALOP=@MaLopMoi

		update LOP
		set SISO=@DemSiSoCu
		where MALOP=@MaLopCu
	end
go

go
create trigger LOP_insert_C17
on LOP
after insert
as	
	declare @MaLop char(3)
	select @MaLop=inserted.MALOP
	from inserted
	update LOP
	set SISO=0
	where MALOP=@MaLop
go

go
create trigger LOP_update_C17
on LOP
after update
as
	if (update(SISO))
	begin
		declare @DemSiSoMoi int, @MaLopMoi char(3)
		declare @DemSiSoCu int, @MaLopCu char(3)
		select @DemSiSoMoi=inserted.SISO, @MaLopMoi=inserted.MALOP
		from inserted

		select @MaLopCu=deleted.MALOP, @DemSiSoCu=count(*)
		from deleted, HOCVIEN
		where deleted.MALOP=HOCVIEN.MALOP
		group by deleted.MALOP

		if (@DemSiSoMoi!=@DemSiSoCu)
		begin
			rollback transaction
			print'Loi. Si so cua mot lop phai bang voi so luong hoc vien thuoc lop do.'
		end
	end
go

--Câu 18
go
create trigger DIEUKIEN_insert_C18
on DIEUKIEN
after insert
as 
	declare @MonHocTruoc varchar(10), @MonHocSau varchar(10)
	select @MonHocTruoc=inserted.MAMH_TRUOC, @MonHocSau=inserted.MAMH
	from inserted
	if (@MonHocTruoc=@MonHocSau)
	begin
		rollback transaction
		print'Loi. Mon hoc truoc khong the bang mon hoc sau'
	end
	else if (exists(select * from DIEUKIEN where MAMH=@MonHocTruoc and MAMH_TRUOC=@MonHocSau))
	begin
		rollback transaction
		print'Loi. Khong the nhap mon hoc nhu the duoc'
	end
go

go
create trigger DIEUKIEN_update_C18
on DIEUKIEN
after update
as
	if(update(MAMH) or update(MAMH_TRUOC))
	begin
		declare @MonHocTruoc_Insert varchar(10), @MonHoc_Insert varchar(10)
		select @MonHoc_Insert=inserted.MAMH,@MonHocTruoc_Insert=inserted.MAMH_TRUOC
		from inserted
		if (@MonHoc_Insert=@MonHocTruoc_Insert)
		begin
			rollback transaction
			print'Loi. Mon hoc truoc khong the bang mon hoc sau'
		end
		else if (exists(select * from DIEUKIEN where MAMH=@MonHocTruoc_Insert and MAMH_TRUOC=@MonHoc_Insert))
		begin
			rollback transaction
			print'Loi. Khong the sua mon hoc nhu the'
		end
	end
go
drop trigger DIEUKIEN_update_C18

--Câu 19
go
create trigger GIAOVIEN_insert_C19
on GIAOVIEN
after insert
as 
	declare @HocVi varchar(10), @HocHam varchar(10), @HeSoLuong numeric(4,2), @MAGV char(4)
	select @HocVi=inserted.HOCVI, @HocHam=inserted.HOCHAM, @HeSoLuong=inserted.HESO, @MAGV=inserted.MAGV
	from inserted
	if (exists (select * from GIAOVIEN where HOCVI=@HocVi and HOCHAM=@HocHam and HESO=@HeSoLuong and MAGV!=@MAGV))
	begin
		update GIAOVIEN
		set MUCLUONG=(select distinct MUCLUONG from GIAOVIEN where HOCVI=@HocVi and HOCHAM=@HocHam and HESO=@HeSoLuong and MAGV!=@MAGV)
		where HOCVI=@HocVi
		and HOCHAM=@HocHam
		and HESO=@HeSoLuong
		and MAGV=@MAGV
	end
go

go
create trigger GIAOVIEN_update_C19
on GIAOVIEN 
after update
as 
	if (update(HOCVI) or update(HOCHAM) or update(HESO))
	begin
		declare @HocVi varchar(10), @HocHam varchar(10), @HeSoLuong numeric(4,2), @MAGV char(4)
		select @HocVi=inserted.HOCVI, @HocHam=inserted.HOCHAM, @HeSoLuong=inserted.HESO, @MAGV=inserted.MAGV
		from inserted
		if (exists (select * from GIAOVIEN where HOCVI=@HocVi and HOCHAM=@HocHam and HESO=@HeSoLuong and MAGV!=@MAGV))
		begin
			update GIAOVIEN
			set MUCLUONG=(select distinct MUCLUONG from GIAOVIEN where HOCVI=@HocVi and HOCHAM=@HocHam and HESO=@HeSoLuong and MAGV!=@MAGV)
			where HOCVI=@HocVi
			and HOCHAM=@HocHam
			and HESO=@HeSoLuong
			and MAGV=@MAGV
		end
	end
go
--Câu 20
go
create trigger KETQUATHI_insert_C20
on KETQUATHI
after insert
as
	declare @DiemThi numeric(4,2), @MaHV char(5), @MaMH varchar(10)
	declare @LanThi tinyint
	select @MaHV=inserted.MAHV, @MaMH=inserted.MAMH, @LanThi=inserted.LANTHI
	from inserted
	select @DiemThi=DIEM
	from KETQUATHI
	where MAHV=@MaHV and MAMH=@MaMH
	and LANTHI = (select max(LANTHI) from KETQUATHI where MAHV=@MaHV and MAMH=@MaMH and LANTHI!=@LanThi)
	if @DiemThi>=5
	begin
		rollback transaction
		print'Loi. Hoc vien chi duoc thi lai khi diem lan truoc < 5'
	end
go

go
create trigger KETQUATHI_update_C20
on KETQUATHI
after update
as
	if (update(DIEM))
	begin
		declare @DiemThi numeric(4,2), @MaHV char(5), @MaMH varchar(10)
		declare @LanThi tinyint
		select @MaHV=inserted.MAHV, @MaMH=inserted.MAMH, @LanThi=inserted.LANTHI, @DiemThi=inserted.DIEM
		from inserted
		if (@DiemThi>=5 and exists(select * from KETQUATHI where MAHV=@MaHV and MAMH=@MaMH and LANTHI>@LanThi))
		begin
			rollback transaction
			print'Loi. Hoc vien chi duoc thi lai khi diem lan truoc < 5'
		end
	end
go
--Câu 21
go
create trigger KETQUATHI_insert_C21
on KETQUATHI
after insert
as
	declare @NgayThi smalldatetime, @LanThi tinyint
	declare @MaHV char(5), @MaMH varchar(10), @NgayThiTruoc smalldatetime
	select @NgayThi=inserted.NGTHI, @MaHV=inserted.MAHV, @MaMH=inserted.MAMH, @LanThi=inserted.LANTHI
	from inserted
	select @NgayThiTruoc=NGTHI
	from KETQUATHI
	where MAHV=@MaHV and MAMH=@MaMH
	and LANTHI=(select max(LANTHI) from KETQUATHI where MAHV=@MaHV and MAMH=@MaMH and LANTHI!=@LanThi)
	if (@NgayThi<=@NgayThiTruoc)
	begin
		rollback transaction
		print'Loi. Ngay thi lan thi sau phai lon hon ngay thi lan thi truoc'
	end
go

go
create trigger KETQUATHI_update_C21
on KETQUATHI
after update 
as
	if (update(NGTHI))
	begin
		declare @NgayThi smalldatetime, @LanThi tinyint
		declare @MaHV char(5), @MaMH varchar(10), @NgayThiTruoc smalldatetime
		select @NgayThi=inserted.NGTHI, @MaHV=inserted.MAHV, @MaMH=inserted.MAMH, @LanThi=inserted.LANTHI
		from inserted
		select @NgayThiTruoc=NGTHI
		from KETQUATHI
		where MAHV=@MaHV and MAMH=@MaMH
		and LANTHI=(@LanThi-1)
		if (@NgayThi<=@NgayThiTruoc)
		begin
			rollback transaction
			print'Loi. Ngay thi lan thi sau phai lon hon ngay thi lan thi truoc'
		end
	end
go
--Câu 22
go
create trigger KETQUATHI_insert_C22
on KETQUATHI
after insert
as 
	declare @MaHV char(5), @MaLop char(3)
	declare @MaMH varchar(10)
	select @MaMH=inserted.MAMH, @MaHV=inserted.MAHV
	from inserted
	select @MaLop=MALOP
	from HOCVIEN
	where MAHV=@MaHV
	if (not exists(select * from GIANGDAY where MALOP=@MaLop and MAMH=@MaMH))
	begin
		rollback transaction
		print'Loi. Hoc vien chi duoc thi mon hoc khi lop cua hoc vien do da hoc xong mon nay'
	end
go

go
create trigger KETQUATHI_update_C22
on KETQUATHI
after update
as 
	if(update(MAMH))
	begin
		declare @MaHV char(5), @MaLop char(3)
		declare @MaMH varchar(10)
		select @MaMH=inserted.MAMH, @MaHV=inserted.MAHV
		from inserted
		select @MaLop=MALOP
		from HOCVIEN
		where MAHV=@MaHV
		if (not exists(select * from GIANGDAY where MALOP=@MaLop and MAMH=@MaMH))
		begin
			rollback transaction
			print'Loi. Hoc vien chi duoc thi mon hoc khi lop cua hoc vien do da hoc xong mon nay'
		end
	end
go

go
create trigger GIANGDAY_delete_C22
on GIANGDAY
after delete
as
	declare @MaMH varchar(10), @MaLop char(3)
	select @MaMH=deleted.MAMH, @MaLop=deleted.MALOP
	from deleted
	if (exists(select * from KETQUATHI where MAMH=@MaMH and MAHV in(select MAHV from HOCVIEN where MALOP=@MaLop)))
	begin
		rollback transaction
		print'Loi. Lop cua hoc vien da hoc xong mon nay va co hoc vien dang thi.'
	end
go

go
create trigger GIANGDAY_update_C22
on GIANGDAY
after update
as
	if(update(MAMH))
	begin
		declare @MaMH varchar(10), @MaLop char(3)
		select @MaMH=deleted.MAMH, @MaLop=deleted.MALOP
		from deleted
		if (exists(select * from KETQUATHI where MAMH=@MaMH and MAHV in(select MAHV from HOCVIEN where MALOP=@MaLop)))
		begin
			rollback transaction
			print'Loi. Lop cua hoc vien da hoc xong mon nay va co hoc vien dang thi.'
		end
	end
go
--Câu 23
--Bảng tầm ảnh hưởng: Bảng DIEUKIEN có trước, bảng GIANGDAY có sau
--DIEUKIEN: 
--GIANGDAY: trigger insert
go
create trigger GIANGDAY_insert_C23
on GIANGDAY
after insert
as
	declare @MaLop char(3), @MaMH varchar(10), @Check tinyint
	declare @MonHocTruoc varchar(10), @MonHocSau varchar(10)
	declare @Nam int, @HocKy int
	set @Check=0
	select @MaLop=inserted.MALOP, @MaMH=inserted.MAMH, @Nam=inserted.NAM, @HocKy=inserted.HOCKY
	from inserted
	if (exists (select * from DIEUKIEN where MAMH=@MaMH))
	begin
		declare DieuKien_Cursor 
		cursor for (select MAMH_TRUOC from DIEUKIEN where MAMH=@MaMH)
		open DieuKien_Cursor
		fetch next from DieuKien_Cursor
		into @MonHocTruoc
		while (@@FETCH_STATUS=0)
		begin
			if(exists(select * from GIANGDAY where MALOP=@MaLop and MAMH=@MonHocTruoc and HOCKY=@HocKy and NAM=@Nam))
			begin
				set @Check=1
				break
			end
			else
			begin
				fetch next from DieuKien_Cursor
				into @MonHocTruoc
			end
		end
		close DieuKien_Cursor
		deallocate DieuKien_Cursor
		if @Check=0
		begin
			rollback transaction
			print'Loi. Mon hoc nay khong duoc hoc truoc vi chua hoc mon hoc tien quyet'
		end
	end
go

--Câu 24
go
create trigger GIANGDAY_insert_C24
on GIANGDAY
after insert
as
	declare @MaGV char(4), @MaMH varchar(10)
	declare @MaKhoaGV varchar(4)
	select @MaGV=inserted.MAGV, @MaMH=inserted.MAMH
	from inserted
	select @MaKhoaGV=MAKHOA
	from GIAOVIEN
	where MAGV=@MaGV
	if (not exists(select * from MONHOC where MAMH=@MaMH and MAKHOA=@MaKhoaGV))
	begin
		rollback transaction
		print'Loi. Giao vien chi duoc phan cong day nhung mon thuoc khoa giao vien do phu trach'
	end
go

go
create trigger GIANGDAY_update_C24
on GIANGDAY
after update
as 
	if(update(MAGV))
	begin
		declare @MaGV char(4), @MaMH varchar(10)
		declare @MaKhoaGV varchar(4)
		select @MaGV=inserted.MAGV, @MaMH=inserted.MAMH
		from inserted
		select @MaKhoaGV=MAKHOA
		from GIAOVIEN
		where MAGV=@MaGV
		if (not exists(select * from MONHOC where MAMH=@MaMH and MAKHOA=@MaKhoaGV))
		begin
			rollback transaction
			print'Loi. Giao vien chi duoc phan cong day nhung mon thuoc khoa giao vien do phu trach'
		end
	end
go

go
create trigger MONHOC_update_C24
on MONHOC
after update
as
	if(update(MAKHOA))
	begin
	declare @MaMH varchar(10), @MaKhoa varchar(4), @MaGV char(4)
	declare @MaKhoaGV varchar(4)
	select @MaMH=inserted.MAMH, @MaKhoa=inserted.MAKHOA
	from inserted
	select distinct top 1 @MaGV=MAGV 
	from GIANGDAY
	where MAMH=@MaMH
	select @MaKhoaGV=MAKHOA
	from GIAOVIEN
	where MAGV=@MaGV 
	if @MaKhoa!=@MaKhoaGV
		begin
			rollback transaction
			print'Loi. Giao vien chi duoc phan cong day nhung mon thuoc khoa giao vien do phu trach'
		end
	end
go

go
create trigger GIAOVIEN_update_C24
on GIAOVIEN
after update
as
	if (update(MAKHOA))
	begin
		declare @MaMH varchar(10), @MaKhoa varchar(4), @MaGV char(4)
		declare @MaKhoaMH varchar(4)
		select @MaGV=inserted.MAGV, @MaKhoa=inserted.MAKHOA
		from inserted
		select distinct top 1 @MaMH=MAMH
		from GIANGDAY
		where MAGV=@MaGV

		select @MaKhoaMH=MAKHOA
		from MONHOC
		where MAMH=@MaMH
		if @MaKhoaMH!=@MaKhoa
		begin
			rollback transaction
			print'Loi. Giao vien chi duoc phan cong day nhung mon thuoc khoa giao vien do phu trach'
		end
	end
go


use QLGV
select distinct LOP.MALOP, HOCVIEN.MAHV, HO, TEN 
from LOP
join HOCVIEN on HOCVIEN.MALOP=LOP.MALOP
join KETQUATHI on KETQUATHI.MAHV=HOCVIEN.MAHV
where exists (
	
	select * from (
		select A.MALOP, Max(A.DiemCaoNhat) as DiemCaoTungLop from (
			select MALOP, KETQUATHI.MAHV, max(DIEM) as DiemCaoNhat
			from KETQUATHI
			join HOCVIEN on KETQUATHI.MAHV=HOCVIEN.MAHV
			group by MALOP, KETQUATHI.MAHV
		) as A
		group by A.MALOP
	)
	as B
	where B.MALOP=LOP.MALOP
	and B.DiemCaoTungLop=KETQUATHI.DIEM
)