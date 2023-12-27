const express = require('express');
const cors = require('cors');
const ConnectDatabase = require('./database.js');
const auth = require('./routes/auth.js');
const chat = require('./routes/chat.js');
const message = require('./routes/messages.js');

ConnectDatabase();
const app = express();

app.use(cors());
app.use(express.json());
app.use('/api', auth);
app.use('/api/chats', chat);
app.use('/api/message', message);

app.listen(process.env.PORT, () => {
    console.log('Server Running on port:', process.env.PORT);
})



