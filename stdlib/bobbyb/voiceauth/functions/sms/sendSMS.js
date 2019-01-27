const lib = require('lib');
const sms = lib.utils.sms['@1.0.9'];

/**
* A basic SMS function
* @param {string} phone Who you're sending the text to
* @param {string} fname Who you're sending the text to
* @param {string} body The message you want to send
*/
module.exports = async (phone = 'world', fname, body= '! Your account has been updated! If this was not done by you, please contact our representatives.', context) =>
  await sms({
    to: phone,
    body: 'Hi, ' + fname + body
  });
