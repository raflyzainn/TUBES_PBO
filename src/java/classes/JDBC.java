/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package classes;

import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author rafly
 */
public class JDBC {

    private Connection con;
    public Statement stmt;
    public boolean isConnected;
    public String message;

    public JDBC() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/tubes1_pbo", "root", "");
            stmt = con.createStatement();
            isConnected = true;
            message = "DB connected";
        } catch (Exception e) {
            isConnected = false;
            message = e.getMessage();
        }
        if (!isConnected) {
            System.err.println("Database connection failed: " + message);
        }

    }

    public void runQuery(String query) {
        try {
            int result = stmt.executeUpdate(query);
            message = "Info: " + result + " rows affected";
        } catch (SQLException e) {
            message = e.getMessage();
        }
    }

    public ResultSet runSelectQuery(String query) {
        try {
            return stmt.executeQuery(query);
        } catch (SQLException e) {
            message = e.getMessage();
            return null;
        }
    }

    public boolean signUp(String email, String username, String password, int umur, String asalNegara) {
        String query = "INSERT INTO Pengguna (email, username, password, umur, asal_negara, foto_profil_url) VALUES (?, ?, ?, ?, ?, NULL)";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, username);
            ps.setString(3, password); 
            ps.setInt(4, umur);
            ps.setString(5, asalNegara);

            int result = ps.executeUpdate();
            System.out.println("Insert success: " + result + " rows affected.");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("SignUp Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getReviewsByFilmId(int filmId) {
        List<Map<String, Object>> reviews = new ArrayList<>();
        String query = "SELECT * FROM ulasan WHERE film_id = ?";

        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, filmId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> review = new HashMap<>();
                    review.put("id", rs.getInt("id"));
                    review.put("rating", rs.getInt("rating"));
                    review.put("pesan", rs.getString("pesan"));
                    review.put("pengirim", rs.getString("pengirim"));
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public boolean submitReview(int rating, String pesan, String pengirim, int filmId) {
        String query = "INSERT INTO ulasan (rating, pesan, pengirim, film_id) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, rating);
            ps.setString(2, pesan);
            ps.setString(3, pengirim);
            ps.setInt(4, filmId);

            int result = ps.executeUpdate();
            System.out.println("Review submitted: " + result + " rows affected.");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error while submitting review: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Object> login(String username, String password) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);

        String query = "SELECT id, username, email FROM Pengguna WHERE username = ? AND password = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password); 

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result.put("success", true);
                result.put("userId", rs.getInt("id"));
                result.put("username", rs.getString("username"));
                result.put("email", rs.getString("email"));
            }
        } catch (SQLException e) {
            message = e.getMessage();
            System.err.println("Login error: " + e.getMessage());
        }
        return result;
    }

    public String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null; 
        }
    }

    public void disconnect() {
        try {
            if (stmt != null) {
                stmt.close();
            }
            if (con != null) {
                con.close();
            }
            message = "DB disconnected";
        } catch (SQLException e) {
            message = e.getMessage();
        }
    }

    public boolean addToWatchlist(int userId, int filmId) {
        String query = "INSERT INTO Watchlist (pengguna_id, film_id) VALUES (?, ?)";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, filmId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error adding to watchlist: " + e.getMessage());
            return false;
        }
    }

    public boolean removeFromWatchlist(int userId, int filmId) {
        String query = "DELETE FROM Watchlist WHERE pengguna_id = ? AND film_id = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, filmId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error removing from watchlist: " + e.getMessage());
            return false;
        }
    }

    public List<Map<String, Object>> getWatchlist(int userId) {
        List<Map<String, Object>> watchlist = new ArrayList<>();
        String query = """
        SELECT f.* 
        FROM Watchlist w 
        JOIN Film f ON w.film_id = f.id 
        WHERE w.pengguna_id = ?
    """;

        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> film = new HashMap<>();
                    film.put("id", rs.getInt("id"));
                    film.put("judul", rs.getString("judul"));
                    film.put("deskripsi", rs.getString("deskripsi"));
                    film.put("cast", rs.getString("cast"));
                    film.put("sutradara", rs.getString("sutradara"));
                    film.put("duration", rs.getInt("duration"));
                    film.put("rating", rs.getFloat("rating"));
                    film.put("kategori", rs.getString("kategori"));
                    film.put("genre", rs.getString("genre"));
                    watchlist.add(film);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching watchlist: " + e.getMessage());
        }
        return watchlist;
    }

    public boolean isInWatchlist(int userId, int filmId) {
        String query = "SELECT 1 FROM Watchlist WHERE pengguna_id = ? AND film_id = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, filmId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error checking watchlist: " + e.getMessage());
            return false;
        }
    }

    public Map<String, Object> getUserById(int userId) {
        Map<String, Object> user = new HashMap<>();
        String query = "SELECT id, username, email, umur, asal_negara FROM Pengguna WHERE id = ?";

        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user.put("id", rs.getInt("id"));
                user.put("username", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("umur", rs.getInt("umur"));
                user.put("asalNegara", rs.getString("asal_negara"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting user details: " + e.getMessage());
        }
        return user;
    }
    
    public Map<String, Object> getUserProfile(int userId) throws SQLException {
        Map<String, Object> userProfile = new HashMap<>();
        String query = "SELECT email, username, password, umur, asal_negara FROM pengguna WHERE id = ?";
        PreparedStatement preparedStatement = con.prepareStatement(query);
        preparedStatement.setInt(1, userId);
        ResultSet resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {
            userProfile.put("email", resultSet.getString("email"));
            userProfile.put("username", resultSet.getString("username"));
            userProfile.put("password", resultSet.getString("password"));
            userProfile.put("umur", resultSet.getInt("umur"));
            userProfile.put("asalNegara", resultSet.getString("asal_negara"));
        }
        resultSet.close();
        preparedStatement.close();
        return userProfile;
    }
    
    public boolean addFilm(String judul, String deskripsi, String cast, String sutradara, int duration, double rating, String kategori, String genre) {
        String query = "INSERT INTO Film (judul, deskripsi, cast, sutradara, duration, rating, kategori, genre) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, judul);
            ps.setString(2, deskripsi);
            ps.setString(3, cast);
            ps.setString(4, sutradara);
            ps.setInt(5, duration);
            ps.setDouble(6, rating);
            ps.setString(7, kategori);
            ps.setString(8, genre);

            int result = ps.executeUpdate();
            System.out.println("Film berhasil ditambahkan: " + result + " baris terpengaruh.");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error saat menambahkan film: " + e.getMessage());
            return false;
        }
    }
    
    public boolean editFilm(int id, String judul, String deskripsi, String cast, String sutradara, int duration, double rating, String kategori, String genre) {
        String query = "UPDATE Film SET judul = ?, deskripsi = ?, cast = ?, sutradara = ?, duration = ?, rating = ?, kategori = ?, genre = ? WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, judul);
            ps.setString(2, deskripsi);
            ps.setString(3, cast);
            ps.setString(4, sutradara);
            ps.setInt(5, duration);
            ps.setDouble(6, rating);
            ps.setString(7, kategori);
            ps.setString(8, genre);
            ps.setInt(9, id);

            int result = ps.executeUpdate();
            System.out.println("Film berhasil diperbarui: " + result + " baris terpengaruh.");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error saat memperbarui film: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteFilm(int id) {
        String query = "DELETE FROM Film WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, id);

            int result = ps.executeUpdate();
            System.out.println("Film berhasil dihapus: " + result + " baris terpengaruh.");
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error saat menghapus film: " + e.getMessage());
            return false;
        }
    }
    
    public Map<String, Object> getFilmById(int filmId) {
        Map<String, Object> film = new HashMap<>();
        String query = "SELECT * FROM Film WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, filmId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                film.put("id", rs.getInt("id"));
                film.put("judul", rs.getString("judul"));
                film.put("deskripsi", rs.getString("deskripsi"));
                film.put("cast", rs.getString("cast"));
                film.put("sutradara", rs.getString("sutradara"));
                film.put("duration", rs.getInt("duration"));
                film.put("rating", rs.getDouble("rating"));
                film.put("kategori", rs.getString("kategori"));
                film.put("genre", rs.getString("genre"));
            }
        } catch (SQLException e) {
            System.err.println("Error saat mendapatkan film: " + e.getMessage());
        }
        return film;
    }
    
    public List<Map<String, Object>> getAllFilms() {
        List<Map<String, Object>> films = new ArrayList<>();
        String query = "SELECT id, judul FROM Film WHERE id > 5";

        try (PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> film = new HashMap<>();
                film.put("id", rs.getInt("id"));
                film.put("judul", rs.getString("judul"));
                films.add(film);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching films: " + e.getMessage());
        }
        return films;
    }

    public Connection getConnection() {
        return this.con;
    }




}

