(function () {
    'use strict';

    var serviceId = 'ConfigWindow';

    angular.module('app.config.window').factory(serviceId,
        ['$window', '$http', '$timeout', 'config', ConfigWindow]);

    function ConfigWindow ($window, $http, $timeout, config) {
        var service = {
            isReportUrl: isReportUrl,
            wrapWindowForTelerik: wrapWindowForTelerik,
            wrapWindowOpenForReports: wrapWindowOpenForReports,
            wrapDocumentBodyAppendChildForReports: wrapDocumentBodyAppendChildForReports,
            getReportWithXhr: getReportWithXhr,
            renderReport: renderReport,
            saveReportForInternetExplorer: saveReportForInternetExplorer,
            saveReportForOtherBrowser: saveReportForOtherBrowser,
            printReport: printReport
        };

        // Holds a reference to the helper anchor used for exporting reports
        // See saveReportForOtherBrowser method.
        var anchor;

        // Holds a reference to the helper iframe used for printing reports
        // See printReport method.
        var ifr;

        // Initial report file name when downloading.
        var filename = 'report.pdf';

        return service;

        /**
        * Checks whether a given url is pointing to the Reports API.
        *
        * @param {String} url
        * @return {Boolean}
        */
        function isReportUrl (url) {
            if (!url) {
                return false;
            }

            var reportApiUrl = config.apiBaseUrl + config.apiResourceUris.reports;
            return url.indexOf(reportApiUrl) > -1 ? true : false;
        }

        function wrapWindowForTelerik () {
            service.wrapWindowOpenForReports();
            service.wrapDocumentBodyAppendChildForReports();
        }

        /**
        * Wraps window.open to check for calls to the Reports API.
        * Telerik report viewer uses window.open to retrieve its reports
        * rather than XHR requests. When Telerik calls window.open with a
        * report URL, replace that call with an XHR request.
        *
        * @param none
        * @return none
        */
        function wrapWindowOpenForReports () {
            window.open = function (originalWindowOpen) {
                return function (url, windowName, windowFeatures) {
                    if (service.isReportUrl(url)) {
                        return service.getReportWithXhr(url, false);
                    } else {
                        return originalWindowOpen.call(window, url, windowName, windowFeatures);
                    }
                };
            }(window.open);
        }

        /**
        * Wraps document.body.appendChild to check for calls to the Reports
        * API URL. Telerik report viewer retrieves a report for printing by
        * appending an iframe with a src pointing to the url at the Reports API,
        * using document.body.appendChild to. When Telerik calls document.body.appendChild
        * with a report URL, replace that call with an XHR request.
        *
        * @param none
        * @return none
        */
        function wrapDocumentBodyAppendChildForReports () {
            document.body.appendChild = function (originalAppendChild) {
                return function (node) {
                    if (node.tagName === 'IFRAME' && service.isReportUrl(node.src)) {
                        return service.getReportWithXhr(node.src, true);
                    } else {
                        return originalAppendChild.apply(this, arguments);
                    }
                };
            }(document.body.appendChild);
        }

        /**
        * Alternative to window.open that uses XHR to retrieve the data so
        * custom headers can be set, the authorization header is therefore
        * injected normally as for any other $http request.
        *
        * @param {String} url The url of the data to get
        * @param {Boolean} isPrint True if the report is intended for printing
        * @return {Object} Promise
        */
        function getReportWithXhr (url, isPrint) {
            return $http.get(url, { responseType: 'blob' })
                .success(function (response) {
                    service.renderReport(response, isPrint);
                });
        }

        /**
        * Render the response from Telerik Reports.
        *
        * @param {HTTPResponse} response
        * @param {Boolean} isPrint True if the report is intended for printing
        * @return none
        */
        function renderReport (response, isPrint) {
            var isInternetExplorer = function () {
                var ua = $window.navigator.userAgent;
                var msie = ua.indexOf('MSIE ');
                var trident = ua.indexOf('Trident/');

                // IE 10 or older, return version number
                if (msie > 0) {
                    return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
                }

                // IE 11 (or newer), return version number
                if (trident > 0) {
                    var rv = ua.indexOf('rv:');
                    return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
                }

                // other browser
                return false;
            };

            var blob;

            blob = new Blob([response], {
                type: 'application/pdf'
            });

            if (isInternetExplorer()) {
                service.saveReportForInternetExplorer(blob);
            } else if (isPrint) {
                service.printReport(blob);
            } else {
                service.saveReportForOtherBrowser(blob);
            }
        }

        /**
        * Prompt a file save dialog for Internet Explorer.
        * Note: uses vendor-prefixed method. May need to be updated once
        * Microsoft standardises Blob handling in Internet Explorer.
        *
        * @param {Blob} blob
        * @return none
        */
        function saveReportForInternetExplorer (blob) {
            $window.navigator.msSaveBlob(blob, filename);
        }

        /**
        * Prompt a file save dialog for non Internet Explorer browsers.
        * There isn't a saveBlob equivalent outside of IE so creates an anchor
        * element on the page then trigger a click on it.
        *
        * @param {Blob} blob
        * @param {Boolean} clickThrough Whether to auto click the anchor
        *   Defaults to true
        * @return none
        */
        function saveReportForOtherBrowser (blob, clickThrough) {
            clickThrough = angular.isDefined(clickThrough) ? clickThrough : true;

            if (!anchor) {
                anchor = document.createElement('a');
                anchor.id = 'zmd-report-exporter';
                anchor.download = filename;
                anchor.style.display = 'none';
            }
            var blobUrl = URL.createObjectURL(blob);

            anchor.href = blobUrl;
            document.body.appendChild(anchor);

            if (clickThrough) {
                if (anchor.click) {
                    anchor.click();
                } else {
                    angular.element(anchor).click();
                }
            }

            // clean up, let anchor have time to render
            $timeout(function () {
                URL.revokeObjectURL(blobUrl);
            }, 100);
        }

        /**
        * Invoke Telerik's direct print. Using an iframe with a source
        * attribute pointing to the blob url will cause it to trigger a print
        * dialog without the user having to save the file and open it. If
        * printing on a mobile device, let it be handled natively.
        *
        * @param {Blob} blob
        * @return none
        */
        function printReport (blob) {
            var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test($window.navigator.userAgent);
            var blobUrl;

            if (isMobile) {
                service.saveReportForOtherBrowser(blob);
            } else {
                blobUrl = URL.createObjectURL(blob);

                if (!ifr) {
                    ifr = document.createElement('iframe');
                    ifr.id = 'zmd-report-printer';

                    // Create a hidden iframe. Can't use 'display: none' as it
                    // fails in Firefox due to a null offsetParent
                    // ref: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement.offsetParent
                    ifr.setAttribute('style', 'position: absolute; height: 1px; width: 1px; visibility: hidden');
                }

                ifr.src = blobUrl;

                document.body.appendChild(ifr);

                // clean up, let iframe have time to render
                $timeout(function () {
                    URL.revokeObjectURL(blobUrl);
                }, 100);
            }
        }
    }
})();