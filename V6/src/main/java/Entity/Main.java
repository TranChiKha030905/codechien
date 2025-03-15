package Entity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import Entity.Users;
import Entity.ChildProfiles;

public class Main {
    public static void main(String[] args) {
        Users user = new Users(0, "Đạt ", "đạt123", "ledat222zz.com",
                "lê Thanh Đạt ", Users.Role.Admin, LocalDateTime.now());
        System.out.println("Username: " + user.getUsername());
        System.out.println("Email: " + user.getEmail());
        System.out.println("Full Name: " + user.getFullName());
        System.out.println("Role: " + user.getRoleName());
        System.out.println("Created At: " + user.getCreatedAt());

        ChildProfiles child = new ChildProfiles(0, "Vũ", LocalDate.of(2005, 11, 15),
                ChildProfiles.Gender.Male, 173.45, 50.5, 20.5, user);

        System.out.println("Child Profile Information:");
        System.out.println("Child ID: " + child.getChildId());
        System.out.println("Child Name: " + child.getChildName());
        System.out.println("Date of Birth: " + child.getDateOfBirth());
        System.out.println("Gender: " + child.getGender());
        System.out.println("Height (cm): " + child.getHeightCm());
        System.out.println("Weight (kg): " + child.getWeightKg());
        System.out.println("BMI: " + child.getBmi());
        System.out.println("User: " + child.getUser().getUsername());

     }
}