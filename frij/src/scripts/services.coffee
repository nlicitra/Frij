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

services.factory('UtilityChargePeriod', ($log, $http, UtilityAmount) ->
  amounts = []

  init: (data) ->
    @date = new Date(data.date.substring(0,4), parseInt(data.date.substring(5,7)) - 1)
    amounts.length = 0
    for amount in data.utilities
      amounts.push(new UtilityAmount(amount))

  fetch: (date) ->
    $http({method:'GET', url:'/frij/utilities/' + date.getFullYear() + '/' + (parseInt(date.getMonth()) + 1) + '/'})
      .success (data) =>
        @init(data)
        $log.info("SUCCESS GET UtilityAmounts")
      .error (data) =>
        $log.info("FAILED GET UtilityAmounts")

  data: ->
    return amounts

  update: ->
    serializedAmounts = []
    for amount in amounts
      serializedAmounts.push(amount.serialize())
    data = {utilities:serializedAmounts}
    $http({method:'PUT', url:'/frij/utilities/' + @date.getFullYear() + "/" + (@date.getMonth() + 1) + "/", data:data})
      .success(data) =>
        alert('you did it!')

)