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
@WebServlet("/deleteFilmServlet")
public class DeleteFilmServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        JDBC jdbc = new JDBC();
        boolean success = jdbc.deleteFilm(id);

        if (success) {
            response.sendRedirect("indexAdmin.jsp"); 
        } else {
            response.getWriter().println("Gagal menghapus film. Silakan coba lagi.");
        }
    }
}

