// ==UserScript==
// @name         CLUPA Bound maker
// @version      0.1
// @author       andrushkin
// @match        http://www.giscoeapp.lrc.gov.on.ca/CLUPA/Index.html?site=CLUPA&viewer=CLUPA&locale=en-US
// @require     https://raw.githubusercontent.com/eligrey/FileSaver.js/master/FileSaver.js
// ==/UserScript==
var coordStr = "";
(function() {
    'use strict';

    document.addEventListener("keydown", function(event) {
        console.log("userscript", event);
        if ( event.which == 192 ) {
            var x = document.getElementsByClassName("coords-values");
            //alert(x.length);
            //alert(x[2].innerHTML + ", " + x[3].innerHTML);
            var lon = x[3].innerHTML;
            var lat = x[2].innerHTML;

            if(lon.length < 1 || lat.length < 1){
                alert("Something isn't right, make sure you opened the coordinates box at the bottom");
                return;
            }

            if(lon.charAt(lon.length-1) == "W"){
                lon = "-" + lon.substring(0, lon.length - 3);
            }else{
                lon.substring(0, lon.length - 3);
            }

            if(lat.charAt(lat.length-1) == "S"){
                lat = "-" + lat.substring(0, lat.length - 3);
            }else{
                lat = lat.substring(0, lat.length - 3);
            }

            //alert(lon + ", " + lat);
            coordStr = coordStr + lon + "," + lat + "\n";
        }else if(event.which == 191){
            coordStr = coordStr + "\n";
        }else if(event.which == 220){
            var blob = new Blob([coordStr], {type: "text/plain;charset=utf-8"});
            saveAs(blob, "coords.txt", true);
        }else if(event.which == 67){
            coordStr = "";
        }
    }, true);
})();