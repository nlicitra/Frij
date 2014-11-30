directives = angular.module('frij.directives', [])

directives.directive('utilityInput', ->
  {
    restrict: 'A'
    templateUrl: '../static/frij/partials/utility_input.html'
    replace: false
  }
)