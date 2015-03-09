$(document).ready(function() {

  var max_trials=1000

  var headerTitleElement = $("#header h1");
  var entriesElement = $("#guestbook-entries");
  var hostAddressElement = $("#guestbook-host-address");
  var currentEntries = []

  var updateEntryCount = function(data, trial) {
      if(currentEntries.length > 1000)
        currentEntries.splice(0,100);
      //console.info("entry count " + data) ;
      currentEntries[trial]=data ;
  }

  var updateEntries = function(data) {
    entriesElement.empty();
      //console.info("data - > " + Math.random())
      //uncommend for debugging...
      //entriesElement.append("<br><br> CURRENT TIME :  "+ $.now() +"<br><br>TOTAL entries :  "+ JSON.stringify(currentEntries)+"<br><br>")
      entriesElement.append("<br><br> CURRENT TIME :  "+ $.now() +"<br><br>TOTAL entries :  "+ currentEntries[currentEntries.length-1]+"<br><br>")
      f(currentEntries);
    $.each(data, function(key, val) {
        //console.info(key + " -> " +val);
        entriesElement.append("<p>" + key + " " + val.substr(100,200) + "</p>");
    });

  }

  // colors = purple, blue, red, green, yellow
  var colors = ["#549", "#18d", "#d31", "#2a4", "#db1"];
  var randomColor = colors[Math.floor(5 * Math.random())];
  (
      function setElementsColor(color) {
          headerTitleElement.css("color", color);
      })

        (randomColor);

  hostAddressElement.append(document.URL);

  // Poll every second.
  (function fetchGuestbook() {

      // Get JSON by running the query, and append
    $.getJSON("lrange/guestbook").done(updateEntries).always(
      function() {
        setTimeout(fetchGuestbook, 2000);
      });
  })();

    (function fetchLength(trial) {
        $.getJSON("llen").done(
            function a(llen1){
                updateEntryCount(llen1, trial)
            }).always(
                function() {
                    // This function is run every 2 seconds.
                    setTimeout(
                        function(){
                            trial+=1 ;
                            fetchLength(trial);
                            f();
                        }, 5000);
                }
            )
    })(0);
});

