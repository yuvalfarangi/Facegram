const express = require("express");
const router = express.Router();
router.use(express.json({ limit: '10mb' }));

const generateTags = require('../API/imagga.js')

router.post('/', async (req, res) => {
    try {
        const tags = await generateTags(req.body.image_base64);
        res.status(200).json({ tags: tags });
    } catch (e) {
        console.log(e);
        res.status(500).json({ error: 'An error occurred' });
    }
})

module.exports = router;