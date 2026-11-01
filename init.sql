CREATE TABLE roluri (
    id SERIAL PRIMARY KEY,
    nume VARCHAR(30) NOT NULL UNIQUE,
    descriere VARCHAR(200)
);

CREATE TABLE utilizatori (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    parola VARCHAR(255) NOT NULL,
    rol_id INT NOT NULL REFERENCES roluri(id) ON DELETE RESTRICT,
    creat_la TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE jucatori (
    id SERIAL PRIMARY KEY,
    utilizator_id INT UNIQUE REFERENCES utilizatori(id) ON DELETE SET NULL,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    numar_tricou INT NOT NULL UNIQUE CHECK (numar_tricou BETWEEN 1 AND 99),
    pozitie VARCHAR(20) NOT NULL CHECK (pozitie IN ('Portar', 'Fundas', 'Mijlocas', 'Atacant')),
    marime_tricou VARCHAR(5) NOT NULL CHECK (marime_tricou IN ('S', 'M', 'L', 'XL', 'XXL')),
    marime_ghete NUMERIC(3,1) NOT NULL CHECK (marime_ghete BETWEEN 36.0 AND 48.0)
);

CREATE TABLE categorii_echipament (
    id SERIAL PRIMARY KEY,
    nume VARCHAR(80) NOT NULL UNIQUE,
    tip VARCHAR(30) NOT NULL CHECK (tip IN ('Meci', 'Antrenament', 'Prezentare', 'Accesorii'))
);

CREATE TABLE furnizori (
    id SERIAL PRIMARY KEY,
    nume_firma VARCHAR(100) NOT NULL UNIQUE,
    telefon VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE echipamente (
    id SERIAL PRIMARY KEY,
    categorie_id INT NOT NULL REFERENCES categorii_echipament(id) ON DELETE RESTRICT,
    furnizor_id INT NOT NULL REFERENCES furnizori(id) ON DELETE RESTRICT,
    denumire VARCHAR(120) NOT NULL,
    marime VARCHAR(10) NOT NULL,
    stoc_total INT NOT NULL CHECK (stoc_total >= 0),
    stoc_disponibil INT NOT NULL CHECK (stoc_disponibil >= 0),
    pret_unitar NUMERIC(7,2) NOT NULL CHECK (pret_unitar > 0),
    CONSTRAINT verificare_stoc CHECK (stoc_disponibil <= stoc_total)
);

CREATE TABLE alocari_echipament (
    id SERIAL PRIMARY KEY,
    jucator_id INT NOT NULL REFERENCES jucatori(id) ON DELETE CASCADE,
    echipament_id INT NOT NULL REFERENCES echipamente(id) ON DELETE RESTRICT,
    cantitate INT NOT NULL CHECK (cantitate > 0),
    data_alocarii DATE NOT NULL DEFAULT CURRENT_DATE,
    data_returnarii DATE,
    stare_returnare VARCHAR(30) CHECK (stare_returnare IN ('Buna', 'Uzata', 'Deteriorata', 'Pierduta')),
    CONSTRAINT verificare_date CHECK (data_returnarii IS NULL OR data_returnarii >= data_alocarii)
);

INSERT INTO roluri (nume, descriere) VALUES
('ADMIN', 'Acces complet la toate sectiunile si rapoartele aplicatiei'),
('MAGAZIONER', 'Gestioneaza stocurile de echipamente si alocarile catre jucatori'),
('JUCATOR', 'Vizualizeaza propriul profil si echipamentele primite');

INSERT INTO utilizatori (email, parola, rol_id) VALUES
('admin@echipa.ro', 'parola_hash_admin', 1),
('magazie@echipa.ro', 'parola_hash_magazie', 2),
('popescu.andrei@echipa.ro', 'parola_hash_jucator1', 3),
('ionescu.vlad@echipa.ro', 'parola_hash_jucator2', 3),
('stan.matei@echipa.ro', 'parola_hash_jucator3', 3);

INSERT INTO jucatori (utilizator_id, nume, prenume, numar_tricou, pozitie, marime_tricou, marime_ghete) VALUES
(3, 'Popescu', 'Andrei', 10, 'Mijlocas', 'M', 42.0),
(4, 'Ionescu', 'Vlad', 9, 'Atacant', 'L', 43.5),
(5, 'Stan', 'Matei', 1, 'Portar', 'XL', 45.0),
(NULL, 'Marin', 'Cristian', 4, 'Fundas', 'L', 43.0),
(NULL, 'Dumitru', 'Alex', 7, 'Mijlocas', 'S', 40.5);

INSERT INTO categorii_echipament (nume, tip) VALUES
('Kit Joc Acasa', 'Meci'),
('Kit Joc Deplasare', 'Meci'),
('Trening Oficial', 'Prezentare'),
('Ghete Teren Iarba', 'Meci'),
('Veste Departajare', 'Antrenament');

INSERT INTO furnizori (nume_firma, telefon, email) VALUES
('Macron Sport Romania', '0721000111', 'contact@macronsport.ro'),
('Nike Team Distribution', '0722333444', 'comenzi@niketeam.ro'),
('Hervis Corporate SRL', '0744555666', 'b2b@hervis.ro');

INSERT INTO echipamente (categorie_id, furnizor_id, denumire, marime, stoc_total, stoc_disponibil, pret_unitar) VALUES
(1, 1, 'Tricou Oficial Acasa Alb-Rosu', 'M', 20, 18, 190.00),
(1, 1, 'Tricou Oficial Acasa Alb-Rosu', 'L', 20, 19, 190.00),
(3, 1, 'Trening Prezentare Bumbac', 'XL', 15, 14, 320.00),
(4, 2, 'Ghete Nike Tiempo Legend', '42.0', 10, 9, 750.00),
(4, 2, 'Ghete Nike Mercurial Vapor', '43.5', 10, 9, 820.00),
(5, 3, 'Vesta Antrenament Verde Neon', 'L', 30, 30, 35.00);

INSERT INTO alocari_echipament (jucator_id, echipament_id, cantitate, data_alocarii, data_returnarii, stare_returnare) VALUES
(1, 1, 2, '2026-09-01', NULL, NULL),
(1, 4, 1, '2026-09-01', NULL, NULL),
(2, 2, 1, '2026-09-02', NULL, NULL),
(2, 5, 1, '2026-09-02', '2026-10-15', 'Uzata'),
(3, 3, 1, '2026-09-05', NULL, NULL);