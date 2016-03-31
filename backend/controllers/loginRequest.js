var User = require('../models/user');
var r = require('../response.js');

module.exports.get = function(req, res) {
    User.find({userName: req.params.userName}, function(err, users) {
        if (err) {
            res.json(r.error(err));
        }
        if (users.length <= 0) {
            res.json(r.error("Error: user not found"));
        } else {
            res.json(r.get("Success"));
        }
    });
};
