'use strict';

import React from 'react-native';
import Parse from 'parse/react-native';
import NavigationBar from 'react-native-navbar';
import FBLogin from 'react-native-facebook-login';
import { FBLoginManager } from 'NativeModules';

//App modules
import { NavCloseButton, NavTitleLabel } from 'app-components';

const {
Component,
StyleSheet,
Image,
Text,
View,
} = React;

const FB_PHOTO_WIDTH = 200;

export default class Settings extends Component {

    constructor(props) {
        super(props);
        this.state = {
            user: null,
            loadingCurrentUser: true,
        };
    }

    render() {
        var user = this.state.user;

        return (
            <View style={styles.container}>
                <NavigationBar
                title={<NavTitleLabel title={'Settings'} />}
                rightButton={<NavCloseButton />} />

                { user && <Photo user={user} /> }
                { user && <Info user={user} /> }

                <FBLogin
                style={styles.loginButton}
                permissions={['email','user_friends']}
                loginBehavior={FBLoginManager.LoginBehaviors.SystemAccount}
                onLogin={this.onFBLogin.bind(this)}
                onLogout={this.onFBLogout.bind(this)}
                onError={this.onFBError.bind(this)}
                onCancel={this.onFBCancel}
                />
            </View>
        );
    }

    onFBLogin(data) {
        console.log('Logged in!');
        this.setState({ user : data.credentials });

        let authData = {
            id: data.credentials.userId,
            access_token: data.credentials.token,
            expiration_date: data.credentials.tokenExpirationDate
        };

        //Log into Parse
        let _this = this;
        Parse.FacebookUtils.logIn(authData, {
            success: (user) => {
                console.log('Logged into Parse!');
                _this.setState({loadingCurrentUser: false});
            },
            error: (user, error) => {
                switch (error.code) {
                    case Parse.Error.INVALID_SESSION_TOKEN:
                        Parse.User.logOut();
                        break;
                    default:
                        _this.setState({loadingCurrentUser: false});
                        alert(error.message);
                }
            }
        });
    }

    onFBLogout(data) {
        console.log('Logged out!');
        this.setState({ user : null });

        Parse.User.logOut().then(() => {
            console.log('Logged out of Parse!');
        });
    }

    onFBError(data) {
        console.log('Login error!');
        console.log(data);
    }

    onFBCancel() {
        console.log('User cancelled!');
    }
};


var Photo = React.createClass({
    propTypes: {
        user: React.PropTypes.object.isRequired,
    },

    getInitialState: function(){
        return {
            photo: null,
        };
    },

    componentWillMount: function(){
        var _this = this;
        var user = this.props.user;
        var api = `https://graph.facebook.com/v2.3/${user.userId}/picture?width=${FB_PHOTO_WIDTH}&redirect=false&access_token=${user.token}`;

        fetch(api)
        .then((response) => response.json())
        .then((responseData) => {
            _this.setState({
                photo : {
                    url : responseData.data.url,
                    height: responseData.data.height,
                    width: responseData.data.width,
                },
            });
        })
        .done();
    },

    render: function(){
        var photo = this.state.photo;

        if (photo) {
            return (
            <View style={styles.bottomBump}>
                <Image
                style={photo &&
                {
                  height: photo.height,
                  width: photo.width,
                }
              }
                source={{uri: photo && photo.url}}
                />
            </View>
            );
        }
        else {
            return (<View></View>);
        }
    }
});

var Info = React.createClass({
    propTypes: {
        user: React.PropTypes.object.isRequired,
    },

    getInitialState: function(){
        return {
            info: null,
        };
    },

    componentWillMount: function(){
        var _this = this;
        var user = this.props.user;
        var api = `https://graph.facebook.com/v2.3/${user.userId}?fields=name,email&access_token=${user.token}`;

        fetch(api)
        .then((response) => response.json())
        .then((responseData) => {
            _this.setState({
                info : {
                    name : responseData.name,
                    email: responseData.email,
                },
            });
        })
        .done();
    },

    render: function(){
        var info = this.state.info;

        return (
        <View style={styles.bottomBump}>
            <Text>{ info && info.name }</Text>
        </View>
        );
    }
});


var styles = StyleSheet.create({
    container: {
        flex:1
    },
    loginButton: {
        flex:1
    }
});