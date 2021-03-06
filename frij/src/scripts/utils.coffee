frijapp = angular.module('frij.utility',['ui.router', 'frij.directives', 'frij.services', 'frij.controllers'])

frijapp.config(($interpolateProvider, $stateProvider, $urlRouterProvider) ->
  $interpolateProvider.startSymbol('[[')
  $interpolateProvider.endSymbol(']]')

  # default to current date
  currentDate = new Date()
  $urlRouterProvider.otherwise('/' + currentDate.getFullYear() + '/' + (currentDate.getMonth() + 1) + '/')

  $stateProvider
    .state('utilityList'
      url:'/{year}/{month}/'
      template:'<div data-utility-form />'
      controller:'utilityListController'
      resolve:
        utilityData: (Utilities) ->
          Utilities.fetchData()
    )
)


frijapp.config(($httpProvider) ->
    getCookie = (name) ->
        for cookie in document.cookie.split ';' when cookie and name is (cookie.trim().split '=')[0]
            return decodeURIComponent cookie.trim()[(1 + name.length)...]
        null

    $httpProvider.defaults.headers.common['X-CSRFToken'] = getCookie("csrftoken")
)