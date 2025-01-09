/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import classes.JDBC;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author rafly
 */
@WebServlet("/editFilmServlet")
public class EditFilmServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Ambil parameter dan validasi
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new IllegalArgumentException("ID Film tidak boleh kosong.");
            }
            int id = Integer.parseInt(idParam);

            // Ambil data lainnya (opsional)
            String judul = request.getParameter("judul");
            String deskripsi = request.getParameter("deskripsi");
            String cast = request.getParameter("cast");
            String sutradara = request.getParameter("sutradara");
            int duration = request.getParameter("duration") != null && !request.getParameter("duration").isEmpty()
                ? Integer.parseInt(request.getParameter("duration"))
                : 0;
            double rating = request.getParameter("rating") != null && !request.getParameter("rating").isEmpty()
                ? Double.parseDouble(request.getParameter("rating"))
                : 0.0;
            String kategori = request.getParameter("kategori");
            String genre = request.getParameter("genre");

            // Panggil metode editFilm
            JDBC jdbc = new JDBC();
            boolean success = jdbc.editFilm(id, judul, deskripsi, cast, sutradara, duration, rating, kategori, genre);

            if (success) {
                response.sendRedirect("indexAdmin.jsp");
            } else {
                response.getWriter().println("Gagal mengedit film. Pastikan data benar dan coba lagi.");
            }
        } catch (IllegalArgumentException e) {
            response.getWriter().println("Terjadi kesalahan: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Terjadi kesalahan: " + e.getMessage());
        }
    }
}

