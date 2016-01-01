'use strict';

import React from 'react-native';
import { Icon } from 'react-native-icons';
import NavigationBar from 'react-native-navbar';

const {
Component,
StyleSheet,
Text,
View,
} = React;

export default class Login extends Component {

    render() {

        return (
        <View style={styles.container}>
            <Text>Login</Text>
        </View>
        );
    }
};

var styles = StyleSheet.create({
    container: {
        flex:1
    }


});