const express = require('express');
const router = express.Router();
const { saveCard, getUserCards } = require('../controllers/cardController');

router.post('/save', saveCard);              // Kart kaydet
router.get('/:userId', getUserCards);        // Kullanıcının kartlarını getir

module.exports = router;
