frijControllers = angular.module('frij.controllers', [])

frijControllers.controller('utilityListController', ['$scope','UtilityChargePeriod',($scope, utilityAmounts) ->
  $scope.utilAmounts = utilityAmounts.data()
  $scope.balance = ->
    total = 0
    for util in $scope.utilAmounts
      if (!isNaN(util.amount))
        total += parseFloat(util.amount)
    return total

  $scope.save = -> utilityAmounts.update()

  $scope.next = ->
    month = utilityAmounts.month()
    year = utilityAmounts.year()
    month++
    if (month > 12)
      month = 1
      year++

    return "{year:" + year + ", month:" + month + "}"

  $scope.prev = ->
    month = utilityAmounts.month()
    year = utilityAmounts.year()
    month--
    if (month < 1)
      month = 12
      year--

    return "{year:" + year + ", month:" + month + "}"
])