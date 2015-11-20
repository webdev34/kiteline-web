
angular.module('kiteLineApp').service 'IPService', ($http, $q, $rootScope) ->
  rootUrl =  $rootScope.rootUrl
  self = undefined
  self = this
  deferred = undefined
  deferred = $q.defer()

  @getIPAddress = () ->  
    if $rootScope.isLocalHost 
      url = 'http://api.ipify.org?format=json'
    else
      url = 'https://api.ipify.org?format=json'

    $http(
      method: 'GET'
      headers:
        'Content-Type': 'application/json'
      url: url).success((data, status, headers, config) ->
      deferred.resolve data

      $rootScope.userIP = data.ip

      return
    ).error (data, status, headers, config) ->
      deferred.reject status

      
  return