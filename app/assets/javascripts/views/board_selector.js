var BoardSelectorView = Backbone.View.extend({
  tagName: "li",
  className: "board_selector_view",
  template: App.templates.board_selector,
  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.$el.appendTo(App.$el.find($(this.attributes.ul)));
  },
  initialize: function() {
    this.render();
  }
});
