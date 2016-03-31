module.exports.get = function(value) {
    return {
        "status": 1,
        "value": value
    };
};

module.exports.post = function(message) {
    return {
        "status": 1,
        "message": message
    };
};

module.exports.put = function(message) {
    return {
        "status": 1,
        "message": message
    };
}

module.exports.delete = function(message) {
    return {
        "status": 1,
        "message": message
    };
}

module.exports.error = function(message) {
    return {
        "status": 0,
        "message": message
    };
};
