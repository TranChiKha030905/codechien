CREATE DATABASE chidren_V2;

USE chidren_V2;


--  NHÓM 1: QUẢN LÝ NGƯỜI DÙNG
--  Mđ: Quản lý tài khoản & vai trò của người dùng.
-- Lấy từ Data: "Đăng ký tài khoản, lựa chọn gói thành viên, ..."

CREATE TABLE Roles (
  RoleID INT PRIMARY KEY AUTO_INCREMENT,  -- ID vai trò, tự động tăng, duy nhất
  RoleName VARCHAR(50) NOT NULL           -- Tên vai trò (Admin, User, Doctor)
);

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


--  NHÓM 2: GÓI THÀNH VIÊN & THANH TOÁN
--  Mđ: Quản lý gói thành viên và giao dịch thanh toán
-- Lấy Data: "Khai báo các gói phí thành viên sử dụng hệ thống."

CREATE TABLE Memberships (
  MembershipID INT PRIMARY KEY AUTO_INCREMENT,  -- ID gói thành viên, tự động tăng, duy nhất
  UserID INT NOT NULL,                          -- Người dùng sở hữu gói này
  MembershipType VARCHAR(50) NOT NULL,          -- Loại gói (Basic, Premium)
  Price DECIMAL(10,2) NOT NULL,                 -- Giá tiền của gói
  StartDate DATE NOT NULL,                      -- Ngày bắt đầu gói thành viên
  EndDate DATE NOT NULL,                        -- Ngày hết hạn
  FOREIGN KEY (UserID) REFERENCES Users(UserID) -- Liên kết với Users để biết ai đăng ký gói này
);

CREATE TABLE PaymentTransactions (
  TransactionID INT PRIMARY KEY AUTO_INCREMENT, -- ID giao dịch, tự động tăng, duy nhất
  UserID INT NOT NULL,                          -- Người thực hiện thanh toán
  MembershipID INT NOT NULL,                    -- Gói thành viên được thanh toán
  PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP, -- Ngày thanh toán
  Amount DECIMAL(10,2) NOT NULL,                -- Số tiền thanh toán
  PaymentMethod VARCHAR(50) NOT NULL,           -- Phương thức thanh toán
  TransactionStatus ENUM('Success', 'Failed', 'Pending') NOT NULL, -- Trạng thái giao dịch
  FOREIGN KEY (UserID) REFERENCES Users(UserID), -- Liên kết với Users để biết ai thực hiện giao dịch này
  FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID) -- Liên kết với Memberships để biết thanh toán cho gói nào
);

-- NHÓM 3: HỒ SƠ TRẺ EM & SỨC KHỎE
-- Mđ: Quản lý thông tin trẻ em và tình trạng sức khỏe theo thời gian.
-- Lấy Data: "Chức năng cho phép thành viên cập nhật các chỉ số thông tin tăng trưởng quan trọng..."

CREATE TABLE ChildProfiles (
  ChildID INT PRIMARY KEY AUTO_INCREMENT,  -- ID hồ sơ trẻ, tự động tăng, duy nhất
  UserID INT NOT NULL,                     -- Chủ sở hữu hồ sơ này (người dùng)
  ChildName VARCHAR(100) NOT NULL,         -- Tên trẻ
  DateOfBirth DATE NOT NULL,               -- Ngày sinh
  Gender ENUM('Male', 'Female') NOT NULL,  -- Giới tính của trẻ
  FOREIGN KEY (UserID) REFERENCES Users(UserID) -- Liên kết với Users để biết hồ sơ này thuộc về ai
);

CREATE TABLE GrowthRecords (
  RecordID INT PRIMARY KEY AUTO_INCREMENT, -- ID ghi nhận tăng trưởng, tự động tăng, duy nhất
  ChildID INT NOT NULL,                    -- Hồ sơ trẻ cần ghi nhận
  RecordDate DATE NOT NULL,                
  HeightCm DECIMAL(5,2) NOT NULL,          
  WeightKg DECIMAL(5,2) NOT NULL,          
  BMI DECIMAL(4,2) NOT NULL,               
  FOREIGN KEY (ChildID) REFERENCES ChildProfiles(ChildID) -- Liên kết với hồ sơ trẻ cần ghi nhận
);

CREATE TABLE Alerts (
  AlertID INT PRIMARY KEY AUTO_INCREMENT, -- ID cảnh báo, tự động tăng, duy nhất
  ChildID INT NOT NULL,                   
  AlertType VARCHAR(50) NOT NULL,         
  Description TEXT NOT NULL,              
  AlertDate DATETIME DEFAULT CURRENT_TIMESTAMP, 
  FOREIGN KEY (ChildID) REFERENCES ChildProfiles(ChildID) 
);

--  NHÓM 4: TƯ VẤN & PHẢN HỒI
-- MĐ: Quản lý tư vấn giữa người dùng và bác sĩ, phản hồi từ khách hàng.
-- Lấy Data: "Hệ thống cho phép thành viên chia sẻ biểu đồ tăng trưởng..."

CREATE TABLE Consultations (
  ConsultationID INT PRIMARY KEY AUTO_INCREMENT, 
  UserID INT NOT NULL,                           
  DoctorID INT NOT NULL,                         
  ChildID INT NOT NULL,                          
  RequestDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  Message TEXT NOT NULL,                         
  Status ENUM('Pending', 'Completed') DEFAULT 'Pending', 
  FOREIGN KEY (UserID) REFERENCES Users(UserID), 
  FOREIGN KEY (DoctorID) REFERENCES Users(UserID), 
  FOREIGN KEY (ChildID) REFERENCES ChildProfiles(ChildID) 
);

CREATE TABLE Feedbacks (
  FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
  UserID INT NOT NULL,
  ConsultationID INT NOT NULL,
  FeedbackText TEXT NOT NULL,
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (UserID) REFERENCES Users(UserID),
  FOREIGN KEY (ConsultationID) REFERENCES Consultations(ConsultationID)
);

-- =========================
-- NHÓM 6: DASHBOARD & REPORTS
-- Mục đích: Lưu trữ dữ liệu thống kê phục vụ Dashboard & Report.
-- Lấy Data: "Dashboard & Report."

CREATE TABLE Reports (
  ReportID INT PRIMARY KEY AUTO_INCREMENT,  
  ReportName VARCHAR(100) NOT NULL,         
  Description TEXT,                          
  GeneratedAt DATETIME DEFAULT CURRENT_TIMESTAMP,  
  GeneratedByUserID INT,                     
  ReportData JSON,                           
  FOREIGN KEY (GeneratedByUserID) REFERENCES Users(UserID) 
);
