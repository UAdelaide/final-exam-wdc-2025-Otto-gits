var express = require('express');
var router = express.Router();
var db = require('../db');


router.get('/dogs', async (req, res) => {
    const [rows] = await db.query('SELECT d.name, d.size, u.username FROM Dogs d JOIN Users u ON d.owner_id = u.user_id');
    res.json(rows);
});

router.get('/walkrequests/open', async (req, res) => {
    const [rows] = await db.query('SELECT rq.id')
    res.json(rows);
});

module.exports = router;