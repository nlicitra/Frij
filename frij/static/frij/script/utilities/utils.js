// Generated by CoffeeScript 1.8.0
(function() {
  var frijapp;

  frijapp = angular.module('frij.utility', ['ui.router', 'frij.directives', 'frij.services', 'frij.controllers']);

  frijapp.config(function($interpolateProvider, $stateProvider, $urlRouterProvider) {
    var currentDate;
    $interpolateProvider.startSymbol('[[');
    $interpolateProvider.endSymbol(']]');
    currentDate = new Date();
    $urlRouterProvider.otherwise('/' + currentDate.getFullYear() + '/' + (currentDate.getMonth() + 1) + '/');
    return $stateProvider.state('utilityList', {
      url: '/{year}/{month}/',
      templateUrl: '../static/frij/template/utility_form.html',
      controller: 'utilityListController',
      resolve: {
        utilityAmounts: function(UtilityChargePeriod, $stateParams) {
          UtilityChargePeriod.fetch(new Date($stateParams.year, $stateParams.month));
          return UtilityChargePeriod.data();
        }
      }
    });
  });

  frijapp.config(function($httpProvider) {
    var getCookie;
    getCookie = function(name) {
      var cookie, _i, _len, _ref;
      _ref = document.cookie.split(';');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cookie = _ref[_i];
        if (cookie && name === (cookie.trim().split('='))[0]) {
          return decodeURIComponent(cookie.trim().slice(1 + name.length));
        }
      }
      return null;
    };
    return $httpProvider.defaults.headers.common['X-CSRFToken'] = getCookie("csrftoken");
  });

}).call(this);

//# sourceMappingURL=utils.js.map
