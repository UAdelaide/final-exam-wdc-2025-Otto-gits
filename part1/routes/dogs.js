var express = require('express');
var router = express.Router();
var db = require('../db');


router.get('/dogs', async (req, res) => {
    const [rows] = await db.query(`
        SELECT
        d.name  AS dog_name,
        d.size,
        u.username AS owner_username
        FROM Dogs d
        JOIN Users u
        ON d.owner_id = u.user_id
        `);
    res.json(rows);
});

router.get('/walkrequests/open', async (req, res) => {
    const [rows] = await db.query(`
        SELECT
        rq.request_id,
        d.name AS dog_name,
        rq.requested_time,
        rq.duration_minutes,
        rq.location,
        u.username AS owner_username
        FROM WalkRequests rq
        JOIN Dogs d ON rq.dog_id = d.dog_id
        JOIN Users u ON d.owner_id = u.user_id
        WHERE rq.status = 'open'
        `);
    res.json(rows);
});


router.get('/walkers/summary', async (req, res) => {
    const [rows] = await db.query(`
        SELECT
        rq.request_id,
        d.name,
        rq.requested_time,
        rq.duration_minutes,
        rq.location,
        u.username
        FROM WalkRequests rq
        JOIN Dogs d ON rq.dog_id = d.dog_id
        JOIN Users u ON d.owner_id = u.user_id
        WHERE rq.status = 'open'
        `);
    res.json(rows);
});

module.exports = router;