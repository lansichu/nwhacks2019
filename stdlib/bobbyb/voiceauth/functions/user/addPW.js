const lib = require('lib');

module.exports = (userid = 'a', service, password, context, callback) => {
  return lib[`${context.service.identifier}.azure.addPWToAzureUser`](userid, service, password, (err, result) => {
    if (err) {
      return callback(err);
    }
    console.log("RESULT from add pw to user ", result);
    callback(null, '"id": "'+userid+'"}');
  });
}
