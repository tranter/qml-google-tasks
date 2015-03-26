# Introduction #

The **qml-google-tasks** example uses Google Tasks API. To use API you need to register your own application on Google.


# Details #

You need to login to Google, so first you need to create simple Google account. Then you can visit the page

https://code.google.com/apis/console

there you can create your application. You need to check access to Google Tasks API. Right now you need to request for an access.



Then  you can see credentials of your application. You need to copy and paste **Client\_ID**, **Client\_Secret**, **Redirect\_URI** to the file **google\_oauth.js**.
```
var client_id = "YOUR_CLIENT_ID_HERE";
var client_secret = "YOUR_CLIENT_SECRET_HERE";
var redirect_uri = "YOUR_REDIRECT_URI_HERE";

```

After that you can compile and run **qml-google-tasks**.