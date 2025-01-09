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
@WebServlet("/addFilmServlet")
public class AddFilmServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String judul = request.getParameter("judul");
        String deskripsi = request.getParameter("deskripsi");
        String cast = request.getParameter("cast");
        String sutradara = request.getParameter("sutradara");
        int duration = Integer.parseInt(request.getParameter("duration"));
        double rating = Double.parseDouble(request.getParameter("rating"));
        String kategori = request.getParameter("kategori");
        String genre = request.getParameter("genre");

        JDBC jdbc = new JDBC();
        boolean success = jdbc.addFilm(judul, deskripsi, cast, sutradara, duration, rating, kategori, genre);

        if (success) {
            response.sendRedirect("indexAdmin.jsp"); 
            response.getWriter().println("Gagal menambahkan film. Silakan coba lagi.");
        }
    }
}

