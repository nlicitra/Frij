// Generated by CoffeeScript 1.8.0
(function() {
  var services;

  services = angular.module('frij.services', []);

  services.factory('UtilityType', function() {
    var UtilityType;
    UtilityType = (function() {
      function UtilityType(data) {
        this.code = data.code;
        this.name = data.name;
      }

      return UtilityType;

    })();
    return UtilityType;
  });

  services.factory('UtilityAmount', function(UtilityType, $log, $http) {
    var UtilityAmount;
    UtilityAmount = (function() {
      function UtilityAmount(data) {
        if (data !== null) {
          this.init(data);
        }
      }

      UtilityAmount.prototype.init = function(data) {
        this.type = new UtilityType(data.type);
        this.amount = data.amount;
        this.id = data.id;
        return this.date = new Date(data.year, data.month);
      };

      UtilityAmount.prototype.update = function() {
        var amount;
        amount = {
          'amount': this.amount
        };
        return $http({
          method: 'PUT',
          url: '/frij/utility/' + this.id + '/',
          data: amount
        });
      };

      UtilityAmount.prototype.serialize = function() {
        return {
          amount: this.amount,
          id: this.id
        };
      };

      return UtilityAmount;

    })();
    return UtilityAmount;
  });

  services.factory('UtilityChargePeriod', function($log, $http, UtilityAmount) {
    var amounts;
    amounts = [];
    return {
      fromServer: function(data) {
        var amount, _i, _len, _ref, _results;
        this.date = new Date(data.date.substring(0, 4), data.date.substring(5, 7));
        amounts.length = 0;
        _ref = data.utilities;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          amount = _ref[_i];
          _results.push(amounts.push(new UtilityAmount(amount)));
        }
        return _results;
      },
      fetch: function(date) {
        return $http({
          method: 'GET',
          url: '/frij/utilities/' + date.getFullYear() + '/' + date.getMonth() + '/'
        }).success((function(_this) {
          return function(data) {
            _this.fromServer(data);
            return $log.info("SUCCESS GET UtilityAmounts");
          };
        })(this)).error((function(_this) {
          return function(data) {
            return $log.info("FAILED GET UtilityAmounts");
          };
        })(this));
      },
      data: function() {
        return amounts;
      },
      update: function() {
        var amount, data, serializedAmounts, _i, _len;
        serializedAmounts = [];
        for (_i = 0, _len = amounts.length; _i < _len; _i++) {
          amount = amounts[_i];
          serializedAmounts.push(amount.serialize());
        }
        data = {
          utilities: serializedAmounts
        };
        return $http({
          method: 'PUT',
          url: '/frij/utilities/' + this.date.getFullYear() + "/" + this.date.getMonth() + "/",
          data: data
        }).success(data)((function(_this) {
          return function() {
            return alert('you did it!');
          };
        })(this));
      },
      nextDatePeriod: function() {
        return new Date(parseInt(this.date.getFullYear()), parseInt(this.date.getMonth()), 1);
      },
      prevDatePeriod: function() {
        return new Date(parseInt(this.date.getFullYear()), parseInt(this.date.getMonth()) - 2, 1);
      },
      hasNext: function() {
        var nextPeriod, utilsAvailable;
        utilsAvailable = false;
        nextPeriod = this.nextDatePeriod();
        $http({
          method: 'GET',
          url: '/frij/utilities/' + nextPeriod.getFullYear() + '/' + parseInt(nextPeriod.getMonth()) + 1 + '/'
        }).success(data)((function(_this) {
          return function() {
            return utilsAvailable = data.utilities.length > 0;
          };
        })(this));
        return utilsAvailable;
      },
      hasPrev: function() {
        var nextPeriod, utilsAvailable;
        utilsAvailable = false;
        nextPeriod = this.prevDatePeriod();
        $http({
          method: 'GET',
          url: '/frij/utilities/' + nextPeriod.getFullYear() + '/' + parseInt(nextPeriod.getMonth()) + 1 + '/'
        }).success(data)((function(_this) {
          return function() {
            return utilsAvailable = data.utilities.length > 0;
          };
        })(this));
        return utilsAvailable;
      }
    };
  });

}).call(this);

//# sourceMappingURL=services.js.map
