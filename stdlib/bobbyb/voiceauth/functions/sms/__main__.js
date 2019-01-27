const lib = require('lib');
const sms = lib.utils.sms['@1.0.9'];

/**
* A basic SMS function
* @param {string} name Who you're sending the text to
* @param {string} body The message you want to send
*/
module.exports = async (name = 'world', body= 'testtesttesttest', context) =>
  sms({
    to: name,
    body: body
  });
