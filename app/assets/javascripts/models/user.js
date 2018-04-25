var User = Backbone.Model.extend({
  url: 'api/users',
  defaults: {
    username: '',
    initials: ''
  },
  changeName: function() {
    if (this.get('first_name') && this.get('last_name')) {
      this.set({"username": this.get('first_name') + ' ' + this.get('last_name') });
      this.set({"initials": this.get('first_name')[0].toUpperCase() + this.get('last_name')[0].toUpperCase() });
    }
  },
  bindEvents: function() {
    this.listenTo(this, "change", this.changeName.bind(this));
  },
  initialize: function() {
    this.bindEvents();
    this.changeName();
  }
});
