var Boards = Backbone.Collection.extend({
  url: '/api/boards',
  model: Board,
  comparator: function(board) {
    return board.get("id");
  }
});
