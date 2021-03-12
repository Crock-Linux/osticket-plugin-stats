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

require_once(INCLUDE_DIR.'class.plugin.php');
require_once(INCLUDE_DIR.'class.signal.php');
require_once('config.php');

define('STATS_PLUGIN_ROOT', dirname(__FILE__));

spl_autoload_register(['StatsPlugin', 'autoload']);

/**
 * Clase que crea las rutas necesarias para ser despachadas al llamar al plugin
 * @author Esteban De La Fuente Rubio, DeLaF (esteban[at]sasco.cl)
 * @version 2021-03-11
 */
class StatsPlugin extends Plugin
{

    public $config_class = 'StatsConfig';

    public static function autoload($className)
    {
        $className = ltrim($className, '\\');
        $fileName = '';
        $namespace = '';
        if ($lastNsPos = strrpos($className, '\\')) {
            $namespace = substr($className, 0, $lastNsPos);
            $className = substr($className, $lastNsPos + 1);
            $fileName = str_replace('\\', DIRECTORY_SEPARATOR, $namespace) . DIRECTORY_SEPARATOR;
        }
        $fileName .= str_replace('_', DIRECTORY_SEPARATOR, $className) . '.php';
        $fileName = 'include/' . $fileName;
        if (file_exists ( STATS_PLUGIN_ROOT . DIRECTORY_SEPARATOR . $fileName )) {
            require $fileName;
        }
    }

    public function bootstrap()
    {
        if($this->firstRun()) {
            $this->install();
        }
        Signal::connect('api', [
            'StatsPlugin',
            'callbackDispatch'
        ]);
    }

    private function firstRun()
    {
        return (db_num_rows(db_query('SHOW TABLES LIKE "stats_%"')) == 0);
    }

    private function install()
    {
        $config = $this->getConfig();
        $replace = [
            'SUBJECT_SUPPORT_LIKE' => $config->get('stats-ticket-subject-support')
                                        ? $config->get('stats-ticket-subject-support')
                                        : StatsConfig::DEFAULT_TICKET_SUBJECT_SUPPORT,
            'SUBJECT_SALES_LIKE' => $config->get('stats-ticket-subject-sales')
                                        ? $config->get('stats-ticket-subject-sales')
                                        : StatsConfig::DEFAULT_TICKET_SUBJECT_SALES,
        ];
        $queries = str_replace(
            array_map(function($k) {return '{'.$k.'}';}, array_keys($replace)),
            array_values($replace),
            file_get_contents(STATS_PLUGIN_ROOT . '/sql/install.sql')
        );
        $this->multiquery($queries);
    }

    public function pre_uninstall()
    {
        $this->multiquery(file_get_contents(STATS_PLUGIN_ROOT . '/sql/uninstall.sql'));
    }

    private function multiquery($queries)
    {
        $queries = explode(';',$queries);
        foreach($queries as $query) {
            db_query($query);
        }
    }

    static public function callbackDispatch($object, $data)
    {
        $object->append(url('^/stats/',
            patterns('StatsApiController',
                url_get("^all\.(?P<format>json|xml)$", 'all'),
            )
        ));
    }

}
