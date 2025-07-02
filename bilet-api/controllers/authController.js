const User = require('../models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Kayıt işlemi
const register = async (req, res) => {
  const { ad, email, sifre } = req.body;

  try {
    // Aynı email ile kayıtlı kullanıcı var mı kontrol et
    const existing = await User.findOne({ email });
    if (existing) {
      return res.status(400).json({ message: 'Bu email zaten kayıtlı.' });
    }

    // Şifreyi hashle
    const hashedPassword = await bcrypt.hash(sifre, 10);

    // Yeni kullanıcı oluştur ve kaydet
    const user = new User({ ad, email, sifre: hashedPassword });
    await user.save();

    // JWT token oluştur
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });

    // Başarılı kayıt yanıtı
    res.status(201).json({
      message: 'Kayıt başarılı',
      user: {
        _id: user._id,
        ad: user.ad,
        email: user.email
      },
      token: token
    });
  } catch (err) {
    res.status(500).json({ message: 'Sunucu hatası', error: err.message });
  }
};

// Giriş işlemi
const login = async (req, res) => {
  const { email, sifre } = req.body;

  try {
    // Email ile kullanıcı bul
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: 'Kullanıcı bulunamadı' });
    }

    // Şifre doğrulama
    const isMatch = await bcrypt.compare(sifre, user.sifre);
    if (!isMatch) {
      return res.status(401).json({ message: 'Şifre hatalı' });
    }

    // JWT token oluştur
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });

    // Başarılı giriş yanıtı
    res.status(200).json({
      message: 'Giriş başarılı',
      token: token,
      userId: user._id,
      userName: user.ad
    });
  } catch (err) {
    res.status(500).json({ message: 'Sunucu hatası', error: err.message });
  }
};

module.exports = {
  register,
  login,
};
