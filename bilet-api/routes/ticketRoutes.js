const express = require('express');
const router = express.Router();
const {
  buyTicket,
  getUserTickets,
  completePayment,
} = require('../controllers/ticketController');

// ✅ Bilet alma işlemi (doğrudan satın alma)
router.post('/buy', buyTicket);

// ✅ Kullanıcının biletlerini getir
router.get('/user/:userId', getUserTickets);

// (Opsiyonel) Ödeme işlemini tamamlama (eğer ayrı yapılıyorsa hâlâ kullanılabilir)
router.post('/pay', completePayment);

module.exports = router;
