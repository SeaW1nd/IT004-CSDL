--Đề thi thực hành 1

--Câu 1:
create database QLTTCB
use QLTTCB

create table ToBay (
	MaTB int not null,
	TenTB varchar(50),
	NgayTL smalldatetime,
	ThongTin varchar(100),
	MaNV int
)

create table NhanVien (
	MaNV int not null,
	HoTen varchar(50),
	Email varchar(50),
	SDT varchar(20),
	DChi varchar(100),
	NgayVL smalldatetime,
	Luong money,
	ChucVu varchar(50),
	MaTB int
)

create table MayBay (
	MaMB int not null,
	TenMB varchar(50),
	LoaiMB varchar(50),
	SucChua int,
	ThongTin varchar(100)
)

create table ChuyenBay (
	MaCB int not null,
	DiemDi varchar(50),
	DiemDen varchar(50),
	KhoiHanh smalldatetime,
	HaCanh smalldatetime
)

create table LichBay (
	MaTB int not null,
	MaCB int not null,
	MaMB int
)

alter table ToBay add constraint PK_ToBay primary key (MaTB)
alter table NhanVien add constraint PK_NhanVien primary key (MaNV)
alter table MayBay add constraint PK_MayBay primary key (MaMB)
alter table ChuyenBay add constraint PK_ChuyenBay primary key (MaCB)
alter table LichBay add constraint PK_LichBay primary key (MaTB,MaCB)

alter table ToBay add constraint FK_ToBay_NhanVien foreign key (MaNV) references NhanVien(MaNV)
alter table NhanVien add constraint FK_NhanVien_ToBay foreign key (MaTB) references ToBay(MaTB)
alter table LichBay add constraint FK_LichBay_MayBay foreign key (MaMB) references MayBay(MaMB)
alter table LichBay add constraint FK_LichBay_ToBay foreign key (MaTB) references ToBay(MaTB)
alter table LichBay add constraint FK_LichBay_ChuyenBay foreign key (MaCB) references ChuyenBay(MaCB)
--Câu 2:
--2.1:
alter table NhanVien add constraint Check_ChucVu check (ChucVu='phi công trưởng' or ChucVu='phi công phụ' or ChucVu='tiếp viên hàng không')
--2.2:
go
create trigger NhanVien_insert
on NhanVien
after insert
as 
	declare @NgayVaoLam smalldatetime, @NgayThanhLap smalldatetime
	declare @MaToBay int
	select @NgayVaoLam=inserted.NgayVL, @MaToBay=inserted.MaTB
	from inserted
	select @NgayThanhLap=ToBay.NgayTL
	from ToBay
	where MaTB=@MaToBay
	if @NgayVaoLam > @NgayThanhLap
	begin
		print'Loi. Ngay vao lam cua nhan vien phai nho hon hoac bang ngay thanh lap cua to bay dang cong tac'
		rollback transaction
	end
go

--Câu 3:
--3.1:
select NhanVien.MaNV, HoTen
from NhanVien
join ToBay on ToBay.MaTB=NhanVien.MaTB
where TenTB='Vietnam Airline 1'
and Luong > 20000000
--3.2:
select A.MaTB, ToBay.TenTB, A.LuongCaoNhatToBay from (
	select MaTB, max(Luong) as LuongCaoNhatToBay
	from NhanVien
	group by MaTB
)
as A
right join ToBay on ToBay.MaTB=A.MaTB

--3.3:
select MaNV, HoTen
from NhanVien
where not exists (
	select * from ChuyenBay
	where year(KhoiHanh)=2023
	and not exists (
		select * from LichBay
		join ToBay on LichBay.MaTB=ToBay.MaTB
		where ToBay.MaTB=NhanVien.MaTB
		and LichBay.MaCB=ChuyenBay.MaCB
		)
	)
	