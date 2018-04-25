var Picture = Backbone.Model.extend({
  setActivity: function() {
    var pictureActivity = App.activities.where({"picture_id": this.get("id")});

    if (this.get("activity") != undefined) {
      return
    } else if (pictureActivity.length !== 0) {
      this.set({ "activity": pictureActivity });
    } else {
      this.createActivity();
    }
  },
  createActivity: function() {
    App.createPictureActivityObject.call(App, this);
  }
});
