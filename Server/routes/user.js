const express = require("express");
const mongoose = require('mongoose')
const bcrypt = require('bcrypt');
const router = express.Router();
const DBusers = require('../modals/user.js')

const notification = require('../modals/notification.js')

router.use(express.json({ limit: '10mb' }));

router.get('/id/:id', async (req, res) => {

    if (req.params.id == "all") {
        const users = await DBusers.find({});
        if (users) { res.status(200).json(users); }
        else { res.status(404).json({ message: 'User not found' }); }

    } else {
        try {
            const user = await DBusers.findById(req.params.id);
            if (!user) {
                return res.status(404).json({ message: 'User not found' });
            }
            res.json(user);
        } catch (error) {
            res.status(500).json({ message: 'Server error', error });
        }
    }
});


router.get('username/:username', async (req, res) => {
    try {
        const users = await DBusers.find({ username: req.params.username });
        if (users.length === 0) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.json(users[0]);
    } catch (error) {
        res.status(500).json({ message: 'Server error', error });
    }
});

router.post('/login', async (req, res) => {

    const { username, password } = req.body;

    console.log(req.body)

    const user = await DBusers.findOne({ username });
    if (user) {
        res.status(200).json(user) //debugging
    }

    // if (user) {
    //     console.log(user)
    //     const valid = await bcrypt.compare(password, user.password);
    //     if (valid) {
    //         res.status(200).json(user)
    //     }
    //     else {
    //         console.log("passwords do not match")
    //         res.status(401).json({ message: "incorrect password" })
    //     }
    // } else {
    //     console.log('no user found')
    //     res.status(404).json({ message: "no user found" })
    // }
})


router.post('/', async (req, res) => {
    console.log(req.body)
    try {
        await DBusers.addNewUser(req.body)
        res.status(200).json({ message: "User created successfully", status: 200 })
    } catch (e) {
        console.log('Error posting data: ', e)
        res.status(500).json({ message: "Error create user", status: 500 })
    }
})

router.patch('/:id/:actionType', async (req, res) => {

    console.log(req.params.actionType)
    console.log(req.body)

    const user = await DBusers.findById(req.params.id);

    if (user) {

        if (user.update(req.body)) {
            console.log('user updated')

            switch (req.params.actionType) {
                case 'follow':
                    await new notification(
                        "Follow",
                        "New Follower!",
                        "Someone followed new on Facegram!",
                        req.params.id
                    ).post();
                    break;
            }

            res.status(200).json({ message: 'User updated' });
        }

    } else {
        console.log('user not found')
        res.status(404).json({ message: 'User not found' });
    }
})

module.exports = router;