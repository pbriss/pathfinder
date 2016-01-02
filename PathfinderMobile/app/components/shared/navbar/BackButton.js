'use strict';

import React from 'react-native';
import { Icon } from 'react-native-icons';
import { Actions } from 'react-native-router-flux';
import { Theme } from 'app-libs';

const {
Component,
StyleSheet,
TouchableHighlight
} = React;

export default class BackButton extends Component{
    render() {
        return (
            <TouchableHighlight underlayColor={'transparent'} onPress={Actions.pop}>
                <Icon
                    name='fontawesome|arrow-left'
                    size={20}
                    color={Theme.color.brand}
                    style={styles.icon}
                />
            </TouchableHighlight>
        );
    }
};

const styles = StyleSheet.create({
    icon: {
        width: 20,
        height: 20,
        marginLeft: 10
    }
});