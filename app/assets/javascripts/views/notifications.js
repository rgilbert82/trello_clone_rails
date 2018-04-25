var NotificationsView = Backbone.View.extend({
  className: "general_modal",
  template: App.templates.notifications,
  events: {
    "click .x_out_card_options_window": "closeModal",
    "click .close_modal_layer": "closeModal",
  },
  closeModal: function() {
    this.$el.remove();
  },
  render: function() {
    this.$el.html(this.template());
    this.$el.appendTo($("#header_notifications"));
  },
  initialize: function() {
    this.render();
  }
});
