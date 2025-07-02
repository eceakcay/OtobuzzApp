const crypto = require('crypto');
const bcrypt = require('bcrypt');
const User = require('../models/User');
const { sendEmail } = require('../utils/emailService'); // E-posta göndermek için yardımcı fonksiyon
const { sendPasswordResetEmail } = require('../utils/emailService');


// Kullanıcı profilini getirir (şifre hariç)
const getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select('-sifre');
    if (!user) {
      return res.status(404).json({ message: 'Kullanıcı bulunamadı' });
    }
    res.status(200).json(user);
  } catch (err) {
    res.status(500).json({ message: 'Sunucu hatası', error: err });
  }
};

// Şifre sıfırlama - eposta ile geçici şifre gönderir
// Şifre sıfırlama - eposta ile geçici şifre gönderir
const forgotPassword = async (req, res) => {
  const { email } = req.body;

  try {
    console.log("Forgot Password çağrıldı, email:", email);

    const user = await User.findOne({ email });
    if (!user) {
      console.log("Kullanıcı bulunamadı:", email);
      return res.status(404).json({ message: 'Kullanıcı bulunamadı' });
    }

    const tempPassword = crypto.randomBytes(5).toString('hex');
    console.log("Geçici şifre oluşturuldu:", tempPassword);

    const hashedPassword = await bcrypt.hash(tempPassword, 10);

    user.sifre = hashedPassword;
    await user.save();

    console.log("Kullanıcı şifresi güncellendi, mail gönderiliyor...");

    // Doğru fonksiyon ismiyle çağırıyoruz
    await sendPasswordResetEmail(email, tempPassword);

    console.log("Mail gönderildi:", email);

    res.status(200).json({ message: 'Geçici şifre e-postanıza gönderildi' });
  } catch (err) {
    console.error("Forgot Password hata yakalandı:", err);
    res.status(500).json({ message: 'Sunucu hatası', error: err.message });
  }
};


module.exports = {
  getUserProfile,
  forgotPassword,
};
