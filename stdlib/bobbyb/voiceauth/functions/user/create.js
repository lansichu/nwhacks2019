
const lib = require('lib')({token: 'b_vkISlNCO4L3-OxoUo98SeGofHj0VzyhiL5mLvwuNvBHQHp17CRNoMhcTL_KuiR'});
const kv = lib.utils.kv['@0.1.8'];


// module.exports = (callback) => {
  
//   //ms return userid
//   let userid = '';
  
//   return {userid: userid, value: false};
// };

module.exports = (a=0, context, callback) => {
  return lib[`${context.service.identifier}.azure.createAzureUser`]((err, result) => {
    let userid = result;
    let table = await kv.set({
      key: userid, // (required)
      value: false // (required)
    });
    callback(err, result);
  });
};