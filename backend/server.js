var express = require('express');
var app = express();
var http = require('http').Server(app);
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
var io = require('socket.io')(http);

// <<<<<<< UNCOMMENT WHEN WORKING LOCAL! >>>>>>>
// mongoose.connect('mongodb://localhost:27017/test');

mongoose.connect('mongodb://projekt:projekt@ds021969.mlab.com:21969/internetprogrammering16'); // anv: projekt, pw: projekt


var Bear = require('./models/bear');
var User = require('./models/user');
var BetEvent = require('./models/betevent');
var PlacedBets = require('./models/placedbets');
var BalanceHistory = require('./models/balancehistory');
var ChatRoom = require('./models/chatroom');

var userRequest = require('./controllers/userRequest');
var betEventRequest = require('./controllers/betEventRequest');
var placedBetsRequest = require('./controllers/placedBetsRequest');
var balanceHistoryRequest = require('./controllers/balanceHistoryRequest');
var loginRequest = require('./controllers/loginRequest');
var registerRequest = require('./controllers/registerRequest');
var ioRequest = require('./controllers/ioRequest');
var chatRoomRequest = require('./controllers/chatRoomRequest');

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 3000;

// ROUTES FOR OUR API
// =============================================================================
var router = express.Router();              // get an instance of the express Router

// middleware to use for all requests
router.use(function(req, res, next) {
    // do logging
    console.log('Something is happening.');
    next(); // make sure we go to the next routes and don't stop here
});

// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
router.get('/', function(req, res) {
    res.json({ message: 'hooray! welcome to our api!' });
});


function assignParametersToSchema(req, schema){
    for (var param in req.body) {
        if(param === 'balance' && schema[param] != null){
            schema[param] = parseInt(schema[param]) + parseInt(req.body[param]);
        }else{
            schema[param] = req.body[param];
        }
    }
}

//        Routes for our API      \\
//----------------------------------\\

//Route for Users
router.route('/bears')
    .post(function(req, res) {

        var bear = new Bear();   // create a new instance of the User model

        assignParametersToSchema(req, bear);

        // save the user and check for errors
        bear.save(function(err) {
                if (err){
                    res.send(err);
                }

            res.json({ message: 'Bear created!' });
            });
        })

        .get(function(req, res) {
        Bear.find(function(err, bears) {
            if (err){
                res.send(err);
            }

        res.json(bears);
        });
    });


//Route for Users
router.route('/user')
  .post(function(req, res) {
    userRequest.post(req, res);
  })
  .get(function(req, res) {
    userRequest.get(req, res);
  });


// on routes that end in /user/:user_id
// ----------------------------------------------------
router.route('/user/:userName')

    // get the user with that id (accessed at GET http://localhost:3000/api/user/:user_id)
    .get(function(req, res) {
      userRequest.getUser(req.params.userName, res);
    })

    // update the user with this id (accessed at PUT http://localhost:3000/api/user/:user_id)
    .put(function(req, res) {
        userRequest.putUser(req.params.userName, req.body.balance, res);
    })

    // delete the user with this id (accessed at DELETE http://localhost:3000/api/user/:user_id)
    .delete(function(req, res) {
        userRequest.deleteUser(req.params.userName, res);
    });

router.route('/updatebalance')
    .put(function(req, res) {
        userRequest.updateBalance(req.body.userName, req.body.balance, res);
    });

router.route('/addfriend')
    .put(function(req, res){
        userRequest.addFriend(req.body.userName, req.body.friendName, res);
    });

router.route('/deleteFriend')
    .put(function(req, res){
        userRequest.deleteFriend(req.body.userName, req.body.friendName, res);
    });

router.route('/getFoes/:userName')
    .get(function(req, res){
        userRequest.getFoes(req.params.userName, res);
    });

router.route('/getFriends/:userName')
    .get(function(req, res){
        userRequest.getFriends(req.params.userName, res);
    });



//Route for betevent
router.route('/betevent')
    .post(function(req, res) {
        betEventRequest.post(req, res);
    })

    .get(function(req, res) {
        betEventRequest.get(req, res);
    });

router.route('/betevent/unfinished')
    .get(function(req, res) {
        betEventRequest.getUnfinished(req, res);
    });


// on routes that end in /betevent/:betevent_id
// ----------------------------------------------------

router.route('/betevent/id/:betevent_id')
    // get the betevent with that id (accessed at GET http://localhost:3000/api/betevent/:betevent_id)
    .get(function(req, res) {
        betEventRequest.getBetEventById(req.params.betevent_id, res);
    });

