const lib = require('lib')({token: STDLIB_TOKEN});
const kv = lib.utils.kv['@0.1.8'];

module.exports = async (userid = 0) => {
  return `hello ${name}`;
};
