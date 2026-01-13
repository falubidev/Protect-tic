const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
require('dotenv').config();

const app = express();

// ✅ Permitir peticiones desde cualquier origen (útil para pruebas locales desde el celular)
app.use(cors({
  origin: '*', // Permite todas las conexiones temporalmente
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type'],
}));

app.use(express.json());

// Ruta de prueba
app.get('/', (req, res) => {
  res.send('🟢 API ProtecTIC funcionando correctamente');
});

// Rutas de autenticación y registro
app.use('/', authRoutes);

// Puerto del backend
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ Backend ProtecTIC escuchando en http://localhost:${PORT}`);
});
