require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const fs = require('fs');

const app = express();

const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: { rejectUnauthorized: false }
});

async function pornesteBazaDeDate() {
    try {
        const schemaSql = fs.readFileSync('./init.sql', 'utf8');
        await pool.query(schemaSql);
        console.log('1. Cele 7 tabele sunt create si verificate in Neon DB.');

        const rezultat = await pool.query('SELECT COUNT(*) FROM roluri');
        if (parseInt(rezultat.rows[0].count) === 0) {
            console.log('2. Baza de date este goala. Se introduc datele de test (Fixtures)...');
            const fixturesSql = fs.readFileSync('./fixtures.sql', 'utf8');
            await pool.query(fixturesSql);
            console.log('-> Fixtures au fost introduse cu succes!');
        } else {
            console.log('2. Datele de test (Fixtures) exista deja in baza de date.');
        }

        const jucatori = await pool.query('SELECT COUNT(*) FROM jucatori');
        const echipamente = await pool.query('SELECT COUNT(*) FROM echipamente');
        const alocari = await pool.query('SELECT COUNT(*) FROM alocari_echipament');
        console.log(`3. Stare baza de date: ${jucatori.rows[0].count} jucatori, ${echipamente.rows[0].count} echipamente, ${alocari.rows[0].count} alocari.`);

    } catch (eroare) {
        console.error('Eroare la baza de date:', eroare.message);
    }
}

app.listen(3000, async () => {
    console.log('Serviciul a pornit...');
    await pornesteBazaDeDate();
});