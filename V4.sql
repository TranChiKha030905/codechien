
CREATE TABLE Users (
  UserID INT PRIMARY KEY AUTO_INCREMENT,  -- ID người dùng, tự động tăng
  Username VARCHAR(50) NOT NULL UNIQUE,   -- Tên đăng nhập (duy nhất, không rỗng)
  PasswordHash VARCHAR(255) NOT NULL,     -- Mật khẩu đã mã hóa
  Email VARCHAR(100) NOT NULL UNIQUE,     -- Email người dùng (duy nhất)
  FullName VARCHAR(100) NOT NULL,         -- Họ và tên đầy đủ
  RoleName ENUM('Admin', 'Doctor', 'User') NOT NULL, -- Vai trò của người dùng (Admin, Doctor, User)
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP -- Ngày tạo tài khoản
);
insert into Users 
value( 
);

-- BẢNG 2: ChildProfiles - Quản lý hồ sơ trẻ em
CREATE TABLE ChildProfiles (
  ChildID INT PRIMARY KEY AUTO_INCREMENT,  -- ID hồ sơ trẻ, tự động tăng
  UserID INT NOT NULL,                      -- Chủ sở hữu hồ sơ này (người dùng)
  ChildName VARCHAR(100) NOT NULL,         -- Tên trẻ
  DateOfBirth DATE NOT NULL,               -- Ngày sinh
  Gender ENUM('Male', 'Female') NOT NULL,  -- Giới tính của trẻ
  HeightCm DECIMAL(5,2),                   -- Chiều cao (cm)
  WeightKg DECIMAL(5,2),                   -- Cân nặng (kg)
  BMI DECIMAL(4,2),                        -- Chỉ số BMI
  FOREIGN KEY (UserID) REFERENCES Users(UserID) -- Liên kết với Users để biết hồ sơ này thuộc về ai
);

-- BẢNG 3: Memberships - Quản lý gói thành viên & thanh toán
CREATE TABLE Memberships (
  MembershipID INT PRIMARY KEY AUTO_INCREMENT, -- ID gói thành viên, tự động tăng
  UserID INT NOT NULL UNIQUE,                  -- ID người dùng sở hữu gói này
  MembershipType ENUM('Basic', 'Premium') NOT NULL, -- Loại gói thành viên
  Price DECIMAL(10,2) NOT NULL,                -- Giá tiền của gói
  StartDate DATE NOT NULL,                     -- Ngày bắt đầu
  EndDate DATE NOT NULL,                       -- Ngày hết hạn
  PaymentMethod VARCHAR(50) NOT NULL,          -- Phương thức thanh toán
  TransactionStatus ENUM('Success', 'Failed') NOT NULL, -- Trạng thái thanh toán
  FOREIGN KEY (UserID) REFERENCES Users(UserID) -- Liên kết với Users
);

-- BẢNG 4: Alerts - Quản lý cảnh báo sức khỏe của trẻ
CREATE TABLE Alerts (
  AlertID INT PRIMARY KEY AUTO_INCREMENT, -- ID cảnh báo, tự động tăng
  ChildID INT NOT NULL,                   -- Hồ sơ trẻ nhận cảnh báo
  AlertType VARCHAR(50) NOT NULL,         -- Loại cảnh báo (Sốt, Dị ứng, ...)
  Description TEXT NOT NULL,              -- Mô tả chi tiết
  AlertDate DATETIME DEFAULT CURRENT_TIMESTAMP, -- Ngày tạo cảnh báo
  FOREIGN KEY (ChildID) REFERENCES ChildProfiles(ChildID) -- Liên kết với ChildProfiles
);

-- BẢNG 5: Consultations - Quản lý tư vấn giữa người dùng và bác sĩ
CREATE TABLE Consultations (
  ConsultationID INT PRIMARY KEY AUTO_INCREMENT,  -- ID tư vấn, tự động tăng
  UserID INT NOT NULL,                            -- Người yêu cầu tư vấn
  DoctorID INT NOT NULL,                          -- Bác sĩ tư vấn
  ChildID INT NOT NULL,                           -- Hồ sơ trẻ liên quan
  RequestDate DATETIME DEFAULT CURRENT_TIMESTAMP, -- Ngày yêu cầu tư vấn
  Message TEXT NOT NULL,                          -- Nội dung tư vấn
  Status ENUM('Pending', 'Completed') DEFAULT 'Pending', -- Trạng thái tư vấn
  FeedbackText TEXT,                              -- Nội dung phản hồi từ user
  FeedbackCreatedAt DATETIME,                     -- Thời gian phản hồi
  FOREIGN KEY (UserID) REFERENCES Users(UserID),
  FOREIGN KEY (DoctorID) REFERENCES Users(UserID),
  FOREIGN KEY (ChildID) REFERENCES ChildProfiles(ChildID)
);

-- BẢNG 6: Reports - Quản lý báo cáo & dashboard
CREATE TABLE Reports (
  ReportID INT PRIMARY KEY AUTO_INCREMENT,    -- ID báo cáo, tự động tăng
  ReportName VARCHAR(100) NOT NULL,           -- Tên báo cáo
  Description TEXT,                           -- Mô tả báo cáo
  GeneratedAt DATETIME DEFAULT CURRENT_TIMESTAMP, -- Ngày tạo báo cáo
  GeneratedByUserID INT NOT NULL,             -- Người tạo báo cáo (Admin)
  ReportData JSON,                            -- Dữ liệu thống kê dạng JSON
  FOREIGN KEY (GeneratedByUserID) REFERENCES Users(UserID) -- Liên kết với Users
);

-- BẢNG 7: ContentPosts - Quản lý Blog & FAQ
CREATE TABLE ContentPosts (
  PostID INT PRIMARY KEY AUTO_INCREMENT,  -- ID bài viết, tự động tăng
  Title VARCHAR(255) NOT NULL,            -- Tiêu đề bài viết
  Content TEXT NOT NULL,                  -- Nội dung bài viết
  PostType ENUM('Blog', 'FAQ') NOT NULL,  -- Loại bài (Blog hoặc FAQ)
  AuthorID INT,                            -- Người viết bài (nếu có)
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP, -- Ngày tạo bài viết
  FOREIGN KEY (AuthorID) REFERENCES Users(UserID) -- Liên kết với Users (Admin viết bài)
);