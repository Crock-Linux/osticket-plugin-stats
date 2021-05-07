osTicket Plugin Stats
=====================

Plugin for osTicket for creating stats fromt tickets data.

You can get all the statistics with something like this:

    https://osticket.example.com/api/http.php/stats/all.json?date_from=&date_to=

The API return a JSON object with the fields:

- osticket
- date
- stats

The stats currently are created with 18 queries. The sames in the [src/sql/queries](https://github.com/sascocl/osticket-plugin-stats/tree/master/src/sql/queries) folder.

You can pass 3 variables via GET (in the URL):

- date_from: optional, by default the first day of the current month.
- date_to: optional, by default the last day of the month of date_from.
- queries: optional, a list separated by comma with the stats you want to get

In the [dashboard directory](https://github.com/sascocl/osticket-plugin-stats/tree/master/dashboard) is an example of a dashboard that uses the plugin for extracting the data of the statistics.

License of the project: AGPL
