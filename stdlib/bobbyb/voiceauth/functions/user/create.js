const lib = require('lib')({token: 'b_vkISlNCO4L3-OxoUo98SeGofHj0VzyhiL5mLvwuNvBHQHp17CRNoMhcTL_KuiR'});
const kv = lib.utils.kv['@0.1.8'];

module.exports = (context, callback) => {
  let userid = '';
  return lib[`${context.service.identifier}.azure.createAzureUser`]((err, result) => {
    if (err) {
      return callback(err);
    }
    console.log("RESULT 1 ", result);
    userid = result;
      console.log('userid is ', userid);
      lib[`${context.service.identifier}.azure.saveAzureUser`](userid, (err, result) => {
        if (err) {
          return callback(err);
        }
        console.log("RESULT 2 ", result);
        let userid = result;
        callback(null, userid);
      });
  });

};
