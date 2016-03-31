var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var userSchema = new Schema({
    userName: { type: String, required: true, unique: true },
    password: { type: String },
    balance: { type: Number , default: 500 },
    profilePicture: { type: String },
    friends: []
});

module.exports = mongoose.model('User', userSchema);
