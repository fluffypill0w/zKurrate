import React, {Fragment} from 'react';
import {Route} from 'react-router-dom';

// Review Form

import ReviewFormAdded from './ReviewFormAdded';

// Layout

import AppHeader from '../../Layout/AppHeader/';
import AppSidebar from '../../Layout/AppSidebar/';
import AppFooter from '../../Layout/AppFooter/';

const ReviewAdded = ({match}) => (
    <Fragment>
        <AppHeader/>
        <div className="app-main">
            <AppSidebar/>
            <div className="app-main__outer">
                <div className="app-main__inner">

                    {/* Review Added */}

                    <Route path={`${match.url}`} component={ReviewFormAdded}/>
                </div>
                <AppFooter/>
            </div>
        </div>
    </Fragment>
);

export default ReviewAdded;