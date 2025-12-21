package com.ecommerce.ecommercebackend;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestMySQLConnection {
    public static void main(String[] args) {
        String url = "jdbc:mysql://192.168.56.132:3306/ecommerce_db?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true";
        String username = "root";
        String password = "tosennanoda";

        if (args.length >= 1 && args[0] != null && !args[0].trim().isEmpty()) {
            url = args[0].trim();
        }
        if (args.length >= 2 && args[1] != null && !args[1].trim().isEmpty()) {
            username = args[1].trim();
        }
        if (args.length >= 3 && args[2] != null && !args[2].trim().isEmpty()) {
            password = args[2];
        }
        
        System.out.println("=== Testing MySQL Connection ===");
        System.out.println("URL: " + url);
        System.out.println("Username: " + username);
        System.out.println();
        
        try {
            System.out.println("Loading MySQL JDBC Driver...");
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver loaded successfully!");
            
            System.out.println("\nAttempting to connect to MySQL...");
            Connection conn = DriverManager.getConnection(url, username, password);
            System.out.println("Connection successful!");
            
            System.out.println("\nExecuting test query...");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT 1 as test, DATABASE() as current_db");
            
            if (rs.next()) {
                System.out.println("Test query result: " + rs.getInt("test"));
                System.out.println("Current database: " + rs.getString("current_db"));
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
            System.out.println("\n=== SUCCESS: MySQL connection is working! ===");
            System.exit(0);
            
        } catch (Exception e) {
            System.err.println("\n=== ERROR: MySQL connection failed! ===");
            System.err.println("Error type: " + e.getClass().getName());
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
