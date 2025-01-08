const express = require("express");
const router = express.Router();
router.use(express.json({ limit: '10mb' }));
const axios = require('axios')

router.get('/:userID', async (req, res) => {
    console.log(req.params.userID);
    let data;
    try {
        const response = await fetch(`https://facegram-a94d9-default-rtdb.firebaseio.com/users/${req.params.userID}.json`, {
            method: 'GET'
        });
        const rawData = await response.json();

        // Convert dictionary to array
        if (rawData && typeof rawData === 'object') {
            data = Object.entries(rawData).map(([id, notification]) => ({
                id,
                ...notification
            }));
        } else {
            data = [];
        }
    } catch (e) {
        console.error("Error fetching data:", e);
        return res.status(500).send();
    }

    if (data && data.length > 0) {
        console.log("Fetched data:", data);
        res.status(200).json(data);
    } else {
        console.log("No data found");
        res.status(404).send();
    }
});


module.exports = router;