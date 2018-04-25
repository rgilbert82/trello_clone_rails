var AddBoardView = Backbone.View.extend({
  tagName: "li",
  className: "add_board_view",
  template: App.templates.add_board,
  events: {
    "click h2": "fadeInAddBoardButton",
    "click a": "fadeOutAddBoardButton",
    "submit form": "addNewBoard"
  },
  fadeInAddBoardButton: function() {
    $("h2").fadeOut(100);
    $("#create_board_menu").delay(100).fadeIn(100);
  },
  fadeOutAddBoardButton: function(e) {
    e.preventDefault();

    $("#create_board_menu").fadeOut(100);
    $("h2").delay(100).fadeIn(100);
  },
  addNewBoard: function(e) {
    var newBoardTitle = e.target.elements[0].value;
    var newBoard = new Board({
      "title": App.dontAllowEmptyTitle(newBoardTitle)
    });

    e.preventDefault();

    App.addNewBoard.call(App, newBoard);
  },
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo(App.$el.find($("#personal_boards_list")));
  },
  initialize: function() {
    this.render();
  }
});
