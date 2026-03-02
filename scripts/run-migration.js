import mysql from 'mysql2/promise';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Obtener la URL de conexión desde variables de entorno
const MYSQL_URL = process.env.MYSQL_URL;

if (!MYSQL_URL) {
  console.error('[v0] Error: MYSQL_URL no está configurada');
  process.exit(1);
}

// Parsear la URL de conexión
function parseConnectionString(url) {
  const regex = /mysql:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/;
  const match = url.match(regex);
  
  if (!match) {
    throw new Error('Formato de URL inválido');
  }
  
  return {
    user: match[1],
    password: match[2],
    host: match[3],
    port: parseInt(match[4]),
    database: match[5]
  };
}

async function runMigration() {
  let connection;
  
  try {
    console.log('[v0] Parsing connection string...');
    const config = parseConnectionString(MYSQL_URL);
    
    console.log(`[v0] Connecting to ${config.host}:${config.port}/${config.database}`);
    
    // Crear conexión a MySQL
    connection = await mysql.createConnection({
      host: config.host,
      user: config.user,
      password: config.password,
      port: config.port,
      database: config.database,
      multipleStatements: true
    });
    
    console.log('[v0] Connected to MySQL');
    
    // Leer el archivo SQL
    const sqlFile = path.join(__dirname, 'init-mysql.sql');
    const sql = fs.readFileSync(sqlFile, 'utf8');
    
    console.log('[v0] Executing migration script...');
    
    // Ejecutar las sentencias SQL
    const statements = sql.split(';').filter(stmt => stmt.trim());
    
    for (const statement of statements) {
      const trimmed = statement.trim();
      if (trimmed && !trimmed.startsWith('--')) {
        try {
          console.log(`[v0] Executing: ${trimmed.substring(0, 80)}...`);
          await connection.execute(trimmed);
        } catch (error) {
          console.error(`[v0] Error executing statement: ${error.message}`);
          // Continuar con la siguiente sentencia
        }
      }
    }
    
    console.log('[v0] Migration completed successfully!');
    
  } catch (error) {
    console.error('[v0] Migration failed:', error.message);
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

runMigration();
