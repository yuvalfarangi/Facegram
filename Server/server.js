const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcrypt');
const morgan = require("morgan");


// Initialize app
const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(morgan('tiny'));

const userRouter = require('./routes/user')
const postRouter = require('./routes/post')
const commentRouter = require('./routes/comment')
const tagsRouter = require('./routes/tags')
const notificationRouter = require('./routes/notification')


app.use('/user', userRouter)
app.use('/post', postRouter)
app.use('/comment', commentRouter)
app.use('/tags', tagsRouter)
app.use('/notifications', notificationRouter)




// Connect to MongoDB 
mongoose.connect('mongodb://127.0.0.1:27017/Facegram')
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.log(err));



// Start server
app.listen(3000, () => console.log('Server running on http://localhost:3000'));
