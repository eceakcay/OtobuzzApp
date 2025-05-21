const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');

// Route dosyaları
const authRoutes = require('./routes/authRoutes');
const tripRoutes = require('./routes/tripRoutes');
const ticketRoutes = require('./routes/ticketRoutes');
const cardRoutes = require('./routes/cardRoutes');

// Ortam değişkenlerini yükle
dotenv.config();

// Veritabanına bağlan
connectDB();

// Uygulama oluştur
const app = express();
app.use(cors());
app.use(express.json());

// API rotalarını tanımla
app.use('/api/auth', authRoutes);
app.use('/api/trips', tripRoutes);
app.use('/api/tickets', ticketRoutes);
app.use('/api/cards', cardRoutes);

// Sunucuyu başlat
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Sunucu ${PORT} portunda çalışıyor`);
});
