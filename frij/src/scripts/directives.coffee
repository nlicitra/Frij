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

    utilColorMap = {
      'WTR': {
        fillColor: "rgba(49,189,240,0.2)"
        strokeColor: "rgba(49,189,240,1)"
        pointColor: "rgba(49,189,240,1)"
        pointHighlightStroke: "rgba(49,189,240,1)"
      }
      'GAS': {
        fillColor: "rgba(238,73,73,0.2)"
        strokeColor: "rgba(238,73,73,1)"
        pointColor: "rgba(238,73,73,1)"
        pointHighlightStroke: "rgba(238,73,73,1)"
      }
      'CBL': {
        fillColor: "rgba(73,238,106,0.2)"
        strokeColor: "rgba(73,238,106,1)"
        pointColor: "rgba(73,238,106,1)"
        pointHighlightStroke: "rgba(73,238,106,1)"
      }
      'ELC': {
        fillColor: "rgba(246,246,66,0.2)"
        strokeColor: "rgba(246,246,66,1)"
        pointColor: "rgba(246,246,66,1)"
        pointHighlightStroke: "rgba(220,220,220,1)"
      }
    }

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
              fillColor: utilColorMap[util.type.code].fillColor
              strokeColor: utilColorMap[util.type.code].strokeColor
              pointColor: utilColorMap[util.type.code].pointColor
              pointStrokeColor: "#fff"
              pointHighlightFill: "#fff"
              pointHighlightStroke: utilColorMap[util.type.code].pointHighlightStroke
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