var exec = require('cordova/exec');

exports.performTest = function (success, error, testID) {
        exec(success, error, 'Streambow', 'performTest', [testID]);
};

exports.requestPermissions = function (success, error) {
        exec(success, error, 'Streambow', 'requestPermissions');
};