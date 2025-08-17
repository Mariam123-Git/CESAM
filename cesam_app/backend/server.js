const express = require('express');
const cors = require('cors');
const fs = require('fs');
const https = require('https');
require('dotenv').config();

const app = express();

// Autoriser Flutter (localhost:PORT de ton app Flutter)
app.use(cors({
  origin: '*', // en dev on autorise tout, en prod mettre le domaine exact
  credentials: true
}));

// Middleware JSON
app.use(express.json());

// Routes
const userRoutes = require('./user.routes');
app.use('/api/users', userRoutes);

// SSL pour HTTPS (optionnel)
if (fs.existsSync('./ssl/key.pem') && fs.existsSync('./ssl/certif.pem')) {
  const sslFiles = {
    key: fs.readFileSync('./ssl/key.pem'),
    cert: fs.readFileSync('./ssl/certif.pem')
  };
  https.createServer(sslFiles, app).listen(443, () => {
    console.log(`✅ Serveur HTTPS sur https://localhost`);
  });
}

// HTTP normal
app.listen(process.env.PORT, () => {
  console.log(`✅ Serveur HTTP sur http://localhost:${process.env.PORT}`);
});
