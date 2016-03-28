var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var placedBetsSchema = new Schema({
    userName: { type: String, required: true },
    betId:  { type: String, required: true },
    type: String
});

module.exports = mongoose.model('PlacedBets', placedBetsSchema);
