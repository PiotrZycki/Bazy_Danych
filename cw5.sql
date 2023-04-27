--Utworzenie bazy danych
CREATE DATABASE firma;
use firma;

--Utworzenie schematu
CREATE SCHEMA ksiegowosc;

--Utworzenie tabeli pracownicy 
CREATE TABLE ksiegowosc.pracownicy (

id_pracownika INT PRIMARY KEY,
imie NVARCHAR(50) NOT NULL,
nazwisko NVARCHAR(50) NOT NULL,
adres NVARCHAR(70) NOT NULL,
telefon VARCHAR(15) NOT NULL,

);

--Utworzenie tabeli godziny
CREATE TABLE ksiegowosc.godziny (

id_godziny INT PRIMARY KEY,
data date NOT NULL,
liczba_godzin FLOAT(3) NOT NULL,
id_pracownika INT NOT NULL,

CONSTRAINT pracownikFK FOREIGN KEY (id_pracownika) REFERENCES rozliczenia.pracownicy (id_pracownika)

);

--Utworzenie tabeli premie
CREATE TABLE ksiegowosc.premia (

id_premii INT PRIMARY KEY,
rodzaj VARCHAR(50) NOT NULL,
kwota money NOT NULL,

);

--Utworzenie tabeli pensja
CREATE TABLE ksiegowosc.pensja (

id_pensji INT PRIMARY KEY,
stanowisko NVARCHAR(50) NOT NULL,
kwota money NOT NULL,

);

--Utworzenie tabeli wynagrodzenie
CREATE TABLE ksiegowosc.wynagrodzenie (

id_wynagrodzenia INT PRIMARY KEY,
data date NOT NULL,
id_pracownika INT NOT NULL,
id_godziny INT NOT NULL,
id_pensji INT NOT NULL,
id_premii INT,

);

ALTER TABLE ksiegowosc.wynagrodzenie
ADD FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy (id_pracownika);
ALTER TABLE ksiegowosc.wynagrodzenie
ADD FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny (id_godziny);
ALTER TABLE ksiegowosc.wynagrodzenie
ADD FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensja (id_pensji);
ALTER TABLE ksiegowosc.wynagrodzenie
ADD FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premia (id_premii);

--Opis tabeli pracownicy
EXEC sys.sp_addextendedproperty 
    @name=N'Opis tabeli:', 
    @value=N'Tabela zawieraj¹ca dane pracowników',
    @level0type=N'SCHEMA',
    @level0name=N'ksiegowosc', 
    @level1type=N'TABLE',
    @level1name=N'pracownicy'

--Opis tabeli godziny
EXEC sys.sp_addextendedproperty 
    @name=N'Opis tabeli:', 
    @value=N'Tabela zawiera dane odnoœnie liczby godzin pracy danego pracownika w okreœlony dzieñ.',
    @level0type=N'SCHEMA',
    @level0name=N'ksiegowosc', 
    @level1type=N'TABLE',
    @level1name=N'godziny'

--Opis tabeli pensja
EXEC sys.sp_addextendedproperty 
    @name=N'Opis tabeli:', 
    @value=N'Tabela zawiera informacje odnoœnie wysokoœci pensji na danym stanowisku.',
    @level0type=N'SCHEMA',
    @level0name=N'ksiegowosc', 
    @level1type=N'TABLE',
    @level1name=N'pensja'

--Opis tabeli premia
EXEC sys.sp_addextendedproperty 
    @name=N'Opis tabeli:', 
    @value=N'Tabela zawiera informacje o rodzaju i wysokoœci premii.',
    @level0type=N'SCHEMA',
    @level0name=N'ksiegowosc', 
    @level1type=N'TABLE',
    @level1name=N'premia'

--Opis tabeli wynagrodzenie
EXEC sys.sp_addextendedproperty 
    @name=N'Opis tabeli:', 
    @value=N'Tabela zawiera dane dot. wynagrodzeñ ka¿dego z pracowników, wliczaj¹c w to: datê, iloœæ przepracowanych godzin, wysokoœæ pensji oraz premie.',
    @level0type=N'SCHEMA',
    @level0name=N'ksiegowosc', 
    @level1type=N'TABLE',
    @level1name=N'wynagrodzenie'

--Dodanie 10 rekordów do tabeli pracownicy
INSERT INTO ksiegowosc.pracownicy VALUES 
(1, 'Pawe³', 'Kie³basa', '£ódzka 17/32, 34-400 Nowy Targ', '+48674364094'),
(2, 'Jaros³aw', 'Pêdziwiatr', 'Zielona 3, 32-400 Myœlenice', '+48583950261'),
(3, 'Micha³', 'Bolig³owa', 'Szadkowska 65, 32-200 Miechów', '+48884506744'),
(4, 'Marta', 'Tatarata', 'al.D¹browskiego 11, 32-085 Modlniczka', '+48748950382'),
(5, 'Sandra', 'Ma³olepsza', 'Mi³a 1, 32-051 Zelczyna', '+48754999576'),
(6, 'Krystian', 'Jab³uszko', 'Spokojna 3, 	32-020 Wieliczka', '+48754124054'),
(7, 'Anna', 'Siekierka', 'Szpitalna 16, 34-700 Rabka-Zdrój', '+48987405102'),
(8, 'Zdzis³aw', 'Sprzeczka', 'Podleœna 23, 34-100 Wadowice', '+48597192059'),
(9, 'Wies³awa', 'Tarapata', 'Kobusiewicza 33, 33-300 Nowy S¹cz', '+48975038954'),
(10, 'Alicja', 'Lulunowska', '£¹kowa 94/7, 32-800 Brzesko', '+48534195034');

