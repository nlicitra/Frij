app = angular.module("testapp", [])

app.controller("MainCtrl", ['$scope', ($scope) ->
  console.log($scope)
])

app.directive("myDirective", ->
  {
    link: (scope) -> console.log(scope)
  }
)