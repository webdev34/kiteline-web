(function() {
  'use strict';
  angular.module('kiteLineApp').service('StorageService', function($http, $q, $rootScope, localStorageService) {
    var self;
    self = void 0;
    self = void 0;
    self = this;
    this.getItem = function(item) {
      var value;
      value = localStorageService.get(item);
      return value;
    };
    this.setItem = function(key, value) {
      localStorageService.set(key, value);
    };
    this.deleteItem = function(key) {
      localStorageService.remove(key);
    };
    this.deleteLocalStorage = function(key) {
      localStorageService.clearAll();
    };
    this.getCookie = function(item) {
      var value;
      value = localStorageService.cookie.get(item);
      return value;
    };
    this.setCookie = function(key, value) {
      localStorageService.cookie.set(key, value);
    };
    this.deleteCookie = function(key) {
      localStorageService.cookie.remove(key);
    };
    this.deleteCookieSession = function(key) {
      localStorageService.cookie.clearAll();
    };
  });

}).call(this);

//# sourceMappingURL=storage.js.map
