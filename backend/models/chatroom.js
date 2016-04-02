var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var ChatRoomSchema = new Schema({
    roomId: {type: String, required: true, unique: true},
    date: { type: Date, default: Date.now },
    members: []
});

module.exports = mongoose.model('ChatRoom', ChatRoomSchema);
