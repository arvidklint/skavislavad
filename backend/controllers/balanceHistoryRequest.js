var BetEvent = require('../models/placedbets');
var r = require('../response.js');

module.exports.post = function(req, res) {
    var balancehistory = new BalanceHistory();      // create a new instance of the BalanceHistory

    if (!req.body.userName) {
        res.json(r.error("userName is not defined"));
    }

    balancehistory.userName = req.body.userName;
    balancehistory.newBalance = req.body.newBalance;
    balancehistory.changedAmount = req.body.changedAmount;
    balancehistory.balanceChange = req.body.balanceChange;

    // save the bear and check for errors
    balancehistory.save(function(err) {
        if (err){
            res.jsone(r.error(err));
        }
        res.json(r.post('Your balance history!'));
    });
};

module.exports.get = function(req, res) {
    BalanceHistory.find(function(err, balancehistories) {
        if (err){
            res.json(r.error(err));
        }
        res.json(r.get(balancehistories));
    });
};

module.exports.getBalanceHistoryByUserName = function(userName, res) {
    BalanceHistory.find({ userName: req.params.userName }, function(err, balancehistories) {
        if (err){
            res.json(r.error(err));
        }
        res.json(r.get(balancehistories));
    }).sort( { "balanceChange" : -1 } );
};
