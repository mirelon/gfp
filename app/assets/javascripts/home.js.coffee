@Parser =
  coords: ""

  generatePossibilities: (string) ->
    if string.indexOf("?") != -1
      p = ['0'..'9'].map (c) -> Parser.generatePossibilities(string.replace('?', c))
      [].concat p...
    else
      [string]

  splitIntoParts: (string) ->
    string.split(/[^\d\.\?]/).filter (part) -> part isnt ""

  parseAndShowInMap: (force) ->
    if @coords != $('#coordinates_input #coords').val()
      console.log "change from " + @coords + " to " + $('#coordinates_input #coords').val()
      @coords = $('#coordinates_input #coords').val()
      if @coords.split("?").length-1 > 3
        alert "Too many wildcarts. Use max 3!"
      else
        parts = @splitIntoParts @coords
        if parts.length != 4 and parts.length != 2
          if force
            alert "See console.log for parsed coordinates parts, their length should be 2 or 4"
          console.log parts
          return

        mapOptions =
          mapTypeId: google.maps.MapTypeId.SATELLITE
        map = new google.maps.Map $("#map-canvas").get(0), mapOptions

        bounds = new google.maps.LatLngBounds

        for coords in @generatePossibilities(@coords)
          parts = @splitIntoParts coords
          latLng = switch parts.length
            when 4
              [(Number)(parts[0]) + (Number)(parts[1])/60, (Number)(parts[2]) + (Number)(parts[3])/60]
            when 2
              [(Number)(parts[0]), (Number)(parts[1])]
          marker = new google.maps.Marker
            map: map
            position: new google.maps.LatLng(latLng...)
            animation: google.maps.Animation.DROP
            icon: 
              path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z'
              fillColor: "yellow"
              fillOpacity: 0.5
              scale: 0.05
              strokeColor: "gold"
              strokeWeight: 1

          google.maps.event.addListener marker, 'click', () ->
            map.setZoom(map.getZoom()+1)
            map.setCenter @.getPosition()

          bounds.extend (new google.maps.LatLng(latLng...))

        map.fitBounds bounds

$ ->

  $('#coordinates_input #coords').unbind('focusout').focusout ->
    Parser.parseAndShowInMap false
  $('#coordinates_input #submit').unbind('click').click ->
    Parser.parseAndShowInMap true
    false