--Dodanie 10 rekordów do tabeli premia
INSERT INTO ksiegowosc.premia VALUES
(1, 'regulaminowa', 100),
(2, 'uznaniowa', 100),
(3, 'motywacyjna 1', 50),
(4, 'motywacyjna 2', 150),
(5, 'motywacyjna 3', 300),
(6, 'zadaniowa', 120),
(7, 'prowizyjna', 200),
(8, 'indywidualna', 500),
(9, 'zespo³owa', 100),
(10, 'frekwencyjna', 50);

--Dodanie 10 rekordów do tabeli pensja
INSERT INTO ksiegowosc.pensja VALUES
(1, 'sekretarz', 900),
(2, 'ksiêgowy', 800),
(3, 'kierownik', 2000),
(4, 'ochroniarz', 3000),
(5, 'sprz¹tacz', 4000),
(6, 'kucharz', 6000),
(7, 'listonosz', 1500),
(8, 'pielêgniarz', 2300),
(9, 'lekarz', 10000),
(10, 'farmaceuta', 5000);

--Dodanie 10 rekordów do tabeli godziny
INSERT INTO ksiegowosc.godziny VALUES
(1, '2023/03/01', 7.5, 1),
(2, '2023/03/01', 8, 2),
(3, '2023/03/01', 7, 3),
(4, '2023/03/01', 4.5, 4),
(5, '2023/03/01', 9, 5),
(6, '2023/03/01', 8.5, 6),
(7, '2023/03/01', 8, 7),
(8, '2023/03/01', 6, 8),
(9, '2023/03/01', 4.5, 9),
(10, '2023/03/01', 10, 10);

--Dodanie 10 rekordów do tabeli wynagrodzenie
INSERT INTO ksiegowosc.wynagrodzenie VALUES
(1, '2023/04/10', 1, 1, 2, 3),
(2, '2023/04/10', 2, 2, 2, 3),
(3, '2023/04/10', 3, 3, 6, NULL),
(4, '2023/04/10', 4, 4, 4, 1),
(5, '2023/04/10', 5, 5, 4, 1),
(6, '2023/04/10', 6, 6, 5, 8),
(7, '2023/04/11', 7, 7, 9, NULL),
(8, '2023/04/11', 8, 8, 3, 9),
(9, '2023/04/11', 9, 9, 1, NULL),
(10, '2023/04/11', 10, 10, 2, 10);



--6a) Wyswietlenie id pracownika i jego nazwiska
SELECT id_pracownika, nazwisko FROM ksiegowosc.pracownicy;


--6b) Wyswietlenie id pracowników, których pensja > 1000
SELECT pracownicy.id_pracownika
FROM ksiegowosc.pracownicy
JOIN ksiegowosc.wynagrodzenie
ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika
JOIN ksiegowosc.pensja
ON ksiegowosc.pensja.id_pensji = ksiegowosc.wynagrodzenie.id_pensji
WHERE ksiegowosc.pensja.kwota > 1000;


--6c) Wyswietlenie id pracowników, którzy nie posiadaj¹ premii, a których pensja > 2000
SELECT pracownicy.id_pracownika
FROM ksiegowosc.pracownicy
JOIN ksiegowosc.wynagrodzenie
ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika
JOIN ksiegowosc.pensja
ON ksiegowosc.pensja.id_pensji = ksiegowosc.wynagrodzenie.id_pensji
WHERE ksiegowosc.pensja.kwota > 1000 AND ksiegowosc.wynagrodzenie.id_premii IS NULL;


--6d) Wyswietlenie pracowników, których imie zaczyna siê na literê 'J'
SELECT * FROM ksiegowosc.pracownicy
WHERE ksiegowosc.pracownicy.imie LIKE 'j%';


--6e) Wyswietlenie pracowników, których nazwisko zawiera literê 'n', a których imie koñczy siêna literê 'a'
SELECT * FROM ksiegowosc.pracownicy
WHERE ksiegowosc.pracownicy.nazwisko LIKE '%n%'
AND ksiegowosc.pracownicy.imie LIKE '%a';


--6f) Wyœwietlenie imion i nazwisk pracowników oraz liczbê ich nadgodzin (std czas pracy = 160h miesiêcznie)
SELECT pracownicy.imie, pracownicy.nazwisko, (godziny.liczba_godzin*23)-160 AS nadgodziny
FROM ksiegowosc.pracownicy
JOIN ksiegowosc.godziny
ON godziny.id_pracownika = pracownicy.id_pracownika
WHERE (godziny.liczba_godzin*23)>160;


