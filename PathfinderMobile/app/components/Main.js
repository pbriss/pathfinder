'use strict';

import React from 'react-native';
import Parse from 'parse/react-native';
import { Router, Route, Schema, Animations } from 'react-native-router-flux';

const{
Component,
Navigator,
AppRegistry,
StyleSheet,
StatusBarIOS
} = React;

//Views
import Home from './Home';
import Settings from './Settings';
import Search from './Search';
import CreatePath from './CreatePath';

export default class Main extends Component {

    componentWillMount() {
        Parse.initialize(
            'kvOdHosvHnOVJVhTrRjb67YxqQnrhDjkPkeGMJsj',
            'IKUaHBuYMvcqNOuaKbyZI1Q7zbjou1qLUDDbaVzq'
        );
    }
    render() {
        return(
            <Router initialRoutes={['home']} showNavigationBar={false}>
                <Schema name="modal" sceneConfig={Navigator.SceneConfigs.FloatFromBottom}/>
                <Schema name="default" sceneConfig={Navigator.SceneConfigs.FloatFromRight}/>
                <Schema name="withoutAnimation"/>

                <Route name="home" component={Home} />
                <Route name="settings" component={Settings} schema="modal"/>
                <Route name="search" component={Search} schema="modal" />
                <Route name="createpath" component={CreatePath} />
            </Router>

        );
    }
};