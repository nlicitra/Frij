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

  $scope.next = ->
    nextDate = new Date(parseInt($stateParams.year), parseInt($stateParams.month), 1)
    $state.go('utilityList', {year:nextDate.getFullYear(), month:(nextDate.getMonth() + 1)})

  $scope.prev = ->
    nextDate = new Date(parseInt($stateParams.year), parseInt($stateParams.month)-2, 1)
    $state.go('utilityList', {year:nextDate.getFullYear(), month:(nextDate.getMonth() + 1)})

  $scope.monthName = ->
    months = ['January','February','March','April','May','June','July','August','September','October','November','December']
    return months[parseInt($stateParams.month) - 1]
])