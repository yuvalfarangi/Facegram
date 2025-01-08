const mongoose = require('mongoose');

const commentSchema = new mongoose.Schema(
    {
        user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
        post: { type: mongoose.Schema.Types.ObjectId, ref: 'Post', required: true },
        commentText: { type: String, required: true, minlength: 1 },
        likes: {
            type: [mongoose.Schema.Types.ObjectId],
            ref: 'User',
            default: []
        }
    },
    { timestamps: true }
);

module.exports = commentSchema;