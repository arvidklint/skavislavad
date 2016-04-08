var BetEvent = require('../models/betevent');
var r = require('../response.js');
var PlacedBets = require('../models/placedbets');
var User = require('../models/user');
var BalanceHistory = require('../models/balancehistory');

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
        res.json(r.post(betevent));
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

module.exports.getUnfinished = function(req, res) {
    BetEvent.find({"finished": false}, function(err, betevent) {
        if (err){
            res.json(r.error(err));
        }
        console.log(betevent);
        res.json(r.get(betevent));
    });
};

module.exports.getBetEventById = function(id, res) {
    BetEvent.findById(id, function(err, betevent) {
        if (err){
            res.json(r.error(err));
        }
        res.json(r.get(betevent));
    });
};

module.exports.putBetEventById = function(id, res) {
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

module.exports.getBetEventsByUser = function(userName, res) {
    BetEvent.find({ userName: userName }, function(err, betevents) {
        if (err){
            res.json(r.error(err));
        }
        res.json(r.get(betevents));
    });
};

module.exports.finishBetEvent = function(betId, result, res) {
    BetEvent.findById(betId, function(err, betevent){
        if (err){
            res.json(r.error(err));
        }
        betevent.finished = true;
        betevent.result = result;
        var betAmount = betevent.betAmount;
        betevent.save(function(err){
            if (err){
                res.json(r.error(err));
            }

            PlacedBets.find({ betId: betId}, function(err, placedbets){
                if(err){
                    res.json(r.error(err));
                }

                var numberOfBetters = placedbets.length;
                var totalAmount = numberOfBetters * betAmount;

                console.log(placedbets);

                var yesBetters = 0;
                var noBetters = 0;
                for (var i = 0; i < placedbets.length; i++) {
                    console.log(placedbets[i].type);
                    if (placedbets[i].type == "no") {
                        noBetters++;
                    } else {
                        yesBetters++;
                    }
                }

                console.log(yesBetters, noBetters);

                if (result === "yes") {
                    var winAmount = totalAmount / yesBetters;
                } else if (result === "no") {
                    var winAmount = totalAmount / noBetters;
                }

                console.log("WinAmount: " + winAmount);

                for (var i = 0; i < placedbets.length; i++) {
                    var doit = (function() {
                        var b = placedbets[i];
                        var r = result;
                        var w = winAmount;
                        console.log(b, r, w);
                        return function() {
                            User.findOne({"userName": b.userName}, function(err, user) {
                                if (b.type == r) {
                                    console.log(w);
                                    user.balance += w;

                                    var balanceHistory = new BalanceHistory();
                                    balanceHistory.userName = user.userName;
                                    balanceHistory.newBalance = user.balance;
                                    balanceHistory.changedAmount = w;

                                    balanceHistory.save(function(err) {
                                        if (err) {
                                            console.log(err);
                                        }
                                    });

                                    user.save(function(err) {
                                        if (err) {
                                            console.log(err);
                                        }
                                    });
                                }
                            });
                        }
                    })();
                    doit();
                }

                res.json(r.put("Success"));
            })
        });
    })
}
