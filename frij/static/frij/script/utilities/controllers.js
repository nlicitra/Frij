// Generated by CoffeeScript 1.8.0
(function() {
  var frijControllers;

  frijControllers = angular.module('frij.controllers', []);

  frijControllers.controller('utilityListController', [
    '$scope', 'UtilityChargePeriod', function($scope, utilityAmounts) {
      $scope.utilAmounts = utilityAmounts.data();
      $scope.balance = function() {
        var total, util, _i, _len, _ref;
        total = 0;
        _ref = $scope.utilAmounts;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          util = _ref[_i];
          if (!isNaN(util.amount)) {
            total += parseFloat(util.amount);
          }
        }
        return total;
      };
      $scope.save = function() {
        return utilityAmounts.update();
      };
      $scope.next = function() {
        var month, year;
        month = utilityAmounts.month();
        year = utilityAmounts.year();
        month++;
        if (month > 12) {
          month = 1;
          year++;
        }
        return "{year:" + year + ", month:" + month + "}";
      };
      return $scope.prev = function() {
        var month, year;
        month = utilityAmounts.month();
        year = utilityAmounts.year();
        month--;
        if (month < 1) {
          month = 12;
          year--;
        }
        return "{year:" + year + ", month:" + month + "}";
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=controllers.js.map
