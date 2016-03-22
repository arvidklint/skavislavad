var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var placedBetsSchema = new Schema({
    userName: { type: String, required: true, unique: true },
    betId:  { type: Number, unique: true },
    type: Boolean
});

module.exports = mongoose.model('placedBets', placedBetsSchema);