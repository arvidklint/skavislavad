var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var betEventSchema = new Schema({ 
	betName: { type: String, required: true},
    userName: { type: String, required: true, unique: true },
    betAmount: Number,
    startTime: Date,
    endTime: Date

});

module.exports = mongoose.model('betEvent', betEventSchema);