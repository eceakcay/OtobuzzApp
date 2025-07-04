const nodemailer = require('nodemailer');
require('dotenv').config();

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER || 'otobuzz0@gmail.com',      // Mail kullanıcı adı (env dosyasından okunabilir)
    pass: process.env.EMAIL_PASS || 'ltfhtjxpqobgzquw'         // Mail şifresi veya app password
  }
});

async function sendTicketEmail(toEmail, ticketInfo) {
  const mailOptions = {
    from: 'otobuzz0@gmail.com',
    to: toEmail,
    subject: '🎫 Otobuzz Bilet Bilgilendirmesi',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #ddd; border-radius: 10px; overflow: hidden;">
        <div style="background-color: #d32f2f; color: white; padding: 20px; text-align: center;">
          <h2 style="margin: 0;">OTOBUZZ</h2>
        </div>

        <div style="padding: 20px;">
          <p>Sayın Yolcumuz, </p>
          <p>Bilet satın alma işleminiz başarıyla tamamlanmıştır. Aşağıda seyahatinize ait detayları bulabilirsiniz:</p>

          <hr style="margin: 20px 0;">

          <h3>🚌 Sefer Bilgileri</h3>
          <table style="width: 100%; border-collapse: collapse;">
            <tr>
              <td><strong>Kalkış Noktası:</strong></td>
              <td>${ticketInfo.from}</td>
            </tr>
            <tr>
              <td><strong>Varış Noktası:</strong></td>
              <td>${ticketInfo.to}</td>
            </tr>
            <tr>
              <td><strong>Tarih:</strong></td>
              <td>${ticketInfo.date}</td>
            </tr>
            <tr>
              <td><strong>Saat:</strong></td>
              <td>${ticketInfo.time}</td>
            </tr>
            <tr>
              <td><strong>Koltuk No:</strong></td>
              <td>${ticketInfo.seat}</td>
            </tr>
            <tr>
              <td><strong>Firma:</strong></td>
              <td>${ticketInfo.company}</td>
            </tr>
          </table>

          <hr style="margin: 20px 0;">
          <p style="color: #d32f2f;"><strong>Not:</strong> Bilet çıktısı almanıza gerek yoktur. Mobil bilet ile otobüse binebilirsiniz.</p>

          <p style="margin-top: 30px;">İyi yolculuklar dileriz,<br>Otobuzz Müşteri Hizmetleri 💕</p>
        </div>

        <div style="background-color: #f5f5f5; color: #888; padding: 10px; text-align: center; font-size: 12px;">
          Bu e-posta Otobuzz sistemi tarafından otomatik olarak gönderilmiştir.
        </div>
      </div>
    `
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`📧 Mail gönderildi: ${toEmail}`);
  } catch (error) {
    console.error('Mail gönderme hatası:', error);
    throw error;
  }
}

async function sendPasswordResetEmail(toEmail, tempPassword) {
  const mailOptions = {
    from: 'otobuzz0@gmail.com',
    to: toEmail,
    subject: '🔑 Otobuzz Şifre Sıfırlama',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #ccc; border-radius: 10px; overflow: hidden;">
        <div style="background-color: #FF6D05FF; color: white; padding: 20px; text-align: center;">
          <h2 style="margin: 0;">OTOBUZZ</h2>
        </div>

        <div style="padding: 20px;">
          <p>Sayın Kullanıcımız,</p>
          <p>Şifre sıfırlama talebiniz üzerine geçici bir şifre oluşturulmuştur. Lütfen bu şifre ile giriş yaptıktan sonra yeni bir şifre belirleyiniz.</p>

          <div style="background-color: #f0f0f0; padding: 15px; margin: 20px 0; text-align: center; font-size: 20px; font-weight: bold; border-radius: 6px;">
            ${tempPassword}
          </div>

          <p>Geçici şifreniz yalnızca kısa bir süre için geçerlidir. Güvenliğiniz için oturum açtıktan sonra hemen şifrenizi güncellemenizi öneririz.</p>

          <p style="margin-top: 30px;">İyi günler dileriz,<br>Otobuzz Destek Ekibi 💕</p>
        </div>

        <div style="background-color: #f5f5f5; color: #888; padding: 10px; text-align: center; font-size: 12px;">
          Bu e-posta Otobuzz sistemi tarafından otomatik olarak gönderilmiştir.
        </div>
      </div>
    `
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`📧 Şifre sıfırlama maili gönderildi: ${toEmail}`);
  } catch (error) {
    console.error('Mail gönderilirken hata oluştu:', error);
    throw error;
  }
}


module.exports = {
  sendTicketEmail,
  sendPasswordResetEmail
};
