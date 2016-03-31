var User = require('../models/user');
var r = require('../response.js');

module.exports.post = function(req, res) {
    User.find({username: req.body.userName}, function(err, users) {
        if (err) {
            res.json(r.error("Error getting users"));
        }
        if (users.length <= 0) {

            var user = new User();
            user.userName = req.body.userName;
            user.save(function(err) {
                if (err) {
                    res.json(r.error("Error creating the user"));
                }
                res.json(r.post("Success"));
            });
        } else {
            res.json(r.error("Användaren finns redan"));
        }
    })
};
