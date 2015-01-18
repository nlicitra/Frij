frijControllers = angular.module('frij.controllers', [])

frijControllers.controller('utilityListController', ['$scope', '$state', '$stateParams', 'utilityData', 'Utilities', ($scope, $state, $stateParams, utilityData, Utilities) ->
  Utilities.populateData(utilityData.data)
  $scope.utilityData = Utilities.data()
  
  getIndexFromDate = (year, month) ->
    date = new Date(parseInt(year), parseInt(month)-1, 1)
    for period, index in $scope.utilityData
      if ((date.getFullYear() == period.date.getFullYear()) && date.getMonth() == period.date.getMonth())
        return index

  $scope.selectedPeriod = $scope.utilityData[getIndexFromDate($stateParams.year, $stateParams.month)]
  
  currentDate = new Date()
  $scope.monthNames = ['January','February','March','April','May','June','July','August','September','October','November','December']
  $scope.monthNames = $scope.monthNames[parseInt(currentDate.getMonth() + 1)..].concat($scope.monthNames[0..(parseInt(currentDate.getMonth()))])

  $scope.save = -> $scope.selectedPeriod.update()

  $scope.changeState = (index) ->
    nextDate = $scope.utilityData[index].date
    $state.go('utilityList', {year:nextDate.getFullYear(), month:(nextDate.getMonth() + 1)})

  $scope.monthName = ->
    return $scope.monthNames[getIndexFromDate($stateParams.year, $stateParams.month)]

])