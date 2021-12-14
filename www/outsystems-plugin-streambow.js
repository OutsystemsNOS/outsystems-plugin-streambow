var exec = require('cordova/exec');

exports.initializer = function (success, error, getUserLocation) {
        exec(success, error, 'Streambow', 'initializer', [getUserLocation]);
};

exports.performTest = function (success, error) {
        exec(success, error, 'Streambow', 'performTest');
};

exports.performFeedbackDiagnostic = function (success, error, inOutStatus, feedbackType) {
        exec(success, error, 'Streambow', 'performFeedbackDiagnostic', [inOutStatus, feedbackType]);
};