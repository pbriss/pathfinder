'use strict';

import React from 'react-native';
import Parse from 'parse/react-native';
import { Icon } from 'react-native-icons';
import { Actions } from 'react-native-router-flux';
import Swiper from 'react-native-swiper';
import NavigationBar from 'react-native-navbar';
import BackButton from './shared/navbar/BackButton';
import TitleLabel from './shared/navbar/TitleLabel';
import { Theme, Styles } from 'app-libs';
import SettingsButton from './shared/navbar/SettingsButton';

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
            places: [],
            loaded: false,
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
                    dataSource: self.state.dataSource.cloneWithRows([0]),
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
        this.setState({
            dataSource: this.state.dataSource.cloneWithRows([0,0])
        });

    }

    render() {
        if (!this.state.loaded) {
            return this.renderLoadingView();
        }

        return (
        <View style={styles.container}>
            <NavigationBar
                title={<TitleLabel title={this.props.location.get('name')} />}
                leftButton={<BackButton />}
                rightButton={<SettingsButton />} />
            <ListView
            dataSource={this.state.dataSource}
            renderRow={this.renderRow.bind(this)}
            renderFooter={this.renderFooter.bind(this)}
            style={styles.listView}
            />
        </View>
        );
    }

    renderRow() {
        return (
        <View>
            <Swiper
            showsPagination={false}
            style={styles.rowContainer}
            height={200}
            onMomentumScrollEnd ={this._onMomentumScrollEnd}>
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
                                <Text style={[styles.label, styles.locationLabel]}>{place.get('name')}</Text>
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
                color={Theme.color.brand}
                style={styles.icon}
                />
            </View>
        </View>
        );
    }

    renderFooter() {
        return (
        <TouchableHighlight
        underlayColor={'transparent'}
        onPress={this.addRow.bind(this)}>
            <View style={styles.rowContainer}>
                <Text style={styles.locationLabel}>Add place</Text>
            </View>
        </TouchableHighlight>
        );
    }

    //
    // Swiper
    //
    _onMomentumScrollEnd(e, state, context) {
        console.log(state, context.state);
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
        height:30,
        justifyContent:'center',
        alignSelf: 'center',
    },
    icon: {
        width: 32,
        height: 32,
        backgroundColor: 'transparent'
    }
});