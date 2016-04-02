var ChatRoom = require('../models/chatroom');
var r = require('../response.js');

module.exports.getChatRooms = function(username, res) {
    ChatRoom.find(function(err, rooms) {
        if (err) {
            res.json(r.error(err));
        }
        var returnArray = [];
        for (var roomIndex in rooms) {
            if (rooms[roomIndex].members.indexOf(username) > -1) {
                returnArray.push(rooms[roomIndex]);
            }
        }
        res.json(r.get(returnArray));
    });
};
