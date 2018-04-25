var DueDateView = Backbone.View.extend({
  className: "edit_modal",
  template: App.templates.edit_card_due_date,
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo($("#card_window_layer"));
  },
  initialize: function() {
    this.render();
  }
});