router.route('/betevent/id/:betId')
    // update the betevent with this id (accessed at PUT http://localhost:3000/api/betevent/:betevent_id)
    .put(function(req, res) {
        betEventRequest.putBetEventById(req.params.betevent_id, res);
    });

router.route('/betevent/votes/:betId')
    .get(function(req, res){
        placedBetsRequest.getVotes(req.params.betId, res);
    });



router.route('/betevent/:userName')
    .get(function(req, res){
        betEventRequest.getBetEventsByUser(req.params.userName, res);
    });


//Route for placedbets
router.route('/placedbets')
    .post(function(req, res) {
        placedBetsRequest.post(req, res);
    })

    .get(function(req, res) {
        placedBetsRequest.get(req, res);
    });

router.route('/placedbets/:userName')
    .get(function(req, res){
        placedBetsRequest.getPlacedBetsByUserName(req.params.userName, res);
    });


//Route for balancehistory
router.route('/balancehistory')
    .post(function(req, res) {
        balanceHistoryRequest.post(req, res);
    })

    .get(function(req, res) {
        balanceHistoryRequest.get(req, res);
    });

router.route('/balancehistory/:userName')
    .get(function(req, res){
        balanceHistoryRequest.getBalanceHistoryByUserName(req.params.userName, res);
    });

router.route('/login/:userName')
    .get(function(req, res) {
        loginRequest.get(req, res);
    });

router.route('/register')
    .post(function(req, res) {
        registerRequest.post(req, res);
    });

router.route('/finishedbets')
    .put(function(req, res){
        betEventRequest.finishBetEvent(req.body.betId, req.body.result, res);
    });

router.route('/getrooms/:userName')
    .get(function(req, res) {
        chatRoomRequest.getChatRooms(req.params.userName, res);
    });

router.route('/getmessages/:roomId')
    .get(function(req, res) {
        ioRequest.getMessagesFromRoom(req.params.roomId, res);
    });

// all of our routes will be prefixed with /api
app.use('/api', router);

// START THE SERVER
// =============================================================================
http.listen(port);

// IO STUFF
// =============================================================================
var typingUsers = {};
var sockets = {};
var users = {};

io.on('connection', function(clientSocket) {
    console.log('a user connected');

    clientSocket.on('connectUser', function(username){
        console.log(username + " connected to skavislavad");
        users[username] = clientSocket.id;
        sockets[clientSocket.id] = {
            "username" : username,
            "socket" : clientSocket
        };
    });

    clientSocket.on('disconnect', function() {
        console.log('user disconnected');
    });

    clientSocket.on('chatMessage', function(message, roomId){
        var currentDateTime = new Date().toLocaleString();
        var sender = sockets[clientSocket.id].username;
        console.log("hehe");
        var msg =  {
            "date" : currentDateTime,
            "message" : message,
            "from" : sender
        };

        ioRequest.saveMessage(message, sender, roomId);

        ChatRoom.find({"roomId": roomId}, function(err, room) {
            if (err){
                console.log("error: " + err);
                // res.json(r.error(err));
            }
            for(var member in room.members){
                sockets[users[room.members[member]]].socket.emit('receiveMessage', msg);
            }
        });

    });

    clientSocket.on('connectToRoom', function(clientUsername, otherUsername, roomId) {
        var message = "User " + clientUsername + " was connected.";
        console.log(message);
    });

    clientSocket.on('joinChatRoomWithMembers', function(members) {
        console.log("Creating new room");

        ChatRoom.find(function(err, rooms) {
            var exists = false;
            var room = {};
            for (var roomIndex in rooms) {
                var isTheSame = true;
                for (var memberIndex in rooms[roomIndex].members) {
                    var member = rooms[roomIndex].members[memberIndex];
                    if (members.indexOf(member) <= -1) {
                        isTheSame = false;
                    }
                }
                if (isTheSame) {
                    console.log("Rummet finns");
                    exists = true;
                    room = rooms[roomIndex];
                    break;
                }
            }
            var receiver = sockets[clientSocket.id].socket;
            if (exists) {
                receiver.emit("room", room);
            } else {
                var currentDateTime = String(new Date().getTime());
                ioRequest.createChatRoom(receiver, members, currentDateTime);
            }
        });
    });

    clientSocket.on('joinChatRoomWithId', function(roomId) {
        console.log("Joining room with id: " + roomId);
    });
});

console.log('Magic happens on port ' + port);
