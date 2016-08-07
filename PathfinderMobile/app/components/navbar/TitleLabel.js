'use strict';

import React from 'react-native';
import { Theme, Styles } from 'app-libs';

const {
PropTypes,
Component,
StyleSheet,
Text
} = React;

export default class NavTitleLabel extends Component{

    static propTypes = {
        title: PropTypes.string
    };

    render() {
        return (
                <Text
                    color={Theme.color.brand}
                    style={styles.label}>
                    {this.props.title}
                </Text>
        );
    }
};

const styles = StyleSheet.create({
    label: {
        ...Styles.defaults.label
    }
});
