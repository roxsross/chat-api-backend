const express = require('express');
const router = express.Router();

const { authenticated } = require('../middleware/authentication');

const {
    sendmessage,
    getallmessages
} = require('../controllers/messageController');


router.route('/').post(authenticated, sendmessage);
router.route('/:chatID').get(authenticated, getallmessages);

module.exports = router;