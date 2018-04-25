var Activities = Backbone.Collection.extend({
  url: '/api/activities',
  model: Activity,
  comparator: function(activity) {
    return activity.get("id");
  }
});
