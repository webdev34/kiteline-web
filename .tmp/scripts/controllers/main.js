(function() {
  'use strict';
  angular.module('kiteLineApp').controller('MainCtrl', function($scope, $rootScope, $location, StorageService) {
    $rootScope.changePageTitle = function() {
      if ($location.$$path === '/dashboard') {
        $rootScope.pageTitle = 'Dashboard';
      }
      if ($location.$$path === '/invoices') {
        $rootScope.pageTitle = 'Invoices';
      }
      if ($location.$$path === '/') {
        $rootScope.pageTitle = 'Kiteline Web';
      }
      if ($location.$$path === '/my-children') {
        $rootScope.pageTitle = 'My Children';
      }
      if ($location.$$path === '/messages') {
        $rootScope.pageTitle = 'Messages';
      }
    };
    $rootScope.logOut = function() {
      StorageService.deleteLocalStorage();
      $location.path('/');
    };
    $rootScope.changePageTitle();
    $rootScope.scrollbarConfig = {
      theme: 'dark',
      scrollInertia: 500
    };
    $rootScope.rootUrl = 'https://cloud.spinsys.com/SkyServices/KiteLine/V1.0/';
    return $rootScope.footerYear = (new Date).getFullYear();
  });

}).call(this);

//# sourceMappingURL=main.js.map
