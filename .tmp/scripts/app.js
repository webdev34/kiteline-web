(function() {
  'use strict';
  angular.module('kiteLineApp', ['ngAnimate', 'ngCookies', 'ngResource', 'ngRoute', 'ngSanitize', 'toastr', 'LocalStorageModule', 'ngScrollbars', 'ngDialog', 'toggle-switch', 'ngMask', 'angular-datepicker']).config(function($routeProvider, ScrollBarsProvider) {
    $routeProvider.when('/', {
      templateUrl: 'views/login.html',
      controller: 'LoginCtrl'
    }).when('/dashboard', {
      templateUrl: 'views/dashboard/dashboard.html',
      controller: 'DashboardCtrl'
    }).when('/billing', {
      templateUrl: 'views/billing/billing.html',
      controller: 'BillingCtrl'
    }).when('/daily-activity-feed', {
      templateUrl: 'views/daily-activity-feed/daily-activity-feed.html',
      controller: 'DailyActivityFeedCtrl'
    }).when('/terms-of-service', {
      templateUrl: 'views/terms-of-service.html',
      controller: 'TOSCtrl'
    }).when('/privacy', {
      templateUrl: 'views/privacy.html',
      controller: 'PrivacyCtrl'
    }).otherwise({
      redirectTo: '/'
    });
    ScrollBarsProvider.defaults = {
      autoHideScrollbar: false,
      setHeight: 'auto',
      scrollInertia: 0,
      axis: 'yx',
      advanced: {
        updateOnContentResize: true
      },
      scrollButtons: {
        scrollAmount: 'auto',
        enable: true
      }
    };
  });

}).call(this);

//# sourceMappingURL=app.js.map
