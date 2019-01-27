const lib = require('lib')({token: STDLIB_TOKEN});
const kv = lib.utils.kv['@0.1.8'];

module.exports = async (userid = "") => {
  return await kv.get({
    key: userid
  });
}
