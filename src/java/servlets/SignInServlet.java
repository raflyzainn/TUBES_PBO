package servlets;

import classes.JDBC;
import java.io.IOException;
import java.util.Map;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/signin")
public class SignInServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        JDBC jdbc = new JDBC();
        Map<String, Object> loginResult = jdbc.login(username, password);
        
        if ((Boolean) loginResult.get("success")) {
            HttpSession session = request.getSession(true);
            
            session.setAttribute("userId", loginResult.get("userId"));
            session.setAttribute("username", loginResult.get("username"));
            session.setAttribute("email", loginResult.get("email"));
            session.setAttribute("isLoggedIn", true);
            
            session.setMaxInactiveInterval(30 * 60);
            
            if ("admin".equals(username) && "1234".equals(password)) {
                response.sendRedirect("indexAdmin.jsp");
            } else {
                response.sendRedirect("indexPengguna.jsp");
            }
        } else {
            request.setAttribute("error", "Username atau Password salah. Coba lagi.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("signIn.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate(); 
            response.sendRedirect("index.jsp");
        }
    }
}