--6g) Wyœwietlenie imion i nazwisk pracowników, których pensja zawiera siê w przedziale 1500-3000 PLN
SELECT pracownicy.imie, pracownicy.nazwisko
FROM ksiegowosc.pracownicy
JOIN ksiegowosc.wynagrodzenie
ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika
JOIN ksiegowosc.pensja
ON ksiegowosc.pensja.id_pensji = ksiegowosc.wynagrodzenie.id_pensji
WHERE ksiegowosc.pensja.kwota >= 1500 AND ksiegowosc.pensja.kwota <= 3000;


--6h) Wyœwietlenie imion i nazwisk pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii
SELECT pracownicy.imie, pracownicy.nazwisko
FROM ksiegowosc.pracownicy
JOIN ksiegowosc.godziny
ON godziny.id_pracownika = pracownicy.id_pracownika
JOIN ksiegowosc.wynagrodzenie
ON wynagrodzenie.id_pracownika = pracownicy.id_pracownika
WHERE (godziny.liczba_godzin*23)>160 AND wynagrodzenie.id_premii IS NULL;


--6i) Wyswietlenie pracowników uszeregowanych wed³ug ich pensji
SELECT pracownicy.* FROM ksiegowosc.pracownicy
JOIN ksiegowosc.wynagrodzenie
ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika
JOIN ksiegowosc.pensja
ON ksiegowosc.pensja.id_pensji = ksiegowosc.wynagrodzenie.id_pensji
ORDER BY pensja.kwota ASC;


--6j) Wyswietlenie pracowników uszeregowanych wed³ug ich pensji oraz premii malej¹co
SELECT * FROM ksiegowosc.pracownicy
JOIN ksiegowosc.wynagrodzenie
ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika
JOIN ksiegowosc.pensja
ON ksiegowosc.pensja.id_pensji = ksiegowosc.wynagrodzenie.id_pensji
JOIN ksiegowosc.premia
ON ksiegowosc.premia.id_premii = ksiegowosc.wynagrodzenie.id_premii
ORDER BY pensja.kwota DESC, premia.kwota DESC;


--6k) Zliczenie i pogrupowanie pracowników zgodnie z ich stanowiskiem
SELECT pensja.stanowisko, COUNT(pracownicy.imie) AS LiczbaPracownikow
FROM ksiegowosc.pracownicy
JOIN ksiegowosc.wynagrodzenie
ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika
JOIN ksiegowosc.pensja
ON ksiegowosc.pensja.id_pensji = ksiegowosc.wynagrodzenie.id_pensji
GROUP BY pensja.stanowisko;


--6l) Obliczenie œredniej, min i max pensji dla stanowiska "kierownik"
SELECT MIN(pensja.kwota) AS pensjaMIN, AVG(pensja.kwota) AS pensjaAVG, MAX(pensja.kwota) AS pensjaMAX FROM ksiegowosc.pensja
WHERE pensja.stanowisko='kierownik';


--6m) Obliczenie sumy wszystkich wynagrodzeñ
SELECT (SUM(pensja.kwota)+SUM(premia.kwota)) AS SumaWynagrodzen FROM ksiegowosc.wynagrodzenie
JOIN ksiegowosc.pensja
ON pensja.id_pensji = wynagrodzenie.id_pensji
LEFT JOIN ksiegowosc.premia
ON premia.id_premii = wynagrodzenie.id_premii;


--6n) Obliczenie sumy wynagrodzeñ w ramach danego stanowiska
SELECT pensja.stanowisko, (SUM(pensja.kwota)+SUM(ISNULL(premia.kwota,0))) AS SumaWynagrodzen FROM ksiegowosc.wynagrodzenie
JOIN ksiegowosc.pensja
ON pensja.id_pensji = wynagrodzenie.id_pensji
LEFT JOIN ksiegowosc.premia
ON premia.id_premii = wynagrodzenie.id_premii
GROUP BY pensja.stanowisko;


--6o) Wyznaczenie liczby premii przyznanych dla pracowników na danym stanowisku
SELECT pensja.stanowisko, COUNT(premia.id_premii) AS LiczbaPremii FROM ksiegowosc.wynagrodzenie
JOIN ksiegowosc.pensja
ON pensja.id_pensji = wynagrodzenie.id_pensji
LEFT JOIN ksiegowosc.premia
ON premia.id_premii = wynagrodzenie.id_premii
GROUP BY pensja.stanowisko


--6p) Usuniêcie wszystkich pracowników, których pensja < 1200
ALTER TABLE ksiegowosc.wynagrodzenie nocheck constraint all
DELETE kp
FROM ksiegowosc.pracownicy kp
JOIN ksiegowosc.wynagrodzenie
ON wynagrodzenie.id_pracownika = kp.id_pracownika
JOIN ksiegowosc.pensja
ON wynagrodzenie.id_pensji = pensja.id_pensji
WHERE pensja.kwota < 1200;
ALTER TABLE ksiegowosc.wynagrodzenie check constraint all
