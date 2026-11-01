require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const fs = require('fs');

const app = express();
app.set('view engine', 'ejs'); 


const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: { rejectUnauthorized: false }
});


async function verificaBazaDeDate() {
    const rezultat = await pool.query('SELECT COUNT(*) FROM roluri');
    if ( parseInt(rezultat.rows[0].count) === 0 ) {
        console.log('Baza este goala. Introducem datele de test (Fixtures)...');
        const sqlFixtures = fs.readFileSync('./fixtures.sql', 'utf8');
        await pool.query(sqlFixtures);
        console.log('Datele de test au fost introduse!');
    } else {
        console.log('Conexiune reusita la Neon DB! Datele exista deja.');
    }
}


app.get('/', async (req, res) => { 
    const jucatori = await pool.query('SELECT * FROM jucatori ORDER BY numar_tricou');
    const echipamente = await pool.query('SELECT * FROM echipamente');
    const alocari = await pool.query(`
        SELECT a.id, j.nume, j.prenume, e.denumire, a.cantitate, a.data_alocarii, a.stare_returnare 
        FROM alocari_echipament a
        JOIN jucatori j ON a.jucator_id = j.id
        JOIN echipamente e ON a.echipament_id = e.id
    `);

   
    res.render('index', {
        listaJucatori: jucatori.rows,
        listaEchipamente: echipamente.rows,
        listaAlocari: alocari.rows
    });
});


app.listen(3000, async () => {
    await verificaBazaDeDate();
    console.log('Site-ul a pornit pe http://localhost:3000');
});