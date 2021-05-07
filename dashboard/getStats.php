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

// datos para conexión a la API de osTicket usando el Plugin sasco:stats
$url = getenv('OSTICKET_URL');
if (empty($url)) {
    die('Falta definir la variable de entorno OSTICKET_URL' . PHP_EOL);
}
$api_key = getenv('OSTICKET_API_KEY');
if (empty($api_key)) {
    die('Falta definir la variable de entorno OSTICKET_API_KEY' . PHP_EOL);
}

// generar fechas que se buscarán
$current_date_from = !empty($argv[1]) ? date('Y-m-d', strtotime($argv[1])) : date('Y-m').'-01';
$current_date_to = !empty($argv[2]) ? date('Y-m-d', strtotime($argv[2])) : date('Y-m-t', strtotime($current_date_from));
$previous_date_from = date('Y-m-d', strtotime($current_date_from . ' - 1 month'));
$previous_date_to = date('Y-m-d', strtotime($current_date_from . ' - 1 day'));
$day = !empty($argv[1]) ? date('Y-m-d', strtotime($argv[1])) : date('Y-m-d');
$dates = [
    'current' => [
        'from' => $current_date_from,
        'to' => $current_date_to,
    ],
    'previous' => [
        'from' => $previous_date_from,
        'to' => $previous_date_to,
    ],
    'day' => [
        'from' => $day,
        'to' => $day,
    ],
];

// consultas que se necesitan para las estadísticas
$queries_required = [
    'agents',
    'agents_entry_created_by_hour_group_by_agent',
    'tickets_created_by_day_and_hour',
    'sales',
    'clients',
    'tickets_overdue',
    'agents_last_response_by_ticket',
    'tickets_created_2_years',
];

// realizar consulta por cada rango de fechas
$dir = dirname(__FILE__) . DIRECTORY_SEPARATOR . 'json';
if (!is_dir($dir)) {
    mkdir($dir);
}
foreach ($dates as $type => $date) {
    $query_url = sprintf(
        $url.'/api/http.php/stats/all.json?date_from=%s&date_to=%s&queries=%s',
        $date['from'],
        $date['to'],
        implode(',', $queries_required)
    );
    $stats = file_get_contents($query_url, false, stream_context_create([
        'http' => [
            'method' => 'GET',
            'header' => 'X-API-Key: '.$api_key
        ]
    ]));
    file_put_contents($dir . DIRECTORY_SEPARATOR . 'stats-'.$type.'.json', $stats);
}
