frijControllers = angular.module('frij.controllers', [])

frijControllers.controller('utilityListController', ['$scope', '$state', '$stateParams','UtilityChargePeriod', ($scope, $state, $stateParams, utilityAmounts) ->
  $scope.utilAmounts = utilityAmounts.data()

  $scope.balance = ->
    total = 0
    for util in $scope.utilAmounts
      if (!isNaN(util.amount))
        total += parseFloat(util.amount)
    return total

  $scope.save = -> utilityAmounts.update()

  changeState = (date) ->
    $state.go('utilityList', {year:date.getFullYear(), month:(date.getMonth() + 1)})

  $scope.next = ->
    changeState(utilityAmounts.nextDatePeriod())

  $scope.prev = ->
    changeState(utilityAmounts.prevDatePeriod())

  $scope.monthName = ->
    months = ['January','February','March','April','May','June','July','August','September','October','November','December']
    return months[parseInt($stateParams.month) - 1]
])