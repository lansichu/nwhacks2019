const lib = require('lib')({token: 'b_vkISlNCO4L3-OxoUo98SeGofHj0VzyhiL5mLvwuNvBHQHp17CRNoMhcTL_KuiR'});

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
        callback(null, '"id": "'+userid+'"}');
      });
  });
};
