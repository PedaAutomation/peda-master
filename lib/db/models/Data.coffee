module.exports = (orm, db) ->
  Data = db.define('Data', {
    key: { type: 'text' },
    value: { type: 'object' }
  });
