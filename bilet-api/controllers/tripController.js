const Trip = require('../models/Trip');

// Yeni sefer oluştur
const createTrip = async (req, res) => {
  try {
    const newTrip = new Trip(req.body);
    await newTrip.save();
    res.status(201).json({ message: 'Sefer oluşturuldu', trip: newTrip });
  } catch (err) {
    res.status(500).json({ message: 'Sefer oluşturulamadı', error: err });
  }
};

// Seferleri filtrele + sırala
const getTrips = async (req, res) => {
  const { from, to, firma, minFiyat, maxFiyat, sort } = req.query;
  const filter = {};
  if (from) filter.kalkisSehri = from;
  if (to) filter.varisSehri = to;
  if (firma) filter.firma = firma;
  if (minFiyat || maxFiyat) {
    filter.fiyat = {};
    if (minFiyat) filter.fiyat.$gte = Number(minFiyat);
    if (maxFiyat) filter.fiyat.$lte = Number(maxFiyat);
  }

  try {
    let query = Trip.find(filter);
    if (sort === 'fiyatArtan') query = query.sort({ fiyat: 1 });
    else if (sort === 'fiyatAzalan') query = query.sort({ fiyat: -1 });

    const trips = await query.exec();
    res.status(200).json(trips);
  } catch (err) {
    res.status(500).json({ message: 'Sefer listesi alınamadı', error: err });
  }
};

// Sefer detay
const getTripDetail = async (req, res) => {
  try {
    const trip = await Trip.findById(req.params.id);
    if (!trip) return res.status(404).json({ message: 'Sefer bulunamadı' });
    res.status(200).json(trip);
  } catch (err) {
    res.status(500).json({ message: 'Detay alınamadı', error: err });
  }
};

module.exports = { createTrip, getTrips, getTripDetail };
