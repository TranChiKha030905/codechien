CREATE DATABASE chidren_V2;
drop database chidren_v2;

USE chidren_V2;


--  NHÓM 1: QUẢN LÝ NGƯỜI DÙNG
--  Mđ: Quản lý tài khoản & vai trò của người dùng.
-- Lấy từ Data: "Đăng ký tài khoản, lựa chọn gói thành viên, ..."

CREATE TABLE Roles (
  RoleID INT PRIMARY KEY AUTO_INCREMENT,  -- ID vai trò, tự động tăng, duy nhất
  RoleName VARCHAR(50) NOT NULL           -- Tên vai trò (Admin, User, Doctor)
);

INSERT IGNORE INTO Roles (RoleName)
VALUES
    ("Admin"),
    ("Doctor"),
    ("User");
select *from Roles;

CREATE TABLE Users (
  UserID INT PRIMARY KEY AUTO_INCREMENT,  -- ID người dùng, tự động tăng, duy nhất
  Username VARCHAR(50) NOT NULL UNIQUE,   -- Tên đăng nhập, không trùng lặp
  PasswordHash VARCHAR(255) NOT NULL,     -- Mật khẩu đã mã hóa
  Email VARCHAR(100) NOT NULL UNIQUE,     -- Email, không trùng
  FullName VARCHAR(100) NOT NULL,         -- Họ và tên đầy đủ
  RoleID INT NOT NULL,                    -- Vai trò của user (Admin, User, Doctor)
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP, -- Ngày tạo tài khoản
  FOREIGN KEY (RoleID) REFERENCES Roles(RoleID) -- Liên kết với Roles để biết user thuộc vai trò nào
);

INSERT IGNORE INTO Users (Username, PasswordHash, Email, FullName, RoleID)
VALUES
    ('admin123', 'hashed_password_1', 'admin@example.com', 'Admin User', 1),
    ('doctor1', 'hashed_password_2', 'doctor1@example.com', 'Dr. John Doe', 2),
    ('user_01', 'hashed_password_3', 'user01@example.com', 'Alice Nguyen', 3),
    ('user_02', 'hashed_password_4', 'user02@example.com', 'Bob Tran', 3),
    ('doctor2', 'hashed_password_5', 'doctor2@example.com', 'Dr. Emily Smith', 3);
select *From Users;

--  NHÓM 2: GÓI THÀNH VIÊN & THANH TOÁN
--  Mđ: Quản lý gói thành viên và giao dịch thanh toán
-- Lấy Data: "Khai báo các gói phí thành viên sử dụng hệ thống."

drop table Memberships;
CREATE TABLE Memberships (
  MembershipID INT PRIMARY KEY AUTO_INCREMENT,  -- ID gói thành viên, tự động tăng, duy nhất
  UserID INT NOT NULL UNIQUE,                  -- Người dùng sở hữu gói này|
  MembershipType VARCHAR(50) NOT NULL,          -- Loại gói (Basic, Premium)
  Price DECIMAL(10,2) NOT NULL,                 -- Giá tiền của gói
  StartDate DATE NOT NULL,                      -- Ngày bắt đầu gói thành viên
  EndDate DATE NOT NULL,                        -- Ngày hết hạn
  FOREIGN KEY (UserID) REFERENCES Users(UserID) -- Liên kết với Users để biết ai đăng ký gói này
);

INSERT IGNORE INTO Memberships (UserID, MembershipType, Price, StartDate, EndDate)
VALUES
    (1, 'Basic', 9.99, '2025-03-01', '2025-04-01'),
    (2, 'Premium', 19.99, '2025-03-05', '2025-06-05'),
    (3, 'Basic', 9.99, '2025-03-10', '2025-04-10'),
    (4, 'Premium', 19.99, '2025-02-20', '2025-05-20'),
    (5, 'Basic', 9.99, '2025-03-15', '2025-04-11');
select *From Memberships;

Drop table PaymentTransactions;
CREATE TABLE PaymentTransactions (
  TransactionID INT PRIMARY KEY AUTO_INCREMENT,                    -- ID giao dịch, tự động tăng, duy nhất
  UserID INT NOT NULL UNIQUE,                                      -- Người thực hiện thanh toán
  MembershipID INT NOT NULL,                                       -- Gói thành viên được thanh toán
  PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,                  -- Ngày thanh toán
  Amount DECIMAL(10,2) NOT NULL,                                   -- Số tiền thanh toán
  PaymentMethod VARCHAR(50) NOT NULL,                              -- Phương thức thanh toán
  TransactionStatus ENUM('Success', 'Failed') NOT NULL,            -- Trạng thái giao dịch
  FOREIGN KEY (UserID) REFERENCES Users(UserID),                   -- Liên kết với Users để biết ai thực hiện giao dịch này
  FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID)  -- Liên kết với Memberships để biết thanh toán cho gói nào
);

