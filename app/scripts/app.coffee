'use strict'
angular.module('kiteLineApp', [
  'ngAnimate'
  'ngCookies'
  'ngResource'
  'ngRoute'
  'ngSanitize'
  'toastr'
  'LocalStorageModule'
  'ngDialog'
  'toggle-switch'
  'ngMask'
  '720kb.datepicker'
  'angularSpinner'
  'credit-cards'
  'simplePagination'
  'duScroll'

]).config ($routeProvider) ->
  $routeProvider.when('/',
    templateUrl: 'views/login.html'
    controller: 'LoginCtrl').when('/invalid-subscription',
    templateUrl: 'views/invalid-subscription.html'
    controller: 'LoginCtrl').when('/dashboard',
    templateUrl: 'views/dashboard/dashboard.html'
    controller: 'DashboardCtrl').when('/billing',
    templateUrl: 'views/billing/billing.html'
    controller: 'BillingCtrl').when('/billing/invoices',
    templateUrl: 'views/billing/billing.html'
    controller: 'BillingCtrl').when('/billing/payment-accounts',
    templateUrl: 'views/billing/billing.html'    
    controller: 'BillingCtrl').when('/forms',
    templateUrl: 'views/forms/forms.html'
    controller: 'FormsCtrl').when('/terms-of-service',
    templateUrl: 'views/terms-of-service.html'
    controller: 'TOSCtrl').when('/privacy',
    templateUrl: 'views/privacy.html'
    controller: 'PrivacyCtrl').otherwise redirectTo: '/dashboard'

  angular.module('kiteLineApp').config [
    'usSpinnerConfigProvider'
    (usSpinnerConfigProvider) ->
      usSpinnerConfigProvider.setDefaults color: 'blue'
      return
  ]