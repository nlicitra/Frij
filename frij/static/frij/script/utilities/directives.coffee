directives = angular.module('frij.directives', [])

directives.directive('monthpicker', ->
  {
    restrict: 'A',
    require: 'ngModel',
    link: (scope, element) ->
      element.datetimepicker({
        format: "MM/YYYY",
        viewMode: "months",
        minViewMode: "months",
        pickTime: false,
      })
  }
)