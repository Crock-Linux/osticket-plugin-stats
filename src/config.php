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

require_once(INCLUDE_DIR.'/class.forms.php');

class StatsConfig extends PluginConfig
{

    const DEFAULT_TICKET_SUBJECT_SUPPORT = '[%-_] %';
    const DEFAULT_TICKET_SUBJECT_SALES = '[LibreDTE] Ventas % %-_ #%';

    // Provide compatibility function for versions of osTicket prior to
    // translation support (v1.9.4)
    public function translate()
    {
        if (!method_exists('Plugin', 'translate')) {
            return array(
                function($x) { return $x; },
                function($x, $y, $n) { return $n != 1 ? $y : $x; },
            );
        }
        return Plugin::translate('stats');
    }

    public function getOptions()
    {
        list($__, $_N) = self::translate();
        return [
            'stats' => new SectionBreakField([
                'label' => $__('Stats'),
                'hint' => $__('Global configuration for the stats plugin'),
            ]),
            'stats-sales' => new SectionBreakField([
                'label' => $__('Ticket Subjects'),
                'hint' => $__('Format of subjects in tickets for filtering'),
            ]),
            'stats-ticket-subject-support' => new TextboxField([
                'label' => $__('Support'),
                'hint' => $__('Format of subjects from support tickets'),
                'configuration' => ['size'=>80, 'length'=>100],
                'placeholder' => self::DEFAULT_TICKET_SUBJECT_SUPPORT,
            ]),
            'stats-ticket-subject-sales' => new TextboxField([
                'label' => $__('Sales'),
                'hint' => $__('Format of subjects from sales tickets'),
                'configuration' => ['size'=>80, 'length'=>100],
                'placeholder' => self::DEFAULT_TICKET_SUBJECT_SALES,
            ]),
        ];
    }

    public function pre_save(&$config, &$errors)
    {
        global $msg;
        list($__, $_N) = self::translate();
        if (!$errors) {
            $msg = $__('Configuration updated successfully');
        }
        return true;
    }

}
