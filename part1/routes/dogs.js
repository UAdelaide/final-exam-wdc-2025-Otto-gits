var express = require('express');
var router = express.Router();
var db = require('../db');


router.get('/dogs', async (req, res) => {
    const [rows] = await db.query(`
        SELECT
        d.name AS dog_name,
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
        u.username AS walker_username,
        COUNT(r.rating_id) AS total_ratings,
        AVG(r.rating) AS average_rating,
        COUNT(DISTINCT wr.request_id) AS completed_walks,
        FROM Users u
        LEFT JOIN WalkApplications wa
            ON wa.walker_id = u.user_id
            AND wa.status = 'accepted'
        LEFT JOIN WalkRequests wr
            ON wr.walker_id = u.user_id
            AND wr.status = 'completed'
        LEFT JOIN WalkRatings r
            ON r.request_id = wr.request_id
            AND r.

        `);
    res.json(rows);
});

module.exports = router;