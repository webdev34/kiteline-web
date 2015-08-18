'use strict'
describe 'Controller: MainCtrl', ->

 # load the controller's module
  beforeEach module 'kiteLineApp'
  MainCtrl = {}
  mainScope = {}
  mainRootScope = {}

      # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    mainScope = $rootScope.$new()
    MainCtrl = $mainController 'MainCtrl', {
      $scope: mainScope
      $rootScope: mainRootScope
    }

    describe 'Controller: DashboardCtrl', ->

      # load the controller's module
      beforeEach module 'kiteLineApp'
      DashboardCtrl = {}
      scope = {}
      rootScope = {}

      # Initialize the controller and a mock scope
      beforeEach inject ($controller, $rootScope) ->
        scope = $rootScope.$new()

        DashboardCtrl = $controller 'DashboardCtrl', {
          $scope: scope
          $rootScope: rootScope
        }

      it 'should attach a list of awesomeThings to the scope', ->
        expect(scope.currentLowerTab).toBe "Updatesn"
        console.log scope
