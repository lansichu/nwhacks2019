const lib = require('lib');
const sms = lib.utils.sms['@1.0.9'];

module.exports = (userid = 'a', fname, lname, email, phone, context, callback) => {
  return lib[`${context.service.identifier}.azure.updateAzureUser`](userid, fname, lname, email, phone, (err, result) => {
    lib[`${context.service.identifier}.sms.sendSMS`](phone, fname, (err, result) => {
      if (err) {
        return callback(err);
      }
      callback(null, {'id': userid});
    });
  });
}
