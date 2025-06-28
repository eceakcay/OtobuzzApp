const express = require('express');
const router = express.Router();

const {
  createTrip,
  getTrips,
  getTripDetail,
  updateTrip,
  getCities,
  getTripById,
  updateSeat // 🔧 Bunu da buraya ekliyoruz
} = require('../controllers/tripController');

// 📌 Route tanımlamaları
router.get('/cities', getCities);
router.post('/', createTrip);               // Yeni sefer ekle
router.get('/', getTrips);                  // Tüm seferleri listele / filtrele
router.get('/:id', getTripDetail);          // Sefer detayı
router.put('/:id', updateTrip);             // Sefer güncelle
router.get('/:id', getTripById);            // ID'ye göre sefer getir
router.patch('/:id/seats', updateSeat);     // Koltuk güncelleme (PATCH)

module.exports = router;
