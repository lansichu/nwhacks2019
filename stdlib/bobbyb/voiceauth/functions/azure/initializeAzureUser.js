/**
* A basic Hello World function
* @returns {string}
*/

/*const request = require('request');
module.exports = (callback) => {
	request('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY', { json: true }, (err, res, body) => {
	  if (err) { 
	  	return callback(err); 
	  }else{
	  	return callback(null, body);
	  }

	});
};*/


const request = require('request');
module.exports = (callback) => {

request({
    headers: {
      'Ocp-Apim-Subscription-Key': Ocp-Apim-Subscription-Key,
      'Content-Type': 'application/json'
    },
    uri: 'https://westus.api.cognitive.microsoft.com/spid/v1.0/identificationProfiles',
    body: '{"locale":"en-us"}',
    method: 'POST'
  	}, function (err, res, body) {
    	if (err) { 
	  		return callback(err); 
	  	}else{
	  		return callback(null, JSON.parse(body).identificationProfileId);
	  	}
	  });
};