const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail', // Gmail kullanıyorsan
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

const sendTicketEmail = (to, ticketInfo) => {
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: to,
    subject: 'Otobuzz - Bilet Bilgileriniz',
    html: `
      <h2>Sayın yolcumuz, biletiniz başarıyla alınmıştır.</h2>
      <p><strong>Güzergah:</strong> ${ticketInfo.from} → ${ticketInfo.to}</p>
      <p><strong>Tarih:</strong> ${ticketInfo.date}</p>
      <p><strong>Saat:</strong> ${ticketInfo.time}</p>
      <p><strong>Koltuk No:</strong> ${ticketInfo.seat}</p>
      <p><strong>Firma:</strong> ${ticketInfo.company}</p>
      <br>
      <p>İyi yolculuklar dileriz. 🚍</p>
    `
  };

return transporter.sendMail(mailOptions)
  .then(info => {
    console.log("✅ Mail gönderildi:", info.response);
  })
  .catch(err => {
    console.error("❌ Mail gönderilemedi:", err);
  });
};

module.exports = { sendTicketEmail };
