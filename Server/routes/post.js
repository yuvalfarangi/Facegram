const express = require("express");
const router = express.Router();
router.use(express.json({ limit: '10mb' }));

const DBusers = require('../modals/user.js')
const DBposts = require('../modals/post.js')

const notification = require('../modals/notification.js')

router.get('/:id', async (req, res) => {
    try {
        const post = await DBposts.findById(req.params.id);
        if (!post) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.json(post);
    } catch (error) {
        res.status(500).json({ message: 'Server error', error });
    }
});

router.post('/', async (req, res) => {

    try {
        await DBposts.addPost(req.body)
        res.status(200).json({ message: 'post uploaded' })
    } catch (e) {
        console.log(e)
        res.status(500).json({ message: 'error uploading post' })
    }
})

router.get('/tag/:tag', async (req, res) => {
    try {
        const { tag } = req.params;
        console.log("Looking for posts with tag:", tag); // works

        const posts = await DBposts.find({ tags: { $in: [tag] } });
        console.log("Found posts:", posts); // works

        if (!posts || posts.length === 0) {
            console.log('No posts found');
            return res.status(404).json({ message: 'No posts found with this tag' });
        }

        const postIds = posts.map(post => post._id.toString());
        res.json(postIds);
    } catch (error) {
        console.log("Error occurred:", error);
        res.status(500).json({ message: 'Server error', error });
    }
});


router.patch('/:id/:actionType', async (req, res) => {

    console.log(req.params.actionType)
    const post = await DBposts.findById(req.params.id);

    if (post) {

        if (post.update(req.body)) {
            console.log('post updated')

            switch (req.params.actionType) {
                case 'like':
                    await new notification(
                        "Like",
                        "New Like!",
                        "Someone liked your post!",
                        req.body.user
                    ).post();
                    break;
            }

            res.status(200).json({ message: 'post updated' });
        }

    } else {
        console.log('user post found')
        res.status(404).json({ message: 'User not found' });
    }
})

module.exports = router;