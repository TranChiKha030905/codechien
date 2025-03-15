package Entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Entity
@Table(name = "ChildProfiles")
@Data
@NoArgsConstructor
@AllArgsConstructor

public class ChildProfiles {
    @Id //  Khóa chính
    @GeneratedValue(strategy = GenerationType.IDENTITY) //  Tự tăng, giống AUTO_INCREMENT
    @Column(name = "ChildID") //  Nối với cột "ChildID"
    private int childId; //  kiểu số nguyên

    @Column(name = "ChildName", nullable = false, length = 100) // có note mẫu bên kia
    private String childName; // kiểu chuỗi chữ

    @Column(name = "DateOfBirth", nullable = false)
    private LocalDate dateOfBirth; // cái này nóp khác cái kia là k có cả giờ phút s

    @Enumerated(EnumType.STRING) //  cơ chế giống bên kia
    @Column(name = "Gender", nullable = false) //  Nối với "Gender",
    private Gender gender; //

    @Column(name = "HeightCm", columnDefinition = "DECIMAL(5,2)") // Giống với SQL 5 số sau đó được 2 số sau dấu chấm
    private Double heightCm; //  Lưu số thực

    @Column(name = "WeightKg", columnDefinition = "DECIMAL(5,2)")
    private Double weightKg; //

    @Column(name = "BMI", columnDefinition = "DECIMAL(4,2)") //
    private Double bmi; // số thực

    // Quan hệ: ManyToOne
    @ManyToOne // Giống như kiểu 1 gđ có nhiều trẻ
    @JoinColumn(name = "UserID", nullable = false) // Tham chiếu đến cột users
    private Users user;

    public enum Gender { // Giống ở bên Users tự qua xem
        Male, Female
    }
}