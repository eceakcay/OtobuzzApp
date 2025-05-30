const User = require('../models/User');

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

module.exports = {getUserProfile};
