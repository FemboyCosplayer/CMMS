-- ============================================
-- CMMS - Base de Datos MySQL
-- Auto-initialize script para Railway
-- Compatible con Prisma Schema
-- ============================================

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ============================================
-- TABLA: Usuarios
-- ============================================
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `nombre` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `rol` VARCHAR(50) NOT NULL,
  `activo` BOOLEAN NOT NULL DEFAULT true,
  `ultimo_acceso` DATETIME,
  `intentos_fallidos` INT NOT NULL DEFAULT 0,
  `bloqueado_hasta` DATETIME,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_email` (`email`),
  INDEX `idx_rol` (`rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: Equipos
-- ============================================
CREATE TABLE IF NOT EXISTS `equipos` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `codigo` VARCHAR(50) NOT NULL UNIQUE,
  `nombre` VARCHAR(255) NOT NULL,
  `tipo` VARCHAR(100) NOT NULL,
  `marca` VARCHAR(100),
  `modelo` VARCHAR(100),
  `numero_serie` VARCHAR(100),
  `ubicacion` VARCHAR(255),
  `fecha_adquisicion` DATETIME,
  `vida_util_anos` INT,
  `valor_adquisicion` DECIMAL(10, 2),
  `estado` VARCHAR(50) NOT NULL,
  `criticidad` VARCHAR(50) NOT NULL,
  `descripcion` LONGTEXT,
  `especificaciones` JSON,
  `ultima_mantencion` DATETIME,
  `proxima_mantencion` DATETIME,
  `horas_operacion` DECIMAL(10, 2),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_codigo` (`codigo`),
  INDEX `idx_estado` (`estado`),
  INDEX `idx_tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: Órdenes de Trabajo
-- ============================================
CREATE TABLE IF NOT EXISTS `ordenes_trabajo` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `numero_orden` VARCHAR(50) NOT NULL UNIQUE,
  `equipo_id` INT NOT NULL,
  `tipo` VARCHAR(50) NOT NULL,
  `prioridad` VARCHAR(50) NOT NULL,
  `estado` VARCHAR(50) NOT NULL,
  `descripcion` LONGTEXT NOT NULL,
  `fecha_solicitud` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_programada` DATETIME,
  `fecha_inicio` DATETIME,
  `fecha_finalizacion` DATETIME,
  `tiempo_estimado` INT,
  `tiempo_real` INT,
  `costo_estimado` DECIMAL(10, 2),
  `costo_real` DECIMAL(10, 2),
  `creado_por` INT NOT NULL,
  `asignado_a` INT,
  `notas` LONGTEXT,
  `resultado` LONGTEXT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`equipo_id`) REFERENCES `equipos`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`creado_por`) REFERENCES `usuarios`(`id`),
  FOREIGN KEY (`asignado_a`) REFERENCES `usuarios`(`id`),
  INDEX `idx_numero_orden` (`numero_orden`),
  INDEX `idx_equipo_id` (`equipo_id`),
  INDEX `idx_estado` (`estado`),
  INDEX `idx_prioridad` (`prioridad`),
  INDEX `idx_creado_por` (`creado_por`),
  INDEX `idx_asignado_a` (`asignado_a`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: Mantenimientos
-- ============================================
CREATE TABLE IF NOT EXISTS `mantenimientos` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `equipo_id` INT NOT NULL,
  `tipo` VARCHAR(50) NOT NULL,
  `frecuencia` VARCHAR(50) NOT NULL,
  `frecuencia_dias` INT NOT NULL,
  `ultima_realizacion` DATETIME,
  `proxima_programada` DATETIME NOT NULL,
  `descripcion` LONGTEXT NOT NULL,
  `procedimiento` LONGTEXT,
  `tiempo_estimado` INT,
  `activo` BOOLEAN NOT NULL DEFAULT true,
  `creado_por` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`equipo_id`) REFERENCES `equipos`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`creado_por`) REFERENCES `usuarios`(`id`),
  INDEX `idx_equipo_id` (`equipo_id`),
  INDEX `idx_proxima_programada` (`proxima_programada`),
  INDEX `idx_activo` (`activo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: Mantenimientos Realizados
