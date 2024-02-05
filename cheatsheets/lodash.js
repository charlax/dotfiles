const _ = require('lodash');

function upperCaseFirstLetter(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function flattenObject(obj, prefix = '') {
  return _.flatMap(obj, (value, key) => {
    // Uppercase the first letter only for nested keys
    const newKey = prefix + (prefix ? upperCaseFirstLetter(key) : key);
    if (_.isObject(value) && !_.isArray(value)) {
      return flattenObject(value, newKey);
    }
    return { [newKey]: value };
  }).reduce((acc, next) => _.assign(acc, next), {});
}

const originalObject = {a: {b: 1, c: 2, z: {w: 3}}, e: {a: 1, b: 3}};
const flattenedObject = flattenObject(originalObject);

console.assert(_.isEqual(flattenedObject, {aB: 1, aC: 2, aZW: 3, eA: 1, eB: 3}))

const keyedBy = _.keyBy([{id: 1}], "id")
console.assert(_.isEqual(keyedBy, {1: {id: 1}}))

// See also:
// https://devhints.io/lodash
