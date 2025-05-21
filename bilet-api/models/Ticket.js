const mongoose = require('mongoose');

const ticketSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  trip: { type: mongoose.Schema.Types.ObjectId, ref: 'Trip' },
  koltukNo: Number,
  cinsiyet: String,
  odemeDurumu: { type: String, enum: ['Beklemede', 'Odendi'], default: 'Beklemede' },
  onay: { type: Boolean, default: false },
  tarih: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Ticket', ticketSchema);
