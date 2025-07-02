const express = require('express');
const router = express.Router();
const { getUserProfile, forgotPassword } = require('../controllers/userController');

// Kullanıcı profili getirme
router.get('/:id', getUserProfile);

// Şifre sıfırlama isteği
router.post('/forgot-password', forgotPassword);

module.exports = router;
