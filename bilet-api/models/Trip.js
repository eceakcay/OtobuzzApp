const mongoose = require('mongoose');

const tripSchema = new mongoose.Schema({
  kalkisSehri: String,
  varisSehri: String,
  tarih: String,
  saat: String,
  fiyat: Number,
  firma: String,
  koltuklar: [
    {
      numara: Number,
      secili: { type: Boolean, default: false },
      cinsiyet: String
    }
  ]
});

module.exports = mongoose.model('Trip', tripSchema);
