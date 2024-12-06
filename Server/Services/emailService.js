// Services/emailService.js
const nodemailer = require('nodemailer');
const { google } = require('googleapis');

const CLIENT_ID = process.env.CLIENT_ID;
const CLIENT_SECRET = process.env.CLIENT_SECRET;
const REDIRECT_URL = process.env.REDIRECT_URL;
const REFRESH_TOKEN = process.env.REFRESH_TOKEN;

const oAuth2Client = new google.auth.OAuth2(
  CLIENT_ID,
  CLIENT_SECRET,
  REDIRECT_URL
);

oAuth2Client.setCredentials({ refresh_token: REFRESH_TOKEN });

async function sendEmail(userEmail, subject, message) {
  try {
      const accessToken = await oAuth2Client.getAccessToken();

      const transporter = nodemailer.createTransport({
          service: 'gmail',
          auth: {
              type: 'OAuth2',
              user: process.env.EMAIL, // Địa chỉ email gửi
              clientId: CLIENT_ID,
              clientSecret: CLIENT_SECRET,
              refreshToken: REFRESH_TOKEN,
              accessToken: accessToken.token,
          },
      });

      const mailOptions = {
          to: userEmail,
          subject: subject,
          text: message, 
      };

      const result = await transporter.sendMail(mailOptions);
      console.log('Email đã được gửi thành công!', result);
  } catch (error) {
      console.error('Có lỗi xảy ra trong quá trình gửi email:', error);
  }
}

module.exports = { sendEmail };
