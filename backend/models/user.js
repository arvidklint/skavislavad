var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var userSchema = new Schema({
    userName: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    balance: { type: Number },
    profilePicture: { type: String },
    friends: {}

});

module.exports = mongoose.model('user', userSchema);
