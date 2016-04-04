var FunWithRecipes = angular.module('FunWithRecipes', []);

FunWithRecipes.controller('FunWithRecipes', function($scope){
    
    var socket = io.connect('https://' + document.domain + ':' + location.port + '/chat');

    //var socket = io.connect();

    $scope.messages = [];
    $scope.results = [];
    $scope.roster = [];
    $scope.name = '';
    $scope.text = '';
    $scope.searchtext = '';
    $scope.isLoggedIn = '';

        socket.on('connect', function () {
          console.log('connected');
          $scope.setName();
        });

        socket.on('message', function (msg) {
          console.log(msg);
          $scope.messages.push(msg);
          $scope.$apply();
        });

        socket.on('roster', function (names) {
          console.log("Roster update:" +JSON.stringify(names))
          $scope.roster = names;
          $scope.$apply();
        });

        socket.on('isLoggedIn', function (loggedin) {
          $scope.isLoggedIn = loggedin;
          $scope.$apply();
        });
        
        socket.on('results', function (search){
          console.log(search);
          $scope.results.push(search);
          $scope.$apply();
        });
        
        $scope.search = function search() {
          console.log('Searching...', $scope.searchtext);
          socket.emit('search', $scope.searchtext);
          $scope.searchtext = '';
        };
        
        $scope.send = function send() {
          console.log('Sending message:', $scope.text);
          socket.emit('message', $scope.text);
          $scope.text = '';
        };

        $scope.setName = function setName() {
          socket.emit('identify', $scope.name);
        };
        
        $scope.setName2 = function setName2() {
          socket.emit('identify', $scope.name2);
          $scope.name = $scope.name2;
          $scope.$apply();
        };

        $scope.processLogin = function processLogin() {
          console.log("Trying to log in", $scope.pw);
          socket.emit('check', $scope.pw);
        };

     });