-- ============================================
CREATE TABLE IF NOT EXISTS `mantenimientos_realizados` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `mantenimiento_id` INT NOT NULL,
  `equipo_id` INT NOT NULL,
  `fecha_realizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `realizado_por` INT NOT NULL,
  `tiempo_real` INT,
  `costo` DECIMAL(10, 2),
  `observaciones` LONGTEXT,
  `tareas_realizadas` JSON,
  `estado_equipo` VARCHAR(50),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`mantenimiento_id`) REFERENCES `mantenimientos`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`equipo_id`) REFERENCES `equipos`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`realizado_por`) REFERENCES `usuarios`(`id`),
  INDEX `idx_mantenimiento_id` (`mantenimiento_id`),
  INDEX `idx_equipo_id` (`equipo_id`),
  INDEX `idx_fecha_realizacion` (`fecha_realizacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: Documentos
-- ============================================
CREATE TABLE IF NOT EXISTS `documentos` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `tipo` VARCHAR(50) NOT NULL,
  `nombre` VARCHAR(255) NOT NULL,
  `descripcion` LONGTEXT,
  `ruta_archivo` VARCHAR(500) NOT NULL,
  `tipo_archivo` VARCHAR(50) NOT NULL,
  `tamano` INT NOT NULL,
  `equipo_id` INT,
  `orden_id` INT,
  `subido_por` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`equipo_id`) REFERENCES `equipos`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`orden_id`) REFERENCES `ordenes_trabajo`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`subido_por`) REFERENCES `usuarios`(`id`),
  INDEX `idx_equipo_id` (`equipo_id`),
  INDEX `idx_orden_id` (`orden_id`),
  INDEX `idx_tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: Notificaciones
-- ============================================
CREATE TABLE IF NOT EXISTS `notificaciones` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `usuario_id` INT NOT NULL,
  `tipo` VARCHAR(50) NOT NULL,
  `titulo` VARCHAR(255) NOT NULL,
  `mensaje` LONGTEXT NOT NULL,
  `leida` BOOLEAN NOT NULL DEFAULT false,
  `fecha_envio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `datos` JSON,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`usuario_id`) REFERENCES `usuarios`(`id`) ON DELETE CASCADE,
  INDEX `idx_usuario_id` (`usuario_id`),
  INDEX `idx_leida` (`leida`),
  INDEX `idx_tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: Logs
-- ============================================
CREATE TABLE IF NOT EXISTS `logs` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `usuario_id` INT,
  `accion` VARCHAR(100) NOT NULL,
  `modulo` VARCHAR(50) NOT NULL,
  `descripcion` LONGTEXT NOT NULL,
  `ip_address` VARCHAR(45),
  `user_agent` LONGTEXT,
  `datos` JSON,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`usuario_id`) REFERENCES `usuarios`(`id`) ON DELETE SET NULL,
  INDEX `idx_usuario_id` (`usuario_id`),
  INDEX `idx_accion` (`accion`),
  INDEX `idx_modulo` (`modulo`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: Configuración
-- ============================================
CREATE TABLE IF NOT EXISTS `configuracion` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `clave` VARCHAR(100) NOT NULL UNIQUE,
  `valor` LONGTEXT,
  `descripcion` VARCHAR(255),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_clave` (`clave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Insertar datos de ejemplo
-- ============================================

-- Usuario Administrador
INSERT IGNORE INTO `usuarios` (`nombre`, `email`, `password`, `rol`, `activo`) 
VALUES ('Administrador', 'admin@cmms.local', 'admin123', 'admin', true);

-- Usuario Supervisor
INSERT IGNORE INTO `usuarios` (`nombre`, `email`, `password`, `rol`, `activo`) 
VALUES ('Supervisor', 'supervisor@cmms.local', 'supervisor123', 'supervisor', true);

-- Usuarios Técnicos
INSERT IGNORE INTO `usuarios` (`nombre`, `email`, `password`, `rol`, `activo`) 
VALUES 
  ('Juan Pérez', 'juan@cmms.local', 'tecnico123', 'tecnico', true),
  ('María García', 'maria@cmms.local', 'tecnico123', 'tecnico', true),
  ('Carlos Rodríguez', 'carlos@cmms.local', 'tecnico123', 'tecnico', true);
