directives = angular.module('frij.directives', [])

directives.directive('utilityInput', ->
  {
    restrict: 'A'
    templateUrl: '../static/frij/partials/utility_input.html'
    replace: false
  }
)

directives.directive('utilityForm', ->
  {
    restrict: 'A'
    templateUrl: '../static/frij/partials/utility_form.html'
    replace: true
  }
)

directives.directive('lineGraph', ->
  link = (scope, element, attrs) ->
    data = {
      labels: scope.monthNames
      datasets: []
    }

    utilTypes = [
      {
        code:'WTR'
        name:'Water'
      },
      {
        code:'GAS'
        name:'Gas'
      },
      {
        code:'CBL'
        name:'Cabel'
      },
      {
        code:'ELC'
        name:'Electricity'
      }
    ]

    utilMap = {}
    for utilType in utilTypes
      utilMap[utilType.code] = {
        type: utilType
        amounts: []
      }

    for period in scope.utilityData
      for util in period.amounts
        utilMap[util.type.code].amounts.push(util.amount)

    graphData = $.map(utilMap, (value, index) -> 
      return [value]
    )

    if graphData.length > 1
      for util in graphData
        data.datasets.push({
              label: util.type.name
              fillColor: "rgba(220,220,220,0.2)"
              strokeColor: "rgba(220,220,220,1)"
              pointColor: "rgba(220,220,220,1)"
              pointStrokeColor: "#fff"
              pointHighlightFill: "#fff"
              pointHighlightStroke: "rgba(220,220,220,1)"
              data: util.amounts
        })
      ctx = element[0].getContext("2d")
      utilityChart = new Chart(ctx).Line(data)
      element[0].onclick = (evt) ->
        activePoints = utilityChart.getPointsAtEvent(evt)
        index = data.labels.indexOf(activePoints[0].label)
        scope.changeState(index)
    
  {
    restrict: 'A'
    template: '<canvas id="utilityGraph" width="850" height="677"></canvas>'
    replace: true
    link: link
  }
)