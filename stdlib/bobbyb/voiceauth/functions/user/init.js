const lib = require('lib')({token: 'b_vkISlNCO4L3-OxoUo98SeGofHj0VzyhiL5mLvwuNvBHQHp17CRNoMhcTL_KuiR'});
const kv = lib.utils.kv['@0.1.8'];
const request = require('request');


module.exports = async (userid = 0, binary) => {
  //ms call with userid and binary
  return lib[`${context.service.identifier}.azure.initializeAzureUser`]((err, result) => {
    if (err) {
      return callback(err);
    }
    if (result == '202') {
      let status = '';
      while (status != 'enrolled') {
        status = request({
            uri: url
        }, function(err, res, body) {
            if (err) {
                return err;
            } else {
                return res;
            }
        })
      }
      let result = await kv.set({
        key: userid, // (required)
        value: true // (required)
      });
    }
  });
};
