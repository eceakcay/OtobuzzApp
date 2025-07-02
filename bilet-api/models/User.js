const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  ad: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  sifre: { type: String, required: true },
  savedCards: [
    {
      cardHolder: String,
      cardNumber: String,
      expiryDate: String,
      cvv: String
    }
  ],
  yolcuBilgileri: [
    {
      ad: String,
      cinsiyet: String
    }
  ],
  tickets: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Ticket'
    }
  ]
});

module.exports = mongoose.model('User', userSchema);