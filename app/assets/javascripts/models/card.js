var Card = Backbone.Model.extend({
  defaults: {
    "due_date": "",
    "due_date_highlighted": false,
    "description": "",
    "labels": [],
    "archived": false
  },
  setPictures: function() {
    this.set({ "pictures": new Pictures() });
  },
  resetPictures: function() {
    this.get("pictures").reset(App.pictures.where({"card_id": this.id}));
  },
  writeChanges: function() {
    this.save();
  },
  bindEvents: function() {
    this.listenTo(this, "change", this.writeChanges.bind(this));
  },
  initialize: function() {
    this.setPictures();
    this.bindEvents();
  }
});
