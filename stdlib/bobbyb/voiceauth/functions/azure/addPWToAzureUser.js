/*
* @param {string} userid
*/

module.exports = (userid='abfhfjfhsdf', service, password, callback) => {
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
        let sql = `INSERT INTO dbo.pw_table (userid, service, password) VALUES ('${userid}', '${service}', '${password}')`
        // let sql = "INSERT INTO dbo.user_table (userid, fname, lname, email, phone) VALUES ('${userid}', '${fname}', '${lname}', '${email}', '${phone}')"
        console.log('Inserting pw into the Table...');
        console.log('SQL: ', sql)

        // Read all rows from table
        var request = new Request(
            sql,
            function(err, rowCount, rows)
            {
                console.log(rowCount + ' row(s) returned');
                return callback(null, rows)
            }
        );

        // request.on('row', function(columns) {
        //     columns.forEach(function(column) {
        //         console.log("%s\t%s", column.metadata.colName, column.value);
        //     });
        // });
        connection.execSql(request);
  }
}
