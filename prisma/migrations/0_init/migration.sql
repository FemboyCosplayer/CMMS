-- CreateTable usuarios
CREATE TABLE `usuarios` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `rol` VARCHAR(50) NOT NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `ultimo_acceso` DATETIME(3) NULL,
    `intentos_fallidos` INTEGER NOT NULL DEFAULT 0,
    `bloqueado_hasta` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `usuarios_email_key`(`email`),
    INDEX `usuarios_email_idx`(`email`),
    INDEX `usuarios_rol_idx`(`rol`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable equipos
CREATE TABLE `equipos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `codigo` VARCHAR(50) NOT NULL,
    `nombre` VARCHAR(255) NOT NULL,
    `tipo` VARCHAR(100) NOT NULL,
    `marca` VARCHAR(100) NULL,
    `modelo` VARCHAR(100) NULL,
    `numero_serie` VARCHAR(100) NULL,
    `ubicacion` VARCHAR(255) NULL,
    `fecha_adquisicion` DATETIME(3) NULL,
    `vida_util_anos` INTEGER NULL,
    `valor_adquisicion` DECIMAL(10,2) NULL,
    `estado` VARCHAR(50) NOT NULL,
    `criticidad` VARCHAR(50) NOT NULL,
    `descripcion` LONGTEXT NULL,
    `especificaciones` JSON NULL,
    `ultima_mantencion` DATETIME(3) NULL,
    `proxima_mantencion` DATETIME(3) NULL,
    `horas_operacion` DECIMAL(10,2) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `equipos_codigo_key`(`codigo`),
    INDEX `equipos_codigo_idx`(`codigo`),
    INDEX `equipos_estado_idx`(`estado`),
    INDEX `equipos_tipo_idx`(`tipo`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable ordenes_trabajo
CREATE TABLE `ordenes_trabajo` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `numero_orden` VARCHAR(50) NOT NULL,
    `equipo_id` INTEGER NOT NULL,
    `tipo` VARCHAR(50) NOT NULL,
    `prioridad` VARCHAR(50) NOT NULL,
    `estado` VARCHAR(50) NOT NULL,
    `descripcion` LONGTEXT NOT NULL,
    `fecha_solicitud` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `fecha_programada` DATETIME(3) NULL,
    `fecha_inicio` DATETIME(3) NULL,
    `fecha_finalizacion` DATETIME(3) NULL,
    `tiempo_estimado` INTEGER NULL,
    `tiempo_real` INTEGER NULL,
    `costo_estimado` DECIMAL(10,2) NULL,
    `costo_real` DECIMAL(10,2) NULL,
    `creado_por` INTEGER NOT NULL,
    `asignado_a` INTEGER NULL,
    `notas` LONGTEXT NULL,
    `resultado` LONGTEXT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `ordenes_trabajo_numero_orden_key`(`numero_orden`),
    INDEX `ordenes_trabajo_numero_orden_idx`(`numero_orden`),
    INDEX `ordenes_trabajo_equipo_id_idx`(`equipo_id`),
    INDEX `ordenes_trabajo_estado_idx`(`estado`),
    INDEX `ordenes_trabajo_prioridad_idx`(`prioridad`),
    INDEX `ordenes_trabajo_creado_por_idx`(`creado_por`),
    INDEX `ordenes_trabajo_asignado_a_idx`(`asignado_a`),
    CONSTRAINT `ordenes_trabajo_equipo_id_fkey` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `ordenes_trabajo_creado_por_fkey` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE,
    CONSTRAINT `ordenes_trabajo_asignado_a_fkey` FOREIGN KEY (`asignado_a`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE,
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable mantenimientos
CREATE TABLE `mantenimientos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `equipo_id` INTEGER NOT NULL,
    `tipo` VARCHAR(50) NOT NULL,
    `frecuencia` VARCHAR(50) NOT NULL,
    `frecuencia_dias` INTEGER NOT NULL,
    `ultima_realizacion` DATETIME(3) NULL,
    `proxima_programada` DATETIME(3) NOT NULL,
    `descripcion` LONGTEXT NOT NULL,
    `procedimiento` LONGTEXT NULL,
    `tiempo_estimado` INTEGER NULL,
    `activo` BOOLEAN NOT NULL DEFAULT true,
    `creado_por` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `mantenimientos_equipo_id_idx`(`equipo_id`),
    INDEX `mantenimientos_proxima_programada_idx`(`proxima_programada`),
    INDEX `mantenimientos_activo_idx`(`activo`),
    CONSTRAINT `mantenimientos_equipo_id_fkey` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `mantenimientos_creado_por_fkey` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE,
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable mantenimientos_realizados
CREATE TABLE `mantenimientos_realizados` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `mantenimiento_id` INTEGER NOT NULL,
    `equipo_id` INTEGER NOT NULL,
    `fecha_realizacion` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `realizado_por` INTEGER NOT NULL,
    `tiempo_real` INTEGER NULL,
    `costo` DECIMAL(10,2) NULL,
    `observaciones` LONGTEXT NULL,
    `tareas_realizadas` JSON NULL,
    `estado_equipo` VARCHAR(50) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `mantenimientos_realizados_mantenimiento_id_idx`(`mantenimiento_id`),
    INDEX `mantenimientos_realizados_equipo_id_idx`(`equipo_id`),
    INDEX `mantenimientos_realizados_fecha_realizacion_idx`(`fecha_realizacion`),
    CONSTRAINT `mantenimientos_realizados_mantenimiento_id_fkey` FOREIGN KEY (`mantenimiento_id`) REFERENCES `mantenimientos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `mantenimientos_realizados_equipo_id_fkey` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `mantenimientos_realizados_realizado_por_fkey` FOREIGN KEY (`realizado_por`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE,
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable documentos
CREATE TABLE `documentos` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tipo` VARCHAR(50) NOT NULL,
    `nombre` VARCHAR(255) NOT NULL,
    `descripcion` LONGTEXT NULL,
    `ruta_archivo` VARCHAR(500) NOT NULL,
    `tipo_archivo` VARCHAR(50) NOT NULL,
    `tamano` INTEGER NOT NULL,
    `equipo_id` INTEGER NULL,
    `orden_id` INTEGER NULL,
    `subido_por` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `documentos_equipo_id_idx`(`equipo_id`),
    INDEX `documentos_orden_id_idx`(`orden_id`),
    INDEX `documentos_tipo_idx`(`tipo`),
    CONSTRAINT `documentos_equipo_id_fkey` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `documentos_orden_id_fkey` FOREIGN KEY (`orden_id`) REFERENCES `ordenes_trabajo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `documentos_subido_por_fkey` FOREIGN KEY (`subido_por`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE,
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable notificaciones
CREATE TABLE `notificaciones` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `usuario_id` INTEGER NOT NULL,
    `tipo` VARCHAR(50) NOT NULL,
    `titulo` VARCHAR(255) NOT NULL,
    `mensaje` LONGTEXT NOT NULL,
    `leida` BOOLEAN NOT NULL DEFAULT false,
    `fecha_envio` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `datos` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `notificaciones_usuario_id_idx`(`usuario_id`),
    INDEX `notificaciones_leida_idx`(`leida`),
    INDEX `notificaciones_tipo_idx`(`tipo`),
    CONSTRAINT `notificaciones_usuario_id_fkey` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable logs
CREATE TABLE `logs` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `usuario_id` INTEGER NULL,
    `accion` VARCHAR(100) NOT NULL,
    `modulo` VARCHAR(50) NOT NULL,
    `descripcion` LONGTEXT NOT NULL,
    `ip_address` VARCHAR(45) NULL,
    `user_agent` LONGTEXT NULL,
    `datos` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `logs_usuario_id_idx`(`usuario_id`),
    INDEX `logs_accion_idx`(`accion`),
    INDEX `logs_modulo_idx`(`modulo`),
    INDEX `logs_created_at_idx`(`created_at`),
    CONSTRAINT `logs_usuario_id_fkey` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable configuracion
CREATE TABLE `configuracion` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `clave` VARCHAR(100) NOT NULL,
    `valor` LONGTEXT NULL,
    `descripcion` VARCHAR(255) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `configuracion_clave_key`(`clave`),
    INDEX `configuracion_clave_idx`(`clave`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
