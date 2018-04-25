var Lists = Backbone.Collection.extend({
  url: '/api/lists',
  model: List,
  comparator: function(list) {
    return list.get("position");
  }
});
