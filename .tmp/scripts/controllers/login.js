(function() {
  'use strict';
  angular.module('kiteLineApp').controller('LoginCtrl', [
    '$scope', '$rootScope', '$location', 'LogInService', 'CenterInfoService', 'ForgotPinService', function($scope, $rootScope, $location, LogInService, CenterInfoService, ForgotPinService) {
      LogInService.isLoggedIn();
      $rootScope.isLoggedIn = false;
      $rootScope.isLoginPage = true;
      $scope.isValid = false;
      $scope.isValidForgotPin = false;
      $scope.showLogIn = true;
      $scope.email = '';
      $scope.pin = '';
      $scope.centerId = '';
      $scope.emailForgotPin = '';
      $scope.login = function() {
        $rootScope.dataLoading = true;
        LogInService.Login($scope.email, $scope.pin, $scope.centerId);
      };
      $scope.changeView = function(view) {
        if (view === 'forgotPin') {
          $scope.showLogIn = false;
          $scope.validationCheckForgotPin();
        } else {
          $scope.showLogIn = true;
          $scope.validationCheck();
        }
      };
      $scope.centerSearchFunc = function() {
        CenterInfoService.centerSearch($scope.centernameSearch);
      };
      $scope.forgotPinFunc = function() {
        $rootScope.dataLoading = true;
        ForgotPinService.sendForgottenPIN($scope.email, $scope.centerId);
      };
      $scope.selectCenter = function(centerId, centerName) {
        $scope.centernameSearch = centerName;
        $scope.centerId = centerId;
        $rootScope.careCenters = null;
        if ($scope.showLogIn === true) {
          $scope.validationCheck();
        } else {
          $scope.validationCheckForgotPin();
        }
      };
      $scope.validationCheck = function() {
        if ($scope.email.length !== 0 && $scope.pin.length !== 0 && $scope.centerId.length !== 0) {
          $scope.isValid = true;
        } else {
          $scope.isValid = false;
        }
      };
      $scope.validationCheckForgotPin = function() {
        if ($scope.email.length !== 0 && $scope.centerId.length !== 0) {
          $scope.isValidForgotPin = true;
        } else {
          $scope.isValidForgotPin = false;
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=login.js.map
