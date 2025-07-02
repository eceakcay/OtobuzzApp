const nodemailer = require('nodemailer');
require('dotenv').config();

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER || 'otobuzz0@gmail.com',      // Mail kullanıcı adı (env dosyasından okunabilir)
    pass: process.env.EMAIL_PASS || 'ltfhtjxpqobgzquw'         // Mail şifresi veya app password
  }
});

// Bilet maili gönderme fonksiyonu (zaten mevcut)
async function sendTicketEmail(toEmail, ticketInfo) {
  const mailOptions = {
    from: 'otobuzz0@gmail.com',
    to: toEmail,
    subject: '📩 Bilet İşleminiz Başarıyla Tamamlandı',
    text: `
Sayın Yolcumuz,

Rezervasyon işleminiz başarıyla gerçekleştirilmiştir. Aşağıda biletinize ait detaylar yer almaktadır:

━━━━━━━━━━━━━━━━━━━━━━
🚌 Sefer Bilgileri:
• Kalkış Noktası : ${ticketInfo.from}
• Varış Noktası  : ${ticketInfo.to}
• Tarih          : ${ticketInfo.date}
• Saat           : ${ticketInfo.time}
• Koltuk No      : ${ticketInfo.seat}
• Firma          : ${ticketInfo.company}
━━━━━━━━━━━━━━━━━━━━━━

Yolculuğunuz süresince iyi vakit geçirmenizi dileriz.  
Herhangi bir sorunla karşılaşmanız durumunda lütfen bizimle iletişime geçiniz.

Saygılarımızla,  
${ticketInfo.company} Müşteri Hizmetleri
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

// Şifre sıfırlama için geçici şifre maili gönderme fonksiyonu
async function sendPasswordResetEmail(toEmail, tempPassword) {
  const mailOptions = {
    from: 'otobuzz0@gmail.com',
    to: toEmail,
    subject: '🔑 Otobuzz Şifre Sıfırlama',
    text: `
Sayın Kullanıcımız,

Şifreniz sıfırlanmıştır. Aşağıdaki geçici şifre ile giriş yapabilirsiniz:

Geçici Şifre: ${tempPassword}

Lütfen uygulamaya giriş yaptıktan sonra şifrenizi değiştiriniz.

Saygılarımızla,  
Otobuzz Destek Ekibi
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
