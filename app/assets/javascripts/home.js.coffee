$ ->
  mapOptions =
    zoom: 8
    center: new google.maps.LatLng(-34.397, 150.644)
    mapTypeId: google.maps.MapTypeId.SATELLITE
  map = new google.maps.Map $("#map-canvas").get(0), mapOptions