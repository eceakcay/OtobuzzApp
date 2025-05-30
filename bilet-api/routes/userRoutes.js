const express = require('express');
const router = express.Router();
const { getUserProfile } = require('../controllers/userController');

// Kullanıcı profili getirme
router.get('/:id', getUserProfile);

module.exports = router;
