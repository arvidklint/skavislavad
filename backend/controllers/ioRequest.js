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

module.exports.getMessagesFromRoom = function(roomId, res) {
    Message.find({"roomId": roomId}, function(err, messages) {
        if(err) {
            res.json(r.error(err));
        }
        res.json(r.get(messages));
    });
};

module.exports.createChatRoom = function(clientSocket, members, dateId) {
	var room = new ChatRoom();
	room.members = members;
	room.roomId = dateId;

	room.save(function(err) {
        if (err){
            console.log("err:" + err);
        }
        console.log(room);
        clientSocket.emit("room", room);
    });
};
