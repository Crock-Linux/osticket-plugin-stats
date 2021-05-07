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

require_once(INCLUDE_DIR.'class.api.php');

define('STATS_PLUGIN_ROOT', dirname(dirname(__FILE__)));

/**
 * Controlador de las estadísticas vía API
 * @author Esteban De La Fuente Rubio, DeLaF (esteban[at]sasco.cl)
 * @version 2021-03-13
 */
class StatsApiController extends ApiController
{

    public function all($format)
    {
        // check api key
        $this->requireApiKey();
        // set from and to
        $date_from = !empty($_GET['date_from']) ? date('Y-m-d', strtotime($_GET['date_from'])) : date('Y-m').'-01';
        $date_to = !empty($_GET['date_to']) ? date('Y-m-d', strtotime($_GET['date_to'])) : date('Y-m-t', strtotime($date_from));
        $queries = !empty($_GET['queries']) ? explode(',', $_GET['queries']) : [];
        // get timezone
        global $ost;
        $timezone = (new DateTime('now', new DateTimeZone($ost->getConfig()->getTimezone())))->format('P');
        // create response with all the queries availables
        $response = [
            'osticket' => [
                'url' => $ost->getConfig()->getBaseUrl(),
            ],
            'date' => [
                'from' => $date_from,
                'to' => $date_to,
                'timezone' => $timezone
            ],
            'stats' => []
        ];
        foreach ($this->getQueries($queries) as $name => $query) {
            $response['stats'][$name] = $this->query(
                $query,
                [
                    ':date_from' => $date_from,
                    ':date_to' => $date_to.' 23:59:59',
                    ':timezone' => $timezone,
                ]
            );
        }
        // prepare response from result
        if ($format == 'json') {
            $response = json_encode($response);
        } else if ($format == 'xml') {
            // TODO: return XML from array result
            return $this->exerr(405, __('Format XML not allowed, please, use JSON instead'));
        }
        // return results in the format requested
        $this->response(200, $response, 'application/'.$format);
    }

    private function getQueries(array $queries_required = [])
    {
        $dir = STATS_PLUGIN_ROOT . '/sql/queries';
        $filesAux = scandir($dir);
        $queries = [];
        foreach($filesAux as &$file) {
            if ($file[0] != '.') {
                $query_name = substr($file, 0, -4);
                if (empty($queries_required) || in_array($query_name, $queries_required)) {
                    $queries[$query_name] = file_get_contents($dir . '/' . $file);
                }
            }
        }
        return $queries;
    }

    private function query($query, array $params = [])
    {
        $query = str_replace(array_keys($params), array_map(function($p){return '\''.$p.'\'';}, $params), $query);
        $res = db_query($query);
        if ($res === false) {
            return $this->exerr(500, __('SQL error: empty res from db_query'));
        }
        $result = db_assoc_array($res);
        db_free_result($res);
        return $result;
    }

    public function response($code, $resp, $contentType = 'text/html', $charset = 'UTF-8')
    {
        Http::response($code, $resp, $contentType, $charset);
        exit();
    }

}
