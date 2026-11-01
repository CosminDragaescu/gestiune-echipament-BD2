CREATE TABLE IF NOT EXISTS roluri (
    id SERIAL PRIMARY KEY,
    nume VARCHAR(30) NOT NULL UNIQUE,
    descriere VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS utilizatori (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    parola VARCHAR(255) NOT NULL,
    rol_id INT NOT NULL REFERENCES roluri(id) ON DELETE RESTRICT,
    creat_la TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS jucatori (
    id SERIAL PRIMARY KEY,
    utilizator_id INT UNIQUE REFERENCES utilizatori(id) ON DELETE SET NULL,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    numar_tricou INT NOT NULL UNIQUE CHECK (numar_tricou BETWEEN 1 AND 99),
    pozitie VARCHAR(20) NOT NULL CHECK (pozitie IN ('Portar', 'Fundas', 'Mijlocas', 'Atacant')),
    marime_tricou VARCHAR(5) NOT NULL CHECK (marime_tricou IN ('S', 'M', 'L', 'XL', 'XXL')),
    marime_ghete NUMERIC(3,1) NOT NULL CHECK (marime_ghete BETWEEN 36.0 AND 48.0)
);

CREATE TABLE IF NOT EXISTS categorii_echipament (
    id SERIAL PRIMARY KEY,
    nume VARCHAR(80) NOT NULL UNIQUE,
    tip VARCHAR(30) NOT NULL CHECK (tip IN ('Meci', 'Antrenament', 'Prezentare', 'Accesorii'))
);

CREATE TABLE IF NOT EXISTS furnizori (
    id SERIAL PRIMARY KEY,
    nume_firma VARCHAR(100) NOT NULL UNIQUE,
    telefon VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS echipamente (
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

CREATE TABLE IF NOT EXISTS alocari_echipament (
    id SERIAL PRIMARY KEY,
    jucator_id INT NOT NULL REFERENCES jucatori(id) ON DELETE CASCADE,
    echipament_id INT NOT NULL REFERENCES echipamente(id) ON DELETE RESTRICT,
    cantitate INT NOT NULL CHECK (cantitate > 0),
    data_alocarii DATE NOT NULL DEFAULT CURRENT_DATE,
    data_returnarii DATE,
    stare_returnare VARCHAR(30) CHECK (stare_returnare IN ('Buna', 'Uzata', 'Deteriorata', 'Pierduta')),
    CONSTRAINT verificare_date CHECK (data_returnarii IS NULL OR data_returnarii >= data_alocarii)
);