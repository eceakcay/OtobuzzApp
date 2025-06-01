const Ticket = require('../models/Ticket');
const Trip = require('../models/Trip');
const User = require('../models/User');
const { sendTicketEmail } = require('../utils/emailService'); // Mail servisini dahil ettik

const buyTicket = async (req, res) => {
  const { userId, tripId, koltukNo, cinsiyet } = req.body;

  try {
    const trip = await Trip.findById(tripId);
    if (!trip) return res.status(404).json({ message: 'Sefer bulunamadı' });

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'Kullanıcı bulunamadı' });

    const koltuk = trip.koltuklar.find(k => k.numara === koltukNo);
    if (!koltuk || koltuk.secili) return res.status(400).json({ message: 'Koltuk seçilemez' });

    koltuk.secili = true;
    koltuk.cinsiyet = cinsiyet;
    await trip.save();

    const ticket = new Ticket({ user: userId, trip: tripId, koltukNo, cinsiyet, odemeDurumu: 'Beklemede', onay: false });
    await ticket.save();

    await User.findByIdAndUpdate(userId, { $push: { tickets: ticket._id } });

    // Mail gönderimi
    await sendTicketEmail(user.email, {
      from: trip.kalkisSehri,
      to: trip.varisSehri,
      date: trip.tarih,
      time: trip.saat,
      seat: koltukNo,
      company: trip.firma
    });

    res.status(200).json({ message: 'Bilet alındı', ticket });
  } catch (err) {
    res.status(500).json({ message: 'Bilet alınamadı', error: err.message || err });
  }
};

const getUserTickets = async (req, res) => {
  try {
    const tickets = await Ticket.find({ user: req.params.userId }).populate('trip');
    res.status(200).json(tickets);
  } catch (err) {
    res.status(500).json({ message: 'Biletler alınamadı', error: err.message || err });
  }
};

const completePayment = async (req, res) => {
  const { ticketId } = req.body;

  try {
    const ticket = await Ticket.findById(ticketId).populate('trip').populate('user');
    if (!ticket) return res.status(404).json({ message: 'Bilet bulunamadı' });

    ticket.odemeDurumu = 'Odendi';
    ticket.onay = true;
    await ticket.save();

    // Kullanıcının bilet listesine ekle (zaten eklenmiş olabilir, burada tekrar ediliyor)
    await User.findByIdAndUpdate(ticket.user._id, { $push: { tickets: ticket._id } });

    await sendTicketEmail(ticket.user.email, {
      from: ticket.trip.kalkisSehri,
      to: ticket.trip.varisSehri,
      date: ticket.trip.tarih,
      time: ticket.trip.saat,
      seat: ticket.koltukNo,
      company: ticket.trip.firma
    });

    res.status(200).json({ message: 'Ödeme başarılı, bilet e-postayla gönderildi', ticket });
  } catch (err) {
    res.status(500).json({ message: 'Ödeme tamamlanamadı', error: err.message || err });
  }
};

const reserveSeat = async (req, res) => {
  const { userId, tripId, koltukNo, cinsiyet } = req.body;

  try {
    const trip = await Trip.findById(tripId);
    if (!trip) return res.status(404).json({ message: 'Sefer bulunamadı' });

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'Kullanıcı bulunamadı' });

    const koltuk = trip.koltuklar.find(k => k.numara === koltukNo);
    if (!koltuk || koltuk.secili) return res.status(400).json({ message: 'Koltuk seçilemez' });

    koltuk.secili = true;
    koltuk.cinsiyet = cinsiyet;
    await trip.save();

    const ticket = new Ticket({
      user: userId,
      trip: tripId,
      koltukNo,
      cinsiyet,
      odemeDurumu: 'Beklemede',
      onay: false
    });

    await ticket.save();

    res.status(200).json({ message: 'Koltuk rezerve edildi, ödeme bekleniyor', ticketId: ticket._id });
  } catch (err) {
    res.status(500).json({ message: 'Rezervasyon hatası', error: err.message || err });
  }
};

module.exports = { buyTicket, getUserTickets, completePayment, reserveSeat };
