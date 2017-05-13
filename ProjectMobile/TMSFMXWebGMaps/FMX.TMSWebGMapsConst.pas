{***************************************************************************)
{ TMS FMX WebGMaps component                                                    }
{ for Delphi & C++Builder                                                   }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2012 - 2017                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

unit FMX.TMSWebGMapsConst;

interface

{$I TMSDEFS.INC}

{$IFNDEF CHROMIUMOFF}
{$DEFINE USECHROMIUM}
{$ELSE}
{$IFDEF MSWINDOWS}
{$IFDEF DELPHIXE8_LVL}
{$DEFINE USEFMXWEBBROWSER}
{$ENDIF}
{$ENDIF}
{$ENDIF}

const
  HTML_BLANK_PAGE       = 'about:blank';
  JAVASCRIPT            = 'JavaScript';
  MAP_TYPE_PREFIX       = 'google.maps.MapTypeId.';
  CONTROL_POSITION_TEXT = '%controlposition%';

  CONTROL_DEFAULT       = 'DEFAULT';
  CONTROL_ANDROID       = 'ANDROID';
  CONTROL_SMALL         = 'SMALL';
  CONTROL_ZOOMPAN       = 'ZOOM_PAN';

  POSITION_BOTTOMCENTER = 'BOTTOM_CENTER';
  POSITION_BOTTOMLEFT   = 'BOTTOM_LEFT';
  POSITION_BOTTOMRIGHT  = 'BOTTOM_RIGHT';
  POSITION_LEFTBOTTOM   = 'LEFT_BOTTOM';
  POSITION_LEFTCENTER   = 'LEFT_CENTER';
  POSITION_LEFTTOP      = 'LEFT_TOP';
  POSITION_RIGHTBOTTOM  = 'RIGHT_BOTTOM';
  POSITION_RIGHTCENTER  = 'RIGHT_CENTER';
  POSITION_RIGHTTOP     = 'RIGHT_TOP';
  POSITION_TOPCENTER    = 'TOP_CENTER';
  POSITION_TOPLEFT      = 'TOP_LEFT';
  POSITION_TOPRIGHT     = 'TOP_RIGHT';

  ZOOM_DEFAULT          = 'DEFAULT';
  ZOOM_LARGE            = 'LARGE';
  ZOOM_SMALL            = 'SMALL';

  MAPTYPE_DEFAULT       = 'DEFAULT';
  MAPTYPE_DROPDOWNMENU  = 'DROPDOWN_MENU';
  MAPTYPE_HORIZONTALBAR = 'HORIZONTAL_BAR';

  MAP_DEFAULT           = 'ROADMAP';
  MAP_SATELLITE         = 'SATELLITE';
  MAP_HYBRID            = 'HYBRID';
  MAP_TERRAIN           = 'TERRAIN';

  GIF_RESSOURCE_NAME    = 'LOADER';
  GIF_FORMAT            = 'GIF';

  DEFAULT_ZOOM          = 10;
  DEFAULT_LATITUDE      = 48.85904; // Eiffel Tower Paris Latitude
  DEFAULT_LONGITUDE     = 2.294297;  // Eiffel Tower Paris Longitude
  DEFAULT_WIDTH         = 100;
  DEFAULT_HEIGHT        = 100;

  GEOCODING_DOMAIN_URL              = 'https://maps.googleapis.com';
  GEOCODING_BASE_URL                = 'https://maps.googleapis.com/maps/api/geocode/xml?';
  GEOCODING_START_URL               = 'address=';
  GEOCODING_REVERSESTART_URL        = 'latlng=';
  GEOCODING_END_URL                 = '&sensor=false';
  GEOCODING_STATUS                  = 'status';
  GEOCODING_LATITUDE                = 'lat';
  GEOCODING_LONGITUDE               = 'lng';
  GEOCODING_LOCATION_TYPE           = 'location_type';
  GEOCODING_ADDRESS                 = 'formatted_address';
  GEOCODINF_STATUS_OK               = 'OK';
  GEOCODINF_STATUS_ZERO_RESULTS     = 'ZERO_RESULTS';
  GEOCODINF_STATUS_OVER_QUERY_LIMIT = 'OVER_QUERY_LIMIT';
  GEOCODINF_STATUS_REQUEST_DENIED   = 'REQUEST_DENIED';
  GEOCODINF_STATUS_INVALID_REQUEST  = 'INVALID_REQUEST';

  GEOCODING_LOCTYPE_ROOFTOP            = 'ROOFTOP';
  GEOCODING_LOCTYPE_RANGE_INTERPOLATED = 'RANGE_INTERPOLATED';
  GEOCODING_LOCTYPE_GEOMETRIC_CENTER   = 'GEOMETRIC_CENTER';
  GEOCODING_LOCTYPE_APPROXIMATE        = 'APPROXIMATE';

  WEATHER_TEMPERATURE_CELSIUS             = 'CELSIUS';
  WEATHER_TEMPERATURE_FAHRENHEIT          = 'FAHRENHEIT';
  WEATHER_WIND_SPEED_KILOMETERS_PER_HOUR  = 'KILOMETERS_PER_HOUR';
  WEATHER_WIND_SPEED_METERS_PER_SECOND    = 'METERS_PER_SECOND';
  WEATHER_WIND_SPEED_MILES_PER_HOUR       = 'MILES_PER_HOUR';
  WEATHER_LABEL_COLOR_BLACK               = 'BLACK';
  WEATHER_LABEL_COLOR_WHITE               = 'WHITE';

  HTML_FILE_1 = '<!DOCTYPE html>' + #13 +
                '<html>' + #13 +
                '<head>' + #13 +
                '<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />' + #13 +
                '<meta http-equiv="content-type" content="text/html; charset=UTF-8" />' + #13 +
                '<meta http-equiv="X-UA-Compatible" content="IE=11">' + #13 +

                '<style type="text/css">' + #13 +
                ' html, body, #map_canvas {' + #13 +
                '  margin: 0;' + #13 +
                '  padding: 0;' + #13 +
                '  height: 100%' + #13 +
                ' }' + #13 +
                '</style>' + #13 +

