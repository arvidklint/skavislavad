var BetEvent = require('../models/betevent');
var r = require('../response.js');

module.exports.post = function(req, res) {
    var betevent = new BetEvent();      // create a new instance of the betevent model

    if (!req.body.betName || !req.body.userName) {
        res.json(r.error("betName or userName is not specified"));
    }
    betevent.betName = req.body.betName;
    betevent.userName = req.body.userName;
    betevent.description = req.body.description;
    betevent.betAmount = req.body.betAmount;
    if (req.body.startTime) {
        betevent.startTime = req.body.startTime;
    }
    betevent.endTime = req.body.endTime;

    // save the betevent and check for errors
    betevent.save(function(err) {
        if (err){
            res.json(r.error(err));
        }
        res.json(r.post('betevent created!'));
    });
};

module.exports.get = function(req, res) {
    BetEvent.find(function(err, betevent) {
        if (err){
            res.json(r.error(err));
        }
        res.json(r.get(betevent));
    });
};

module.exports.getUserById = function(id, res) {
    BetEvent.findById(id, function(err, betevent) {
        if (err){
            res.json(r.error(err));
        }
        res.json(r.get(betevent));
    });
};

module.exports.putUserById = function(id, res) {
    // use our betevent model to find the betevent we want
    BetEvent.findById(id, function(err, betevent) {
        if (err){
            res.json(r.error(err));
        }

        betevent._id = id;

        // save the betevent
        betevent.save(function(err) {
            if (err){
                res.json(r.error(err));
            }
            res.json(r.put('Betevent updated!'));
        });
    });
};

module.exports.getUser = function(userName, res) {
    BetEvent.find({ userName: userName }, function(err, betevents) {
        if (err){
            res.json(r.error(err));
        }
        res.json(r.get(betevents));
    });
};
