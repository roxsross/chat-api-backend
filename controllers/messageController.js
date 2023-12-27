const asynchandler = require('express-async-handler');
const MESSAGE = require('../models/messagemodel');
const USER = require('../models/usermodel');
const CHAT = require('../models/chatmodel');

exports.sendmessage = asynchandler(async (req, res) => {
    const { content, chatID } = req.body;

    if (!content || !chatID) {
        return res.sendStatus(400);
    }

    let newMessage = {
        sender: req.user._id,
        content: content,
        chat: chatID
    }

    try {

        let message = await MESSAGE.create(newMessage)

        message = await message.populate("sender", "name avatar");
        message = await message.populate('chat');

        message = await USER.populate(message, {
            path: "chat.users",
            select: 'name avatar email'
        });

        await CHAT.findByIdAndUpdate(chatID, { latestmessage: message });

        res.json(message);

    } catch (error) {
        res.status(400).json({ message: "Failed to send message !" })
    }
})

exports.getallmessages = asynchandler(async (req, res) => {
    try {
        const messages = await MESSAGE.find({ chat: req.params.chatID })
            .populate("sender", "name avatar email")
            .populate("chat");
        res.json(messages);
    } catch (error) {
        res.status(400).json({ message: "Failed Operation. Try Again Later !" })
    }
}) 