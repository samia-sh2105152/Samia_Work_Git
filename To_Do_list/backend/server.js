
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const PORT = 5000;
// app.use(cors()); 


app.use(bodyParser.json());
const path = require('path');
app.use(express.static(path.join(__dirname, 'public')));

//  MongoDB connection
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => console.log('✅ MongoDB Connected'))
  .catch(err => console.error('❌ MongoDB error:', err));

//  Routes
const taskRoutes = require('./routes/task');
app.use('/api/tasks', taskRoutes);

//  Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
