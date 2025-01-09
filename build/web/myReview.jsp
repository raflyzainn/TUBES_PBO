<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="classes.JDBC, java.util.*, java.sql.*" %>
<%
    // Get the session and check if the user is logged in
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("userId") == null) {
        response.sendRedirect("signIn.jsp");
        return;
    }

    Integer userId = (Integer) userSession.getAttribute("userId");
    String username = (String) userSession.getAttribute("username");
    if (username == null) {
        out.println("Error: Username not found in session.");
        response.sendRedirect("signIn.jsp");
        return;
    }

    JDBC jdbc = new JDBC();
    List<Map<String, Object>> reviews = new ArrayList<>();

    try {
        // Query the database for the user's reviews
        String query = "SELECT u.*, f.judul FROM ulasan u JOIN Film f ON u.film_id = f.id WHERE u.pengirim = ?";
        try (PreparedStatement ps = jdbc.getConnection().prepareStatement(query)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> review = new HashMap<>();
                review.put("filmTitle", rs.getString("judul"));
                review.put("rating", rs.getInt("rating"));
                review.put("pesan", rs.getString("pesan"));
                review.put("filmId", rs.getInt("film_id"));
                reviews.add(review);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    } finally {
        jdbc.disconnect();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reviews</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#ff0000'
                    }
                }
            }
        }
    </script>
    <style>
        /* Navigation Bar */
        nav {
            display: flex;
            justify-content: center;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            gap: 2.5rem;
            background-color: white;
        }

        nav img {
            height: 30px;
            width: 10%;
        }

        nav a {
            font-family: 'Montserrat', sans-serif;
            font-weight: bold;
            color: #FF0000;
            text-decoration: none;
        }

        nav a:hover {
            text-decoration: underline;
        }
        
        .logout-button {
            background-color: #8B0000; /* Warna merah tua */
            color: white;
            font-family: 'Montserrat', sans-serif;
            font-weight: bold;
            font-size: 1rem;
            padding: 0.2rem 1.2rem; /* Ukuran padding untuk bentuk tombol */
            border: none;
            border-radius: 9999px; /* Membuat tombol oval sempurna */
            cursor: pointer;
            transition: background-color 0.3s;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); /* Tambahkan bayangan */
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav>
        <img src="Images/logo.png" alt="Logo" />
        <a href="indexPengguna.jsp">MOVIES</a>
        <a href="myReview.jsp">MY REVIEW</a>
        <a href="watchlist.jsp">WATCHLIST</a>
        <a href="profile.jsp">PROFILE</a>
        <form method="get" action="signin" class="logout-form">
            <input type="hidden" name="action" value="logout">
            <button type="submit" class="logout-button">LOGOUT</button>
        </form>
    </nav>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900">My Reviews</h1>
        </div>

        <!-- Reviews Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% if (reviews != null && !reviews.isEmpty()) {
                for (Map<String, Object> review : reviews) { %>
            <div class="review-card bg-white rounded-lg overflow-hidden shadow-md border border-gray-200 hover:border-primary hover:shadow-lg transition-all duration-300">
                <div class="p-6">
                    <h3 class="text-xl font-bold text-gray-900 mb-2"><%= review.get("filmTitle") %></h3>
                    <p class="text-gray-600 text-sm mb-4 line-clamp-2"><strong>Review:</strong> <%= review.get("pesan") %></p>
                    <p class="text-gray-600"><strong>Rating:</strong> <%= review.get("rating") %>/5</p>
                </div>
            </div>
            <% }
            } else { %>
                <!-- Empty State -->
                <div class="col-span-full text-center py-16">
                    <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-gray-100 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                        </svg>
                    </div>
                    <h3 class="text-xl font-medium text-gray-900 mb-2">You haven't reviewed any movies yet</h3>
                    <p class="text-gray-600 mb-4">Start sharing your thoughts on your favorite movies!</p>
                    <a href="indexPengguna.jsp" class="inline-block bg-primary text-white px-6 py-3 rounded-md hover:bg-red-700 transition-colors duration-300">
                        Browse Movies
                    </a>
                </div>
            <% } %>
        </div>
    </main>
</body>
</html>
