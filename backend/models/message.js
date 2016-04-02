var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var MessageSchema = new Schema({
    message: { type: String, required: true },
    userName: { type: String, required: true },
    date: { type: Date, default: Date.now },
    roomId: { type: String, required: true }
});

module.exports = mongoose.model('Message', MessageSchema);
