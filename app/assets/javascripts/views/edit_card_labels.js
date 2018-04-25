var CardLabelsView = Backbone.View.extend({
  className: "edit_modal",
  template: App.templates.edit_card_labels,
  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.$el.appendTo($("#card_window_layer"));
  },
  initialize: function() {
    this.render();
  }
});
