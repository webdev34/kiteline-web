
angular.module('kiteLineApp').service 'StorageService', ($http, $q, $rootScope, localStorageService) ->
  self = undefined
  self = undefined
  self = this

  @getItem = (item) ->
    # Read that value back
    value = localStorageService.get(item)
    value

  @setItem = (key, value) ->
    # To add to local storage
    localStorageService.set key, value
    return

  @deleteItem = (key) ->
    # To remove a local storage
    localStorageService.remove key
    return

  @deleteLocalStorage = () ->
    # To remove a local storage
    localStorageService.clearAll()
    return

  #COOKIES

  @getCookie = (item) ->
    # Read that value back
    value = localStorageService.cookie.get(item)
    value

  @setCookie = (key, value) ->
    # To add to local storage
    localStorageService.cookie.set key, value
    return

  @deleteCookie = (key) ->
    # To remove a local storage
    localStorageService.cookie.remove key
    return

  @deleteCookieSession = (key) ->
    # To remove a local storage
    localStorageService.cookie.clearAll()
    return

  return