'use strict';

import React from 'react-native';
import Parse from 'parse/react-native';
import { Icon } from 'react-native-icons';
import { Actions } from 'react-native-router-flux';
import NavigationBar from 'react-native-navbar';
import { Theme, Styles } from 'app-libs';

const {
Component,
StyleSheet,
Text,
View,
StatusBarIOS,
TextInput,
ListView,
TouchableHighlight,
Image,
} = React;


export default class Search extends Component {

    constructor(props) {
        super(props);
        this.state = {
            dataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2,
            }),
            isSearching: false,
            searchQuery: 'Where are you going?'
        };
    }

    performSearch(text) {
        this.setState({searchQuery: text});

        if (text.length > 2) {
            this.fetchData();
        }
        else {
            this.setState({
                dataSource: this.state.dataSource.cloneWithRows([])
            });
        }
    }

    fetchData() {
        var query = new Parse.Query('Location');
        query.startsWith('name', this.state.searchQuery);
        query.limit(10);
        var self = this;
        query.find({
            success: function(results) {
                self.setState({
                    dataSource: self.state.dataSource.cloneWithRows(results)
                });
            },
            error: function(error) {
                alert("Error: " + error.code + " " + error.message);
            }
        });
    }

    render() {
        return (
        <View style={styles.container}>
            <View style={styles.searchWrapper}>
                <TextInput
                style={styles.searchInput}
                autoCorrect={false}
                autoFocus={true}
                clearButtonMode={'while-editing'}
                placeholder={this.state.searchQuery}
                onChangeText={this.performSearch.bind(this)}
                ></TextInput>
                <TouchableHighlight style={styles.searchCancelWrapper} underlayColor={'transparent'} onPress={Actions.pop}>
                    <Text style={styles.searchCancel}>Cancel</Text>
                </TouchableHighlight>
            </View>
            <ListView
            dataSource={this.state.dataSource}
            renderRow={this.renderRow.bind(this)}
            style={styles.searchResults}
            ></ListView>
        </View>
        );
    }

    renderRow(location) {
        const routeData = {location: location};
        return (
        <TouchableHighlight
        style={styles.resultRow}
        underlayColor={'transparent'}
        onPress={() => Actions.createpath(routeData)}>
            <View style={styles.resultContainer}>
                <Image
                source={{uri: location.get('pictures')[0].file._url}}
                style={styles.resultImage} />
                <View style={styles.resultTextContainer}>
                    <Text style={styles.resultTitle}>{location.get('name')}</Text>
                </View>
            </View>
        </TouchableHighlight>
        );
    }
};

var styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5FCFF',
        marginTop: 20
    },
    searchWrapper: {
        height: 60,
        flexDirection: 'row',
        backgroundColor: '#fff',
        borderBottomWidth: 1,
        borderBottomColor: '#ddd'
    },
    searchInput: {
        ...Styles.defaults.label,
        flex: 0.8,
        color: Theme.color.brand,
        paddingLeft: 20
    },
    searchCancelWrapper: {
        flex: 0.2,
        alignItems: 'center',
        justifyContent: 'center',
    },
    searchCancel: {
        color: Theme.color.brand
    },
    searchResults: {
        flex:1
    },
    resultRow: {
        flex: 1,
        justifyContent: 'center',
        height: 70,
        marginLeft: 15,
        borderBottomWidth: 1,
        borderBottomColor: '#eee'
    },
    resultContainer: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    resultImage: {
        width: 50,
        height: 50,
        borderRadius: 25
    },
    resultTextContainer: {
        flex: 1,
    },
    resultTitle: {
        ...Styles.defaults.label,
        marginLeft: 12,
        fontSize: 16
    }

});