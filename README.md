# hofmann-menu
Hofmann-Menü Bestellungen ohne grossen Zeitaufwand verwalten.

Voraussetzungen:
a) Webserver (lokal) mit MySQL/Maria-DB
b) PHP Script "Adminer" (https://www.adminer.org/)

Schritte:
1) Neue Datenbank in Adminer anlegen und SQL-Datei importieren
2) Konfiguration der "users" and "meals" Tabellen (einige Mahlzeiten sind bereits eingegeben)
3) Bestellungen täglich erfassen in Tabelle "meals_users"
4) "offene_posten" View zeigt an, wer wieviel zu zahlen hat.
5) Bezahlung muss derzeit noch manuell erfolgen:
Adminer > SQL:

UPDATE meals_users 
SET payment_date = 'yyymmdd' 
WHERE user_alias='xy' AND payment_date IS NULL AND issue_date <= 'yyymmdd';

(Entsprechende Platzhalter ersetzen)

Ich nummeriere die abgegebenen Coupons mit der zurückgegebenen ID von Adminer und hefte sie zu Nachweiszwecken in numerischer Reihenfolge ab.

