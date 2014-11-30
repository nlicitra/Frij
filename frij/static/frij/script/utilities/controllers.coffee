frijControllers = angular.module('frij.controllers', [])

frijControllers.controller('utilityListController', ['$scope', '$state', '$stateParams','UtilityChargePeriod', 'months', 'navControls', ($scope, $state, $stateParams, utilityAmounts, months, navControls) ->

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

  $scope.next = -> changeState(navControls.nextDatePeriod)

  $scope.prev = -> changeState(navControls.prevDatePeriod)

  $scope.monthName = ->
    return months[parseInt($stateParams.month) - 1]

  $scope.hasNext = -> navControls.hasNext

  $scope.hasPrev = -> navControls.hasPrev

])