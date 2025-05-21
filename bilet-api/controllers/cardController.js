const Card = require('../models/Card');

const saveCard = async (req, res) => {
  try {
    const newCard = new Card(req.body);
    await newCard.save();
    res.status(201).json({ message: 'Kart kaydedildi', card: newCard });
  } catch (err) {
    res.status(500).json({ message: 'Kart kaydedilemedi', error: err });
  }
};

const getUserCards = async (req, res) => {
  try {
    const cards = await Card.find({ user: req.params.userId });
    res.status(200).json(cards);
  } catch (err) {
    res.status(500).json({ message: 'Kartlar alınamadı', error: err });
  }
};

module.exports = { saveCard, getUserCards };
