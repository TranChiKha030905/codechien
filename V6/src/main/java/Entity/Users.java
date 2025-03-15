package Entity; // Chỉ ra là cái thư mục chứa cái users này

import jakarta.persistence.*; // nó tương được với 1 đám dòng  dưới : * = 1 đống
// import jakarta.persistence.Entity;           // Dùng cho @Entity
//import jakarta.persistence.Table;           // Dùng cho @Table
//import jakarta.persistence.Id;              // Dùng cho @Id
//import jakarta.persistence.GeneratedValue;  // Dùng cho @GeneratedValue
//import jakarta.persistence.GenerationType;  // Dùng cho GenerationType.IDENTITY
//import jakarta.persistence.Column;          // Dùng cho @Column
//import jakarta.persistence.Enumerated;      // Dùng cho @Enumerated
//import jakarta.persistence.EnumType;        // Dùng cho EnumType.STRING

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime; // Lấy time thời gian thực // nó khác với java.time.LocalDate thì nó thêm time giờ phút giây

@Entity  // Đánh dấu dây là 1 entity nó dùng để soi với cái sql nó đúng với cái bảng bên sql k
@Table(name = "Users")  // bảng tên là users

@Data // Annotation Lombok: Tự động tạo getter, setter, toString, equals, hashCode cho tất cả field.

@NoArgsConstructor // Annotation Lombok: Tạo constructor không tham số (yêu cầu bắt buộc của JPA).

@AllArgsConstructor // Annotation Lombok: Tạo constructor với tất cả tham số (tiện lợi khi khởi tạo đối tượng).

public class Users {  // Khai Báo bảng

    @Id   // = usersID SQL, Khai báo khóa chính
    //field = giống kiểu 1 hàng
    @GeneratedValue(strategy = GenerationType.IDENTITY)    // Tự động tăng giá trị  = AUTO_INCREMENT ; GenerationType.AUTO là 1 chức năng thích ứng vs các tường hợp các của bảng
    @Column(name = "UserID") // annotation của JPA/Hibernate, nó chỉ định rằng field userId sẽ ánh xạ với cột "UserID" trong bảng Users của database.
    private int id; // Có nhiệm vụ đi ánh xạ với bên cột bên SQL có đúng hay k?

    @Column(name = "Username", nullable = false, unique = true, length = 50)
    // comlumn chỉ đây à tới hàng có tên là Username có chức năng là được bỏ giống là nullable = falase là được bỏ trống còn true là bỏ trống được == các cái khác length là giống vachar đươc để ba nhiêu từ
    private String username;// Lưu giá trị để sử dụng 1. là in ra 2 là lưu vào database . lưu tạm thời

    @Column(name = "PasswordHash", nullable = false, length = 255)
    // comlumn chỉ là hàng mã hóa mật khẩu , // giống trên)
    private String passwordHash; //

    @Column(name = "Email", nullable = false, unique = true, length = 100)
    private String email;// giống trên

    @Column(name = "FullName", nullable = false, length = 100)
    private String fullName;// giống trên

    @Enumerated(EnumType.STRING)
    @Column(name = "RoleName", nullable = false)
    private Role roleName; // giống trên và nó còn liên kết với bảng dưới là enum ở bên sql vì nó cho phép lựa chọn 1 trong 3 vai trò tạo tk

    @Column(name = "CreatedAt", nullable = false, columnDefinition = "DATETIME DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime createdAt = LocalDateTime.now();;// code này cũng i chang cái trên thôi mà nó được cover thêm cái này DATETIME DEFAULT CURRENT_TIMESTAMP nó lấy time của thời gian thực nên phải import java.time.LocalDateTime

    // Quan hệ: ManyToOne

    public enum Role {// enum kiểu là 1 hàng hỗ trợ của hàng chính là rolename
        Admin, Doctor, User
    }

}
