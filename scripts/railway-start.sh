#!/bin/bash
set -e

echo "🚀 Starting Railway deployment with MySQL..."

# Verificar que MYSQL_URL esté configurada
if [ -z "$MYSQL_URL" ] && [ -z "$DATABASE_URL" ]; then
  echo "❌ ERROR: MYSQL_URL o DATABASE_URL no está configurada"
  exit 1
fi

# Usar MYSQL_URL si está disponible, si no usar DATABASE_URL
DB_URL="${MYSQL_URL:-$DATABASE_URL}"
echo "✅ Base de datos configurada: ${DB_URL:0:50}..."

# Asegurar que la URL tiene la base de datos especificada
# Si no la tiene, agregar /cmms_biomedico
if [[ ! "$DB_URL" =~ /[a-zA-Z_]+$ ]]; then
  DB_URL="${DB_URL%/}/cmms_biomedico"
  echo "✅ Base de datos agregada a la URL: .../$DB_URL"
fi

# Exportar la variable para Prisma
export MYSQL_URL="$DB_URL"
export DATABASE_URL="$DB_URL"

# Generar cliente Prisma
echo "⚙️  Generando cliente Prisma..."
rm -rf .prisma 2>/dev/null || true
rm -rf node_modules/.prisma 2>/dev/null || true
npx prisma generate
echo "✅ Cliente Prisma generado con éxito"

# Crear/actualizar todas las tablas automáticamente
echo "📦 Ejecutando migraciones de Prisma..."
npx prisma migrate deploy --skip-generate 2>/dev/null || npx prisma db push --accept-data-loss --skip-generate

echo "✅ Migraciones completadas"

# Ejecutar seed si es necesario
echo "🌱 Cargando datos iniciales..."
npm run db:seed 2>/dev/null || echo "⚠️  Seed no ejecutado (puede que no exista el archivo seed.ts)"

echo "🎉 Deployment completado, iniciando servidor Next.js..."
echo "📡 Servidor escuchando en puerto 3000"
npm run start
