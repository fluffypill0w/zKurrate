import React, {Fragment} from 'react';
import {Route} from 'react-router-dom';

// Home

import SiteHome from './zkurrateHome';

// Layout

import AppHeader from '../../Layout/AppHeader';
import AppSidebar from '../../Layout/AppSidebar';
import AppFooter from '../../Layout/AppFooter';

const ZkurrateHome = ({match}) => (
    <Fragment>
        <AppHeader/>
        <div className="app-main">
            <AppSidebar/>
            <div className="app-main__outer">
                <div className="app-main__inner">

                    {/* Home */}

                    <Route path={`${match.url}`} component={SiteHome}/>
                </div>
                <AppFooter/>
            </div>
        </div>
    </Fragment>
);

export default ZkurrateHome;