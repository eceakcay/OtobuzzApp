const User = require('../models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const register = async (req, res) => {
  const { ad, email, sifre } = req.body;

  try {
    const existing = await User.findOne({ email });
    if (existing) return res.status(400).json({ message: 'Bu email zaten kayıtlı.' });

    const hashedPassword = await bcrypt.hash(sifre, 10);
    const user = new User({ ad, email, sifre: hashedPassword });
    await user.save();

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });
    
    res.status(201).json({
      message: 'Kayıt başarılı',
      user: {
        _id: user._id,
        email: user.email
      },
      token: token
    });
  } catch (err) {
    res.status(500).json({ message: 'Sunucu hatası', error: err });
  }
};

const login = async (req, res) => {
  const { email, sifre } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ message: 'Kullanıcı bulunamadı' });

    const isMatch = await bcrypt.compare(sifre, user.sifre);
    if (!isMatch) return res.status(401).json({ message: 'Şifre hatalı' });

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });

    res.status(200).json({
      message: 'Giriş başarılı',
      token: token,
      userId: user._id
    });
  } catch (err) {
    res.status(500).json({ message: 'Sunucu hatası', error: err });
  }
};

module.exports = { login, register };
