const mongoose = require('mongoose');
const commentSchema = require('./comment.js')
const DBusers = require('./user.js')

const postSchema = new mongoose.Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    encodedMedia: { type: String, required: true },
    caption: { type: String, required: false },
    comments: {
        type: [commentSchema],
        validate: {
            validator: (comments) => Array.isArray(comments),
            message: 'Comments must be an array.'
        },
        default: []
    },
    likes: { type: [mongoose.Schema.Types.ObjectId], ref: 'User', required: false, default: [] },
    tags: { type: [String], required: true, default: [] }
}, { timestamps: true });


postSchema.statics.validatePost = (req) => {
    const errorMsgs = []

    if (!req.user) { errorMsgs.push('no user assigen to post') }
    if (!req.encodedMedia) { errorMsgs.push('no media found') }

    return errorMsgs;
}


postSchema.statics.addPost = async (req) => {
    const userID = new mongoose.Types.ObjectId(req.user);

    const newPost = {
        user: userID,
        encodedMedia: req.encodedMedia,
        caption: req.caption,
        tags: req.tags
    };

    const post = await DBposts.create(newPost);

    const author = await DBusers.findById(userID);
    if (author) {
        await author.addPost(post._id);
    }
};

postSchema.methods.addComment = async function (comment) {
    if (!this.comments) {
        this.comments = []; // Initialize comments array if undefined
    }

    // Exclude the `_id` property from the comment
    const { _id, ...commentWithoutId } = comment;
    delete comment._id;

    this.comments.push(commentWithoutId);
    await this.save();
};

postSchema.methods.deleteComment = async function (commentID) {
    console.log(commentID)
    let index = 0
    for (comment of this.comments) {
        if (comment._id == commentID) {
            this.comments.splice(index, 1)
        }
        index++;
    }
    await this.save();
}


postSchema.methods.toogleCommentLike = async function (userID, commentID) {
    // Find the comment by its ID
    const comment = this.comments.id(commentID);

    if (!comment) {
        throw new Error('Comment not found');
    }

    // Toggle the like for the user
    const userIndex = comment.likes.indexOf(userID);

    if (userIndex !== -1) {
        // User already liked the comment, so remove the like
        comment.likes.splice(userIndex, 1);
    } else {
        // User has not liked the comment, so add the like
        comment.likes.push(userID);
    }

    // Log the updated likes for the comment
    console.log(comment.likes);

    // Mark the likes array as modified to ensure Mongoose saves the changes
    this.markModified('comments');

    // Save the post document with the updated comment
    await this.save();
    return this;
}


postSchema.methods.update = async function (newPostVersion) {
    let changedSaved = false;

    if (DBposts.validatePost(newPostVersion).length > 0) {
        return changedSaved;
    } else {
        try {
            const currentPost = await DBposts.findById(this._id);
            if (currentPost.__v !== this.__v) {
                return changedSaved;
            }

            this.caption = newPostVersion.caption
            this.comments = newPostVersion.comments
            this.likes = newPostVersion.likes
            this.tags = newPostVersion.tags

            changedSaved = true;
        } catch (e) {
            console.log(e);
        }
    }

    await this.save();
    return changedSaved;
};

const DBposts = mongoose.model('Post', postSchema);

module.exports = DBposts;