var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var balanceHistorySchema = new Schema({
    userName: { type: String, ref : 'user'},
    newBalance: { type : Number },
    changedAmount: { type: Number },
    balanceChange: { type : Date, default : Date.now }
});

module.exports = mongoose.model('balanceHistory', balanceHistorySchema);