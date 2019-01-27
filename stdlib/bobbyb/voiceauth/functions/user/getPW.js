const lib = require('lib');

module.exports = (userid = 'a', context, callback) => {
  return lib[`${context.service.identifier}.azure.getPWFromAzureUser`](userid, (err, result) => {
    if (err) {
      return callback(err);
    }
    console.log("RESULT from add pw to user ", result);
    callback(null, result);
  });
}
