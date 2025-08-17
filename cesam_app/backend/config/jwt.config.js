const crypto = require('crypto');

module.exports = {
  jwt: {
    secret: process.env.JWT_SECRET,
    algorithms: ['HS512'],
    accessExpiration: '15m',
    refreshExpiration: '7d',
    issuer: 'CESAM',
    audience: 'mobile-app',
    refreshSecret: process.env.JWT_SECRET + crypto.randomBytes(16).toString('hex')
  },
  cookieOptions: {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'Strict',
    domain: process.env.COOKIE_DOMAIN || 'localhost',
    path: '/',
    maxAge: 7 * 24 * 60 * 60 * 1000
  }
};
