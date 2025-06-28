const Trip = require('../models/Trip');

// Yeni sefer oluştur
const createTrip = async (req, res) => {
  try {
    console.log("🎯 Yeni sefer oluşturma isteği geldi:", req.body); // BU SATIRI EKLE

    const body = req.body;

    if (!body.koltuklar || body.koltuklar.length !== 30) {
      body.koltuklar = Array.from({ length: 30 }, (_, i) => ({
        numara: i + 1,
        secili: false
      }));
    }

    const newTrip = new Trip(body);
    await newTrip.save();

    console.log("✅ Sefer başarıyla kaydedildi."); // BU SATIRI DA EKLE
    res.status(201).json({ message: 'Sefer oluşturuldu', trip: newTrip });
  } catch (err) {
    console.error("❌ Sefer oluşturulamadı:", err);
    res.status(500).json({ message: 'Sefer oluşturulamadı', error: err });
  }
};



// Seferleri filtrele + sırala
const getTrips = async (req, res) => {
  const { from, to, firma, minFiyat, maxFiyat, sort, tarih } = req.query;
  const filter = {};

  if (from) filter.kalkisSehri = new RegExp(from, 'i'); // küçük-büyük harf duyarsız eşleşme
  if (to) filter.varisSehri = new RegExp(to, 'i');
  if (firma) filter.firma = new RegExp(firma, 'i');
  if (tarih) filter.tarih = tarih;

  if (minFiyat || maxFiyat) {
    filter.fiyat = {};
    if (minFiyat) filter.fiyat.$gte = Number(minFiyat);
    if (maxFiyat) filter.fiyat.$lte = Number(maxFiyat);
  }

  console.log("🔍 Uygulanan filtre:", filter); // DEBUG

  try {
    let query = Trip.find(filter);
    if (sort === 'fiyatArtan') query = query.sort({ fiyat: 1 });
    else if (sort === 'fiyatAzalan') query = query.sort({ fiyat: -1 });

    const trips = await query.exec();
    res.status(200).json(trips);
  } catch (err) {
    console.error("❌ Sefer listesi alınamadı:", err);
    res.status(500).json({ message: 'Sefer listesi alınamadı', error: err });
  }
};

// Tüm şehirleri getir (kalkış ve varış şehirlerini birleştirip benzersiz döner)
const getCities = async (req, res) => {
  try {
    const trips = await Trip.find({}, 'kalkisSehri varisSehri');

    const allCities = trips.reduce((acc, trip) => {
      if (trip.kalkisSehri) acc.push(trip.kalkisSehri);
      if (trip.varisSehri) acc.push(trip.varisSehri);
      return acc;
    }, []);

    const uniqueCities = [...new Set(allCities)].sort();

    res.status(200).json(uniqueCities);
  } catch (error) {
    res.status(500).json({ message: 'Şehirler alınamadı', error });
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

const updateTrip = async (req, res) => {
  try {
    const updatedTrip = await Trip.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updatedTrip);
  } catch (error) {
    res.status(500).json({ message: "Güncelleme başarısız", error });
  }
};

const getTripById = async (req, res) => {
  try {
    const trip = await Trip.findById(req.params.id);
    if (!trip) {
      return res.status(404).json({ message: 'Sefer bulunamadı' });
    }
    res.status(200).json(trip);
  } catch (err) {
    res.status(500).json({ message: 'Sunucu hatası', error: err.message || err });
  }
};

// Tek bir koltuğu güncelle (örneğin: cinsiyet ve secili=true)
const updateSeat = async (req, res) => {
  try {
    const tripId = req.params.id;
    const { numara, cinsiyet } = req.body;

    const trip = await Trip.findById(tripId);
    if (!trip) {
      return res.status(404).json({ message: 'Sefer bulunamadı' });
    }

    const seatIndex = trip.koltuklar.findIndex(seat => seat.numara === numara);
    if (seatIndex === -1) {
      return res.status(404).json({ message: 'Koltuk numarası bulunamadı' });
    }

    trip.koltuklar[seatIndex].secili = true;
    trip.koltuklar[seatIndex].cinsiyet = cinsiyet;

    await trip.save();
    res.status(200).json(trip);
  } catch (error) {
    console.error("❌ Koltuk güncelleme hatası:", error);
    res.status(500).json({ message: 'Koltuk güncellenemedi', error });
  }
};



module.exports = { createTrip, getTrips, getTripDetail,getCities,updateTrip,getTripById,updateSeat};
