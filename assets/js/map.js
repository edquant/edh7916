mapboxgl.accessToken = 'pk.eyJ1IjoiYnRza2lubmVyIiwiYSI6ImNqYzBuOXQ4ZTBlOGIyd3BkdWZxejExaTAifQ.ExNuXW_Ovwk0abRso4GdHA';
var map = new mapboxgl.Map({
    container: 'map', 
    style: 'mapbox://styles/mapbox/light-v9?optimize=true',
    center: [-82.3379, 29.6472],
    zoom: 15,
    pitch: 45
});

// Norman hall location data
var geojson = {
    "type": "geojson",
    "data": {
        "type": "FeatureCollection",
        "features": [{
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [-82.3379, 29.6472]
            },
            "properties": {
                "title": "Norman Hall",
		"icon": "marker"
            }
        }]
    }
};

map.on('load', function() {

    var layers = map.getStyle().layers;
    var labelLayerId;
    for (var i = 0; i < layers.length; i++) {
        if (layers[i].type === 'symbol' && layers[i].layout['text-field']) {
            labelLayerId = layers[i].id;
            break;
        }
    }

    // 3D buildings (https://www.mapbox.com/mapbox-gl-js/example/3d-buildings/)
    map.addLayer({
        'id': '3d-buildings',
        'source': 'composite',
        'source-layer': 'building',
        'filter': ['==', 'extrude', 'true'],
        'type': 'fill-extrusion',
        'minzoom': 14,
        'paint': {
            'fill-extrusion-color': '#aaa',
            'fill-extrusion-height': [
                "interpolate", ["linear"], ["zoom"],
                15, 0,
                15.05, ["get", "height"]
            ],
            'fill-extrusion-base': [
                "interpolate", ["linear"], ["zoom"],
                15, 0,
                15.05, ["get", "min_height"]
            ],
            'fill-extrusion-opacity': .6
        }
    }, labelLayerId);

    // marker (https://www.mapbox.com/mapbox-gl-js/example/geojson-markers/)
    map.addLayer({
        "id": "points",
        "type": "symbol",
        "source": geojson,
	"layout": {
            "icon-image": "{icon}-15",
            "text-field": "{title}",
            "text-font": ["Open Sans Semibold"],
            "text-offset": [0, 0.6],
            "text-anchor": "top"
        }
    });

    // controls
    map.addControl(new mapboxgl.NavigationControl());
});
