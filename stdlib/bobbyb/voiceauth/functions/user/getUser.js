const lib = require('lib')({token: 'b_vkISlNCO4L3-OxoUo98SeGofHj0VzyhiL5mLvwuNvBHQHp17CRNoMhcTL_KuiR'});
const kv = lib.utils.kv['@0.1.8'];

module.exports = async (userid = "") => {
  return await kv.get({
    key: userid
  });
}
