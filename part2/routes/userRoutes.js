const express = require('express');
const router = express.Router();
const db = require('../models/db');

// GET all users (for admin/testing)
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT user_id, username, email, role FROM Users');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch users' });
  }
});

// POST a new user (simple signup)
router.post('/register', async (req, res) => {
  const { username, email, password, role } = req.body;

  try {
    const [result] = await db.query(`
      INSERT INTO Users (username, email, password_hash, role)
      VALUES (?, ?, ?, ?)
    `, [username, email, password, role]);

    res.status(201).json({ message: 'User registered', user_id: result.insertId });
  } catch (error) {
    res.status(500).json({ error: 'Registration failed' });
  }
});

router.get('/me', (req, res) => {
  if (!req.session.user) {
    return res.status(401).json({ error: 'Not logged in' });
  }
  res.json(req.session.user);
});

router.post('/login', async (req, res) => {
  // get the username and password from the request body
  const { username, password } = req.body;
  try {
    // get the user from the database
    const [rows] = await db.query(`
      SELECT user_id, username, role FROM Users
      WHERE username = ? AND password_hash = ?
    `, [username, password]);

    if (rows.length === 0) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    // if the user exists, set the session and redirect based on role
    const user = rows[0];
    req.session.userId = user.user_id;
    req.session.role = user.role;
    // redirect based on role

    if (user.role === 'walker') {
      return res.redirect('/walker-dashboard.html');
    }
    return res.redirect('/owner-dashboard.html');

  } catch (error) {
    res.status(500).json({ error: 'Login failed' });
  }
});

router.post('/logout', (req, res) => {
  // destroy the session
  req.session.destroy();
  return res.redirect('/');
});

router.get('/myDogs', async (req, res) => {
  const rows = await db.query(`
    SELECT
    name
    FROM
    Dogs
    WHERE owner_id = ?
  `, [req.session.userId]);
  res.json(rows[0]);
});


module.exports = router;
