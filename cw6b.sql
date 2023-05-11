use firma;
--a) Zmodyfikuj numer telefonu w tabeli pracownicy, dodaj¹c do niego kierunkowy dla Polski w nawiasie (+48)
UPDATE ksiegowosc.pracownicy 
SET telefon = REPLACE(ksiegowosc.pracownicy.telefon,'+48', '(+48)');
SELECT * FROM ksiegowosc.pracownicy;


--b) Zmodyfikuj atrybut telefon w tabeli pracownicy tak, aby numer oddzielony by³ myœlnikami wg wzoru: ‘555-222-333’ 
UPDATE ksiegowosc.pracownicy 
SET telefon = SUBSTRING(ksiegowosc.pracownicy.telefon, 1, 8) +'-'+ SUBSTRING(ksiegowosc.pracownicy.telefon, 9, 3) +'-'+ SUBSTRING(ksiegowosc.pracownicy.telefon, 12, 3);
SELECT * FROM ksiegowosc.pracownicy;


--c) Wyœwietl dane pracownika, którego nazwisko jest najd³u¿sze, u¿ywaj¹c du¿ych liter
SELECT id_pracownika AS ID, 
UPPER(imie) AS IMIE, 
UPPER(nazwisko) AS NAZWISKO, 
UPPER(adres) AS ADRES, 
UPPER(telefon) AS TELEFON 
FROM ksiegowosc.pracownicy 
WHERE LEN(nazwisko) = (SELECT MAX(LEN(nazwisko)) from ksiegowosc.pracownicy);


--d)  Wyœwietl dane pracowników i ich pensje zakodowane przy pomocy algorytmu md5
SELECT 
CONVERT(VARCHAR(32), HashBytes('MD5', CAST(pracownicy.id_pracownika AS varchar(20))), 2) AS id, 
CONVERT(VARCHAR(32), HashBytes('MD5', pracownicy.imie), 2) AS imie, 
CONVERT(VARCHAR(32), HashBytes('MD5', pracownicy.nazwisko), 2) AS nazwisko, 
CONVERT(VARCHAR(32), HashBytes('MD5', pracownicy.adres), 2) AS adres, 
CONVERT(VARCHAR(32), HashBytes('MD5', pracownicy.telefon), 2) AS telefon ,
CONVERT(VARCHAR(32), HashBytes('MD5', CAST(pensja.kwota AS varchar(20))), 2) AS kwota
FROM ksiegowosc.pracownicy
JOIN ksiegowosc.wynagrodzenie
ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika
JOIN ksiegowosc.pensja
ON ksiegowosc.pensja.id_pensji = ksiegowosc.wynagrodzenie.id_pensji;


--e) Wyœwietl pracowników, ich pensje oraz premie. Wykorzystaj z³¹czenie lewostronne.
SELECT pracownicy.imie, pracownicy.nazwisko, pensja.kwota AS pensja, premia.kwota AS premia
FROM ksiegowosc.pracownicy
JOIN ksiegowosc.wynagrodzenie
ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika
JOIN ksiegowosc.pensja
ON ksiegowosc.pensja.id_pensji = ksiegowosc.wynagrodzenie.id_pensji
LEFT JOIN ksiegowosc.premia
ON ksiegowosc.premia.id_premii = ksiegowosc.wynagrodzenie.id_premii;


--f) wygeneruj raport (zapytanie), które zwróci w wyniki treœæ wg szablonu
SELECT 'Pracownik ' + pracownicy.imie +' '+ pracownicy.nazwisko +', w dniu '
+ SUBSTRING(CAST(wynagrodzenie.data AS varchar(20)),9,2) +'.'+ SUBSTRING(CAST(wynagrodzenie.data AS varchar(20)),6,2) +'.'
+ SUBSTRING(CAST(wynagrodzenie.data AS varchar(20)),1,4) +' otrzyma³ pensjê ca³kowit¹ na kwotê '
+ CAST(pensja.kwota + ISNULL(premia.kwota,0) + (CASE WHEN (godziny.liczba_godzin*23)-160>0
	THEN ((godziny.liczba_godzin*23)-160)*(pensja.kwota/160) ELSE 0 END) AS varchar(20)) 
+' z³, gdzie wynagrodzenie zasadnicze wynios³o: '+ CAST(pensja.kwota AS varchar(20))
+' z³, premia: '+ CAST(ISNULL(premia.kwota,0) AS varchar(20)) +' z³, nadgodziny: '
+ CAST((CASE WHEN (godziny.liczba_godzin*23)-160>0
	THEN ((godziny.liczba_godzin*23)-160)*(pensja.kwota/160) ELSE 0 END) AS varchar(20)) +' z³.'
FROM ksiegowosc.wynagrodzenie
JOIN ksiegowosc.pracownicy
ON pracownicy.id_pracownika = wynagrodzenie.id_wynagrodzenia
JOIN ksiegowosc.pensja
ON pensja.id_pensji = wynagrodzenie.id_pensji
LEFT JOIN ksiegowosc.premia
ON premia.id_premii = wynagrodzenie.id_premii
JOIN ksiegowosc.godziny
ON godziny.id_godziny = wynagrodzenie.id_godziny;