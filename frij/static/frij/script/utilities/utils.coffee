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
      templateUrl:'../static/frij/partials/utility_form.html'
      controller:'utilityListController'
      resolve:
        utilityAmounts: (UtilityChargePeriod, $stateParams) ->
          UtilityChargePeriod.fetch(new Date($stateParams.year, (parseInt($stateParams.month) - 1)))
          return UtilityChargePeriod.data()

        navControls: ($stateParams, $http) ->
          navCtrl = {
            hasNext: false
            hasPrev: false
            nextDatePeriod: new Date(parseInt($stateParams.year), parseInt($stateParams.month), 1)
            prevDatePeriod: new Date(parseInt($stateParams.year), parseInt($stateParams.month)-2, 1)
          }
          $http({method:'GET', url:'/frij/utilities/' + navCtrl.nextDatePeriod.getFullYear() + '/' + (parseInt(navCtrl.nextDatePeriod.getMonth())+1) + '/'})
            .then(
              (response) ->
                navCtrl.hasNext = (response.data.utilities != undefined && response.data.utilities.length > 0)
            )

          $http({method:'GET', url:'/frij/utilities/' + navCtrl.prevDatePeriod.getFullYear() + '/' + (parseInt(navCtrl.prevDatePeriod.getMonth())+1) + '/'})
            .then(
              (response) ->
                navCtrl.hasPrev = (response.data.utilities != undefined && response.data.utilities.length > 0)
            )

          return navCtrl

        months: -> ['January','February','March','April','May','June','July','August','September','October','November','December']
    )
)


frijapp.config(($httpProvider) ->
    getCookie = (name) ->
        for cookie in document.cookie.split ';' when cookie and name is (cookie.trim().split '=')[0]
            return decodeURIComponent cookie.trim()[(1 + name.length)...]
        null

    $httpProvider.defaults.headers.common['X-CSRFToken'] = getCookie("csrftoken")
)