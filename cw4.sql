--Utworzenie bazy danych
CREATE DATABASE firma;
use firma;

--Utworzenie schematu
CREATE SCHEMA rozliczenia;

--Utworzenie tabeli pracownicy 
CREATE TABLE rozliczenia.pracownicy (

id_pracownika INT PRIMARY KEY,
imie NVARCHAR(50) NOT NULL,
nazwisko NVARCHAR(50) NOT NULL,
adres NVARCHAR(70) NOT NULL,
telefon VARCHAR(15) NOT NULL,

);

--Utworzenie tabeli godziny
CREATE TABLE rozliczenia.godziny (

id_godziny INT PRIMARY KEY,
data date NOT NULL,
liczba_godzin FLOAT(3) NOT NULL,
id_pracownika INT NOT NULL,

CONSTRAINT pracownikFK FOREIGN KEY (id_pracownika) REFERENCES rozliczenia.pracownicy (id_pracownika)

);

--Utworzenie tabeli premie
CREATE TABLE rozliczenia.premie (

id_premii INT PRIMARY KEY,
rodzaj VARCHAR(50) NOT NULL,
kwota money NOT NULL,

);

--Utworzenie tabeli pensje
CREATE TABLE rozliczenia.pensje (

id_pensji INT PRIMARY KEY,
stanowisko NVARCHAR(50) NOT NULL,
kwota money NOT NULL,
id_premii INT,

);

ALTER TABLE rozliczenia.pensje
ADD FOREIGN KEY (id_premii) REFERENCES rozliczenia.premie (id_premii);

--Dodanie 10 rekordów do tabeli pracownicy
INSERT INTO rozliczenia.pracownicy VALUES 
(1, 'Pawe³', 'Kie³basa', '£ódzka 17/32, 34-400 Nowy Targ', '+48674364094'),
(2, 'Jaros³aw', 'Pêdziwiatr', 'Zielona 3, 32-400 Myœlenice', '+48583950261'),
(3, 'Micha³', 'Bolig³owa', 'Szadkowska 65, 32-200 Miechów', '+48884506744'),
(4, 'Marta', 'Tatarata', 'al.D¹browskiego 11, 32-085 Modlniczka', '+48748950382'),
(5, 'Sandra', 'Ma³olepsza', 'Mi³a 1, 32-051 Zelczyna', '+48754999576'),
(6, 'Krystian', 'Jab³uszko', 'Spokojna 3, 	32-020 Wieliczka', '+48754124054'),
(7, 'Anna', 'Siekierka', 'Szpitalna 16, 34-700 Rabka-Zdrój', '+48987405102'),
(8, 'Zdzis³aw', 'Sprzeczka', 'Podleœna 23, 34-100 Wadowice', '+48597192059'),
(9, 'Wies³awa', 'Tarapata', 'Kobusiewicza 33, 33-300 Nowy S¹cz', '+48975038954'),
(10, 'Alicja', 'Maszerowska', '£¹kowa 94/7, 32-800 Brzesko', '+48534195034');

--Dodanie 10 rekordów do tabeli premie
INSERT INTO rozliczenia.premie VALUES
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

--Dodanie 10 rekordów do tabeli pensje
INSERT INTO rozliczenia.pensje VALUES
(1, 'sekretarz', 4000, 5),
(2, 'ksiêgowy', 4000, 8),
(3, 'kierownik', 4000, 4),
(4, 'ochroniarz', 4000, 5),
(5, 'sprz¹tacz', 4000, 2),
(6, 'kucharz', 4000, 9),
(7, 'listonosz', 4000, 4),
(8, 'pielêgniarz', 4000, 3),
(9, 'lekarz', 4000, 1),
(10, 'farmaceuta', 4000, 7);

--Dodanie 10 rekordów do tabeli godziny
INSERT INTO rozliczenia.godziny VALUES
(1, '2023/03/01', 7.5, 1),
(2, '2023/03/01', 8, 2),
(3, '2023/03/01', 7, 4),
(4, '2023/03/01', 4.5, 7),
(5, '2023/03/01', 9, 10),
(6, '2023/03/02', 8.5, 1),
(7, '2023/03/02', 8, 3),
(8, '2023/03/02', 6, 4),
(9, '2023/03/02', 4.5, 6),
(10, '2023/03/02', 10, 9);

--Wyœwietlenie nazwisk i adresów pracowników
SELECT nazwisko, adres FROM rozliczenia.pracownicy;

--Wyœwietlenie dat z tabeli godziny w konwencji: dzieñ tygodnia, numer miesi¹ca
SELECT datepart(weekday, data) AS DzienTygodnia, datepart(month, data) AS NumerMiesiaca FROM rozliczenia.godziny;

--Zmiana atrybutu kwota na kwota_brutto
EXEC sp_rename 'rozliczenia.pensje.kwota', 'kwota_brutto', 'COLUMN';
--Dodanie tabeli kwota_netto
ALTER TABLE rozliczenia.pensje ADD kwota_netto AS kwota_brutto-(kwota_brutto*0.08);

SELECT * FROM rozliczenia.pensje;