//                '<script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.21&sensor=false%apikey%&libraries=panoramio,weather&language=%lang%"></script>' + #13 +
                '<script type="text/javascript" src="http://maps.google.com/maps/api/js?&libraries=panoramio,weather%apikey%&language=%lang%"></script>' + #13 +

                '<script type="text/javascript" src="https://cdn.rawgit.com/mahnunchik/markerclustererplus/master/src/markerclusterer.js"></script>' + #13 +

                '%showdebug%' + #13 +

                '<script type="text/javascript">' + #13 +
                ' var map;' + #13 +
                ' var streetviewService;' + #13 +
                ' var streetviewPanorama;' + #13 +
                ' var allclusters = [];' + #13 +
                ' var clusterstyles = [];' + #13 +
                ' var allmarkers = [];' + #13 +
                ' var alllabels = [];' + #13 +
                ' var allpolylines = [];' + #13 +
                ' var allpolygons = [];' + #13 +
                ' var allkmllayers = [];' + #13 +
                ' var allinfowindows = [];' + #13 +
                ' var trafficLayer;' + #13 +
                ' var bicyclingLayer;' + #13 +
                ' var panoramioLayer;' + #13 +
                ' var cloudLayer;' + #13 +
                ' var weatherLayer;' + #13 +
                ' var directionsDisplay;' + #13 +
                ' var directionsService = new google.maps.DirectionsService();' + #13 +
                ' var calcLayer;' + #13 +
                ' var mx = 0;' + #13 +
                ' var my = 0;' + #13 +

                ' function printPolygon(index){' + #13 +
                '  if ((allpolygons.length > index) && (index >= 0)) {' + #13 +
                '   var str = "";' + #13 +
                '   var polygonBounds = allpolygons[index].getPath();' + #13 +
                '   var xy;' + #13 +
                '   for (var j = 0; j < polygonBounds.length; j++) {' + #13 +
                '     xy = polygonBounds.getAt(j);' + #13 +
                '     str += "Polygon[" + index + "] Coordinate[" + j + "] LAT[" + xy.lat() + "] LNG[" + xy.lng() + "];";' + #13 +
                '   }' + #13 +
                '   document.getElementById("result").value = str;' + #13 +
                '  }' + #13 +
                '}' + #13 +

                ' function printPolygonCircle(index){' + #13 +
                '  if ((allpolygons.length > index) && (index >= 0)) {' + #13 +
                '   var radius = allpolygons[index].getRadius();' + #13 +
                '   var xy = allpolygons[index].getCenter();' + #13 +
                '   var str = "Polygon[" + index + "] Radius[" + radius + "] LAT[" + xy.lat() + "] LNG[" + xy.lng() + "];";' + #13 +
                '   document.getElementById("result").value = str;' + #13 +
                '  }' + #13 +
                '}' + #13 +

                ' function printPolygonRectangle(index){' + #13 +
                '  if ((allpolygons.length > index) && (index >= 0)) {' + #13 +
                '   var bounds = allpolygons[index].getBounds();' + #13 +
                '   var ne = bounds.getNorthEast();' + #13 +
                '   var sw = bounds.getSouthWest();' + #13 +
                '   var str = "Polygon[" + index + "] NELA[" + ne.lat() + "] NELN[" + ne.lng() + "] SWLA[" + sw.lat() + "] SWLN[" + sw.lng() + "];";' + #13 +
                '   document.getElementById("result").value = str;' + #13 +
                '  }' + #13 +
                '}' + #13 +

                ' function printPolyline(index){' + #13 +
                '  if ((allpolylines.length > index) && (index >= 0)) {' + #13 +
                '   var str = "";' + #13 +
                '   var polylineBounds = allpolylines[index].getPath();' + #13 +
                '   var xy;' + #13 +
                '   for (var j = 0; j < polylineBounds.length; j++) {' + #13 +
                '     xy = polylineBounds.getAt(j);' + #13 +
                '     str += "Polyline[" + index + "] Coordinate[" + j + "] LAT[" + xy.lat() + "] LNG[" + xy.lng() + "];";' + #13 +
                '   }' + #13 +
                '   document.getElementById("result").value = str;' + #13 +
                '  }' + #13 +
                '}' + #13 +

                ' function getLatLngToXY(lat, lng){' + #13 +
                '  var str = "";' + #13 +
                '  var projection = calcLayer.getProjection();' + #13 +
                '  if (projection) {' + #13 +
                '    myLatLng = new google.maps.LatLng(parseFloat(lat), parseFloat(lng));' + #13 +
                '    var position = projection.fromLatLngToDivPixel(myLatLng);' + #13 +
                '    str = "XPOS[" + parseInt(position.x) + "] YPOS[" + parseInt(position.y) + "];";' + #13 +
                '  }' + #13 +
                '  document.getElementById("result").value = str;' + #13 +
                '}' + #13 +

                ' function getXYToLatLng(x, y){' + #13 +
                '  var str = "";' + #13 +
                '  var projection = calcLayer.getProjection();' + #13 +
                '  if (projection) {' + #13 +
                '    myPoint = new google.maps.Point(parseInt(x), parseInt(y));' + #13 +
                '    var position = projection.fromDivPixelToLatLng(myPoint);' + #13 +
                '    str = "LAT[" + position.lat() + "] LNG[" + position.lng() + "];";' + #13 +
                '  }' + #13 +
                '  document.getElementById("result").value = str;' + #13 +
                '}' + #13 +

                ' function setzoommap(newzoom) {' + #13 +
                '   var OldZoomLevel = parseFloat(map.getZoom());' + #13 +
                '   var NewzoomLevel = parseFloat(newzoom);' + #13 +
                '   if (OldZoomLevel!=NewzoomLevel) {' + #13 +
                '     map.setZoom(newzoom);' + #13 +
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +

                ' function getBounds() {' + #13 +
                '   var result = map.getBounds();' + #13 +
                '   var ne = result.getNorthEast();' + #13 +
                '   var sw = result.getSouthWest();' + #13 +
                {$IFNDEF FMXLIB}
                '   external.ExternalBoundsRetrieved(ne.lat(), ne.lng(), sw.lat(), sw.lng());' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '   sendObjectMessage("jsevent://boundsretrieved:nelat="+ne.lat()+"#nelng="+ne.lng()+"#swlat="+sw.lat()+"#swlng="+sw.lng()); '+ #13 + //event
                {$ENDIF}
                ' }' + #13 +
                ' ' + #13 +

                ' function showStreetview(lat, lng, valhead, valzm, valptch) {' + #13 +
                '   var valheading = parseFloat(valhead);' + #13 +
                '   var valzoom = parseFloat(valzm);' + #13 +
                '   var valpitch = parseFloat(valptch);' + #13 +
                '   var point = new google.maps.LatLng(parseFloat(lat),parseFloat(lng));' + #13 +
                '   streetviewPanorama.setPov({' + #13 +
                '                              heading: valheading,' + #13 +
                '                              zoom: valzoom,' + #13 +
                '                              pitch: valpitch});' + #13 +
                '   streetviewService.getPanoramaByLocation(point, 50, processStreeviewData);' + #13 +
