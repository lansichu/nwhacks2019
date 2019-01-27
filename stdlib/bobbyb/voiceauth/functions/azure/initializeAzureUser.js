const request = require('request');

/**
* A basic Hello World function
* @param {string} userID
* @param {buffer} wavFile
* @returns {object}
*/
module.exports = (userID="", wavFile, callback) => {
	request({
	    headers: {
      	'Ocp-Apim-Subscription-Key': Ocp_Apim_Subscription_Key,
	      'Content-Type': "audio/wav"
	    },
	    uri: 'https://westus.api.cognitive.microsoft.com/spid/v1.0/identificationProfiles/'+userID+'/enroll?shortAudio=false',
	    body: wavFile,
    	encoding: null,
	    method: 'POST'
	  	}, function (err, res, body) {
	    	if (err) { 
		  		return callback("Damn sth is wrong"); 
		  	}else{
		  		return callback(null, JSON.parse(body));
		  	}
		}
	);
};