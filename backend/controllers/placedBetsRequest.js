var PlacedBets = require('../models/placedbets');
var BetEvent = require('../models/betevent');
var r = require('../response.js');

module.exports.post = function(req, res) {
    var placedbets = new PlacedBets();      // create a new instance of the placebets

    if (!req.body.userName || !req.body.betId || !req.body.type) {
        res.json(r.error("userName, betId or type is not set"));
    }

    placedbets.userName = req.body.userName;
    placedbets.betId = req.body.betId;
    placedbets.type = req.body.type;

    // save the bear and check for errors
    placedbets.save(function(err) {
        if (err){
            res.json(r.error(err));
        }
        res.json(r.post("Success"));
    });
};

module.exports.get = function(req, res) {
    var userName = req.query.userName;
    var betId = req.query.betId;
    if (userName && betId) {
      PlacedBets.find({"userName": userName, "betId": betId}, function(err, placedbets) {
        if (err){
          res.json(r.error(err));
        }
        if (placedbets.length > 0) {
          res.json(r.get(placedbets));
        } else {
          res.json(r.error("no bets"));
        }
      });
    } else {
      PlacedBets.find(function(err, placedbets) {
        if (err) {
          res.json(r.error(err));
        }
        res.json(r.get(placedbets));
      });
    }
};

module.exports.getPlacedBetsByUserName = function(userName, res) {
    PlacedBets.find({ userName: userName }, function(err, placedbets) {
        if (err){
            res.json(r.error(err));
        }

        placedBetsIds = placedbets.map(function(bet){ return bet.betId; });

        BetEvent.find({ _id: { $in: placedBetsIds }}, function(err, betevents){
            if (err){
                res.json(r.error(err));
            }
            reformBetEvents = [];
            for(var i in betevents){
                var reformedObj = {
                    betAmount : betevents[i].betAmount,
                    description : betevents[i].description,
                    betName : betevents[i].betName,
                    userName : betevents[i].userName,
                    _id : betevents[i]["_id"],
                    finished : betevents[i].finished,
                    whatYouGuessed : placedbets[i].type
                };
                reformBetEvents.push(reformedObj);
            }
            res.json(r.get(reformBetEvents));
        });
    });
};


module.exports.getVotes = function(betId, res) {
    PlacedBets.find({"betId": betId}, function(err, placedbets){
        if (err){
            res.json(r.error(err));
        }

        var yesVoterArray = [];
        var noVoterArray = [];

        for (var i in placedbets){
            if(placedbets[i].type === "yes"){
                yesVoterArray.push(placedbets[i]);
            }
            else{
                noVoterArray.push(placedbets[i]);
            }
        }

        var value = {
            "yesVoters": yesVoterArray,
            "noVoters": noVoterArray
        };

        res.json(r.get(value));
    });
};