//                ' alert("User-agent header sent: " + navigator.userAgent);'+
//                '   var fenway = new google.maps.LatLng(42.345573,-71.098326);' + #13 +
//                '   var panoramaOptions = {' + #13 +
//                '     position: fenway,' + #13 +
//                '     pov: {' + #13 +
//                '       heading: 34,' + #13 +
//                '       pitch: 10,' + #13 +
//                '       zoom: 1' + #13 +
//                '     }' + #13 +
//                '   };' + #13 +
//                '   var panorama = new google.maps.StreetViewPanorama(map_canvas,panoramaOptions);' + #13 +
//                '   map.setStreetView(panorama);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function processStreeviewData(data, status) {' + #13 +
                '   if (status == google.maps.StreetViewStatus.OK) {' + #13 +
                '     streetviewPanorama.setPano(data.location.pano);' + #13 +
                '     streetviewPanorama.setVisible(true);' + #13 +
                '   } else {' + #13 +
                '     streetviewPanorama.setVisible(false);' + #13 +
                '     if (status == google.maps.StreetViewStatus.UNKNOWN_ERROR) {' + #13 +
                {$IFNDEF FMXLIB}
                '       external.ExternalGMapsError(4);' + #13 +
                '     } else {' + #13 +
                '       external.ExternalGMapsError(5);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '       sendObjectMessage("jsevent://error:errorid=4"); '+ #13 +
                '     } else {' + #13 +
                '       sendObjectMessage("jsevent://error:errorid=5"); '+ #13 +
                {$ENDIF}
                '     }' + #13 +
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +

                'String.prototype.hexEncode = function(){' + #13 +
                '    var hex, i;' + #13 +

                '    var result = "";' + #13 +
                '    for (i=0; i<this.length; i++) {' + #13 +
                '        hex = this.charCodeAt(i).toString(16);' + #13 +
                '        result += "\\u" + ("000"+hex).slice(-4);' + #13 +
                '    }' + #13 +

                '    return result' + #13 +
                '}' + #13 +

                //Directions
                ' function calcDirections(start, end, travelmode, avoidhighways, avoidtolls, wp, optwp, color, displayroute) {' + #13 +
                ' if (color != "") ' + #13 +
                '   directionsDisplay = new google.maps.DirectionsRenderer({polylineOptions: {  strokeColor: color, strokeWeight: 5, strokeOpacity: 0.5 }});' + #13 +
                ' else' + #13 +
                '   directionsDisplay = new google.maps.DirectionsRenderer();' + #13 +
                ' if (displayroute)' + #13 +
                '  directionsDisplay.setMap(map);' + #13 +
                ' var request = {' + #13 +
                '    origin: start,' + #13 +
                '    destination: end,' + #13 +
                '    travelMode: travelmode,' + #13 +
                '    avoidHighways: avoidhighways,' + #13 +
                '    avoidTolls: avoidtolls,' + #13 +
                '    waypoints: wp,' + #13 +
                '    optimizeWaypoints: optwp' + #13 +
                 '  };' + #13 +
                '  directionsService.route(request, function(result, status) {' + #13 +
                '    if (status == google.maps.DirectionsStatus.OK) {' + #13 +
                '      directionsDisplay.setDirections(result);' + #13 +
                '      myroute = directionsDisplay.getDirections();' + #13 +
                {$IFNDEF FMXLIB}
                '      external.ExternalRouting(JSON.stringify(myroute));' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '      sendObjectMessage("jsevent://routingstart"); '+ #13 +
                '      var routings = JSON.stringify(myroute);'+#13+
                '      var routingsub;'+#13+
                '      while (routings.length > 0) {'+#13+
                '      routingsub = routings.substr(0,  Math.min(routings.length, 300)); '+#13+
                '      routings = routings.substr(routingsub.length, routings.length); '+#13+
                '      sendObjectMessage("jsevent://routing:title=" + routingsub.hexEncode()); '+ #13 +
                '      }'+ #13 +
                '      sendObjectMessage("jsevent://routingend"); '+ #13 +
                {$ENDIF}
                '    } else {' + #13 +
                '      myroute = "no_route_found";' + #13 +
                {$IFNDEF FMXLIB}
                '      external.ExternalRouting(myroute);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '      sendObjectMessage("jsevent://routingstart"); '+ #13 +
                '      sendObjectMessage("jsevent://routing:title=" + myroute.hexEncode()); '+ #13 +
                '      sendObjectMessage("jsevent://routingend"); '+ #13 +
                {$ENDIF}
                '    }' + #13 +
                '  });' + #13 +
                '}' + #13 +

                //KML layer
                ' function addKMLLayer(url, zoomtobounds) {' + #13 +
                '   var kmlOptions = {' + #13 +
                '     clickable: true,' + #13 +
                '     suppressInfoWindows: false,' + #13 +
                '     preserveViewport: zoomtobounds,' + #13 +
                '     map: map' + #13 +
                '   };' + #13 +
                '   var kmlLayer = new google.maps.KmlLayer(url, kmlOptions);' + #13 +
                '   allkmllayers.push(kmlLayer);' + #13 +
                '   google.maps.event.addListener(kmlLayer, "status_changed", function() {' + #13 +
                '     var status = kmlLayer.getStatus();' + #13 +
                '     if (status != "OK")' + #13 +
                ' 	    alert("KML Layer ''" + kmlLayer.getUrl() + "'' status: " + status);' + #13 +
                '   })' + #13 +
                '   google.maps.event.addListener(kmlLayer, "click", function(event) {' + #13 +
                '          IdKMLLayer=-1;' + #13 +
                '          for (var i = 0; i < allkmllayers.length; i++){' + #13 +
                '            if (allkmllayers[i]==kmlLayer) {' + #13 +
                '              IdKMLLayer=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(event.latLng.lat());' + #13 +
                '          lng=parseFloat(event.latLng.lng());' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalKMLLayerClick(event.featureData.name,IdKMLLayer,lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://kmllayerclick:title=" + event.featureData.name + "#id="+IdKMLLayer+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                ' }' + #13 +

                //Polylines
                ' function setPolylineChangedEvents(polyline){' + #13 +
                '  ppath = polyline.getPath();' + #13 +

                // New point
                '    google.maps.event.addListener(ppath, "insert_at", function(){ ' + #13 +
                '    polylineId=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              polylineId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineChanged(polylineId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylinechanged:id="+polylineId); '+ #13 +
                {$ENDIF}
                '    });' + #13 +
                ' ' + #13 +

                // Point was removed
                '    google.maps.event.addListener(ppath, "remove_at", function(){ ' + #13 +
                '    polylineId=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              polylineId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineChanged(polylineId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylinechanged:id="+polylineId); '+ #13 +
                {$ENDIF}
                '    }); ' + #13 +
                ' ' + #13 +

                // Point was moved
                '    google.maps.event.addListener(ppath, "set_at", function(){ ' + #13 +
                '    polylineId=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              polylineId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineChanged(polylineId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylinechanged:id="+polylineId); '+ #13 +
                {$ENDIF}
                '    }); ' + #13 +
                ' } ' + #13 +

                ' function updateMapPolyline(index, clickable, editable, icons, path, color, width, opacity, visible, geodesic, zindex) {' + #13 +
                '   var polylineOptions = { map: map, icons: icons, clickable: clickable, editable: editable , path: path , strokeColor: color, strokeWeight: width, strokeOpacity: opacity, visible: visible, geodesic: geodesic, zIndex: zindex };' + #13 +
                '   allpolylines[index].setOptions(polylineOptions);' + #13 +
                '   setPolylineChangedEvents(allpolylines[index]);' + #13 +
                '   }' + #13 +

                ' function createMapPolyline(clickable, editable, icons, path, color, width, opacity, visible, geodesic, index) {' + #13 +
                '   var polylineOptions = { map: map, icons: icons, clickable: clickable, editable: editable , path: path , strokeColor: color, strokeWeight: width, strokeOpacity: opacity, visible: visible, geodesic: geodesic, zIndex: index };' + #13 +
                '   var polyline = new google.maps.Polyline(polylineOptions);' + #13 +
                '   allpolylines.push(polyline);' + #13 +

                '   setPolylineChangedEvents(polyline);' + #13 +
                ' ' + #13 +

                // Polyline was dragged
                '  google.maps.event.addListener(polyline, "dragend", function(){ ' + #13 +
                '    polygonId=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              polylineId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineChanged(polylineId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylinechanged:id="+polylineId); '+ #13 +
                {$ENDIF}
                '  }); ' + #13 +

                '   google.maps.event.addListener(polyline, "click", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineClick(IdMarker,0);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylineclick:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(polyline, "rightclick", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineClick(IdMarker,1);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylineclick:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(polyline, "dblclick", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineDblClick(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylinedblclick:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(polyline, "mousedown", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineMouseDown(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylinemousedown:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(polyline, "mouseout", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineMouseExit(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylinemouseexit:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(polyline, "mouseover", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineMouseEnter(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylinemouseenter:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(polyline, "mouseup", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolylines.length; i++){' + #13 +
                '            if (allpolylines[i]==polyline) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolylineMouseUp(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polylinemouseup:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                //*//

                //Clusters
                ' function createMapCluster(markeri, coptions, cstyles) {' + #13 +
                '   var cmarkers = [];' + #13 +
                '   for (var i = 0; i < markeri.length; i++) {' + #13 +
                '     cmarkers.push(allmarkers[markeri[i]]);' + #13 +
                '   }' + #13 +
                '   var cluster = new MarkerClusterer(map, cmarkers, coptions);' + #13 +
                '   clusterstyles = cluster.getStyles();' + #13 +
                '   if (cstyles)' + #13 +
                '     cluster.setStyles(cstyles);' + #13 +
                '   allclusters.push(cluster);' + #13 +

                '   google.maps.event.addListener(cluster, "click", function(c) {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allclusters.length; i++){' + #13 +
                '            if (allclusters[i]==cluster) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalClusterClick(IdMarker, c.getSize(), c.getCenter().lat(), c.getCenter().lng());' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://clusterclick:id=" + IdMarker + "#size="+c.getSize()+"#lat="+c.getCenter().lat()+"#lng="+c.getCenter().lng()); '+ #13 +
                {$ENDIF}
                '   });' + #13 +

                '   google.maps.event.addListener(cluster, "mouseover", function(c) {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allclusters.length; i++){' + #13 +
                '            if (allclusters[i]==cluster) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalClusterMouseEnter(IdMarker, c.getSize(), c.getCenter().lat(), c.getCenter().lng());' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://clustermouseenter:id=" + IdMarker + "#size="+c.getSize()+"#lat="+c.getCenter().lat()+"#lng="+c.getCenter().lng()); '+ #13 +
                {$ENDIF}
                '   });' + #13 +

                '   google.maps.event.addListener(cluster, "mouseout", function(c) {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allclusters.length; i++){' + #13 +
                '            if (allclusters[i]==cluster) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalClusterMouseExit(IdMarker, c.getSize(), c.getCenter().lat(), c.getCenter().lng());' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://clustermousexit:id=" + IdMarker + "#size="+c.getSize()+"#lat="+c.getCenter().lat()+"#lng="+c.getCenter().lng()); '+ #13 +
                {$ENDIF}
                '   });' + #13 +

                ' }' + #13 +

                ' function addMarkerToCluster(cindex, mindex) {' + #13 +
                '   if ((cindex < allclusters.length) && (mindex < allmarkers.length))' + #13 +
                '     allclusters[cindex].addMarker(allmarkers[mindex]);' + #13 +
                ' }' + #13 +

                ' function deleteMarkerFromCluster(cindex, mindex) {' + #13 +
                '   if ((cindex < allclusters.length) && (mindex < allmarkers.length))' + #13 +
                '     allclusters[cindex].removeMarker(allmarkers[mindex]);' + #13 +
                ' }' + #13;

  HTML_FILE_2 =
                ' function setPolygonChangedEvents(polygon) { ' + #13 +

                // Loop through all paths in the polygon and add listeners
                // to them. If we just used 'getPath()' then we wouldn't
                // detect all changes to shapes like donuts.
                '  polygon.getPaths().forEach(function(path, index){' + #13 +
                ' ' + #13 +
                '    google.maps.event.addListener(path, "insert_at", function(){ ' + #13 +
                // New point
                '    polygonId=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              polygonId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonChanged(polygonId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonchanged:id="+polygonId); '+ #13 +
                {$ENDIF}
                '    });' + #13 +
                ' ' + #13 +
                '    google.maps.event.addListener(path, "remove_at", function(){ ' + #13 +
                // Point was removed
                '    polygonId=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              polygonId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonChanged(polygonId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonchanged:id="+polygonId); '+ #13 +
                {$ENDIF}
                '    }); ' + #13 +
                ' ' + #13 +
                '    google.maps.event.addListener(path, "set_at", function(){ ' + #13 +
                // Point was moved
                '    polygonId=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              polygonId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonChanged(polygonId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonchanged:id="+polygonId); '+ #13 +
                {$ENDIF}
                '    }); ' + #13 +
                ' ' + #13 +
                '  }); ' + #13 +

                '}' + #13 +

                //Polygons
                ' function updateMapPolygon(index, clickable, editable, paths, bgcolor, bordercolor, borderwidth, bgopacity, borderopacity, visible, geodesic, zindex, ptype, centerlat, centerlng, radius, nelat, nelng, swlat, swlng) {' + #13 +
                '   if (ptype == "circle") {' + #13 +
                '   var center = new google.maps.LatLng(parseFloat(centerlat),parseFloat(centerlng));' + #13 +
                '   var polygonOptions = ' +
                '{ map: map, clickable: clickable, editable: editable , center: center, radius: radius , fillColor: bgcolor , ' +
                'fillOpacity: bgopacity, strokeColor: bordercolor, strokeWeight: borderwidth, strokeOpacity: borderopacity, visible: visible, zIndex: zindex };' + #13 +
                '  allpolygons[index].setOptions(polygonOptions);' + #13 +
                '   } else if (ptype == "rectangle") {' + #13 +
                '   var bounds = new google.maps.LatLngBounds(new google.maps.LatLng(swlat, swlng), new google.maps.LatLng(nelat, nelng));' + #13 +
                '   var polygonOptions = ' +
                '{ map: map, clickable: clickable, editable: editable , bounds: bounds , fillColor: bgcolor , ' +
                'fillOpacity: bgopacity, strokeColor: bordercolor, strokeWeight: borderwidth, strokeOpacity: borderopacity, visible: visible, zIndex: zindex };' + #13 +
                '  allpolygons[index].setOptions(polygonOptions);' + #13 +
                '   } else {' + #13 +
                '   var polygonOptions = ' +
                '{ map: map, clickable: clickable, editable: editable , paths: paths , fillColor: bgcolor , ' +
                'fillOpacity: bgopacity, strokeColor: bordercolor, strokeWeight: borderwidth, strokeOpacity: borderopacity, visible: visible, geodesic: geodesic, zIndex: zindex };' + #13 +

                '  allpolygons[index].setOptions(polygonOptions);' + #13 +
                '  polygon = allpolygons[index];' + #13 +
                '  setPolygonChangedEvents(polygon);' + #13 +

                '   }' + #13 +
                ' }' + #13 +

                ' function createMapPolygon(clickable, editable, paths, bgcolor, bordercolor, borderwidth, bgopacity, borderopacity, visible, geodesic, zindex, ptype, centerlat, centerlng, radius, nelat, nelng, swlat, swlng) {' + #13 +
                '   if (ptype == "circle") {' + #13 +
                '   var center = new google.maps.LatLng(parseFloat(centerlat),parseFloat(centerlng));' + #13 +
                '   var circleOptions = ' +
                '{ map: map, clickable: clickable, editable: editable , center: center, radius: radius , fillColor: bgcolor , ' +
                'fillOpacity: bgopacity, strokeColor: bordercolor, strokeWeight: borderwidth, strokeOpacity: borderopacity, visible: visible, zIndex: zindex };' + #13 +
                '   var polygon = new google.maps.Circle(circleOptions);' + #13 +

                //circle radius changed
                '   google.maps.event.addListener(polygon, "radius_changed", function() {' + #13 +
                '          polygonId=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              polygonId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonChanged(polygonId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonchanged:id="+polygonId); '+ #13 +
                {$ENDIF}
                '   });' + #13 +

                //circle center changed
                '   google.maps.event.addListener(polygon, "center_changed", function() {' + #13 +
                '          polygonId=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              polygonId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonChanged(polygonId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonchanged:id="+polygonId); '+ #13 +
                {$ENDIF}
                '   });' + #13 +

                '   } else if (ptype == "rectangle") {' + #13 +
                '   var bounds = new google.maps.LatLngBounds(new google.maps.LatLng(swlat, swlng), new google.maps.LatLng(nelat, nelng));' + #13 +
                '   var rectOptions = ' +
                '{ map: map, clickable: clickable, editable: editable , bounds: bounds , fillColor: bgcolor , ' +
                'fillOpacity: bgopacity, strokeColor: bordercolor, strokeWeight: borderwidth, strokeOpacity: borderopacity, visible: visible, zIndex: zindex };' + #13 +
                '   var polygon = new google.maps.Rectangle(rectOptions);' + #13 +

                //rectangle bounds changed
                '   google.maps.event.addListener(polygon, "bounds_changed", function() {' + #13 +
                '          polygonId=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              polygonId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonChanged(polygonId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonchanged:id="+polygonId); '+ #13 +
                {$ENDIF}
                '   });' + #13 +

                '   } else {' + #13 +
                '   var polygonOptions = ' +
                '{ map: map, clickable: clickable, editable: editable , paths: paths , fillColor: bgcolor , ' +
                'fillOpacity: bgopacity, strokeColor: bordercolor, strokeWeight: borderwidth, strokeOpacity: borderopacity, visible: visible, geodesic: geodesic, zIndex: zindex };' + #13 +
                '   var polygon = new google.maps.Polygon(polygonOptions);' + #13 +

                '  setPolygonChangedEvents(polygon);' + #13 +

                ' ' + #13 +
                '  google.maps.event.addListener(polygon, "dragend", function(){ ' + #13 +
                // Polygon was dragged
                '    polygonId=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              polygonId=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonChanged(polygonId);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonchanged:id="+polygonId); '+ #13 +
                {$ENDIF}
                '  }); ' + #13 +

                ' }' + #13 +

                '   allpolygons.push(polygon);' + #13 +
                '   google.maps.event.addListener(polygon, "click", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonClick(IdMarker, 0);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonclick:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +

                '   google.maps.event.addListener(polygon, "rightclick", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonClick(IdMarker,1);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonclick:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +

                '   google.maps.event.addListener(polygon, "dblclick", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonDblClick(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygondblclick:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(polygon, "mousedown", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonMouseDown(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonmousedown:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(polygon, "mouseout", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonMouseExit(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonmouseexit:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(polygon, "mouseover", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonMouseEnter(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonmouseenter:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(polygon, "mouseup", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allpolygons.length; i++){' + #13 +
                '            if (allpolygons[i]==polygon) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalPolygonMouseUp(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://polygonmouseup:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                //*//

                //Labels
                // Define the overlay, derived from google.maps.OverlayView
                ' function Label(opt_options,color,bordercolor,padding,fontname,fontcolor,fontsize,offsetleft,offsettop) {' + #13 +
                 // Initialization
                '  this.setValues(opt_options);' + #13 +

                 // Label specific
                '  var span = this.span_ = document.createElement("div");' + #13 +
                '  span.style.cssText = "position: relative; left: " + (offsetleft-50) + "%; top: " + (offsettop-60) + "px; " +' +
                '                       "white-space: nowrap; font-size:" + fontsize + "px;" +' +
                '                       "border: 1px solid " + bordercolor + "; " +' +
                '                       "font-family:" + fontname + "; color: " + fontcolor + ";"+' +
                '                       "padding: " + padding + "px; background-color: " + color + ";";' + #13 +

                '  var div = this.div_ = document.createElement("div");' + #13 +
                '  div.appendChild(span);' + #13 +
                '  div.style.cssText = "position: absolute; display: none";' + #13 +
                ' };' + #13 +
                ' Label.prototype = new google.maps.OverlayView;' + #13 +

                // Implement onAdd
                ' Label.prototype.onAdd = function() {' + #13 +
                '  var pane = this.getPanes().overlayLayer;' + #13 +
                '  pane.appendChild(this.div_);' + #13 +

                 // Ensures the label is redrawn if the text or position is changed.
                '  var me = this;' + #13 +
                '  this.listeners_ = [' + #13 +
                '    google.maps.event.addListener(this, "position_changed",' + #13 +
                '        function() { me.draw(); }),' + #13 +
                '    google.maps.event.addListener(this, "text_changed",' + #13 +
                '        function() { me.draw(); })' + #13 +
                '  ];' + #13 +
                ' };' + #13 +

                // Implement setText
                ' Label.prototype.setText = function(text) {' + #13 +
                '   if (this.span_) {' + #13 +
                '   this.set("text", text);'+ #13 +
                '   this.draw();'+
                '   }' + #13 +
                ' }' + #13 +

                // Implement setColor
                ' Label.prototype.setColor = function(color) {' + #13 +
                '   if (this.span_) {' + #13 +
                '   this.span_.style.color = color;'+ #13 +
                '   this.draw();'+
                '   }' + #13 +
                ' }' + #13 +

                // Implement setBackgroundColor
                ' Label.prototype.setBackgroundColor = function(color) {' + #13 +
                '   if (this.span_) {' + #13 +
                '   this.span_.style.backgroundColor = color;'+ #13 +
                '   this.draw();'+
                '   }' + #13 +
                ' }' + #13 +

                // Implement setBorderColor
                ' Label.prototype.setBorderColor = function(color) {' + #13 +
                '   if (this.span_) {' + #13 +
                '   this.span_.style.borderColor = color;'+ #13 +
                '   this.draw();'+
                '   }' + #13 +
                ' }' + #13 +

                // Implement setFont
                ' Label.prototype.setFont = function(fontname) {' + #13 +
                '   if (this.span_) {' + #13 +
                '   this.span_.style.fontFamily = fontname;'+ #13 +
                '   this.draw();'+
                '   }' + #13 +
                ' }' + #13 +

                // Implement setFontSize
                ' Label.prototype.setFontSize = function(fontsize) {' + #13 +
                '   if (this.span_) {' + #13 +
                '   this.span_.style.fontSize = fontsize + "px";'+ #13 +
                '   this.draw();'+
                '   }' + #13 +
                ' }' + #13 +

                // Implement setPadding
                ' Label.prototype.setPadding = function(padding) {' + #13 +
                '   if (this.span_) {' + #13 +
                '   this.span_.style.padding = padding + "px";'+ #13 +
                '   this.draw();'+
                '   }' + #13 +
                ' }' + #13 +

                // Implement setOffsetLeft
                //keep offset relative to the default value (-50%)
                ' Label.prototype.setOffsetLeft = function(offset) {' + #13 +
                '   if (this.span_) {' + #13 +
                '   this.span_.style.left = (offset-50) + "%";'+ #13 +
                '   this.draw();'+
                '   }' + #13 +
                ' }' + #13 +

                // Implement setOffsetTop
                //keep offset relative to the default value (-60px)
                ' Label.prototype.setOffsetTop = function(offset) {' + #13 +
                '   if (this.span_) {' + #13 +
                '   this.span_.style.top = (offset-60) + "px";'+ #13 +
                '   this.draw();'+
                '   }' + #13 +
                ' }' + #13 +

                // Implement Hide
                ' Label.prototype.hide = function() {' + #13 +
                '   if (this.div_) {' + #13 +
                '     this.div_.style.visibility = "hidden";' + #13 +
                '   }' + #13 +
                ' }' + #13 +

                // Implement Show
                ' Label.prototype.show = function() {' + #13 +
                '   if (this.div_) {' + #13 +
                '     this.div_.style.visibility = "visible";' + #13 +
                '   }' + #13 +
                ' }' + #13 +

                // Implement onRemove
                ' Label.prototype.onRemove = function() {' + #13 +
                '  this.div_.parentNode.removeChild(this.div_);' + #13 +
                 // Label is removed from the map, stop updating its position/text.
                '  for (var i = 0, I = this.listeners_.length; i < I; ++i) {' + #13 +
                '    google.maps.event.removeListener(this.listeners_[i]);' + #13 +
                '  }' + #13 +
                ' };' + #13 +

                // Implement draw
                ' Label.prototype.draw = function() {' + #13 +
                '  var projection = this.getProjection();' + #13 +

                '  if (projection) {' + #13 +
                '    var position = projection.fromLatLngToDivPixel(this.get("position"));' + #13 +

                '    var div = this.div_;' + #13 +
                '    div.style.left = position.x + "px";' + #13 +
                '    div.style.top = position.y + "px";' + #13 +
                '    div.style.display = "block";' + #13 +
                '    div.style.zIndex = 999;' + #13 +
                ' } ' + #13 +

                '  this.span_.innerHTML = this.get("text").toString();' + #13 +
                ' };' + #13 +
                //*//

                ' function updateMapMarker(itemindex, lat, lng, html, drag, vis, clickble, flaticon, dropanimation, imageicon, index, labeltext, labelcolor, labelbordercolor, labelpadding, labelfontname, labelfontcolor, labelfontsize, iconwidth, iconheight, mtext) {' + #13 +
                '  if (itemindex <= allmarkers.length) {' + #13 +
                '   var point = new google.maps.LatLng(parseFloat(lat),parseFloat(lng));' + #13 +

                '   var pinImage = imageicon;' + #13 +
                '   if ((iconwidth > 0) && (iconheight > 0)) {' + #13 +
                '     var pinImage = new google.maps.MarkerImage(imageicon, null, null, null, new google.maps.Size(iconwidth,iconheight));' +
                '   }' + #13 +

                '   if (dropanimation==true) { ' + #13 +
                '     var markerOptions = { label: mtext, map: map, position: point, title: html , draggable:drag , visible:vis , clickable:clickble , flat:flaticon, animation: google.maps.Animation.DROP, icon: pinImage, zIndex: index};' + #13 +
                '   } else {' + #13 +
                '     var markerOptions = { label: mtext, map: map, position: point, title: html , draggable:drag , visible:vis , clickable:clickble , flat:flaticon , icon: pinImage, zIndex: index };' + #13 +
                '   } ' + #13 +
                '   updateMarker = allmarkers[itemindex];' + #13 +
                '   if (updateMarker) ' + #13 +
                '    updateMarker.setOptions(markerOptions);' + #13 +
                '  }' + #13 +
                ' }' + #13 +

                ' function createMapMarker(lat, lng, html, drag, vis, clickble, flaticon, dropanimation, imageicon, index, lbtext, lbcolor, lbbordercolor, lbpadding, lbfontname, lbfontcolor, lbfontsize, iconwidth, iconheight, mtext, lboffsetleft, lboffsettop) {' + #13 +
                '   var point = new google.maps.LatLng(parseFloat(lat),parseFloat(lng));' + #13 +

                '   var pinImage = imageicon;' + #13 +
                '   if ((iconwidth > 0) && (iconheight > 0)) {' + #13 +
                '     var pinImage = new google.maps.MarkerImage(imageicon, null, null, null, new google.maps.Size(iconwidth,iconheight));' +
                '   }' + #13 +

                '   if (dropanimation==true) { ' + #13 +
                '     var markerOptions = { label: mtext, map: map, position: point, title: html , draggable:drag , visible:vis , clickable:clickble , flat:flaticon, animation: google.maps.Animation.DROP, icon: pinImage, zIndex: index};' + #13 +
                '   } else {' + #13 +
                '     var markerOptions = { label: mtext, map: map, position: point, title: html , draggable:drag , visible:vis , clickable:clickble , flat:flaticon , icon: pinImage, zIndex: index };' + #13 +
                '   } ' + #13 +
                '   var marker = new google.maps.Marker(markerOptions);' + #13 +

                '   var infowindow = new google.maps.InfoWindow({});' + #13 +
                '   allmarkers.push(marker);' + #13 +
                '   allinfowindows.push(infowindow);' + #13;


  HTML_FILE_3 = //Add Label
                '   var label = new Label({'+
                '     map: map'+
                '   }, lbcolor, lbbordercolor, lbpadding, lbfontname, lbfontcolor, lbfontsize, lboffsetleft, lboffsettop);'+ #13 +
                '   label.bindTo("position", marker, "position");'+ #13 +
                '   label.set("text", lbtext);'+ #13 +
                '   if (lbtext == "")'+ #13 +
                '     label.hide();'+ #13 +
                '   alllabels.push(label);' + #13 +
                '   google.maps.event.addListener(infowindow, "closeclick", function() {' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerInfoWindowCloseClick(IdMarker);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markerinfowindowcloseclick:id="+IdMarker); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(marker, "click", function() {' + #13 +
                '          ptmarker=marker.getPosition()' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(ptmarker.lat());' + #13 +
                '          lng=parseFloat(ptmarker.lng());' + #13 +
                '          title=marker.getTitle();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerClick(title,IdMarker,lat,lng,0);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markerclick:title=" + title + "#id="+IdMarker+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(marker, "rightclick", function() {' + #13 +
                '          ptmarker=marker.getPosition()' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(ptmarker.lat());' + #13 +
                '          lng=parseFloat(ptmarker.lng());' + #13 +
                '          title=marker.getTitle();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerClick(title,IdMarker,lat,lng,1);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markerclick:title=" + title + "#id="+IdMarker+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(marker, "dblclick", function() {' + #13 +
                '          ptmarker=marker.getPosition()' + #13 +
                '          IdMarker=-1;' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(ptmarker.lat());' + #13 +
                '          lng=parseFloat(ptmarker.lng());' + #13 +
                '          title=marker.getTitle();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerDblClick(title,IdMarker,lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markerdblclick:title=" + title + "#id="+IdMarker+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(marker, "dragstart", function() {' + #13 +
                '          ptmarker=marker.getPosition()' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(ptmarker.lat());' + #13 +
                '          lng=parseFloat(ptmarker.lng());' + #13 +
                '          title=marker.getTitle();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerDragStart(title,IdMarker,lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markerdragstart:title=" + title + "#id="+IdMarker+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '    google.maps.event.addListener(marker, "drag", function() {' + #13 +
                '          ptmarker=marker.getPosition()' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(ptmarker.lat());' + #13 +
                '          lng=parseFloat(ptmarker.lng());' + #13 +
                '          title=marker.getTitle();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerDrag(title,IdMarker,lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markerdrag:title=" + title + "#id="+IdMarker+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '    });' + #13 +
                '   google.maps.event.addListener(marker, "dragend", function() {' + #13 +
                '          ptmarker=marker.getPosition()' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(ptmarker.lat());' + #13 +
                '          lng=parseFloat(ptmarker.lng());' + #13 +
                '          title=marker.getTitle();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerDragEnd(title,IdMarker,lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markerdragend:title=" + title + "#id="+IdMarker+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(marker, "mousedown", function() {' + #13 +
                '          ptmarker=marker.getPosition()' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(ptmarker.lat());' + #13 +
                '          lng=parseFloat(ptmarker.lng());' + #13 +
                '          title=marker.getTitle();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerMouseDown(title,IdMarker,lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markermousedown:title=" + title + "#id="+IdMarker+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(marker, "mouseout", function() {' + #13 +
                '          ptmarker=marker.getPosition()' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(ptmarker.lat());' + #13 +
                '          lng=parseFloat(ptmarker.lng());' + #13 +
                '          title=marker.getTitle();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerMouseExit(title,IdMarker,lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markermouseexit:title=" + title + "#id="+IdMarker+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '   google.maps.event.addListener(marker, "mouseover", function() {' + #13 +
                '          ptmarker=marker.getPosition()' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(ptmarker.lat());' + #13 +
                '          lng=parseFloat(ptmarker.lng());' + #13 +
                '          title=marker.getTitle();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerMouseEnter(title,IdMarker,lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markermouseenter:title=" + title + "#id="+IdMarker+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                '  google.maps.event.addListener(marker, "mouseup", function() {' + #13 +
                '          ptmarker=marker.getPosition()' + #13 +
                '          for (var i = 0; i < allmarkers.length; i++){' + #13 +
                '            if (allmarkers[i]==marker) {' + #13 +
                '              IdMarker=i;' + #13 +
                '            }' + #13 +
                '          }' + #13 +
                '          lat=parseFloat(ptmarker.lat());' + #13 +
                '          lng=parseFloat(ptmarker.lng());' + #13 +
                '          title=marker.getTitle();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalMarkerMouseUp(title,IdMarker,lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://markermouseup:title=" + title + "#id="+IdMarker+"#lat="+lat+"#lng="+lng); '+ #13 +
                {$ENDIF}
                '   });' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function startMarkerBounceAnimation(IdMarker) {' + #13 +
                '   if (IdMarker<allmarkers.length) {' + #13 +
                '     allmarkers[IdMarker].setAnimation(google.maps.Animation.BOUNCE);' + #13 +
                '   } else {' + #13 +
                {$IFNDEF FMXLIB}
                '     external.ExternalGMapsError(3);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '     sendObjectMessage("jsevent://error:errorid=3");' + #13 +
                {$ENDIF}
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function stopMarkerBounceAnimation(IdMarker) {' + #13 +
                '   if (IdMarker<allmarkers.length) {' + #13 +
                '     allmarkers[IdMarker].setAnimation(null);' + #13 +
                '   } else {' + #13 +
                {$IFNDEF FMXLIB}
                '     external.ExternalGMapsError(3);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '     sendObjectMessage("jsevent://error:errorid=3");' + #13 +
                {$ENDIF}
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function deleteMapMarker(IdMarker) {' + #13 +
                '   if (IdMarker<allmarkers.length) {' + #13 +
                '     allmarkers[IdMarker].setMap(null);' + #13 +
                '     allmarkers.splice(IdMarker,1);' + #13 +
                '     allinfowindows.splice(IdMarker,1);' + #13 +
                '   } else {' + #13 +
                {$IFNDEF FMXLIB}
                '     external.ExternalGMapsError(3);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '     sendObjectMessage("jsevent://error:errorid=3");' + #13 +
                {$ENDIF}
                '   }' + #13 +
                '   if (IdMarker<alllabels.length) {' + #13 +
                '     alllabels[IdMarker].setMap(null);' + #13 +
                '     alllabels.splice(IdMarker,1);' + #13 +
                '   } else {' + #13 +
                {$IFNDEF FMXLIB}
                '     external.ExternalGMapsError(3);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '     sendObjectMessage("jsevent://error:errorid=3");' + #13 +
                {$ENDIF}
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function deleteMapPolyline(IdMarker) {' + #13 +
                '   if (IdMarker<allpolylines.length) {' + #13 +
                '     allpolylines[IdMarker].setMap(null);' + #13 +
                '     allpolylines.splice(IdMarker,1);' + #13 +
                '   } else {' + #13 +
                {$IFNDEF FMXLIB}
                '     external.ExternalGMapsError(3);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '     sendObjectMessage("jsevent://error:errorid=3");' + #13 +
                {$ENDIF}
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +

                ' function deleteMapCluster(IdMarker) {' + #13 +
                '   if (IdMarker<allclusters.length) {' + #13 +
                '     allclusters[IdMarker].clearMarkers();' + #13 +
                '     allclusters.splice(IdMarker,1);' + #13 +
                '   } else {' + #13 +
                {$IFNDEF FMXLIB}
                '     external.ExternalGMapsError(3);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '     sendObjectMessage("jsevent://error:errorid=3");' + #13 +
                {$ENDIF}
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +

                ' function deleteMapPolygon(IdMarker) {' + #13 +
                '   if (IdMarker<allpolygons.length) {' + #13 +
                '     allpolygons[IdMarker].setMap(null);' + #13 +
                '     allpolygons.splice(IdMarker,1);' + #13 +
                '   } else {' + #13 +
                {$IFNDEF FMXLIB}
                '     external.ExternalGMapsError(3);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '     sendObjectMessage("jsevent://error:errorid=3");' + #13 +
                {$ENDIF}
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function deleteKMLLayer(IdLayer) {' + #13 +
                '   if (IdLayer<allkmllayers.length) {' + #13 +
                '     allkmllayers[IdLayer].setMap(null);' + #13 +
                '     allkmllayers.splice(IdLayer,1);' + #13 +
                '   } else {' + #13 +
                {$IFNDEF FMXLIB}
                '     external.ExternalGMapsError(3);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '     sendObjectMessage("jsevent://error:errorid=3");' + #13 +
                {$ENDIF}
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function openMarkerInfoWindowHtml(IdMarker, html) {' + #13 +
                '   if (IdMarker<allmarkers.length) {' + #13 +
                '     var marker = allmarkers[IdMarker];' + #13 +
                '     var infowindow = allinfowindows[IdMarker];' + #13 +
                '     infowindow.setContent(html);' + #13 +
                '     infowindow.open(map, marker);' + #13 +
                '   } else {' + #13 +
                {$IFNDEF FMXLIB}
                '     external.ExternalGMapsError(3);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '     sendObjectMessage("jsevent://error:errorid=3");' + #13 +
                {$ENDIF}
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function closeMarkerInfoWindowHtml(IdMarker) {' + #13 +
                '   if (IdMarker<allmarkers.length) {' + #13 +
                '     var marker = allmarkers[IdMarker];' + #13 +
                '     var infowindow = allinfowindows[IdMarker];' + #13 +
                '     infowindow.close();' + #13 +
                '   } else {' + #13 +
                {$IFNDEF FMXLIB}
                '     external.ExternalGMapsError(3);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '     sendObjectMessage("jsevent://error:errorid=3");' + #13 +
                {$ENDIF}
                '   }' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function deleteAllMapMarker() {' + #13 +
                '   for (i in allmarkers) {' + #13 +
                '     allmarkers[i].setMap(null);' + #13 +
                '   }' + #13 +
                '   allmarkers.splice(0,allmarkers.length);' + #13 +
                '   allinfowindows.splice(0,allinfowindows.length);' + #13 +
                '   for (i in alllabels) {' + #13 +
                '     alllabels[i].setMap(null);' + #13 +
                '   }' + #13 +
                '   alllabels.splice(0,alllabels.length);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function deleteAllMapPolyline() {' + #13 +
                '   for (i in allpolylines) {' + #13 +
                '     allpolylines[i].setMap(null);' + #13 +
                '   }' + #13 +
                '   allpolylines.splice(0,allpolylines.length);' + #13 +
                ' }' + #13 +
                ' ' + #13 +

                ' function deleteAllMapCluster() {' + #13 +
                '   for (i in allclusters) {' + #13 +
                '     allclusters[i].clearMarkers();' + #13 +
                '   }' + #13 +
                '   allclusters.splice(0,allclusters.length);' + #13 +
                ' }' + #13 +
                ' ' + #13 +

                ' function deleteAllMapPolygon() {' + #13 +
                '   for (i in allpolygons) {' + #13 +
                '     allpolygons[i].setMap(null);' + #13 +
                '   }' + #13 +
                '   allpolygons.splice(0,allpolygons.length);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function deleteAllKMLLayer() {' + #13 +
                '   for (i in allkmllayers) {' + #13 +
                '     allkmllayers[i].setMap(null);' + #13 +
                '   }' + #13 +
                '   allkmllayers.splice(0,allkmllayers.length);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function ShowTraffic() {' + #13 +
                '   trafficLayer.setMap(map);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function HideTraffic() {' + #13 +
                '   trafficLayer.setMap(null);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function ShowBicycling() {' + #13 +
                '   bicyclingLayer.setMap(map);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function HideBicyling() {' + #13 +
                '   bicyclingLayer.setMap(null);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function ShowPanoramio() {' + #13 +
                '   panoramioLayer.setMap(map);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function HidePanoramio() {' + #13 +
                '   panoramioLayer.setMap(null);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function ShowCloud() {' + #13 +
                '   cloudLayer.setMap(map);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function HideCloud() {' + #13 +
                '   cloudLayer.setMap(null);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function ShowWeather() {' + #13 +
                '   weatherLayer.setMap(map);' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' function HideWeather() {' + #13 +
                '   weatherLayer.setMap(null);' + #13 +
                ' }' + #13 +
                ' ' + #13;

  HTML_FILE_4 = ' function initialize() {' + #13 +
                '  var latlng = new google.maps.LatLng(%latitude%, %longitude%);' + #13 +

                //disable POI labels
                ' var myStyles =[' + #13 +
                '     {' + #13 +
                '         featureType: "poi",' + #13 +
                '         elementType: "labels",' + #13 +
                '         stylers: [' + #13 +
//                '               { visibility: "off" }' + #13 +
                '               { visibility: "%disablepoi%" }' + #13 +
                '         ]' + #13 +
                '     }' + #13 +
                ' ];' + #13 +

                '  var myOptions = {' + #13 +
                '    navigationControlOptions: {' + #13 +
                '      style: google.maps.NavigationControlStyle.%controlstype%' + #13 +
                '    },' + #13 +
                '   panControl: %panControl%,' + #13 +
                '   panControlOptions: {' + #13 +
                '     position: google.maps.ControlPosition.%panControlPosition%' + #13 +
                '   },' + #13 +
                '   zoomControl: %zoomControl%,' + #13 +
                '   zoomControlOptions: {' + #13 +
                '     position: google.maps.ControlPosition.%zoomControlPosition%,' + #13 +
                '     style: google.maps.ZoomControlStyle.%zoomControlStyle%' +
                '   },' + #13 +
                '   mapTypeControl: %mapTypeControl%,' + #13 +
                '   mapTypeControlOptions: {' + #13 +
                '     position: google.maps.ControlPosition.%mapTypeControlPosition%,' + #13 +
                '     style: google.maps.MapTypeControlStyle.%mapTypeControlStyle%' +
                '   },' + #13 +
                '   scaleControl: %scaleControl%,' + #13 +
                '   scaleControlOptions: {' + #13 +
                '     position: google.maps.ControlPosition.%scaleControlPosition%' + #13 +
                '   },' + #13 +
                '   streetViewControl: %streetViewControl%,' + #13 +
                '   streetViewControlOptions: {' + #13 +
                '     position: google.maps.ControlPosition.%streetViewControlPosition%' + #13 +
                '   },' + #13 +
                '   overviewMapControl: %overviewMapControl%,' + #13 +
                '   overviewMapControlOptions: {' + #13 +
                '     opened: %overviewMapControlOpened%' + #13 +
                '   },' + #13 +
                '   disableDoubleClickZoom: %disableDoubleClickZoom%,' + #13 +
                '   draggable: %draggable%,' + #13 +
                '   keyboardShortcuts: %keyboardShortcuts%,' + #13 +
                '   scrollwheel: %scrollwheel%,' + #13 +
                '   disableDefaultUI: %disableDefaultUI%,' + #13 +
                '   zoom: %zoom%,' + #13 +
                '   center: latlng,' + #13 +
                '   mapTypeId: google.maps.MapTypeId.%maptype%,' + #13 +
                '   styles: myStyles' + #13 +
                '   , tilt: %disabletilt%' +
                '   , rotateControl: %rotateControl%' +
                '   , rotateControlOptions: {' + #13 +
                '     position: google.maps.ControlPosition.%rotateControlPosition%' + #13 +
                '   },' + #13 +
                '  };' + #13 +
                '  streetviewService = new google.maps.StreetViewService();' + #13 +
                '  trafficLayer = new google.maps.TrafficLayer();' + #13 +
                '  bicyclingLayer = new google.maps.BicyclingLayer();' + #13 +
                '  panoramioLayer = new google.maps.panoramio.PanoramioLayer();' + #13 +
                '  var myWeatherOptions = {' + #13 +
                '   temperatureUnits: google.maps.weather.TemperatureUnit.%weatherTemperature%,' + #13 +
                '   labelColor: google.maps.weather.LabelColor.%weatherLabelColor%,' + #13 +
                '   suppressInfoWindows: %weatherSuppressInfoWinddows%,' + #13 +
                '   windSpeedUnits: google.maps.weather.WindSpeedUnit.%weatherWindSpeed%' + #13 +
                '  };' + #13 +
                '  cloudLayer = new google.maps.weather.CloudLayer()' + #13 +
                '  weatherLayer = new google.maps.weather.WeatherLayer(myWeatherOptions);' + #13 +
                '  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);' + #13 +
                '    trafficLayer.setMap(%showtraffic%);' + #13 +
                '    bicyclingLayer.setMap(%showbicycling%);' + #13 +
                '    panoramioLayer.setMap(%showpanoramio%);' + #13 +
                '    cloudLayer.setMap(%showcloud%);' + #13 +
                '    weatherLayer.setMap(%showweather%);' + #13 +
                '    streetviewPanorama = map.getStreetView();' + #13 +
                '  if (%SVVisible%){' + #13 +
                '    streetviewPanorama.setVisible(true);'+
                '    showStreetview("%SVLat%", "%SVLng%", %SVHeading%, %SVZoom%, %SVPitch%);' + #13 +
                '  }' + #13 +

                ' calcLayer = new google.maps.OverlayView();' + #13 +
                ' calcLayer.draw = function() {};' + #13 +
                ' calcLayer.setMap(map);' + #13 +

                '    google.maps.event.addListener(map, "tilesloaded", function() {' + #13 +
//                '        streetviewPanorama = map.getStreetView();' + #13 +

                '        google.maps.event.addListener(streetviewPanorama, "position_changed", function() {' + #13 +
                '          NewPosition = streetviewPanorama.getPosition();' + #13 +
                '          var lat = NewPosition.lat();' + #13 +
                '          var lng = NewPosition.lng();' + #13 +
                {$IFNDEF FMXLIB}
                '          external.ExternalStreetViewMove(lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://streetviewmove:lat=" + lat + "#lng=" + lng+"#x="+mx+"#y="+my); '+ #13 +
                {$ENDIF}
                '        });' + #13 +

                '        google.maps.event.addListener(streetviewPanorama, "pov_changed", function() {' + #13 +
//              Fix: POI streetview click has undefined zoom value
                '        var heading = streetviewPanorama.getPov().heading;' + #13 +
                '        if (heading)' + #13 +
                '          heading = parseInt(heading);' + #13 +
                '        else' + #13 +
                '          heading = -1;' + #13 +
                '        var pitch = streetviewPanorama.getPov().pitch;' + #13 +
                '        if (pitch)' + #13 +
                '          pitch = parseInt(pitch);' + #13 +
                '        else' + #13 +
                '          pitch = -1;' + #13 +
                '        var zoom = streetviewPanorama.getPov().zoom;' + #13 +
                '        if (zoom)' + #13 +
                '          zoom = parseInt(zoom);' + #13 +
                '        else' + #13 +
                '          zoom = -1;' + #13 +
                {$IFNDEF FMXLIB}
                '        external.ExternalStreetViewChange(heading,pitch,zoom);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '        sendObjectMessage("jsevent://streetviewchange:heading=" + heading + "#pitch=" + pitch + "#zoom=" + zoom); '+ #13 +
                {$ENDIF}
                '        });' + #13 +
                {$IFNDEF FMXLIB}
                '        external.ExternalMapTilesLoad();' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '          sendObjectMessage("jsevent://tilesload"); '+ #13 +
                {$ENDIF}
                '    });' + #13;


  HTML_FILE_5 = '    google.maps.event.addListener(map, "click", function(event) {' + #13 +
                '         var ClickLatLng = event.latLng;' + #13 +
                '         if (ClickLatLng) {' + #13 +
                '            var lat = ClickLatLng.lat();' + #13 +
                '            var lng = ClickLatLng.lng();' + #13 +
                {$IFNDEF FMXLIB}
                '            external.ExternalMapClick(lat,lng,0);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '            sendObjectMessage("jsevent://click:lat="+lat+"#lng="+lng+"#x="+mx+"#y="+my); '+ #13 +
                {$ENDIF}
                '         }' + #13 +

                '    });' + #13 +
                '    google.maps.event.addListener(map, "dblclick", function(event) {' + #13 +
                '         var ClickLatLng = event.latLng;' + #13 +
                '         if (ClickLatLng) {' + #13 +
                '            var lat = ClickLatLng.lat();' + #13 +
                '            var lng = ClickLatLng.lng();' + #13 +
                {$IFNDEF FMXLIB}
                '            external.ExternalMapDblClick(lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '            sendObjectMessage("jsevent://dblclick:lat="+lat+"#lng="+lng+"#x="+mx+"#y="+my); '+ #13 +
                {$ENDIF}
                '         }' + #13 +
                '    });' + #13 +
                '    google.maps.event.addListener(map, "mousemove", function(event) {' + #13 +
                '         var ClickLatLng = event.latLng;' + #13 +
                '         if (ClickLatLng) {' + #13 +
                '            var lat = ClickLatLng.lat();' + #13 +
                '            var lng = ClickLatLng.lng();' + #13 +
                {$IFNDEF FMXLIB}
                '            external.ExternalMapMouseMove(lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '            sendObjectMessage("jsevent://mousemove:lat="+lat+"#lng="+lng+"#x="+mx+"#y="+my); '+ #13 +
                {$ENDIF}
                '         }' + #13 +
                '    });' + #13 +
                '    google.maps.event.addListener(map, "mouseout", function(event) {' + #13 +
                '         var ClickLatLng = event.latLng;' + #13 +
                '         if (ClickLatLng) {' + #13 +
                '            var lat = ClickLatLng.lat();' + #13 +
                '            var lng = ClickLatLng.lng();' + #13 +
                {$IFNDEF FMXLIB}
                '            external.ExternalMapMouseExit(lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '            sendObjectMessage("jsevent://mouseexit:lat="+lat+"#lng="+lng+"#x="+mx+"#y="+my); '+ #13 +
                {$ENDIF}
                '         }' + #13 +
                '    });' + #13 +
                '    google.maps.event.addListener(map, "mouseover", function(event) {' + #13 +
                '         var ClickLatLng = event.latLng;' + #13 +
                '         if (ClickLatLng) {' + #13 +
                '            var lat = ClickLatLng.lat();' + #13 +
                '            var lng = ClickLatLng.lng();' + #13 +
                {$IFNDEF FMXLIB}
                '            external.ExternalMapMouseEnter(lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '            sendObjectMessage("jsevent://mouseenter:lat="+lat+"#lng="+lng+"#x="+mx+"#y="+my); '+ #13 +
                {$ENDIF}
                '         }' + #13 +
                '    });' + #13 +
                '    google.maps.event.addListener(map, "dragstart", function() {' + #13 +
                '         var ptcenter=map.getCenter();' + #13 +
                '         var lat=ptcenter.lat();' + #13 +
                '         var lng=ptcenter.lng();' + #13 +
                {$IFNDEF FMXLIB}
                '            external.ExternalMapMoveStart(lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '            sendObjectMessage("jsevent://dragstart:lat="+lat+"#lng="+lng+"#x="+mx+"#y="+my); '+ #13 +
                {$ENDIF}
                '    });' + #13 +
                '    google.maps.event.addListener(map, "dragend", function() {' + #13 +
                '         var ptcenter=map.getCenter();' + #13 +
                '         var lat=ptcenter.lat();' + #13 +
                '         var lng=ptcenter.lng();' + #13 +
                {$IFNDEF FMXLIB}
                '            external.ExternalMapMoveEnd(lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '            sendObjectMessage("jsevent://dragend:lat="+lat+"#lng="+lng+"#x="+mx+"#y="+my); '+ #13 +
                {$ENDIF}
                '    });' + #13 +
                '    google.maps.event.addListener(map, "drag", function() {' + #13 +
                '         var ptcenter=map.getCenter();' + #13 +
                '         var lat=ptcenter.lat();' + #13 +
                '         var lng=ptcenter.lng();' + #13 +
                {$IFNDEF FMXLIB}
                '            external.ExternalMapMove(lat,lng);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '            sendObjectMessage("jsevent://drag:lat="+lat+"#lng="+lng+"#x="+mx+"#y="+my); '+ #13 +
                {$ENDIF}
                '    });' + #13 +
                '    google.maps.event.addListener(map, "idle", function() {' + #13 +
                {$IFNDEF FMXLIB}
                '         external.ExternalMapIdle();' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '         sendObjectMessage("jsevent://idle"); '+ #13 +
                {$ENDIF}
                '    });' + #13 +
                '    google.maps.event.addListener(map, "rightclick", function(event) {' + #13 +
                '         var ClickLatLng = event.latLng;' + #13 +
                '         if (ClickLatLng) {' + #13 +
                '            var lat = ClickLatLng.lat();' + #13 +
                '            var lng = ClickLatLng.lng();' + #13 +
                {$IFNDEF FMXLIB}
                '            external.ExternalMapClick(lat,lng,1);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '            sendObjectMessage("jsevent://click:lat="+lat+"#lng="+lng+"#x="+mx+"#y="+my); '+ #13 +
                {$ENDIF}
                '         }' + #13 +
                '    });' + #13;

 HTML_FILE_6  = '    google.maps.event.addListener(map, "maptypeid_changed", function() {' + #13 +
                '         var TypeMap=map.getMapTypeId();'+ #13 +
                '         var IdTypeMap=0;' + #13 +
                '         switch(TypeMap)' + #13 +
                '         {' + #13 +
                '         case google.maps.MapTypeId.ROADMAP:' + #13 +
                '           IdTypeMap=0;' + #13 +
                '           break' + #13 +
                '         case google.maps.MapTypeId.SATELLITE:' + #13 +
                '           IdTypeMap=1;' + #13 +
                '           break' + #13 +
                '         case google.maps.MapTypeId.HYBRID:' + #13 +
                '           IdTypeMap=2;' + #13 +
                '           break' + #13 +
                '         case google.maps.MapTypeId.TERRAIN:' + #13 +
                '           IdTypeMap=3;' + #13 +
                '           break' + #13 +
                '         }' + #13 +
                {$IFNDEF FMXLIB}
                '         external.ExternalMapTypeChanged(IdTypeMap);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '         sendObjectMessage("jsevent://typeidchange:id="+IdTypeMap); '+ #13 +
                {$ENDIF}
                '    });' + #13 +
                '    google.maps.event.addListener(map, "zoom_changed", function() {' + #13 +
                '         var ZoomLevel = map.getZoom();' + #13 +
                {$IFNDEF FMXLIB}
                '         external.ExternalMapZoomChange(ZoomLevel);' + #13 +
                {$ENDIF}
                {$IFDEF FMXLIB}
                '         sendObjectMessage("jsevent://zoomchange:zoomlevel="+ZoomLevel); '+ #13 +
                {$ENDIF}
                '    });' + #13 +
                ' }' + #13 +
                ' ' + #13 +
                ' google.maps.event.addDomListener(window, "load", initialize);' + #13 +
                ' ' + #13 +
                '  function SetValues()'+#13+
                '    {'+#13+
                '    mx = window.event.clientX;'+#13+
                '    my = window.event.clientY;'+#13+
                '    }'+#13+

                'var sendObjectMessage = function(parameters) {'+#13+
                {$IFDEF ANDROID}
                '  injectedObject.setPrivateImeOptions(parameters); '+ #13 +
                '  injectedObject.performClick();'+ #13 +
                {$ENDIF}
                {$IFDEF IOS}
                'window.location = parameters;'+#13+
                {$ENDIF}
                {$IFNDEF ANDROID}
                {$IFNDEF IOS}
                'var iframe = document.createElement(''iframe'');'+#13+
                'iframe.setAttribute(''src'', parameters);'+#13+
                'document.documentElement.appendChild(iframe);'+#13+
                'iframe.parentNode.removeChild(iframe);'+#13+
                'iframe = null;'+#13+
                {$ENDIF}
                {$ENDIF}
                ' };'+#13+

                'function touchStart(event) {'+#13+
                '  var allTouches = event.touches;'+#13+
                '  for (var i = 0; i < allTouches.length; i++){' + #13 +
                '    mx = event.touches[i].pageX;'+#13+
                '    my = event.touches[i].pageY;'+#13+
                '  }'+#13+
                '}'+#13+
                '</script>' + #13 +
                '</head>' + #13 +
                '<body>' + #13 +
                '  <div id="map_canvas" onmousedown=SetValues();></div>' + #13 +
                // Hidden input that will be used to get the result from Javascript
                // See the print AllPolygons Javascript function defined above.
                '  <input type="hidden" name="result" id="result" value="" />' + #13 +
                '</body>' + #13 +
                '</html>';

implementation

end.
