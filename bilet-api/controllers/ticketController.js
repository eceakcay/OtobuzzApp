const Ticket = require('../models/Ticket');
const Trip = require('../models/Trip');
const User = require('../models/User');

const buyTicket = async (req, res) => {
  const { userId, tripId, koltukNo, cinsiyet } = req.body;

  try {
    const trip = await Trip.findById(tripId);
    if (!trip) return res.status(404).json({ message: 'Sefer bulunamadı' });

    // Koltuğu işaretle
    const koltuk = trip.koltuklar.find(k => k.numara === koltukNo);
    if (!koltuk || koltuk.secili) return res.status(400).json({ message: 'Koltuk seçilemez' });

    koltuk.secili = true;
    koltuk.cinsiyet = cinsiyet;
    await trip.save();

    const ticket = new Ticket({ user: userId, trip: tripId, koltukNo, cinsiyet });
    await ticket.save();

    await User.findByIdAndUpdate(userId, { $push: { tickets: ticket._id } });

    res.status(200).json({ message: 'Bilet alındı', ticket });
  } catch (err) {
    res.status(500).json({ message: 'Bilet alınamadı', error: err });
  }
};

const getUserTickets = async (req, res) => {
  try {
    const tickets = await Ticket.find({ user: req.params.userId }).populate('trip');
    res.status(200).json(tickets);
  } catch (err) {
    res.status(500).json({ message: 'Biletler alınamadı', error: err });
  }
};

const completePayment = async (req, res) => {
  const { ticketId } = req.body;

  try {
    const updated = await Ticket.findByIdAndUpdate(ticketId, {
      odemeDurumu: 'Odendi',
      onay: true
    }, { new: true });

    res.status(200).json({ message: 'Ödeme tamamlandı', ticket: updated });
  } catch (err) {
    res.status(500).json({ message: 'Ödeme sırasında hata oluştu', error: err });
  }
};


module.exports = { buyTicket, getUserTickets, completePayment };
