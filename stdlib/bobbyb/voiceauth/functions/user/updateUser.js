const lib = require('lib');

module.exports = (userid = 'a', fname, lname, email, phone, context, callback) => {
  return lib[`${context.service.identifier}.azure.updateAzureUser`](userid, fname, lname, email, phone, (err, result) => {
    if (err) {
      return callback(err);
    }
    console.log("RESULT from update user ", result);
    callback(null, '"id": "'+userid+'"}');
  });
}
