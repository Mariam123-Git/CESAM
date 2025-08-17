const express = require('express');
const router = express.Router();
const userController = require('./user.controller');// j'ai modifié le chemin pour les tests   
const authMiddleware = require('./auth.middleware');
const nodemailer = require('nodemailer');
const pool = require('./db');


// Route POST pour l'inscription
router.post('/register', userController.registerUser);

// Route POST pour la connexion
router.post('/login', userController.loginUser);

// POST - Rafraîchir le token d'accès
router.post('/refresh-token',
    authMiddleware.authenticate,
    userController.refreshToken);

// POST - Révoquer tous les tokens (nécessite authentification)
router.post('/revoke-tokens',
  authMiddleware.authenticate, 
  userController.revokeTokens
);

// Dans votre fichier de routes utilisateur
// Route POST pour envoyer l'OTP par email
router.post('/send-otp', async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ success: false, message: 'Email requis' });
  }

  try {
    // Vérifier si l'utilisateur existe
    const result = await pool.query(
      'SELECT * FROM utilisateur WHERE email = $1',
      [email]
    );

    const user = result.rows[0];
    if (!user) {
      return res.status(404).json({ 
        success: false, 
        message: 'Aucun compte associé à cet email' 
      });
    }

    // Générer un code OTP de 4 chiffres
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    const otpExpires = new Date(Date.now() + 15 * 60 * 1000); // Expire dans 15 min

    // Sauvegarder le code OTP dans la base de données
    await pool.query(
      'UPDATE utilisateur SET otp = $1, otp_expires = $2 WHERE email = $3',
      [otp, otpExpires, email]
    );

    // Envoyer l'email avec le code OTP
    await sendOtpEmail(email, otp);

    res.status(200).json({ 
      success: true, 
      message: 'Code OTP envoyé avec succès' 
    });

  } catch (error) {
    console.error('Erreur envoi OTP:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Erreur lors de l\'envoi du code OTP' 
    });
  }
});

// Fonction pour envoyer l'email
async function sendOtpEmail(email, otp) {
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.EMAIL_USER ,
      pass: process.env.EMAIL_PASS  
    }
  });

  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: 'Votre code de vérification StudentHop',
    text: `Votre code de vérification est: ${otp}`,
    html: `<p>Votre code de vérification est: <strong>${otp}</strong></p>`
  };

  await transporter.sendMail(mailOptions);
}

// Route POST pour vérifier l'OTP
// Route POST pour vérifier l'OTP
router.post('/verify-opt', async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).json({ success: false, message: 'Email et OTP requis' });
  }

  try {
    const result = await pool.query(
      'SELECT otp, otp_expires, role FROM utilisateur WHERE email = $1',
      [email]
    );

    const user = result.rows[0];
    if (!user) {
      return res.status(404).json({ success: false, message: 'Utilisateur non trouvé' });
    }

    // Vérifier si l’OTP correspond
    if (user.otp !== otp) {
      return res.status(400).json({ success: false, message: 'Code OTP invalide' });
    }

    // Vérifier si l’OTP n’a pas expiré
    if (new Date() > new Date(user.otp_expires)) {
      return res.status(400).json({ success: false, message: 'Code OTP expiré' });
    }

    // Supprimer l’OTP ou le marquer comme utilisé
    await pool.query(
      'UPDATE utilisateur SET otp = NULL, otp_expires = NULL WHERE email = $1',
      [email]
    );

    // ✅ Retourner le rôle avec la réponse
    return res.status(200).json({
      success: true,
      message: 'OTP vérifié avec succès',
      role: user.role, // <-- ajout du rôle ici
    });

  } catch (error) {
    console.error('Erreur vérification OTP:', error);
    return res.status(500).json({ success: false, message: 'Erreur serveur lors de la vérification' });
  }
});


/* Dans votre fichier de routes users
router.get('/protected-route', authenticateToken, (req, res) => {
    res.json({
        success: true,
        message: "Accès autorisé à une ressource protégée",
        user: req.user,
        sensitiveData: {
            lastLogin: new Date().toISOString(),
            permissions: ["read", "write"]
        }
    });
});*/
module.exports = router;
