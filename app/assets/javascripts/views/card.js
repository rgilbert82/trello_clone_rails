var CardView = Backbone.View.extend({
  tagName: "li",
  className: "card_view",
  template: App.templates.card,
  render: function(list_id) {
    var pictures = App.pictures.where({"card_id": this.model.get("id")});
    var hasActivity = App.activities.where({"card_id": this.model.get("id")}).length > 0;
    var hasComments = App.comments.where({"card_id": this.model.get("id")}).length > 0;
    var mainPicture;

    pictures = pictures.map(function(a) { return a.toJSON() }).reverse();
    mainPicture = pictures[0];
    data = _.extend(this.model.toJSON(), { "mainPicture": mainPicture, "activity": hasActivity, "comments": hasComments });
    this.$el.html(this.template(data));
    this.$el.appendTo(App.$el.find($(".card_selector_list[data-list_id='" + list_id + "']")));
  },
  setupDragEvents: function() {
    var self = this;

    this.$el.draggable({
      appendTo: "body",
      connectToSortable: ".cards ul",
      cursor: "-webkit-grabbing",
      delay: 100,
      helper: "clone",
      revert: "invalid",
      revertDuration: 100,
      scroll: false,
      start : function(e, ui) {
        ui.helper.width($(this).width());
        self.$el.remove();
      },
      stop: function(e, ui) {
        var board_id = App.lists.get(self.model.get("list_id")).get("board_id");
        App.reSetupBoard(board_id);
      },
      zIndex: 100
    });
  },
  initialize: function() {
    var list_id = this.model.get("list_id");
    this.render(list_id);
    this.setupDragEvents();
  }
});
