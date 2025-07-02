const mongoose = require('mongoose');

const ticketSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  trip: { type: mongoose.Schema.Types.ObjectId, ref: 'Trip', required: true }, // ✅ REFERANS
  koltukNo: { type: Number, required: true },
  cinsiyet: { type: String, enum: ['Kadın', 'Erkek'], required: true },
  odemeDurumu: { type: String, enum: ['Beklemede', 'Odendi'], default: 'Beklemede' },
  onay: { type: Boolean, default: false }
}, { timestamps: true });

module.exports = mongoose.model('Ticket', ticketSchema);
