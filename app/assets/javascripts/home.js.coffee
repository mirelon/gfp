@Parser =
  coords: ""
  parseAndShowInMap: (force) ->
    if @coords != $('#coordinates_input #coords').val()
      console.log "change from " + @coords + " to " + $('#coordinates_input #coords').val()
      @coords = $('#coordinates_input #coords').val()
      parts = @coords.split(/[^\d\.]/).filter (part) -> part isnt ""
      lat = ""
      lng = ""
      ok = true
      switch parts.length
        when 4
          lat = (Number)(parts[0]) + (Number)(parts[1])/60
          lng = (Number)(parts[2]) + (Number)(parts[3])/60
        when 2
          lat = (Number)(parts[0])
          lng = (Number)(parts[1])
        else
          if force
            alert "See console.log for parsed coordinates parts, their length should be 2 or 4"
          console.log parts
          ok = false
      if ok
        mapOptions =
          zoom: 8
          center: new google.maps.LatLng(lat, lng)
          mapTypeId: google.maps.MapTypeId.SATELLITE
        map = new google.maps.Map $("#map-canvas").get(0), mapOptions

$ ->

  $('#coordinates_input #coords').unbind('focusout').focusout ->
    Parser.parseAndShowInMap false
  $('#coordinates_input #submit').unbind('click').click ->
    Parser.parseAndShowInMap true
    false