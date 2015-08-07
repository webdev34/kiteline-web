describe('services', function () {
    'use strict';

    describe('ConfigWindow', function () {
        var $httpBackend;
        var ConfigWindow;
        var $window;
        var $timeout;

        var reportRequestURL = 'http://localhost:56264/api/reports';
        var nonReportRequestURL1 = 'http://localhost:56264/api/report';
        var nonReportRequestURL2 = 'http://localhost:56264/apis/report';
        var nonReportRequestURL3 = 'http://localhost:56264/apis/reports';
        var ieUserAgent = 'Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E; InfoPath.3; rv:11.0) like Gecko';
        var chromeUserAgent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36';
        var iPadUserAgent = 'Mozilla/5.0 (iPad; CPU OS 7_0_2 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A501 Safari/9537.53';
        var mockWindow = {
            navigator: {
                userAgent: 'test',
                msSaveBlob: angular.noop
            }
        };

        // Mock Blob constructor as PhantomJS doesn't have it
        window.Blob = function (data, options) {
            this.data = data;
            this.type = options.type;
        };

        // Mock URL object as PhantomJS doesn't have it
        window.URL = {
            createObjectURL: angular.noop,
            revokeObjectURL: angular.noop
        };

        beforeEach(module('app.config.window'));

        beforeEach(function () {
            module(function ($provide) {
                $provide.value('$window', mockWindow);
            });
        });

        beforeEach(inject(function (_$httpBackend_, _ConfigWindow_, _$window_, _$timeout_) {
            $httpBackend = _$httpBackend_;
            ConfigWindow = _ConfigWindow_;
            $window = _$window_;
            $timeout = _$timeout_;

            spyOn(ConfigWindow, 'isReportUrl').andCallThrough();
            spyOn(ConfigWindow, 'getReportWithXhr').andCallThrough();
            spyOn(window.URL, 'createObjectURL').andReturn('http://bloburl/');
            spyOn(window.URL, 'revokeObjectURL');
        }));

        it('should be defined', function () {
            expect(ConfigWindow).not.toBeUndefined();
        });

        it('should have an isReportUrl method', function () {
            expect(angular.isFunction(ConfigWindow.isReportUrl)).toBe(true);
        });

        describe('isReportUrl', function () {
            var result;

            it('should be true if url contains url to reports api', function () {
                result = ConfigWindow.isReportUrl(reportRequestURL);
                expect(result).toBe(true);
            });

            it('should be false if url does not contain url to reports api', function () {
                result = ConfigWindow.isReportUrl(nonReportRequestURL1);
                expect(result).toBe(false);

                result = ConfigWindow.isReportUrl(nonReportRequestURL2);
                expect(result).toBe(false);

                result = ConfigWindow.isReportUrl(nonReportRequestURL3);
                expect(result).toBe(false);
            });
        });

        it('should have a wrapWindowForTelerik method', function () {
            expect(angular.isFunction(ConfigWindow.wrapWindowForTelerik)).toBe(true);
        });

        describe('wrapWindowForTelerik', function () {
            beforeEach(function () {
                spyOn(ConfigWindow, 'wrapWindowOpenForReports').andCallThrough();
                spyOn(ConfigWindow, 'wrapDocumentBodyAppendChildForReports').andCallThrough();
            });

            it('should call other wrap methods', function () {
                ConfigWindow.wrapWindowForTelerik();

                expect(ConfigWindow.wrapWindowOpenForReports).toHaveBeenCalled();
                expect(ConfigWindow.wrapDocumentBodyAppendChildForReports).toHaveBeenCalled();
            });
        });

        it('should have a wrapWindowOpenForReports method', function () {
            expect(angular.isFunction(ConfigWindow.wrapWindowOpenForReports)).toBe(true);
        });

        describe('wrapWindowOpenForReports', function () {
            beforeEach(function () {
                ConfigWindow.wrapWindowOpenForReports();
            });

            it('window.open should call getReportWithXhr with no-printing if is reports url', function () {
                window.open(reportRequestURL);
                expect(ConfigWindow.isReportUrl).toHaveBeenCalled();
                expect(ConfigWindow.getReportWithXhr)
                    .toHaveBeenCalledWith(reportRequestURL, false);
            });

            xit('window.open should not call getReportWithXhr if is not reports url', function () {
                window.open(nonReportRequestURL1);
                window.open(nonReportRequestURL2);
                window.open(nonReportRequestURL3);
                expect(ConfigWindow.isReportUrl).toHaveBeenCalled();
                expect(ConfigWindow.getReportWithXhr).not.toHaveBeenCalled();
            });
        });

        it('should have a wrapDocumentBodyAppendChildForReports method', function () {
            expect(angular.isFunction(ConfigWindow.wrapDocumentBodyAppendChildForReports)).toBe(true);
        });

        describe('wrapDocumentBodyAppendChildForReports', function () {
            var ifr;
            var anchor = document.createElement('a');

            beforeEach(function () {
                ifr = document.createElement('iframe');
                ConfigWindow.wrapDocumentBodyAppendChildForReports();
            });

            it('should not interfere if node is not an iframe', function () {
                document.body.appendChild(anchor);
                expect(ConfigWindow.isReportUrl).not.toHaveBeenCalled();
            });

            it('appendChild should call isReportUrl if node is iframe', function () {
                document.body.appendChild(ifr);
                expect(ConfigWindow.isReportUrl).toHaveBeenCalled();
            });

            it('appendChild should call getReportWithXhr with printing if is reports url', function () {
                ifr.src = reportRequestURL;
                document.body.appendChild(ifr);
                expect(ConfigWindow.getReportWithXhr)
                    .toHaveBeenCalledWith(reportRequestURL, true);
            });

            it('appendChild should not call getReportWithXhr if is not reports url', function () {
                ifr.src = nonReportRequestURL1;
                document.body.appendChild(ifr);

                ifr.src = nonReportRequestURL2;
                document.body.appendChild(ifr);

                ifr.src = nonReportRequestURL3;
                document.body.appendChild(ifr);

                expect(ConfigWindow.isReportUrl).toHaveBeenCalled();
                expect(ConfigWindow.getReportWithXhr).not.toHaveBeenCalled();
            });
        });

        it('should have a getReportWithXhr method', function () {
            expect(angular.isFunction(ConfigWindow.getReportWithXhr)).toBe(true);
        });

        describe('getReportWithXhr', function () {
            var response = 'myResponse';

            beforeEach(function () {
                spyOn(ConfigWindow, 'renderReport').andCallFake(angular.noop);
                $httpBackend.expectGET('//myUrl');
            });

            afterEach(function () {
                $httpBackend.verifyNoOutstandingExpectation();
                $httpBackend.verifyNoOutstandingRequest();
            });

            it('should call renderReport on success with 2 params', function () {
                $httpBackend.whenGET('//myUrl').respond(response);

                ConfigWindow.getReportWithXhr('//myUrl', true);
                $httpBackend.flush();
                expect(ConfigWindow.renderReport)
                    .toHaveBeenCalledWith('myResponse', true);
            });

            it('should not call renderReport on fail', function () {
                $httpBackend.whenGET('//myUrl').respond(500, response);

                ConfigWindow.getReportWithXhr('//myUrl', true);
                $httpBackend.flush();
                expect(ConfigWindow.renderReport).not.toHaveBeenCalled();
            });
        });

        it('should have a renderReport method', function () {
            expect(angular.isFunction(ConfigWindow.renderReport)).toBe(true);
        });

        describe('renderReport', function () {
            var response = 'myResponse';

            beforeEach(function () {
                spyOn(window, 'Blob').andCallThrough();
                spyOn(ConfigWindow, 'saveReportForInternetExplorer');
                spyOn(ConfigWindow, 'saveReportForOtherBrowser');
                spyOn(ConfigWindow, 'printReport');
            });

            it('should create a blob', function () {
                ConfigWindow.renderReport(response, true);
                expect(window.Blob).toHaveBeenCalledWith([response], { type: 'application/pdf' });
            });

            it('should call saveReportForInternetExplorer if internet explorer', function () {
                mockWindow.navigator.userAgent = ieUserAgent;

                ConfigWindow.renderReport(response, true);
                expect(ConfigWindow.saveReportForInternetExplorer)
                    .toHaveBeenCalled();
            });

            it('should call printReport if printing and not internet explorer', function () {
                mockWindow.navigator.userAgent = chromeUserAgent;

                ConfigWindow.renderReport(response, true);
                expect(ConfigWindow.printReport)
                    .toHaveBeenCalled();
            });

            it('should call saveReportForOtherBrowser if not printing and not internet explorer', function () {
                mockWindow.navigator.userAgent = chromeUserAgent;

                ConfigWindow.renderReport(response, false);
                expect(ConfigWindow.saveReportForOtherBrowser)
                    .toHaveBeenCalled();
            });
        });

        it('should have a saveReportForInternetExplorer method', function () {
            expect(angular.isFunction(ConfigWindow.saveReportForInternetExplorer)).toBe(true);
        });

        describe('saveReportForInternetExplorer', function () {
            var thingToSave = 'thing';

            beforeEach(function () {
                spyOn($window.navigator, 'msSaveBlob');
            });

            it('should call msSaveBlob', function () {
                ConfigWindow.saveReportForInternetExplorer(thingToSave);

                expect($window.navigator.msSaveBlob)
                    .toHaveBeenCalledWith(thingToSave, 'report.pdf');
            });
        });

        it('should have a saveReportForOtherBrowser method', function () {
            expect(angular.isFunction(ConfigWindow.saveReportForOtherBrowser)).toBe(true);
        });

        describe('saveReportForOtherBrowser', function () {
            var thingToSave = 'thing';
            var anchor;

            beforeEach(function () {
                ConfigWindow.saveReportForOtherBrowser(thingToSave, false);

                anchor = angular.element('#zmd-report-exporter');
            });

            it('should create anchor element with correct properties', function () {
                expect(anchor.length).toBe(1);
                expect(anchor[0].download).toBe('report.pdf');
                expect(anchor[0].style.display).toBe('none');
            });

            it('should have created an object url to the blob', function () {
                expect(anchor[0].href).toBe('http://bloburl/');
            });

            it('should clean up object url after a timeout', function () {
                $timeout.flush();
                expect(window.URL.revokeObjectURL)
                    .toHaveBeenCalledWith('http://bloburl/');
            });
        });

        it('should have a printReport method', function () {
            expect(angular.isFunction(ConfigWindow.printReport)).toBe(true);
        });

        describe('printReport', function () {
            var thingToSave = 'thing';
            var ifr;

            beforeEach(function () {
                spyOn(ConfigWindow, 'saveReportForOtherBrowser');
            });

            describe('for mobile', function () {
                beforeEach(function () {
                    mockWindow.navigator.userAgent = iPadUserAgent;
                    ConfigWindow.printReport(thingToSave);
                    ifr = angular.element('#zmd-report-printer');
                });

                it('should call saveReportForOtherBrowser', function () {
                    expect(ConfigWindow.saveReportForOtherBrowser)
                        .toHaveBeenCalledWith(thingToSave);
                });

                it('should not have created an iframe', function () {
                    expect(ifr.length).toBe(0);
                });
            });

            describe('for desktop', function () {
                beforeEach(function () {
                    mockWindow.navigator.userAgent = chromeUserAgent;
                    ConfigWindow.printReport(thingToSave);
                    ifr = angular.element('#zmd-report-printer');
                });

                it('should create iframe element with correct properties', function () {
                    expect(ifr.length).toBe(1);
                    expect(ifr.attr('style'))
                        .toEqual('position: absolute; height: 1px; width: 1px; visibility: hidden');
                });

                it('should have created an object url to the blob', function () {
                    expect(ifr[0].src).toBe('http://bloburl/');
                });

                it('should clean up object url after a timeout', function () {
                    $timeout.flush();
                    expect(window.URL.revokeObjectURL)
                        .toHaveBeenCalledWith('http://bloburl/');
                });
            });
        });
    });
});