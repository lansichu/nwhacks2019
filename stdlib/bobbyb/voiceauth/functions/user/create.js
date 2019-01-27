const lib = require('lib')({token: process.env.STDLIB_TOKEN});
const kv = lib.utils.kv['@0.1.8'];


// module.exports = (callback) => {

//   //ms return userid
//   let userid = '';

//   return {userid: userid, value: false};
// };

module.exports = (context, callback) => {
  return lib[`${context.service.identifier}.azure.createAzureUser`]((err, result) => {
    if (err) {
      return callback(err);
    }
    console.log("RESULT ", result);
    let userid = result;
    let table = kv.set({
      key: userid, // (required)
      value: false // (required)
    }, (err, resultSet) => {
      callback(err, '"id": "'+result+'"}');
    });
  });
};
