import React, {Fragment} from 'react';
import {Route} from 'react-router-dom';

// Search Results

import SearchResults from './SearchResults';

// Layout

import AppHeader from '../../Layout/AppHeader';
import AppSidebar from '../../Layout/AppSidebar';
import AppFooter from '../../Layout/AppFooter';

const Search = ({match}) => (
    <Fragment>
        <AppHeader/>
        <div className="app-main">
            <AppSidebar/>
            <div className="app-main__outer">
                <div className="app-main__inner">

                    {/* Return search results */}

                    <Route path={`${match.url}`} component={SearchResults}/>
                </div>
                <AppFooter/>
            </div>
        </div>
    </Fragment>
);

export default Search;