<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <title>Place Autocomplete Hotel Search</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      table {
        font-size: 12px;
      }
      #map {
        height: 470px;
      }
      #listing {
        position: absolute;
        width: 200px;
        height: 458px;
        overflow: auto;
        top: 12px;
        cursor: pointer;
        overflow-x: hidden;
      }
      #findhotels {
        position: absolute;
        text-align: right;
        width: 100px;
        font-size: 14px;
        padding: 4px;
        z-index: 5;
        background-color: #fff;
      }
      #locationField {
        position: absolute;
        width: 190px;
        height: 25px;
        left: 108px;
        top: 0px;
        z-index: 5;
        background-color: #fff;
      }
      #controls {
        position: absolute;
        left: 300px;
        width: 140px;
        top: 0px;
        z-index: 5;
        background-color: #fff;
      }
      #autocomplete {
        width: 100%;
      }
      #country {
        width: 100%;
      }
      .placeIcon {
        width: 20px;
        height: 34px;
        margin: 4px;
      }
      .hotelIcon {
        width: 24px;
        height: 24px;
      }
      #resultsTable {
        border-collapse: collapse;
        width: 240px;
      }
      #rating {
        font-size: 13px;
        font-family: Arial Unicode MS;
      }
      .iw_table_row {
        height: 18px;
      }
      .iw_attribute_name {
        font-weight: bold;
        text-align: right;
      }
      .iw_table_icon {
        text-align: right;
      }
    </style>
  </head>

  <body>

    <div id="findhotels">
      Find hotels in:
    </div>

    <div id="locationField">
      <input id="autocomplete" placeholder="Enter a city" type="text" />
    </div>
 <div id="controls"><input type="button" id="autoClick" value="??????">
