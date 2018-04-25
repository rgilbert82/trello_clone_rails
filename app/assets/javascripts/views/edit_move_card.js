var MoveCardView = Backbone.View.extend({
  className: "edit_modal",
  template: App.templates.edit_move_card,
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo($("#card_window_layer"));
  },
  initialize: function() {
    this.render();
  }
});
