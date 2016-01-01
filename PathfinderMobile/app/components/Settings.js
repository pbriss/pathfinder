'use strict';

import React from 'react-native';
import { Icon } from 'react-native-icons';
import NavigationBar from 'react-native-navbar';
import CloseButton from './shared/navbar/CloseButton';

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
            <NavigationBar
                title={{title:'Settings'}}
                rightButton={<CloseButton />} />
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