INSERT INTO PaymentTransactions (UserID, MembershipID, Amount, PaymentMethod, TransactionStatus)
VALUES
    (1, 1, 9.99, 'Momo', 'Success'),
    (2, 2, 19.99, 'Visa', 'Success'),
    (3, 3, 9.99, 'Bank App', 'Failed'),
    (4, 4, 19.99, 'Momo', 'Success'),
    (5, 5, 9.99, 'payPal', 'Success');
select *From PaymentTransactions;

-- NHÓM 3: HỒ SƠ TRẺ EM & SỨC KHỎE
-- Mđ: Quản lý thông tin trẻ em và tình trạng sức khỏe theo thời gian.
-- Lấy Data: "Chức năng cho phép thành viên cập nhật các chỉ số thông tin tăng trưởng quan trọng..."

CREATE TABLE ChildProfiles (
  ChildID INT PRIMARY KEY AUTO_INCREMENT,  -- ID hồ sơ trẻ, tự động tăng, duy nhất
  UserID INT NOT NULL UNIQUE,              -- Chủ sở hữu hồ sơ này (người dùng)
  ChildName VARCHAR(100) NOT NULL,         -- Tên trẻ
  DateOfBirth DATE NOT NULL,               -- Ngày sinh
  Gender ENUM('Male', 'Female') NOT NULL,  -- Giới tính của trẻ
  FOREIGN KEY (UserID) REFERENCES Users(UserID) -- Liên kết với Users để biết hồ sơ này thuộc về ai
);

INSERT INTO ChildProfiles (UserID, ChildName, DateOfBirth, Gender)
VALUES
    (1, 'Đồng Huy vũ ', '2025-06-12', 'Male'),
    (2, 'Trần Bảo', '2018-09-25', 'Male'),
    (3, 'Lê Cẩm Tú', '2016-03-07', 'Female'),
    (4, 'Hoàng Minh', '2017-12-30', 'Male'),
    (5, 'Phạm Ngọc Anh', '2019-05-20', 'Female');
select *From ChildProfiles;

CREATE TABLE GrowthRecords (
  RecordID INT PRIMARY KEY AUTO_INCREMENT, -- ID ghi nhận tăng trưởng, tự động tăng, duy nhất
  ChildID INT NOT NULL UNIQUE,             -- Hồ sơ trẻ cần ghi nhận
  RecordDate DATE NOT NULL,                -- tạo ngày              
  HeightCm DECIMAL(5,2) NOT NULL,          -- cao
  WeightKg DECIMAL(5,2) NOT NULL,          -- nặng 
  BMI DECIMAL(4,2) NOT NULL,               -- chỉ số độ mập 
  FOREIGN KEY (ChildID) REFERENCES ChildProfiles(ChildID) -- Liên kết với hồ sơ trẻ cần ghi nhận
);
INSERT INTO GrowthRecords (ChildID, RecordDate, HeightCm, WeightKg, BMI)
VALUES
    (1, '2025-03-01', 120.5, 25.3, 17.4),
    (2, '2025-03-02', 110.2, 22.8, 18.7),
    (3, '2025-03-03', 115.0, 24.5, 18.5),
    (4, '2025-03-04', 118.7, 26.1, 18.6),
    (5, '2025-03-05', 105.3, 20.2, 18.3);
select *From GrowthRecords;

CREATE TABLE Alerts (
  AlertID INT PRIMARY KEY AUTO_INCREMENT, -- ID cảnh báo, tự động tăng, duy nhất
  ChildID INT NOT NULL UNIQUE,             -- Hồ sơ trẻ cần ghi nhận
  AlertType VARCHAR(50) NOT NULL,         -- Cảnh báo ví dụ như tiêu cảy 
  Description TEXT NOT NULL,              -- Miêu tả 
  AlertDate DATETIME DEFAULT CURRENT_TIMESTAMP, -- ngày tạo 
  FOREIGN KEY (ChildID) REFERENCES ChildProfiles(ChildID) -- conect 
);
INSERT INTO Alerts (ChildID, AlertType, Description)
VALUES
    (1, 'Sốt', 'Trẻ bị sốt cao 39°C vào buổi tối.'),
    (2, 'Tiêu chảy', 'Trẻ đi ngoài nhiều lần trong ngày.'),
    (3, 'Ho dai dẳng', 'Trẻ bị ho kéo dài hơn 3 ngày.'),
    (4, 'Phát ban', 'Xuất hiện mẩn đỏ trên da, có thể dị ứng.'),
    (5, 'Nôn ói', 'Trẻ nôn nhiều sau khi ăn, cần theo dõi.');
select * from Alerts;

--  NHÓM 4: TƯ VẤN & PHẢN HỒI
-- MĐ: Quản lý tư vấn giữa người dùng và bác sĩ, phản hồi từ khách hàng.
-- Lấy Data: "Hệ thống cho phép thành viên chia sẻ biểu đồ tăng trưởng..."

