'use strict';

import React from 'react-native';
import Parse from 'parse/react-native';
import { Icon } from 'react-native-icons';
import { Actions } from 'react-native-router-flux';
import NavigationBar from 'react-native-navbar';

//App modules
import { NavSettingsButton, NavTitleLabel } from 'app-components';
import { Theme, Styles } from 'app-libs';

const {
Component,
StyleSheet,
ActivityIndicatorIOS,
Image,
ListView,
Animated,
TouchableHighlight,
Text,
View,
} = React;

export default class Home extends Component {

    constructor(props) {
        super(props);
        this.state = {
            dataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2,
            }),
            loaded: false,
            isScrolling: false
        };
    }

    componentDidMount() {
        this.fetchData();
    }

    fetchData() {
        var query = new Parse.Query('Location').limit(10);
        var _this = this;
        query.find({
            success: function(results) {
                _this.setState({
                    dataSource: _this.state.dataSource.cloneWithRows(results),
                    loaded: true
                });
            },
            error: function(error) {
                alert("Error: " + error.code + " " + error.message);
            }
        });
    }

    onScroll(event: Object) {
        var position = event.nativeEvent.contentOffset.y;
        this.setState({
            isScrolling: position > 5
        })
    }

    render() {
        if (!this.state.loaded) {
            return this.renderLoadingView();
        }

        var collapsedButtonStyle = this.state.isScrolling ? styles.searchButtonCollapsed : [];

        return (
        <View style={styles.container}>
            <NavigationBar
            title={<NavTitleLabel title={'HappyPath'} />}
            rightButton={<NavSettingsButton />} />
            <ListView
            dataSource={this.state.dataSource}
            renderRow={this.renderRow.bind(this)}
            onScroll={this.onScroll.bind(this)}
            scrollEventThrottle={200}
            style={styles.listView}
            />
            <TouchableHighlight
            underlayColor={'transparent'}
            onPress={Actions.search}
            style={[styles.searchButtonWrapper, collapsedButtonStyle]}>
                <View style={[styles.searchButton, collapsedButtonStyle]}>
                    <Icon
                    name='fontawesome|search'
                    size={16}
                    color={Theme.color.brand}
                    style={styles.searchButtonIcon}
                    />
                    { !this.state.isScrolling ? <SearchText /> : null }
                </View>
            </TouchableHighlight>
        </View>
        );
    }

    renderRow(location) {
        const routeData = {location: location};
        return (
        <TouchableHighlight underlayColor={'transparent'} onPress={() => Actions.createpath(routeData)}>
            <View style={styles.rowContainer}>
                <Image
                source={{uri: location.get('pictures')[0].file._url}}
                style={styles.rowBackground}>
                    <Text style={styles.locationLabel}>{location.get('name')}</Text>
                </Image>
            </View>
        </TouchableHighlight>
        );
    }

    renderLoadingView() {
        return (
        <View style={[styles.container, styles.loadingContainer]}>
            <ActivityIndicatorIOS
            animating={!this.state.loaded}
            style={[styles.centering, {height: 80}]}
            size="large"
            />
            <Text>Getting locations...</Text>
        </View>
        );
    }
};

class SearchText extends Component {
    render() {
        return <Text style={styles.searchButtonText}>Where are you going?</Text>
    }
};


var styles = StyleSheet.create({
    container: {
        ...Styles.defaults.container
    },
    loadingContainer: {
        alignItems: 'center',
        justifyContent: 'center',
    },
    searchButtonWrapper: {
        position:'absolute',
        top:80,
        left:20,
        right: 20
    },
    searchButton: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        shadowColor: '#000',
        shadowOffset: {width:0, height:0},
        shadowOpacity: 0.2,
        shadowRadius: 2,
        borderRadius: 2,
        height:50,
        padding:5,
        backgroundColor: 'white',
    },
    searchButtonIcon: {
        flex:0.1,
        width: 16,
        height: 16
    },
    searchButtonText: {
        ...Styles.defaults.label,
        flex:0.9,
        color: '#58595D',
        opacity: 0.6
    },
    listView: {
        flex:1
    },
    rowContainer: {
        flex: 1,
        height:200
    },
    rowBackground: {
        flex: 1,
        justifyContent:'center'
    },
    locationLabel: {
        ...Styles.defaults.label,
        fontSize: 20,
        alignSelf: 'center',
        marginTop: 10,
        backgroundColor: 'transparent',
        color: 'white',
        shadowColor: '#000',
        shadowOffset: {width:0, height:0},
        shadowOpacity: 0.9,
        shadowRadius: 3
    },

    //On scroll
    searchButtonCollapsed: {
        width:50,
        borderRadius: 25,
    }
});