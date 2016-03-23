var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var balanceHistorySchema = new Schema({
    userName: { type: String, required: true, unique: true },
    balanceChange: Date,
    balance: Number
    
});

module.exports = mongoose.model('balanceHistory', balanceHistorySchema);