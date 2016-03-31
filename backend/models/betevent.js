var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var BetEventSchema = new Schema({
	betName: { type: String, required: true},
    userName: { type: String, required: true },
	description: String,
    betAmount: Number,
    startTime: { type: Date, default: Date.now },
    endTime: Date,
	finished: { type: Boolean, default: false},
	result: {type: String, default: "ongoing" }
});

module.exports = mongoose.model('BetEvent', BetEventSchema);
