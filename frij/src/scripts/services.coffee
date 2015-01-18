services = angular.module('frij.services', [])

services.factory('UtilityType', ->
  class UtilityType
    constructor: (data) ->
      @code = data.code
      @name = data.name

  return UtilityType
)

services.factory('UtilityTypeList', ($http, UtilityType) ->
  types = []

  populate: (data) ->
    for utils in data
      types.push(new UtilityType(utils))

  fetch: ($http) ->
    $http({method:'GET', url:'/frij/utilities/types/'})
      .success (data) =>
        @populate(data)
        $log.info("SUCCESS GET UtilityType List")
      .error (data) =>
        $log.info("FAILURE GET UtilityType List")

  list: -> 
    return types  
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

    update: ->
      amount = {'amount' : @amount}
      $http({method:'PUT', url:'/frij/utility/' + @id + '/', data:amount})

    serialize: -> {
      amount:@amount
      id:@id
      type:@type
    }

  return UtilityAmount
)

services.factory('UtilityChargePeriod', ($log, $http, UtilityAmount) ->
  class UtilityChargePeriod
    constructor: (data) ->
      if data != null
        @init(data)
    
    init: (data) ->
      @date = new Date(data.date.substring(0,4), parseInt(data.date.substring(5,7)) - 1)
      @amounts = []
      for amount in data.utilities
        @amounts.push(new UtilityAmount(amount)) 

    update: ->
      serializedAmounts = []
      for amount in @amounts
        serializedAmounts.push(amount.serialize())
      data = {utilities:serializedAmounts}
      $http({method:'PUT', url:'/frij/utilities/' + @date.getFullYear() + "/" + (@date.getMonth() + 1) + "/", data:data})

    balance: ->
      total = 0
      for util in @amounts
        total += parseFloat(util.amount)
      return total

    utilities: ->
      return @amounts

  return UtilityChargePeriod
)

services.factory('Utilities', ($http, $log, UtilityChargePeriod, UtilityType) ->
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
  utilData = {
    util: []
  }
  graphData = {}

  populateTypes: (data) ->
    for utils in data
      utilTypes.push(new UtilityType(utils))

  fetchTypes: ->
    $http({method:'GET', url:'/frij/utilities/types/'})


  types: -> 
    return utilTypes

  populateData: (data) ->
    utilData['util'].length = 0
    for period in data
      if period.utilities.length == 0
        for utilType in utilTypes
          utilAmount = {}
          utilAmount.type = utilType
          utilAmount.amount = 0
          period.utilities.push(utilAmount)
      utilData['util'].push(new UtilityChargePeriod(period))

  fetchData: ->
    $http({method:'GET', url:'/frij/utilities/'})
    .success (data) =>
      @populateData(data)
      $log.info("SUCCESS GET Utility")
    .error (data) =>
      $log.info("FAILURE GET Utility")

  data: ->
    return utilData.util

  init: ->
    @fetchTypes().then(@fetchData())

  graphData: ->
    utilMap = {}
    for utilType in utilTypes
      utilMap[utilType.code] = {
        type: utilType
        amounts: []
      }

    for period in utilData
      for util in period.amounts
        utilMap[util.type.code].amounts.push(util.amount)

    return $.map(utilMap, (value, index) -> 
      return [value]
    )
)