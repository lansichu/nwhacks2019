module.exports = (userid='a', callback) => {
  var Connection = require('tedious').Connection;
  var Request = require('tedious').Request;

  // Create connection to database
  var config =
  {
      userName: 'ant2', // update me
      password: 'vancouver2019?', // update me
      server: 'nwhacks2019server.database.windows.net', // update me
      options:
      {
          database: 'nwhacks2019db', //update me
          encrypt: true
      }
  }
  var connection = new Connection(config);

  // Attempt to connect and execute queries if connection goes through
  connection.on('connect', function(err)
      {
          if (err)
          {
              console.log(err)
              return callback(err)
          }
          else
          {
              addPWToAzureUser(callback)
          }
      }
  );

  function addPWToAzureUser(callback) {
        let sql = `SELECT * FROM dbo.pw_table WHERE userid='${userid}'`

        // Read all rows from table
        var request = new Request(
            sql,
            function(err, rowCount, rows)
            {
                //console.log(rowCount + ' row(s) returned');

            }
        );
        connection.execSql(request);

        let services = {};
        console.log("here")
        request.on('row', function(columns) {
            columns.forEach(function(column) {
              services += '"'+column.metadata.colName +'": ';
              services += '"'+ column.value + ",";
            });
            callback(null, services);
        });
  }
}
