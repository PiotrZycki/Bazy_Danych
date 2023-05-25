SHOW search_path;
SET search_path TO geochronologia;

CREATE TABLE geochronologia.GeoEon (
	id_eon int PRIMARY KEY,
	nazwa_eon varchar(25)
);

CREATE TABLE geochronologia.GeoEra (
	id_era int PRIMARY KEY,
	id_eon int,
	nazwa_era varchar(25),
	CONSTRAINT fk_eon
		FOREIGN KEY (id_eon) 
			REFERENCES geochronologia.GeoEon(id_eon)
);

CREATE TABLE geochronologia.GeoOkres (
	id_okres int PRIMARY KEY,
	id_era int,
	nazwa_okres varchar(25),
	CONSTRAINT fk_era
		FOREIGN KEY (id_era) 
			REFERENCES geochronologia.GeoEra(id_era)
);

CREATE TABLE geochronologia.GeoEpoka (
	id_epoka int PRIMARY KEY,
	id_okres int,
	nazwa_epoka varchar(25),
	CONSTRAINT fk_okres
		FOREIGN KEY (id_okres) 
			REFERENCES geochronologia.GeoOkres(id_okres)
);

CREATE TABLE geochronologia.GeoPietro (
	id_pietro int PRIMARY KEY,
	id_epoka int,
	nazwa_pietro varchar(25),
	CONSTRAINT fk_epoka
		FOREIGN KEY (id_epoka)
			REFERENCES geochronologia.GeoEpoka(id_epoka)
);


INSERT INTO geochronologia.GeoEon VALUES 
(1, 'Fanerozoik');

INSERT INTO geochronologia.GeoEra VALUES 
(1, 1, 'Paleozoik'),
(2, 1, 'Mezozoik'),
(3, 1, 'Kenozoik');

INSERT INTO geochronologia.GeoOkres VALUES 
(1, 1, 'Dewon'),
(2, 1, 'Karbon'),
(3, 1, 'Perm'),
(4, 2, 'Trias'),
(5, 2, 'Jura'),
(6, 2, 'Kreda'),
(7, 3, 'Paleogen'),
(8, 3, 'Neogen'),
(9, 3, 'Czwartorzęd');

INSERT INTO geochronologia.GeoEpoka VALUES 
(1, 1, 'Dolny'),
(2, 1, 'Środkowy'),
(3, 1, 'Górny'),
(4, 2, 'Dolny'),
(5, 2, 'Górny'),
(6, 3, 'Dolny'),
(7, 3, 'Górny'),
(8, 4, 'Dolny'),
(9, 4, 'Środkowy'),
(10, 4, 'Górny'),
(11, 5, 'Dolna'),
(12, 5, 'Środkowa'),
(13, 5, 'Górna'),
(14, 6, 'Dolna'),
(15, 6, 'Górna'),
(16, 7, 'Paleocen'),
(17, 7, 'Eocen'),
(18, 7, 'Oligocen'),
(19, 8, 'Miocen'),
(20, 8, 'Pliocen'),
(21, 9, 'Plejstocen'),
(22, 9, 'Halocen');


CREATE TABLE geochronologia.GeoTabela AS
	(SELECT * FROM geochronologia.GeoPietro 
		NATURAL JOIN geochronologia.GeoEpoka 
		NATURAL JOIN geochronologia.GeoOkres 
		NATURAL JOIN geochronologia.GeoEra 
		NATURAL JOIN geochronologia.GeoEon );
		

CREATE TABLE geochronologia.Milion(liczba int,cyfra int, bit int);

CREATE TABLE geochronologia.Dziesiec(cyfra int, bit int);

INSERT INTO geochronologia.Dziesiec VALUES 
(0, 1),
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1);

INSERT INTO geochronologia.Milion 
	SELECT a1.cyfra +10* a2.cyfra +100*a3.cyfra + 1000*a4.cyfra 
		+ 10000*a5.cyfra + 10000*a6.cyfra AS liczba , a1.cyfra AS cyfra, a1.bit AS bit 
	FROM geochronologia.Dziesiec a1, geochronologia.Dziesiec a2, geochronologia.Dziesiec a3, 
			geochronologia.Dziesiec a4, geochronologia.Dziesiec a5, geochronologia.Dziesiec a6 ;

--ZL1
SELECT COUNT(*) FROM geochronologia.Milion INNER JOIN geochronologia.GeoTabela ON 
(mod(geochronologia.Milion.liczba,68)=(geochronologia.GeoTabela.id_pietro));

--ZL2
SELECT COUNT(*) FROM geochronologia.Milion 
INNER JOIN geochronologia.GeoPietro 
ON (mod(geochronologia.Milion.liczba,68)=geochronologia.GeoPietro.id_pietro)
NATURAL JOIN geochronologia.GeoEpoka 
NATURAL JOIN geochronologia.GeoOkres 
NATURAL JOIN geochronologia.GeoEra 
NATURAL JOIN geochronologia.GeoEon;

--ZG3
SELECT COUNT(*) FROM geochronologia.Milion 
WHERE mod(geochronologia.Milion.liczba,68)= 
(SELECT id_pietro FROM geochronologia.GeoTabela 
 WHERE mod(geochronologia.Milion.liczba,68)=(id_pietro));

--ZG4
SELECT COUNT(*) FROM geochronologia.Milion 
WHERE mod(geochronologia.Milion.liczba,68)=
(SELECT geochronologia.GeoPietro.id_pietro FROM geochronologia.GeoPietro 
 NATURAL JOIN geochronologia.GeoEpoka 
 NATURAL JOIN geochronologia.GeoOkres 
 NATURAL JOIN geochronologia.GeoEra 
 NATURAL JOIN geochronologia.GeoEon);
 
-- indeksowanie
CREATE INDEX index_eon
ON geochronologia.GeoEon (id_eon, nazwa_eon);

CREATE INDEX index_era
ON geochronologia.GeoEra (id_era, id_eon, nazwa_era);

CREATE INDEX index_okres
ON geochronologia.GeoOkres (id_okres, id_era, nazwa_okres);

CREATE INDEX index_epoka
ON geochronologia.GeoEpoka (id_epoka, id_okres, nazwa_epoka);

CREATE INDEX index_pietro
ON geochronologia.GeoPietro (id_pietro, id_epoka, nazwa_pietro);

CREATE INDEX index_geotabela
ON geochronologia.GeoTabela (id_eon, id_era, id_okres, id_epoka, id_pietro, nazwa_pietro,
nazwa_epoka, nazwa_okres, nazwa_era, nazwa_eon);

CREATE INDEX index_milion
ON geochronologia.Milion (liczba, cyfra, bit);

