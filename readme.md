



## Descrierea temei 

Aplicația ajută la gestionarea magaziei de echipamente a unui club de fotbal. Ideea principală este să ținem evidența stocurilor (tricouri de meci, treninguri, ghete, veste) și să știm în orice moment ce echipament a primit fiecare jucător și ce mărimi poartă.

Cum funcționează:
- În magazie intră echipamente de la diferiți furnizori, împărțite pe categorii și mărimi.
- Fiecare jucător din lot are salvate în baza de date numărul de pe tricou, poziția și mărimile lui la haine și ghete.
- Când un jucător primește echipament, se face o alocare și scade stocul disponibil. Când îl aduce înapoi (la final de sezon sau dacă s-a rupt), se trece data returnării și starea în care l-a adus (Bună, Uzată, Deteriorată sau Pierdută).

Rolurile din aplicație:
- **Admin:** Are acces la tot, gestionează utilizatorii, jucătorii, furnizorii și rapoartele.
- **Magazioner:** Se ocupă de stocul de echipamente și trece în sistem când dă sau primește înapoi echipament de la jucători.
- **Jucător:** Poate doar să își vadă profilul, mărimile și ce echipament are primit în momentul respectiv.

## Modelul de date și Fixtures 

Baza de date este făcută în PostgreSQL și are 7 tabele legate între ele:
1. `roluri` - cele 3 roluri de acces - Admin, Magazioner, Jucător
2. `utilizatori` - conturile de logare - legate de roluri
3. `jucatori` - datele jucătorilor și mărimile lor - legate de contul de utilizator
4. `categorii_echipament` - tipul echipamentului - meci, antrenament, prezentare
5. `furnizori` - firmele de la care clubul cumpără echipamentul
6. `echipamente` - produsele din magazie, mărimea, prețul și stocul -  total vs disponibil
7. `alocari_echipament` - tabelul care leagă jucătorii de echipamentele primite

La pornirea serverului (`node server.js`), aplicația verifică dacă baza de date este goală și încarcă automat datele de test (fixtures).