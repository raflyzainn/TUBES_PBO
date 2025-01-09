<%@page import="java.util.Map"%>
<%@page import="classes.JDBC"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Film</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Styles/DesignReviewFilm.css">
</head>
<body>
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
    
    <div class="container">
        <%
            // Mendapatkan ID film dari parameter
            int filmId = Integer.parseInt(request.getParameter("id"));
            JDBC jdbc = new JDBC();
            Map<String, Object> film = jdbc.getFilmById(filmId);

            if (film.isEmpty()) {
        %>
            <p>Film tidak ditemukan.</p>
        <% } else { %>
        <div class="review-form">
            <h1 class="section-title">Review Film: <%= film.get("judul") %></h1>
            <form action="submitReview" method="POST">
                <input type="hidden" name="filmId" value="<%= film.get("id") %>">

                <div class="rating">
                    <label for="rating">Rating (1-5):</label>
                    <input type="number" id="rating" name="rating" min="1" max="5" required>
                </div>

                <label for="pengirim">Pengirim:</label>
                <input type="text" id="pengirim" name="pengirim" class="input-field" placeholder="Your Name" required><br>

                <textarea name="review" class="review-textarea" placeholder="Write your review here..." required></textarea>

                <button type="submit" class="submit-btn">Submit Review</button>
            </form>
        </div>
        <% } %>
    </div>
</body>
</html>
