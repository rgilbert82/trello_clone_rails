var Comments = Backbone.Collection.extend({
  url: '/api/comments',
  model: Comment,
  comparator: function(comment) {
    return comment.get("id");
  }
});
