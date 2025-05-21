const mongoose = require('mongoose');

const cardSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  cardHolder: String,
  cardNumber: String,
  expiryDate: String,
  cvv: String
});

module.exports = mongoose.model('Card', cardSchema);
