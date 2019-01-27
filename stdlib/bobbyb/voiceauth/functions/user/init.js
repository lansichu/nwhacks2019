const lib = require('lib')({token: 'b_vkISlNCO4L3-OxoUo98SeGofHj0VzyhiL5mLvwuNvBHQHp17CRNoMhcTL_KuiR'});
const kv = lib.utils.kv['@0.1.8'];
const request = require('request');


module.exports = async (userid, binary) => {
  //ms call with userid and binary
  if (status == '202') {
      let url = // MS returned URL
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
        value: {result: true} // (required)
      });
  };
};
