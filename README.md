osTicket Plugin Stats
=====================

Plugin for osTicket for creating stats fromt tickets data.

You can get all the statistics with something like this:

    https://osticket.example.com/api/http.php/stats/all.json?date_from=&date_to=

The API return a JSON object with the fields:

- date
- stats

The stats currently are created with 11 queries. The sames in the [src/sql/queries folder](https://github.com/sascocl/osticket-plugin-stats/tree/master/src/sql/queries).

You can pass 2 variables via GET (in the URL):

- date_from: optional, by default the first day of the current month.
- date_to: optional, by default the last day of the month of date_from.

License of the project: AGPL
