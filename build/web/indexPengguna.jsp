<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="classes.JDBC"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Review Website</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Styles/indexPengguna.css">
    <style>
        /* Styling Button Logout */
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

    <section>
        <div class="hero">
            <div class="hero-left">
                <h1>Bagikan Pendapatmu, Temukan Perspektif Baru.</h1>
                <h2>"Bagikan ulasan film favoritmu dan temukan perspektif baru dari sesama pecinta film. Jadilah bagian dari komunitas ini sekarang!"</h2>
                <a href="#">Ayo Mulai!</a>
            </div>
            <img src="Images/gambar.png" alt="Hero Image" />
        </div>
    </section>

    <div class="container" id="movies-section">
        <h1 class="section-title">MOVIES</h1>
        <div class="movies">
            <!-- Bagian film tetap tidak berubah -->
            <a href="Interstellar.jsp">
                <div class="movie">
                    <img src="Images/interstellar.jpg" alt="Interstellar">
                    <p>Interstellar</p>
                </div>
            </a>
            <a href="BackToTheFuture.jsp">
                <div class="movie">
                    <img src="Images/back-to-future.jpg" alt="Back To The Future">
                    <p>Back To The Future</p>
                </div>
            </a>
            <a href="Jaws.jsp">
                <div class="movie">
                    <img src="Images/jaws.jpg" alt="Jaws">
                    <p>Jaws</p>
                </div>
            </a>
            <a href="Joker.jsp">
                <div class="movie">
                    <img src="Images/joker.jpg" alt="Joker">
                    <p>Joker</p>
                </div>
            </a>
            <a href="ShutterIsland.jsp">
                <div class="movie">
                    <img src="Images/shutter-island.jpg" alt="Shutter Island">
                    <p>Shutter Island</p>
                </div>
            </a>
        </div>
    </div>
    
    <div class="container" id="movies-section">
        <h1 class="section-title">MOVIES</h1>
        <div class="movies">
            <% 
                // Memanggil JDBC untuk mengambil data film
                JDBC jdbc = new JDBC();
                List<Map<String, Object>> films = jdbc.getAllFilms();

                // Loop untuk menampilkan data film
                if (films != null && !films.isEmpty()) {
                    for (Map<String, Object> film : films) {
            %>
                        <a href="halamanFilm.jsp?id=<%= film.get("id") %>">
                            <div class="movie">
                                <!-- Jika tidak ada gambar, gunakan gambar default -->
                                <p><%= film.get("judul") %></p>
                            </div>
                        </a>
            <%
                    }
                } else {
            %>
                <p>No movies available.</p>
            <%
                }
            %>
        </div>
    </div>

    <div class="movies-list">
        <h1 class="section-title">KATEGORI</h1>
        <div class="genres-list">
            <%
                Connection connection = null;
                Statement statement = null;
                ResultSet resultSet = null;

                try {
                    // Koneksi ke database
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/tubes1_pbo", "root", "");
                    statement = connection.createStatement();
                    String query = "SELECT judul, genre FROM film"; // Mengambil data dari kolom judul dan genre
                    resultSet = statement.executeQuery(query);

                    // Looping untuk menampilkan data genre
                    while (resultSet.next()) {
                        String judul = resultSet.getString("judul");
                        String genre = resultSet.getString("genre");
            %>
                        <div class="genre-item">
                            <p><strong>Judul:</strong> <%= judul %></p>
                            <p><strong>Genre:</strong> <%= genre %></p>
                        </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    // Menutup koneksi
                    if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                    if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
                    if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
                }
            %>
        </div>
    </div>
    
    <section class="ranking-section">
        <h2 class="section-title">Top Films</h2>
        <div class="ranking-container">
            <!-- Film 1 -->
            <div class="ranking-card">
                <div class="ranking-number">#1</div>
                <img class="ranking-poster" src="Images/interstellar.jpg" alt="Interstellar Poster">
                <h3 class="ranking-title">Interstellar</h3>
                <p class="ranking-rating">? 4.9</p>
            </div>
            <!-- Film 2 -->
            <div class="ranking-card">
                <div class="ranking-number">#2</div>
                <img class="ranking-poster" src="Images/joker.jpg" alt="Joker Poster">
                <h3 class="ranking-title">Joker</h3>
                <p class="ranking-rating">? 4.8</p>
            </div>
            <!-- Film 3 -->
            <div class="ranking-card">
                <div class="ranking-number">#3</div>
                <img class="ranking-poster" src="Images/back-to-future.jpg" alt="Back to the Future Poster">
                <h3 class="ranking-title">Back to the Future</h3>
                <p class="ranking-rating">? 4.7</p>
            </div>
            <!-- Film 4 -->
            <div class="ranking-card">
                <div class="ranking-number">#4</div>
                <img class="ranking-poster" src="Images/jaws.jpg" alt="Jaws Poster">
                <h3 class="ranking-title">Jaws</h3>
                <p class="ranking-rating">? 4.6</p>
            </div>
            <!-- Film 5 -->
            <div class="ranking-card">
                <div class="ranking-number">#5</div>
                <img class="ranking-poster" src="Images/shutter-island.jpg" alt="Shutter Island Poster">
                <h3 class="ranking-title">Shutter Island</h3>
                <p class="ranking-rating">? 4.5</p>
            </div>
        </div>
    </section>
</body>
</html>
