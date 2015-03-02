$(document).ready(function() {

  var headerTitleElement = $("#header h1");
  var entriesElement = $("#guestbook-entries");
  var hostAddressElement = $("#guestbook-host-address");
  var currentEntries = "?";

    var updateEntryCount = function(data) {
        console.info("entry count " + data) ;
       currentEntries=data ;
    }

  var updateEntries = function(data) {
    entriesElement.empty();
      console.info("data - > " + Math.random())
      entriesElement.append("<br><br> CURRENT TIME :  "+ $.now())
          entriesElement.append("<br><br> TOTAL entries :  "+ currentEntries +"<br><br>")

    $.each(data, function(key, val) {
        console.info(key + " -> " +val);
        entriesElement.append("<p>" + key + " " + val + "</p>");
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
        setTimeout(fetchGuestbook, 1000);
      });
  })();

    (function fetchLength() {

        $.getJSON("llen").done(updateEntryCount).always(
            function() {
                setTimeout(fetchGuestbook, 1000);
            });
    })();
});
