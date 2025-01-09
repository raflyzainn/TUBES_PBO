<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Review Website</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="Styles/indexAdmin.css">
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
        <a href="">MOVIES</a>
        <a href="">MY REVIEW</a>
        <a href="profile.jsp">PROFILE</a>
        <a href="watchlist.jsp">WATCHLIST</a>
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
    
    <section class="movie-management">
        <div class="container">
            <h2>Kelola Film</h2>

            <!-- Form Tambah Film -->
            <div class="form-container">
                <h3>Tambah Film</h3>
                <form method="post" action="addFilmServlet">
                    <label for="tambah-judul">Judul Film:</label>
                    <input type="text" id="tambah-judul" name="judul" placeholder="Masukkan judul film" required>

                    <label for="tambah-deskripsi">Deskripsi:</label>
                    <textarea id="tambah-deskripsi" name="deskripsi" placeholder="Masukkan deskripsi film" required></textarea>

                    <label for="tambah-sutradara">Sutradara:</label>
                    <input type="text" id="tambah-sutradara" name="sutradara" placeholder="Masukkan nama sutradara" required>

                    <label for="tambah-cast">Cast:</label>
                    <input type="text" id="tambah-cast" name="cast" placeholder="Masukkan nama cast" required>

                    <label for="tambah-duration">Durasi (menit):</label>
                    <input type="number" id="tambah-duration" name="duration" placeholder="Masukkan durasi film" required>

                    <label for="tambah-rating">Rating:</label>
                    <input type="number" step="0.1" id="tambah-rating" name="rating" placeholder="Masukkan rating" required>

                    <label for="tambah-kategori">Kategori:</label>
                    <input type="text" id="tambah-kategori" name="kategori" placeholder="Masukkan kategori" required>

                    <label for="tambah-genre">Genre:</label>
                    <input type="text" id="tambah-genre" name="genre" placeholder="Masukkan genre" required>

                    <button type="submit">Tambah Film</button>
                </form>
            </div>

            <!-- Form Edit Film -->
            <div class="form-container">
                <h3>Edit Film</h3>
                <form method="post" action="editFilmServlet">
                    <label for="edit-id">ID Film:</label>
                    <input type="number" id="edit-id" name="id" placeholder="Masukkan ID film" required>

                    <label for="edit-judul">Judul Film Baru:</label>
                    <input type="text" id="edit-judul" name="judul" placeholder="Masukkan judul film baru">

                    <label for="edit-deskripsi">Deskripsi Baru:</label>
                    <textarea id="edit-deskripsi" name="deskripsi" placeholder="Masukkan deskripsi baru"></textarea>

                    <label for="edit-sutradara">Sutradara Baru:</label>
                    <input type="text" id="edit-sutradara" name="sutradara" placeholder="Masukkan nama sutradara baru">

                    <label for="edit-cast">Cast Baru:</label>
                    <input type="text" id="edit-cast" name="cast" placeholder="Masukkan cast baru">

                    <label for="edit-rating">Rating Baru:</label>
                    <input type="number" step="0.1" id="edit-rating" name="rating" placeholder="Masukkan rating baru">

                    <button type="submit">Edit Film</button>
                </form>
            </div>

            <!-- Form Hapus Film -->
            <div class="form-container">
                <h3>Hapus Film</h3>
                <form method="post" action="deleteFilmServlet">
                    <label for="delete-id">ID Film:</label>
                    <input type="number" id="delete-id" name="id" placeholder="Masukkan ID film" required>

                    <button type="submit">Hapus Film</button>
                </form>
            </div>
        </div>
    </section>
    
</body>
</html>
