(function(){
  var cookies = {

    /**
     * Set/Overwrite a cookie value
     *
     * @param name
     * @param value
     * @param days      OPTIONAL Days till this cookie will stay valid. Default is current session
     * @param path      OPTIONAL domain root will be used by default
     */
    set: function(name, value, days, path) {
      if (days) {
          var date = new Date();
          date.setTime(date.getTime()+(days*24*60*60*1000));
          var expires = "; expires="+date.toGMTString();
      } else {
        var expires = "";
      }

      var dir = path || '/';
      document.cookie = name+"="+encodeURIComponent(value)+expires+"; path="+dir;
    }
  };
  window.cookies = cookies;
}());
