import QtQuick 1.0
import QtWebKit 1.0
import "google_oauth.js" as OAuth

//import com.nokia.symbian 1.0
import com.nokia.meego 1.0



Rectangle {
    id: google_oauth
    width:  400
    height: 400
    color: "#343434";
    property string oauth_link: "https://accounts.google.com/o/oauth2/auth?" +
                                "client_id=" + OAuth.client_id +
                                "&redirect_uri=" + OAuth.redirect_uri +
                                "&response_type=code" +
                                "&scope=https://www.googleapis.com/auth/tasks" +
                                "&access_type=offline" +
                                "&approval_prompt=force"

    property bool authorized: accessToken != ""
    property string accessToken: ""
    signal loginDone();

    onAccessTokenChanged: {
        console.log('onAccessTokenChanged');
        if(accessToken != '')
        {
            console.log("accessToken = ", accessToken)
            loginDone();
        }
    }


    function login()
    {
        loginView.url = oauth_link;
    }

    function refreshAccessToken(refresh_token)
    {
        OAuth.refreshAccessToken(refresh_token)
    }

    Flickable {
        id: web_view_window

        property bool loading:  false;
        anchors.fill: parent

        contentWidth: Math.max(width,loginView.width)
        contentHeight: Math.max(height,loginView.height)
        clip: true

        WebView {
            id: loginView

            preferredWidth: web_view_window.width
            preferredHeight: web_view_window.height

            url: ""
            onUrlChanged: OAuth.urlChanged(url)

            onLoadFinished: {
                console.log("onLoadFinished");
                busy_indicator.running = false;
                busy_indicator.visible = false;
            }

            onLoadStarted: {
                console.log("onLoadStarted");
                busy_indicator.running = true;
                busy_indicator.visible = true;
            }

            BusyIndicator {
                id: busy_indicator;
                running: false
                width:  100;
                height: 100;
                anchors.centerIn:  parent;
                visible: false
            }

        }
    }


}
