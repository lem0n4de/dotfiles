Request
- [x] Url
- [x] Parameters
- [x] Headers
	- [ ]  set headers for js rendered requests in QWebEngineUrlRequestInfo
- [ ] Cookies
- [ ] Proxy?
## Lower-Level Classes
	_class_ requests.Request(_method=None_, _url=None_, _headers=None_, _files=None_, _data=None_, _params=None_, _auth=None_, _cookies=None_, _hooks=None_, _json=None_)[[source]](https://requests.readthedocs.io/en/latest/_modules/requests/models/#Request)[](https://requests.readthedocs.io/en/latest/api/#requests.Request "Permalink to this definition")

A user-created [`Request`](https://requests.readthedocs.io/en/latest/api/#requests.Request "requests.Request") object.

Used to prepare a [`PreparedRequest`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest "requests.PreparedRequest"), which is sent to the server.

Parameters

-   **method** – HTTP method to use.
    
-   **url** – URL to send.
    
-   **headers** – dictionary of headers to send.
    
-   **files** – dictionary of {filename: fileobject} files to multipart upload.
    
-   **data** – the body to attach to the request. If a dictionary or list of tuples `[(key, value)]` is provided, form-encoding will take place.
    
-   **json** – json for the body to attach to the request (if files or data is not specified).
    
-   **params** – URL parameters to append to the URL. If a dictionary or list of tuples `[(key, value)]` is provided, form-encoding will take place.
    
-   **auth** – Auth handler or (user, pass) tuple.
    
-   **cookies** – dictionary or CookieJar of cookies to attach to this request.
    
-   **hooks** – dictionary of callback hooks, for internal usage.
    

Spider
- Proxy
- add_request
- add_requests
- start()
- parse
	- follow method?
	- threading?
- proxy

[url_decode](https://stackoverflow.com/a/32595923/9105459)
[url_encode](https://stackoverflow.com/a/17708801/9105459)


