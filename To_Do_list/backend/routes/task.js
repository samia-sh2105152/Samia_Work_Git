const express = require('express');
const router = express.Router();
const Task = require('../models/Task');

// GET all tasks
router.get('/', async (req, res) => {
  const tasks = await Task.find();
  res.json(tasks);
});

// POST new task
router.post('/', async (req, res) => {
  console.log('🔔 Received POST request:', req.body);
  const { text } = req.body;
  if (!text) return res.status(400).json({ error: 'Text is required' });

  try {
    const task = new Task({ text });
    await task.save();
    console.log('✅ Task saved:', task); 
    res.json(task);
  } catch (err) {
    console.error('❌ Error saving task:', err); 
    res.status(500).json({ error: 'Internal server error' });
  }
});

// DELETE task
router.delete('/:id', async (req, res) => {
  await Task.findByIdAndDelete(req.params.id);
  res.json({ message: 'Task deleted' });
});

module.exports = router;
