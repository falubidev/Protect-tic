const db = require('../db/connection');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
require('dotenv').config();

const registerUser = async (req, res) => {
  const { name, phone, pin } = req.body;

  if (!name || !phone || !pin) {
    return res.status(400).json({ error: 'Faltan datos' });
  }

  const phoneRegex = /^\d{10}$/;
  if (!phoneRegex.test(phone)) {
    return res.status(400).json({ error: 'El número telefónico debe tener exactamente 10 dígitos' });
  }

  const pinRegex = /^\d{4}$/;
  if (!pinRegex.test(pin)) {
    return res.status(400).json({ error: 'El PIN debe tener exactamente 4 dígitos' });
  }

  try {
    const hashedPin = await bcrypt.hash(pin, 10); 

    const query = 'INSERT INTO users (name, phone, pin) VALUES (?, ?, ?)';
    db.query(query, [name, phone, hashedPin], (err) => {
      if (err) {
        if (err.code === 'ER_DUP_ENTRY') {
          return res.status(409).json({ error: 'Este número ya está registrado' });
        }
        console.log(err);
        return res.status(500).json({ error: 'Error en base de datos' });
      }

      res.json({ message: 'Usuario registrado correctamente' });
    });
  } catch (error) {
    return res.status(500).json({ error: 'Error al procesar el PIN' });
  }
};

const loginUser = (req, res) => {
  const { phone, pin } = req.body;

  const query = 'SELECT * FROM users WHERE phone = ?';
  db.query(query, [phone], async (err, results) => {
    if (err) return res.status(500).json({ error: 'Error en la base de datos' });

    if (results.length === 0) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    const user = results[0];

    const isMatch = await bcrypt.compare(pin, user.pin);
    if (!isMatch) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    const token = jwt.sign(
      { id: user.id, phone: user.phone },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    res.json({ message: 'Inicio de sesión exitoso', token, name: user.name });
  });
};

module.exports = { registerUser, loginUser };
