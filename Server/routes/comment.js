const express = require("express");
const router = express.Router();
router.use(express.json({ limit: '10mb' }));

const DBusers = require('../modals/user.js')
const DBposts = require('../modals/post.js')


router.post('/', async (req, res) => {

    let post;
    if (req.body.post && req.body.post.length > 0) {
        post = await DBposts.findById(req.body.post)
    } else[
        res.status(404).json({ messege: "no post id found" })
    ]

    if (post) {
        try {
            post.addComment(req.body)
            console.debug('comment added')
            res.status(200).json({ messege: "comment added" })
        } catch (e) {
            console.log('error post comment: ', e)
            res.status(500).json({ messege: "error post comment" })
        }
    } else {
        console.log('no post found')
        res.status(404).json({ messege: "no post found" })
    }
})

router.delete('/:postID/:commentID', async (req, res) => {
    const post = await DBposts.findById(req.params.postID)
    if (post) {
        post.deleteComment(req.params.commentID)
        console.log('comment deleted')
        res.status(200).json({ messege: 'comment deleted' })
    } else {
        res.status(404).json({ messege: "no post found" })
    }
})

router.post('/like/:commentID', async (req, res) => {
    try {
        const post = await DBposts.findById(req.body.postID);
        if (post) {
            await post.toogleCommentLike(req.body.userID, req.params.commentID);
            console.log(post);
            res.status(200).json({ message: 'like toggled' });
        } else {
            console.log('no post found');
            res.status(404).json({ message: 'Post not found' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
});


module.exports = router;