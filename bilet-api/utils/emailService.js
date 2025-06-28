const nodemailer = require('nodemailer');

require('dotenv').config(); 


const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'otobuzz0@gmail.com',        
    pass: 'ltfhtjxpqobgzquw'            
  }
});

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
    console.log(`📧 Mail gönderildi: ${toEmail}`); // 🔔 BURASI EKLENDİ
  } catch (error) {
    console.error('Mail gönderme hatası:', error);
    throw error;
  }
}


module.exports = { sendTicketEmail };
