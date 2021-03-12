#!/usr/bin/php
<?php

/**
 * Plugin for osTicket for statistics from tickets.
 * Copyright (C) 2021 SASCO SpA (https://sasco.cl)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

// ¡IMPORTANTE!
// Para poder crear el archivo phar la opción phar.readonly en php.ini debe ser 0

// nombre del archivo phar que se generará
$pharFile = 'sasco-stats.phar';

// se borran los archivos phar si existían previamente
if (file_exists($pharFile)) {
    unlink($pharFile);
}
if (file_exists($pharFile . '.gz')) {
    unlink($pharFile . '.gz');
}

// crear el objeto phar
$p = new Phar($pharFile);

// crear el plugin con todo el contenido de src
$p->buildFromDirectory('src/');

// entregar comprimido como GZIP
$p->compress(Phar::GZ);

// todo ok
echo $pharFile,' archivo phar generado',"\n";
