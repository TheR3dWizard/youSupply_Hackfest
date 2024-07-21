import express from 'express';
import dotenv from 'dotenv';
import mysql from 'mysql2';

dotenv.config();

const app = express();
const port = process.env.PORT || 5000;
app.use(express.json());

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

app.post('/authenticate/login',(req,res) => {
    console.log(req.body)
    var credentials = req.body
    // use sql to veryify the credentials and if correct send latitude and longitude
    // if not send a message saying invalid credentials
    var sql = `SELECT username,contact_number,latitude,longitude FROM users WHERE username = '${credentials.username}' AND password = '${credentials.password}'`
    db.query(sql, (err, result) => {
        if (err) {
            console.log(err);
        } else {
            if (result.length > 0) {
                res.send(result[0]);
            } else {
                res.status(401).send('Invalid credentials');
            }
        }
    }
    );
})

app.post('/authenticate/register',(req,res) => {
    console.log(req.body)
    var credentials = req.body
    var sql = `INSERT INTO users (username,password,contact_number,latitude,longitude) VALUES ('${credentials.username}','${credentials.password}','${credentials.contact_number}',${credentials.latitude},${credentials.longitude})`
    db.query(sql, (err, result) => {
        if (err) {
            if (err.code == 'ER_DUP_ENTRY') {
                res.status(400).send('Username already exists');
            }
        } else {
            res.status(200).send('User registered successfully');
        }
    }
    );
})

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