var User = require('../models/user');
var r = require('../response.js');

module.exports.post = function(req, res) {
    var user = new User();   // create a new instance of the User model

    if (!req.body.userName) {
        res.json(r.error("userName must be specified"));
    }

    user.userName = req.body.userName;
    user.password = req.body.password;
    if (req.body.balance) {
        user.balance = req.body.balance;
    }
    user.profilePicture = req.body.profilePicture;

  // save the user and check for errors
  user.save(function(err) {
    if (err){
      res.json(r.error(err));
    }
    res.json(r.post('User created'));
  });
};

module.exports.get = function(req, res) {
  User.find(function(err, users) {
    if (err){
      res.json(r.error(err));
    }
    res.json(r.get(users));
  });
}

module.exports.getUser = function(userName, res) {
  User.findOne({ userName: userName }, function(err, user) {
      if (err){
          res.json(r.error(err));
      }
      res.json(r.get(user));
  });
}

module.exports.putUser = function(userName, res) {
  // use our user model to find the user we want
  User.findOne({ userName : req.params.userName }, function(err, user) {
      if (err){
          res.send(err);
      }
      user.userName = userName;
      // save the user
      user.save(function(err) {
          if (err){
              res.json(r.error(err));
          }

          // Create a new BalanceHistory instance with username, new balance, and the change, and saves it.
          var balancehistory = new BalanceHistory({
              userName : user.userName,
              newBalance : user.balance,
              changedAmount : req.body.balance
          });

          balancehistory.save(function(err){
              if(err){
                  console.log('error in user .put balancehistory save');
                  res.send(err);
              }
          });

          res.json({ message : 'User updated!' });
      });
  });
}

module.exports.deleteUser = function(userName, res) {
    User.findOneAndRemove({ userName: req.params.userName  }, function(err, user) {
        if (err){
            res.json(r.error(err));
        }
        res.json(r.delete('Successfully deleted user'));
    });
}
