<%@page import="classes.JDBC"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Details</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <style>
        nav {
            display: flex;
            justify-content: center;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            gap: 2.5rem;
            background-color: white;
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

        .movie-header, .reviews-section, .recommended-movies {
            padding: 2rem;
            background-color: white;
            margin: 2rem auto;
            max-width: 800px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        .movie-header h1 {
            font-size: 2rem;
            font-weight: bold;
            color: #333;
        }

        .movie-header p, .reviews-section p {
            font-size: 1rem;
            color: #555;
            margin-top: 0.5rem;
        }

        .btn {
            margin-top: 1.5rem;
            display: inline-block;
            background-color: #FF0000;
            color: white;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            font-weight: bold;
            text-align: center;
            border-radius: 4px;
            text-decoration: none;
        }

        .btn:hover {
            background-color: #cc0000;
        }
        
        .logout-button {
            background-color: #8B0000; 
            color: white;
            font-family: 'Montserrat', sans-serif;
            font-weight: bold;
            font-size: 1rem;
            padding: 0.2rem 1.2rem; 
            border: none;
            border-radius: 9999px; 
            cursor: pointer;
            transition: background-color 0.3s;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); 
        }
    </style>
</head>
<body class="bg-gray-100 font-sans">
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

    <%
        int filmId = Integer.parseInt(request.getParameter("id"));
        JDBC jdbc = new JDBC();
        Map<String, Object> film = jdbc.getFilmById(filmId);

        if (film == null || film.isEmpty()) {
    %>
        <div class="text-center mt-10">
            <p class="text-gray-600 text-xl">Film tidak ditemukan.</p>
        </div>
    <%
        } else {
    %>
    
    <div class="movie-header">
        <h1 class="flex items-center">
            <%= film.get("judul") %>
            <a href="reviewFilm.jsp?id=<%= film.get("id") %>" 
               class="ml-4 px-3 py-1 bg-blue-500 text-white text-sm rounded-md shadow hover:bg-blue-600">
                Review
            </a>
        </h1>
        <p><strong>Deskripsi:</strong> <%= film.get("deskripsi") %></p>
        <p><strong>Cast:</strong> <%= film.get("cast") %></p>
        <p><strong>Sutradara:</strong> <%= film.get("sutradara") %></p>
        <p><strong>Durasi:</strong> <%= film.get("duration") %> menit</p>
        <p><strong>Rating:</strong> <%= film.get("rating") %>/5</p>
        <p><strong>Kategori:</strong> <%= film.get("kategori") %></p>
        <p><strong>Genre:</strong> <%= film.get("genre") %></p>

        <form action="addToWatchlist" method="POST">
            <input type="hidden" name="filmId" value="<%= film.get("id") %>">
            <% 
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId != null) {
            %>
                <input type="hidden" name="userId" value="<%= userId %>">
                <button type="submit" class="btn">Add to Watchlist</button>
            <% } else { %>
                <p class="text-red-500 mt-4">Login untuk menambahkan ke Watchlist.</p>
            <% } %>
        </form>
    </div>

    <div class="reviews-section">
        <h2 class="text-xl font-bold text-gray-800">Reviews</h2>
        <%
            List<Map<String, Object>> reviews = jdbc.getReviewsByFilmId(filmId);

            if (reviews != null && !reviews.isEmpty()) {
                for (Map<String, Object> review : reviews) {
        %>
            <div class="review-item mt-4">
                <p class="text-gray-700"><strong><%= review.get("pengirim") %></strong> - Rating: <%= review.get("rating") %>/5</p>
                <p class="text-gray-600 mt-2"><%= review.get("pesan") %></p>
            </div>
        <%
                }
            } else {
        %>
            <p class="text-gray-500 mt-4">No reviews available for this movie.</p>
        <%
            }
        %>
    </div>

    <div class="recommended-movies bg-white shadow rounded-lg p-6 m-6">
          <h2 class="text-xl font-bold text-gray-800">Recommended Movies</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mt-4">
              <a href="Interstellar.jsp" class="movie-item hover:shadow-lg text-center">
                  <img src="Images/interstellar.jpg" alt="Interstellar Movie Poster" class="w-58 h-auto mx-auto">
                  <h3 class="text-lg font-semibold mt-0">Interstellar</h3>
                  <p class="text-gray-600 mt-3">A mind-bending thriller by Christopher Nolan.</p>
              </a>
              <a href="ShutterIsland.jsp" class="movie-item hover:shadow-lg text-center text-center">
                  <img src="Images/shutter-island.jpg" alt="Back to the Future Movie Poster" class="w-58 h-auto mx-auto ">
                  <h3 class="text-lg font-semibold mt-0">Shutter Island</h3>
                  <p class="text-gray-600 mt-3">Shutter Island thriller film directed by Martin Scorsese.</p>
              </a>
              <a href="Jaws.jsp" class="movie-item hover:shadow-lg text-center text-center">
                  <img src="Images/jaws.jpg" alt="Jaws Movie Poster" class="w-58 h-auto mx-auto">
                  <h3 class="text-lg font-semibold mt-0">Jaws</h3>
                  <p class="text-gray-600 mt-3">Jaws is a 1975 thriller film directed by Steven Spielberg.</p>
              </a>
              <a href="Joker.jsp" class="movie-item hover:shadow-lg text-center text-center">
                  <img src="Images/joker.jpg" alt="Shutter Island Movie Poster" class="w-58 h-auto mx-auto ">
                  <h3 class="text-lg font-semibold mt-0">Joker</h3>
                  <p class="text-gray-600 mt-3">A cult classic exploring identity and chaos.</p>
              </a>
          </div>
      </div> 
    <%
        }
    %>
</body>
</html>
