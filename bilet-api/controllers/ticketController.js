const Ticket = require('../models/Ticket');
const Trip = require('../models/Trip');
const User = require('../models/User');
const { sendTicketEmail } = require('../utils/emailService');

// Bilet satın alma işlemi (referanslı trip ile)
// Burada koltuğu secili yapma, sadece bilet kaydet
const buyTicket = async (req, res) => {
  const { userId, tripId, koltukNo, cinsiyet } = req.body;

  try {
    console.log("🟢 Bilet alma isteği geldi:", { userId, tripId, koltukNo, cinsiyet });

    const trip = await Trip.findById(tripId);
    if (!trip) {
      console.log("❌ Sefer bulunamadı:", tripId);
      return res.status(404).json({ message: 'Sefer bulunamadı' });
    }
    console.log("📦 Sefer verisi yüklendi, koltuklar sayısı:", trip.koltuklar.length);

    const user = await User.findById(userId);
    if (!user) {
      console.log("❌ Kullanıcı bulunamadı:", userId);
      return res.status(404).json({ message: 'Kullanıcı bulunamadı' });
    }
    console.log("👤 Kullanıcı bulundu:", user.email);

    const koltuk = trip.koltuklar.find(k => k.numara === Number(koltukNo));
    console.log("🔍 Bulunan koltuk:", koltuk);

    if (!koltuk) {
      console.log("❌ Koltuk bulunamadı.");
      return res.status(400).json({ message: 'Koltuk bulunamadı' });
    }

    if (koltuk.secili === true || koltuk.secili === "true") {
      console.log("❌ Koltuk zaten seçili:", koltukNo, koltuk.secili);
      return res.status(400).json({ message: 'Koltuk seçilemez' });
    }

    // Burada artık secili yapmıyoruz!
    // koltuk.secili = true;
    // koltuk.cinsiyet = cinsiyet;
    // await trip.save();

    const ticket = new Ticket({
      user: userId,
      trip: tripId,
      koltukNo,
      cinsiyet,
      odemeDurumu: 'Beklemede',
      onay: false
    });
    await ticket.save();
    console.log("🎫 Yeni bilet kaydedildi:", ticket._id);

    await User.findByIdAndUpdate(userId, { $push: { tickets: ticket._id } });

    // İstersen e-posta burada değil ödeme sonrası gönderebilirsin
    // await sendTicketEmail(user.email, {...});

    const populatedTicket = await Ticket.findById(ticket._id).populate({
      path: 'trip',
      select: 'kalkisSehri varisSehri tarih saat firma fiyat'
    });

    res.status(200).json({ message: 'Bilet oluşturuldu, ödeme bekleniyor', ticket: populatedTicket });

  } catch (err) {
    console.error("🚨 Hata:", err);
    res.status(500).json({ message: 'Bilet alınamadı', error: err.message || err });
  }
};

// Kullanıcının biletlerini listele
const getUserTickets = async (req, res) => {
  try {
    const tickets = await Ticket.find({ user: req.params.userId }).populate({
      path: 'trip',
      select: 'kalkisSehri varisSehri tarih saat firma fiyat'
    });

    if (!tickets || tickets.length === 0) {
      return res.status(200).json([]);
    }

    const response = tickets.map(ticket => ({
      _id: ticket._id,
      user: ticket.user,
      koltukNo: ticket.koltukNo,
      cinsiyet: ticket.cinsiyet,
      odemeDurumu: ticket.odemeDurumu,
      onay: ticket.onay,
      trip: {
        kalkisSehri: ticket.trip?.kalkisSehri || "",
        varisSehri: ticket.trip?.varisSehri || "",
        tarih: ticket.trip?.tarih || "",
        saat: ticket.trip?.saat || "",
        firma: ticket.trip?.firma || "",
        fiyat: ticket.trip?.fiyat || 0
      }
    }));

    console.log("🎟 Kullanıcının biletleri:", response);

    res.status(200).json(response);
  } catch (err) {
    res.status(500).json({ message: 'Biletler alınamadı', error: err.message || err });
  }
};

// Ödeme tamamlama (burada koltuğu secili yapıyoruz)
const completePayment = async (req, res) => {
  const { ticketId } = req.body;

  try {
    const ticket = await Ticket.findById(ticketId).populate('trip').populate('user');
    if (!ticket) return res.status(404).json({ message: 'Bilet bulunamadı' });

    const trip = await Trip.findById(ticket.trip._id);
    if (!trip) return res.status(404).json({ message: 'Sefer bulunamadı' });

    const koltuk = trip.koltuklar.find(k => k.numara === ticket.koltukNo);
    if (!koltuk) return res.status(404).json({ message: 'Koltuk bulunamadı' });

    if (koltuk.secili === true) {
      return res.status(400).json({ message: 'Koltuk zaten dolu' });
    }

    // Ödeme başarılıysa koltuğu secili yap
    koltuk.secili = true;
    koltuk.cinsiyet = ticket.cinsiyet;
    await trip.save();

    ticket.odemeDurumu = 'Odendi';
    ticket.onay = true;
    await ticket.save();

    await User.findByIdAndUpdate(ticket.user._id, { $push: { tickets: ticket._id } });

    await sendTicketEmail(ticket.user.email, {
      from: ticket.trip.kalkisSehri,
      to: ticket.trip.varisSehri,
      date: ticket.trip.tarih,
      time: ticket.trip.saat,
      seat: ticket.koltukNo,
      company: ticket.trip.firma
    });

    const populatedTicket = await Ticket.findById(ticket._id).populate({
      path: 'trip',
      select: 'kalkisSehri varisSehri tarih saat firma fiyat koltuklar'
    });

    res.status(200).json({ message: 'Ödeme başarılı, bilet e-postayla gönderildi', ticket: populatedTicket });

  } catch (err) {
    console.error("🚨 Hata:", err);
    res.status(500).json({ message: 'Ödeme tamamlanamadı', error: err.message || err });
  }
};

module.exports = { buyTicket, getUserTickets, completePayment };
