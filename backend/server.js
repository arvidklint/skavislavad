// call the packages we need
var express = require('express');        // call express
var app = express();                 // define our app using express
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
// <<<<<<< UNCOMMENT WHEN WORKING LOCAL! >>>>>>>
// mongoose.connect('mongodb://localhost:27017/test'); 

mongoose.connect('mongodb://projekt:projekt@ds021969.mlab.com:21969/internetprogrammering16'); // anv: projekt, pw: projekt


var Bear = require('./models/bear');
var User = require('./models/user');
var BetEvent = require('./models/betevent');
var PlacedBets = require('./models/placedbets');
var BalanceHistory = require('./models/balancehistory');

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 3000;        // set our port

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

        var user = new User();   // create a new instance of the User model

        assignParametersToSchema(req, user);

        // save the user and check for errors
        user.save(function(err) {
            if (err){
                res.send(err);
            }

        res.json({ message: 'User created!' });
        });
    })

    .get(function(req, res) {
        User.find(function(err, users) {
            if (err){
                res.send(err);
            }

        res.json(users);
        });
    });


// on routes that end in /user/:user_id
// ----------------------------------------------------
router.route('/user/:userName')

    // get the user with that id (accessed at GET http://localhost:3000/api/user/:user_id)
    .get(function(req, res) {
        User.findOne({ userName: req.params.userName }, function(err, user) {
            if (err){
                res.send(err);
            }
            res.json(user);
        });
    })

    // update the user with this id (accessed at PUT http://localhost:3000/api/user/:user_id)
    .put(function(req, res) {

        // use our user model to find the user we want
        User.findOne({ userName : req.params.userName }, function(err, user) {
            if (err){
                res.send(err);
            }
            assignParametersToSchema(req, user);
            // save the user
            user.save(function(err) {
                if (err){
                    console.log('Error in user .put user save');
                    res.send(err);
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
    })

    // delete the user with this id (accessed at DELETE http://localhost:3000/api/user/:user_id)
    .delete(function(req, res) {
        User.findOneAndRemove({ userName: req.params.userName  }, function(err, user) {
            if (err){
                res.send(err);
            }
            res.json({ message : 'Successfully deleted user' });
            // user.remove(function(err){
            //     if (err){
            //         res.send(err);
            //     }
            //     res.json({ message : 'Successfully deleted user' });
            // });
        });
        // User.remove(function(err, user) {
        //     console.log('hej');
        //     if (err){
        //         res.send(err);
        //     }
           
        // });
    });



//Route for betevent
router.route('/betevent')
    .post(function(req, res) {

        var betevent = new BetEvent();      // create a new instance of the betevent model

        assignParametersToSchema(req, betevent);

        // save the betevent and check for errors
        betevent.save(function(err) {
            if (err){
                res.send(err);
            }
            res.json({ message: 'betevent created!' });
        });
    })

    .get(function(req, res) {
        BetEvent.find(function(err, betevent) {
            if (err){
                res.send(err);
            }
            res.json(betevent);
        });
    });


// on routes that end in /betevent/:betevent_id
// ----------------------------------------------------
router.route('/betevent/:betevent_id')

    // get the betevent with that id (accessed at GET http://localhost:3000/api/betevent/:betevent_id)
    .post(function(req, res) {
        BetEvent.findById(req.params.betevent_id, function(err, betevent) {

            if (err){
                res.send(err);
            }
            res.json(betevent);
        });
    })

    // update the betevent with this id (accessed at PUT http://localhost:3000/api/betevent/:betevent_id)
    .put(function(req, res) {

        // use our betevent model to find the betevent we want
        BetEvent.findById(req.params.betevent_id, function(err, betevent) {

            if (err){
                res.send(err);
            }

            assignParametersToSchema(req, betevent);

            // save the betevent
            betevent.save(function(err) {
                if (err){
                    res.send(err);
                }
                res.json({ message: 'Betevent updated!' });
            });
        });
    });


//Route for placedbets
router.route('/placedbets')
    .post(function(req, res) {

        var placedbets = new PlacedBets();      // create a new instance of the placebets

        assignParametersToSchema(req, placebets);

        // save the bear and check for errors
        placedbets.save(function(err) {
            if (err){
                res.send(err);
            }
            res.json({ message: 'You placed a bet!' });
        });
    })

    .get(function(req, res) {
        placedBets.find(function(err, placedbets) {
            if (err){
                res.send(err);
            }
            res.json(placedBets);
        });
    });


//Route for balancehistory
router.route('/balancehistory')
    .post(function(req, res) {

        var balancehistory = new BalanceHistory();      // create a new instance of the BalanceHistory

        assignParametersToSchema(req, balancehistory);

        // save the bear and check for errors
        balancehistory.save(function(err) {
            if (err){
                res.send(err);
            }
            res.json({ message: 'Your balance history!' });
        });
    })

    .get(function(req, res) {
        BalanceHistory.find(function(err, balancehistories) {
            if (err){
                res.send(err);
            }
            res.json(balancehistories);
        });
    });

router.route('/balancehistory/:userName')
    .get(function(req, res){
        BalanceHistory.find({ userName: req.params.userName }, function(err, balancehistories) {
            if (err){
                res.send(err);
            }
            res.json(balancehistories);
        }).sort( { "balanceChange" : -1 } );
    });


// all of our routes will be prefixed with /api
app.use('/api', router);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Magic happens on port ' + port);
