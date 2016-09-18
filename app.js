var express = require('express');
var app = express();
var request = require('request');
//var propertiesObject = { field1:'test1', field2:'test2' };
app.get('/', function (req, res) {
  //res.send("Here");
  console.log(req.query);
  var url = 'http://api.reimaginebanking.com/atms?lat=38.887690&lng=-77.128975&rad=1&key=0fab48dc03f057e44474e835559a55d0'
   request(url, function (error, response, body) {
   		if (!error && response.statusCode == 200) {
      var finobject = {arr: []}
      var json = JSON.parse(body)["data"];
      for(var i=0;i<json.length;i++){
        var name = json[i]["name"];
        var lat = json[i]["geocode"]["lat"]
        var long = json[i]["geocode"]["lng"]
        //res.json({ message: 'hooray! welcome to our api!' });
        finobject["arr"].push({latitude:lat,longitude:long,place:name,url:"http://image.slidesharecdn.com/atmppt-150930135619-lva1-app6892/95/atmautomatic-teller-machinehistorytypes-working-structure-1-638.jpg?cb=1443621575"});
      }
     		var url = 'http://api.reimaginebanking.com/branches?key=0fab48dc03f057e44474e835559a55d0'
   			 request(url, function (error, response, body1) {
    				if (!error && response.statusCode == 200) {
    				  console.log(body1);
      				json = JSON.parse(body1);
      				for(var i=0;i<json.length;i++){
                console.log("1")
                var name2 = json[i]["name"];
                var lat2 = json[i]["geocode"]["lat"]
                var long2 = json[i]["geocode"]["lng"]
                //res.json({ message: 'hooray! welcome to our api!' });
                finobject["arr"].push({latitude:lat2,longitude:long2,place:name2,url:"http://i.imgur.com/3ktlggn.png"});
                // postServer(i2, lat2, long2, name2)
              }
              res.send(finobject);
    				}
  			})
   		}
 	})
});

app.listen(process.env.PORT || 8080, function () {
  console.log('Example app listening on port 3000!');
});