drop table Consultations;
CREATE TABLE Consultations (
  ConsultationID INT PRIMARY KEY AUTO_INCREMENT,          -- ID mã bữa tự vấn 
  UserID INT NOT NULL ,                             -- Chủ sở hữu hồ sơ này (người dùng)
  DoctorID INT NOT NULL ,                                  -- bác sĩ tư vấn 
  ChildID INT NOT NULL ,                            -- Hồ sơ trẻ cần ghi nhận
  RequestDate DATETIME DEFAULT CURRENT_TIMESTAMP,         -- ngày tư vấn 
  Message TEXT NOT NULL,                                  -- nd bữa tư vấn check
  Status ENUM('Pending', 'Completed') DEFAULT 'Pending',  -- trạng thái 
  FOREIGN KEY (UserID) REFERENCES Users(UserID),          
  FOREIGN KEY (DoctorID) REFERENCES Users(UserID), 
  FOREIGN KEY (ChildID) REFERENCES ChildProfiles(ChildID) 
);
INSERT INTO Consultations (UserID, DoctorID, ChildID, Message, Status)
VALUES
    (4, 4, 1, 'Bé bị sốt cao 39°C, cần tư vấn cách hạ sốt.', 'Pending'),
    (5, 3, 2, 'Bé ho kéo dài hơn 3 ngày, cần tư vấn thuốc ho.', 'Completed'),
    (4, 2, 4, 'Bé có dấu hiệu dị ứng, nổi mẩn đỏ.', 'Pending'),
    (4, 5, 4, 'Bé có dấu hiệu dị ứng, nổi mẩn đỏ.', 'Pending');
select * from Consultations;

CREATE TABLE Feedbacks (
  FeedbackID INT PRIMARY KEY AUTO_INCREMENT,  -- ID bài góp ý kiến 
  UserID INT NOT NULL,                        -- ID người ý kiến 
  ConsultationID INT NOT NULL,                 -- Bữa đi khám có đó ý kiến 
  FeedbackText TEXT NOT NULL,                  -- nd ý kiến
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP, -- ngày tạo đơn ý kiến 
  FOREIGN KEY (UserID) REFERENCES Users(UserID), -- kết nối ID các bản 
  FOREIGN KEY (ConsultationID) REFERENCES Consultations(ConsultationID) -- liên kết với bữa tư vấn 
);

INSERT INTO Feedbacks (UserID, ConsultationID, FeedbackText)
VALUES
    (4, 1, 'Bác sĩ tư vấn rất tận tình, tôi rất hài lòng.'),
    (5, 2, 'Buổi tư vấn giúp tôi hiểu rõ hơn về cách chăm sóc bé.'),
    (4, 3, 'Cần thêm hướng dẫn chi tiết hơn về chế độ ăn cho bé.'),
    (5, 4, 'Bác sĩ tư vấn tốt, nhưng thời gian hơi ngắn.'),
    (4, 5, 'Tôi mong muốn có thêm nhiều tư vấn miễn phí.');
SELECT * FROM Feedbacks;

-- NHÓM 6: DASHBOARD & REPORTS
-- Mục đích: Lưu trữ dữ liệu thống kê phục vụ Dashboard & Report.
-- Lấy Data: "Dashboard & Report."

drop table reports;
CREATE TABLE Reports (
  ReportID INT PRIMARY KEY AUTO_INCREMENT,              -- ID báo cáo
  ReportName VARCHAR(100) NOT NULL,                     -- Tên báo cáo
  Description TEXT,                                     -- Mô tả nội dung báo cáo
  GeneratedAt DATETIME DEFAULT CURRENT_TIMESTAMP,       -- Time  tạo báo cáo
  GeneratedByUserID INT NOT NULL,                                -- Người tạo báo cáo (Admin)
  ReportData JSON,                                      -- Dữ liệu thống kê dạng JSON
  FOREIGN KEY (GeneratedByUserID) REFERENCES Users(UserID) -- Lấy data người báo cáo 
);

INSERT INTO Reports (ReportName, Description, GeneratedByUserID, ReportData)
VALUES
    ('Báo cáo tư vấn tháng 3', 'Thống kê số lượng tư vấn trong tháng 3.', 1, 
        JSON_OBJECT('total_consultations', 50, 'pending', 10, 'completed', 40)),
    
    ('Báo cáo phản hồi khách hàng', 'Phân tích phản hồi từ người dùng.', 1, 
        JSON_OBJECT('positive_feedback', 30, 'neutral_feedback', 15, 'negative_feedback', 5)),
    
    ('Báo cáo hoạt động bác sĩ', 'Số lượng tư vấn mà mỗi bác sĩ thực hiện.', 1, 
        JSON_OBJECT('doctor1', 20, 'doctor2', 15, 'doctor3', 10)),

    ('Báo cáo tài chính', 'Tổng doanh thu từ các gói thành viên.', 1, 
        JSON_OBJECT('total_revenue', 5000, 'basic_memberships', 200, 'premium_memberships', 150)),

    ('Báo cáo tổng hợp tháng', 'Dữ liệu tổng hợp hoạt động trong tháng.', 1, 
        JSON_OBJECT('new_users', 120, 'active_users', 300, 'canceled_memberships', 10));

SELECT * FROM Reports;