<input type="hidden" id="country" value="all">
</div>
    <!-- <div id="controls">
      <select id="country">
        <option value="all">All</option>
        <option value="au">Australia</option>
        <option value="br">Brazil</option>
        <option value="ca">Canada</option>
        <option value="fr">France</option>
        <option value="de">Germany</option>
        <option value="mx">Mexico</option>
        <option value="nz">New Zealand</option>
        <option value="ko">Korea</option>
        <option value="it">Italy</option>
        <option value="za">South Africa</option>
        <option value="es">Spain</option>
        <option value="pt">Portugal</option>
        <option value="us">U.S.A.</option>
        <option value="uk">United Kingdom</option>
      </select>
    </div>
 --> 
    <div id="map"></div>

    <div id="listing">
      <table id="resultsTable">
        <tbody id="results"></tbody>
      </table>
    </div>
   
    <div style="display: none">
      <div id="info-content">
        <table>
          <tr id="iw-url-row" class="iw_table_row">
            <td id="iw-icon" class="iw_table_icon"></td>
            <td id="iw-url"></td>
          </tr>
          <tr id="iw-address-row" class="iw_table_row">
            <td class="iw_attribute_name">Address:</td>
            <td id="iw-address"></td>
          </tr>
          <tr id="iw-phone-row" class="iw_table_row">
            <td class="iw_attribute_name">Telephone:</td>
            <td id="iw-phone"></td>
          </tr>
          <tr id="iw-rating-row" class="iw_table_row">
            <td class="iw_attribute_name">Rating:</td>
            <td id="iw-rating"></td>
          </tr>
          <tr id="iw-website-row" class="iw_table_row">
            <td class="iw_attribute_name">Website:</td>
            <td id="iw-website"></td>
          </tr>
          <tr id="iw-price-row" class="iw_table_row">
             <td class="iw_attribute_name">Price:</td>
             <td></td>
          </tr>
        </table>
      </div>
    </div>

   <div id="latlng"></div>

   <div id="info">
   </div>
   
   </table>

    <script>
    function random(){
        var random = Math.random()*30+5;
        random = random * 10;
        var arr = new Array(100);
        for(num=0; num < arr.length; num++){
           arr[num] = random;
        }
        return arr;
     }
    
      // This example requires the Places library. Include the libraries=places :: ?????????????????? ?????? ??????
      var map, places, infoWindow;
      var markers = [];
      var autocomplete;
      var autoClick;
      var countryRestrict = {'country': countries};
      var MARKER_PATH = 'https://developers.google.com/maps/documentation/javascript/images/marker_green';
      var hostnameRegexp = new RegExp('^https?://.+?/');
      
      //Customize Variations
      var lats = [];
      var lngs = [];
      var resultNum=0;

      var countries = { //????????? ???????????? ?????? ?????? ????????? ?????? ?????? ????????? ?????? ?????? ??????
        'au': {
          center: {lat: -25.3, lng: 133.8},
          zoom: 4
        },
        'br': {
          center: {lat: -14.2, lng: -51.9},
          zoom: 3
        },
        'ca': {
          center: {lat: 62, lng: -110.0},
          zoom: 3
        },
        'fr': {
          center: {lat: 46.2, lng: 2.2},
          zoom: 5
        },
        'de': {
          center: {lat: 51.2, lng: 10.4},
          zoom: 5
        },
        'mx': {
          center: {lat: 23.6, lng: -102.5},
          zoom: 4
        },
        'nz': {
          center: {lat: -40.9, lng: 174.9},
          zoom: 5
        },
        'it': {
          center: {lat: 41.9, lng: 12.6},
          zoom: 5
        },
        'za': {
          center: {lat: -30.6, lng: 22.9},
          zoom: 5
        },
        'es': {
          center: {lat: 40.5, lng: -3.7},
          zoom: 5
        },
        'pt': {
          center: {lat: 39.4, lng: -8.2},
          zoom: 6
        },
        'us': {
          center: {lat: 37.1, lng: -95.7},
          zoom: 3
        },
        'uk': {
          center: {lat: 54.8, lng: -4.6},
          zoom: 5
        },
        'ko':{
           center: {lat: 37.552455, lng: 126.991189},
            zoom: 12
        }
      };
      
      function initMap() {//callback  ?????? ??????
        map = new google.maps.Map(document.getElementById('map'), {
          zoom: countries['ko'].zoom,
          center: countries['ko'].center,
          mapTypeControl: false,
          panControl: false,
          zoomControl: false,
          streetViewControl: false
        });
        
        infoWindow = new google.maps.InfoWindow({
          content: document.getElementById('info-content')
        });
        
        // Restrict the search to the default country, and to place type "cities".
        //???????????? ?????? ?????? ?????? 
        autocomplete = new google.maps.places.Autocomplete(
            /** @type {!HTMLInputElement} */ (
                 document.getElementById('autocomplete')), {
              types: ['(cities)'],
              componentRestrictions: countryRestrict
            });
        
          places = new google.maps.places.PlacesService(map);
          
          //?????? ????????? ????????? ????????? ??????. --- ????????? ??????
        document.getElementById('autoClick').addEventListener('click', function(){
           autocomplete.addListener('place_changed', onPlaceChanged);
           onPlaceChanged();
        });
              
       // autoClick.addListener('click',onPlaceChanged);

        //Even Listener??? ?????? ??????
        document.getElementById('country').addEventListener(
            'change', setAutocompleteCountry);
      }   

      //?????? ?????? ?????? ???????????? ?????? ???????????? ?????? ??????
      function onPlaceChanged() {
        var place = autocomplete.getPlace();        
        if (place.geometry) {
          map.panTo(place.geometry.location);
          map.setZoom(15);
          search();
          //window.alert(place.geometry.location);//?????? ?????? ?????? ????????????
        } else {
          document.getElementById('autocomplete').placeholder = '????????????';
        }
      }
      
     //????????? ????????? ?????? ??????
      function search() {
        var search = {
          bounds: map.getBounds(),
          types: ['lodging']
        };
        var geocoder = new google.maps.Geocoder;
        places.nearbySearch(search, function(results, status) {
          if (status === google.maps.places.PlacesServiceStatus.OK) {
            clearResults();
            clearMarkers();
            clearInfo();
            
            //?????? ???????????? ????????? A?????? ???????????? ??????.
            resultNum = results.length;
            for (var i = 0; i < resultNum; i++) {
              var markerLetter = String.fromCharCode('A'.charCodeAt(0) + (i % 26));
              var markerIcon = MARKER_PATH + markerLetter + '.png';
              // Use marker animation to drop the icons incrementally on the map.
              markers[i] = new google.maps.Marker({
                position: results[i].geometry.location,
                animation: google.maps.Animation.DROP,
                icon: markerIcon
              });
           //????????? ?????? ???????????? ????????? ??????????????? ??????.
             markers[i].placeResult = results[i];
             lat = markers[i].position.lat();
            lng = markers[i].position.lng();
            console.log(i+'= '+markers[i].placeResult.place_id);
            var placeI = markers[i].placeResult.place_id;
               
            /* getInfo(placeI,i); */
              google.maps.event.addListener(markers[i], 'animation_changed', showInfoWindow);  //?????? ????????? ????????????.
              console.log(i);
              setTimeout(dropMarker(i), i * 500);
              addResult(results[i], i); //????????? ?????? ????????????
              getInfo(results[i]);
            }//for??????
          }
        });
      }

     
      function clearInfo(){
         document.getElementById('info').innerHTML = null;
      }

     //?????? ?????????
      function clearMarkers() {
        for (var i = 0; i < markers.length; i++) {
          if (markers[i]) {
            markers[i].setMap(null);
          }
        }
        //lat, lng, marker all reset
        markers = [];
        lats = [];
        lngs = [];
        resultNum=0;
      }

      //?????? ???
      function setAutocompleteCountry() {
        var country = document.getElementById('country').value;
        if (country == 'all') {
          autocomplete.setComponentRestrictions([]);
          map.setCenter({lat: 15, lng: 0});
          map.setZoom(2);
        } else {
          autocomplete.setComponentRestrictions({'country': country});
          map.setCenter(countries[country].center);
          map.setZoom(countries[country].zoom);
        }
        clearResults();
        clearMarkers();
        clearInfo();
      }

      //?????? ???????????????
      function dropMarker(i) {
        return function() {
          markers[i].setMap(map);
        };
      }

      //????????? A~?????? ?????? && ???????????? ?????? ?????? ?????? ????????? ?????? ????????? ??????
      function addResult(result, i) {
        var results = document.getElementById('results');
        var markerLetter = String.fromCharCode('A'.charCodeAt(0) + (i % 26));
        var markerIcon = MARKER_PATH + markerLetter + '.png';

        var tr = document.createElement('tr');
        tr.style.backgroundColor = (i % 2 === 0 ? '#F0F0F0' : '#FFFFFF');
        tr.onclick = function() {
          google.maps.event.trigger(markers[i], 'click');
        };

        var iconTd = document.createElement('td');
        var nameTd = document.createElement('td');
        var icon = document.createElement('img');
        icon.src = markerIcon;
        icon.setAttribute('class', 'placeIcon');
        icon.setAttribute('className', 'placeIcon');
        var name = document.createTextNode(result.name);
        iconTd.appendChild(icon);
        nameTd.appendChild(name);
        tr.appendChild(iconTd);
        tr.appendChild(nameTd);
        results.appendChild(tr);
      }

      //?????? ?????? ?????????
      function clearResults() {
        var results = document.getElementById('results');
        while (results.childNodes[0]) {
          results.removeChild(results.childNodes[0]);
        }
      }

      //???????????? ????????? ????????? ????????? ?????? ?????? ????????????.
      function showInfoWindow() {
        var marker = this;
        
        places.getDetails({placeId: marker.placeResult.place_id},function(place, status) {
              if (status !== google.maps.places.PlacesServiceStatus.OK) {
                return;
              }
              infoWindow.open(map, marker);
              buildIWContent(place);
              
              //
              
            });
      }
      
       
      function getInfo(place) {
    	  var price = Math.floor(Math.random()*300+50);
    	  var photos = place.photos;
          if (!photos) {
            return;
          }
        document.getElementById('info').innerHTML += '<br><table style="margin:0px auto;width:800px;border-top:1px solid lightgray;border-bottom:1px solid lightgray;"><tr><td rowspan="7" width="200"><img src = "'+photos[0].getUrl({'maxWidth': 200, 'maxHeight': 200})
                                                  + '"></td><th style="width:100px;">???????????? : </th><td>' + place.name + '</td></tr><tr><th>???????????? : </th><td>'+place.vicinity
                                                  +'</td></tr><tr><th>???????????? : </th><td>'+place.formatted_phone_number
                                                  +'</td></tr><tr><th>???????????? : </th><td>'+place.rating
                                                  +'</td></tr><tr><th>???????????? : </th><td>'+place.website
                                                  +'</td></tr><tr><th>???????????? : </th><td>'+price+'$ <td><td width="100"><a href="yeyak.pd">??????</a></td></tr></table>'
      }
      
      
      //????????? ?????? ?????? ????????? ?????? 
      function buildIWContent(place) {
        document.getElementById('iw-icon').innerHTML = '<img class="hotelIcon" ' +
            'src="' + place.icon + '"/>';
        document.getElementById('iw-url').innerHTML = '<b><a href="' + place.url +
            '">' + place.name + '</a></b>';
        document.getElementById('iw-address').textContent = place.vicinity;

        if (place.formatted_phone_number) {
          document.getElementById('iw-phone-row').style.display = '';
          document.getElementById('iw-phone').textContent =
              place.formatted_phone_number;
        } else {
          document.getElementById('iw-phone-row').style.display = 'none';
        }

        //?????? ??????
        if (place.rating) {
          var ratingHtml = '';
          for (var i = 0; i < 5; i++) {
            if (place.rating < (i + 0.5)) {
              ratingHtml += '&#10025;';
            } else {
              ratingHtml += '&#10029;';
            }
          document.getElementById('iw-rating-row').style.display = '';
          document.getElementById('iw-rating').innerHTML = ratingHtml;
          }
        } else {
          document.getElementById('iw-rating-row').style.display = 'none';
        }

        //?????? URL
        if (place.website) {
          var fullUrl = place.website;
          var website = hostnameRegexp.exec(place.website);
          if (website === null) {
            website = 'http://' + place.website + '/';
            fullUrl = website;
          }
          document.getElementById('iw-website-row').style.display = '';
          document.getElementById('iw-website').textContent = website;
        } else {
          document.getElementById('iw-website-row').style.display = 'none';
        }
      }
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBvOmD3jZiqUocoD3UF9FQinLoyzvig1xQ&libraries=places&callback=initMap"
        async defer></script><!-- &language=ko -->
        
 
 <h2>?????? ??????</h2>
 <div id="resultHotel"> </div>
  </body>
</html>