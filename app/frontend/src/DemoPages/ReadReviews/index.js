import React, {Fragment} from 'react';
import {Route} from 'react-router-dom';

// Review Form

import ReadReviewForm from './ReadReviewForm';

// Layout

import AppHeader from '../../Layout/AppHeader/';
import AppSidebar from '../../Layout/AppSidebar/';
import AppFooter from '../../Layout/AppFooter/';

const Reviews = ({match}) => (
    <Fragment>
        <AppHeader/>
        <div className="app-main">
            <AppSidebar/>
            <div className="app-main__outer">
                <div className="app-main__inner">

                    {/* Reviews */}

                    <Route path={`${match.url}/form`} component={ReadReviewForm}/>
                </div>
                <AppFooter/>
            </div>
        </div>
    </Fragment>
);

export default Reviews;