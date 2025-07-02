// Gerekli modülleri yükle
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');

// Route dosyalarını içe aktar
const authRoutes = require('./routes/authRoutes');
const tripRoutes = require('./routes/tripRoutes');
const ticketRoutes = require('./routes/ticketRoutes');
const cardRoutes = require('./routes/cardRoutes');
const userRoutes = require('./routes/userRoutes'); // Kullanıcı route'ları

// Ortam değişkenlerini yükle (.env dosyasından)
dotenv.config();

// MongoDB bağlantısını başlat
connectDB();

// Express uygulamasını oluştur
const app = express();

// Middleware tanımlamaları
app.use(cors());             // CORS desteği (frontend erişimi için)
app.use(express.json());     // JSON body parse edebilmek için

// API route'ları tanımla
app.use('/api/auth', authRoutes);       // Kullanıcı giriş/kayıt ve şifre sıfırlama
app.use('/api/trips', tripRoutes);      // Sefer işlemleri
app.use('/api/tickets', ticketRoutes);  // Bilet işlemleri
app.use('/api/cards', cardRoutes);      // Kart işlemleri
app.use('/api/users', userRoutes);      // Kullanıcı işlemleri

// Sunucuyu belirtilen portta çalıştır
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Sunucu ${PORT} portunda çalışıyor`);
});
