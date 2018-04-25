var ErrorMessageView = Backbone.View.extend({
  className: "oops",
  template: App.templates.error_message,
  events: {
    "click": "removeErrorMessageWindow"
  },
  removeErrorMessageWindow: function() {
    this.$el.remove();
  },
  fadeOutErrorMessageWindow: function() {
    var self = this;

    setTimeout(function() {
      self.$el.fadeOut(500);
    }, 3000);
  },
  render: function() {
    this.$el.html(this.template({ message: this.attributes.message }));
    this.$el.appendTo($("body"));
  },
  initialize: function() {
    this.render();
    this.fadeOutErrorMessageWindow();
  }
});
