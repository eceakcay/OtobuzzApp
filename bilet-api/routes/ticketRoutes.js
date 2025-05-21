const express = require('express');
const router = express.Router();
const { buyTicket, getUserTickets, completePayment } = require('../controllers/ticketController');

router.post('/buy', buyTicket);              // Bilet satın al
router.get('/user/:userId', getUserTickets); // Kullanıcıya ait biletleri getir
router.post('/pay', completePayment);

module.exports = router;
