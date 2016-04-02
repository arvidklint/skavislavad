var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var ChatRoomSchema = new Schema({
    date: { type: Date, default: Date.now },
    members: []
});

module.exports = mongoose.model('ChatRoom', ChatRoomSchema);
