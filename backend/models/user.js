var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var userSchema = new Schema({
    userName: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    balance: Number,
    profilePicture: String,
    friends: {}

});

module.exports = mongoose.model('user', userSchema);
