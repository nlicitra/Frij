services = angular.module('frij.services', [])

services.factory('UtilityType', ->
  class UtilityType
    constructor: (data) ->
      @code = data.code
      @name = data.name

  return UtilityType
)

services.factory('UtilityAmount', (UtilityType, $log, $http) ->
  class UtilityAmount
    constructor: (data) ->
      if data != null
        @init(data)

    init: (data) ->
      @type = new UtilityType(data.type)
      @amount = data.amount
      @id = data.id
      @date = new Date(data.year, data.month)

    update: ->
      amount = {'amount' : @amount}
      $http({method:'PUT', url:'/frij/utility/' + @id + '/', data:amount})

    serialize: -> {
      amount:@amount
      id:@id
    }

  return UtilityAmount
)

services.factory('UtilityChargePeriod', ($log, $http, $resource, UtilityAmount) ->
  amounts = []

  fromServer: (data) ->
    @date = new Date(data.date.substring(0,4), data.date.substring(5,7))
    amounts.length = 0
    for amount in data.utilities
      amounts.push(new UtilityAmount(amount))

  fetch: (date) ->
    $http({method:'GET', url:'/frij/utilities/' + date.getFullYear() + '/' + date.getMonth() + '/'})
      .success (data) =>
        @fromServer(data)
        $log.info("SUCCESS GET UtilityAmounts")
      .error (data) =>
        $log.info("FAILED GET UtilityAmounts")

  getResource: -> $resource('/frij/utilities/:year/:month/', {month:'@month', year:'@year'})


  data: ->
    return amounts

  update: ->
    serializedAmounts = []
    for amount in amounts
      serializedAmounts.push(amount.serialize())
    data = {utilities:serializedAmounts}
    $http({method:'PUT', url:'/frij/utilities/' + @date.getFullYear() + "/" + @date.getMonth() + "/", data:data})

  month: ->
    return @date.getMonth()

  year: ->
    return @date.getFullYear()
)