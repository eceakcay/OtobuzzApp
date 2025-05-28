const express = require('express');
const router = express.Router();
const { createTrip, getTrips, getTripDetail } = require('../controllers/tripController');
const { getCities } = require('../controllers/tripController');

router.get('/cities', getCities);
router.post('/', createTrip);          // Yeni sefer ekle
router.get('/', getTrips);                   // Tüm seferleri listele / filtrele
router.get('/:id', getTripDetail);           // Sefer detayı

module.exports = router;
 