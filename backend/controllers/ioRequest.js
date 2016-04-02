var Message = require('../models/message');
var ChatRoom = require('../models/chatroom');
var r = require('../response.js');


module.exports.saveMessage = function(m, u, id) {
    var message = new Message();

    message.message = m;
    message.userName = u;
    message.roomId = id;

    message.save(function() {
        console.log("message saved");
    });
};

module.exports.getMessagesFromRoom = function(roomId, io) {
    Message.find({"roomId": roomId}, function(err, messages) {
        
    });
};
