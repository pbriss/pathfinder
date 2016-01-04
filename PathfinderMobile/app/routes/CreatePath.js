'use strict';

import React from 'react-native';
import Parse from 'parse/react-native';
import { Icon } from 'react-native-icons';
import { Actions } from 'react-native-router-flux';
import Swiper from 'react-native-swiper';
import NavigationBar from 'react-native-navbar';

//App modules
import { NavBackButton, NavSettingsButton, NavTitleLabel } from 'app-components';
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

export default class CreatePath extends Component {

    constructor(props) {
        super(props);
        this.state = {
            dataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2,
            }),
            bounceValue: new Animated.Value(1),
            rows: [0],
            places: [],
            loaded: false,
            isScrolling: false,
        };
    }


    componentDidMount() {
        this.fetchPlaces();
    }

    fetchPlaces() {
        var query = new Parse.Query('Place');
        query.exists('pictures');
        query.equalTo('location', this.props.location);
        query.limit(10);
        var self = this;
        query.find({
            success: function(results) {
                self.setState({
                    dataSource: self.state.dataSource.cloneWithRows(self.state.rows),
                    places: results,
                    loaded: true
                });
            },
            error: function(error) {
                alert("Error: " + error.code + " " + error.message);
            }
        });
    }

    addRow() {
        var newArray = this.state.rows;
        newArray.push(this.state.rows.length);
        this.setState({
            dataSource: this.state.dataSource.cloneWithRows(newArray)
        });

        this.state.bounceValue.setValue(0.8);
        Animated.spring(
        this.state.bounceValue,
        {
            toValue: 1,
            friction: 1,
        }
        ).start();

    }

    render() {
        if (!this.state.loaded) {
            return this.renderLoadingView();
        }

        return (
        <View style={styles.container}>
            <NavigationBar
                title={<NavTitleLabel title={this.props.location.get('name')} />}
                leftButton={<NavBackButton />}
                rightButton={<NavSettingsButton />} />
            <ListView
            dataSource={this.state.dataSource}
            renderRow={this.renderRow.bind(this)}
            renderFooter={this.renderFooter.bind(this)}
            style={styles.listView}
            />
        </View>
        );
    }

    getRowAnimation() {
        return {
            transform: [{
                scale: this.state.bounceValue
            }]
        };
    }

    renderRow() {
        return (
        <Animated.View style={this.getRowAnimation()}>
            <Swiper
            showsPagination={false}
            style={styles.rowContainer}
            height={200}
            onMomentumScrollEnd={this._onMomentumScrollEnd.bind(this)}>
                {this.state.places.map(function(place, i){
                    return (
                    <TouchableHighlight
                    underlayColor={'transparent'}
                    onPress={() => console.log(place.get('name'))}
                    key={i}>
                        <View style={styles.rowContainer}>
                            <Image
                            source={{uri: place.get('pictures')[0].file._url}}
                            style={styles.rowBackground}>
                                <Text style={styles.locationLabel}>{place.get('name')}</Text>
                            </Image>
                        </View>
                    </TouchableHighlight>
                    );
                })}
            </Swiper>
            <View style={styles.separatorContainer}>
                <Icon
                name='fontawesome|code-fork'
                size={32}
                color={this.state.isScrolling ? '#222' : Theme.color.brand}
                style={[styles.icon, this.state.isScrolling ? styles.searchButtonCollapsed : []]}
                />
            </View>
        </Animated.View>
        );
    }

    renderFooter() {
        return (
        <TouchableHighlight
        underlayColor={'transparent'}
        onPress={this.addRow.bind(this)}>
            <View style={styles.addRowContainer}>
                <Text style={styles.addLabel}>Add place to your path</Text>
            </View>
        </TouchableHighlight>
        );
    }

    //
    // Swiper
    //
    _onMomentumScrollBegin(e, state, context) {
        this.setState({
            isScrolling: true
        });
    }
    _onMomentumScrollEnd(e, state, context) {
        this.setState({
            isScrolling: state.isScrolling
        });
    }


    //
    // Loading
    //
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

var styles = StyleSheet.create({
    container: {
        ...Styles.defaults.container,
    },
    loadingContainer: {
        alignItems: 'center',
        justifyContent: 'center',
    },
    listView: {
        flex: 1,
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
    separatorContainer: {
        flex: 1,
        height:25,
        justifyContent:'center',
        alignSelf: 'center',
    },
    icon: {
        width: 32,
        height: 32,
        backgroundColor: 'transparent'
    },

    //Footer
    addRowContainer: {
        height:100,
        alignItems: 'center',
        justifyContent: 'center',
        borderWidth: 2,
        borderColor: Theme.color.brand
    },
    addLabel: {
        ...Styles.defaults.label,
        fontSize: 14,
        color: Theme.color.brand,
    },

});