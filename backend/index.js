import express from 'express';
import dotenv from 'dotenv';
import mysql from 'mysql2';
dotenv.config();

const app = express();
const port = process.env.PORT || 5000;

const db = mysql.createConnection({
    host: process.env.HOST,
    user: process.env.UNAME,
    password: process.env.PASSWORD,
    database: process.env.DATABASE
});



app.get('/', (req, res) => {
    res.send('yousupply backend is running');
});

app.get('/suprise', (req, res) => {
    // uses this API to show a cat image 
    // https://api.thecatapi.com/v1/images/search

    fetch('https://meme-api.com/gimme')
        .then(response => response.json())
        .then(data => {
            res.send(`<img src="${data.url}" alt="cat image" />`);
        })
        .catch(error => {
            console.log(error);
        });
});


app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
    db.connect((err) => {
        if (err) {
            console.log(err);
        } else {
            console.log('Connected to the database');
        }
    });
});