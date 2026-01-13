const mysql = require('mysql2');
require('dotenv').config();

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

db.connect((err) => {
  if (err) {
    console.error('❌ Error al conectar a MySQL:', err.message);
    return;
  }
  console.log('✅ Conexión a MySQL exitosa.');

  const createTable = `
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100),
      phone VARCHAR(20) UNIQUE NOT NULL,
      pin VARCHAR(100) NOT NULL
    )
  `;

  db.query(createTable, (err) => {
    if (err) {
      console.error('❌ Error al crear la tabla:', err.message);
    } else {
      console.log('✅ Tabla users lista.');
    }
  });
});

module.exports = db;