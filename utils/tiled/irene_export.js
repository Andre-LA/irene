// Just put this script on the "extensions" directory

/*
  Copyright (c) 2020-present André Luiz Alvares

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

  SPDX-License-Identifier: MPL-2.0
*/

function get_prop_name(prefix, prop) {
  let result = {name: prefix, value: prop.value}

  if (typeof prop.value == "object") {
    let key = Object.keys(prop.value)[0]
    result = get_prop_name(result.name + "." + key, prop.value[key]);
  }

  return result;
}

let ireneMapFormat = {
  name: "Irene map format",
  extension: "json",

  write: function (map, fileName) {
    let m = {
      width: map.width,
      height: map.height,
      tile_layers: [],
      object_layers: [],
    };

    for (let i = 0; i < map.layerCount; ++i) {
      let layer = map.layerAt(i)

      if (layer.isTileLayer) {
        let tile_layer = {
          name = layer.name,
          width = layer.width,
          height = layer.height,
          data = [],
        };

        for (let y = 0; y < layer.height; ++y) {
          for (let x = 0; x < layer.width; ++x) {
            let tile = layer.cellAt(x, y).tileId;
            tile_layer.data.push(tile)
          }
        }

        m.tile_layers.push(tile_layer)
      }
      else if (layer.isObjectLayer) {
        let object_layer = {
          name = layer.name,
          objects = [],
        }

        for (let o = 0; o < layer.objectCount; ++o) {
          let obj = layer.objects[o]
          let object = {
            name = obj.name,
            pos = obj.pos,
            class_name = obj.className,
            properties = {},
          }

          let props = obj.resolvedProperties()

          for (let key in props) {
            let property = get_prop_name(key, props[key])
            object.properties[property.name] = property.value
          }

          object_layer.objects.push(object)
        }

        m.object_layers.push(object_layer)
      }
    }

    let file = new TextFile(fileName, TextFile.WriteOnly);
    file.write(JSON.stringify(m, null, 2));
    file.commit();
  },
}

tiled.registerMapFormat('irene map format', ireneMapFormat)
