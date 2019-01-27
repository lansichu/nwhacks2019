const lib = require('lib');

module.exports = (userid = 'a', context, callback) => {
  return lib[`${context.service.identifier}.sms.sendSMS`](userid, message, (err, result) => {
    if (err) {
      return callback(err);
    }
    console.log("Send SMS to user ", result);
    callback(null, result);
  });
}
