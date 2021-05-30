import {BrowserRouter as Router, Route, Redirect} from 'react-router-dom';
import React, {Suspense, lazy, Fragment} from 'react';

import {
    ToastContainer,
} from 'react-toastify';

const AddReview = lazy(() => import('../../DemoPages/AddReview'));
const ReadReviews = lazy(() => import('../../DemoPages/ReadReviews'));
const SiteHome = lazy(() => import('../../DemoPages/SiteHome'));
const ReviewAdded = lazy(() => import('../../DemoPages/ReviewAdded'));
const ReturnResults = lazy(() => import('../../DemoPages/ReturnResults'));

const AppMain = () => {

    return (
        <Fragment>

            {/* Add a review */}

            <Suspense fallback={
                <div className="loader-container">
                    <div className="loader-container-inner">
                        <h6 className="mt-5">
                            Please wait while we load all the Components examples
                            <small>Because this is a demonstration we load at once all the Components examples. This wouldn't happen in a real live app!</small>
                        </h6>
                    </div>
                </div>
            }>
                <Route path="/add-a-review" component={AddReview}/>
            </Suspense>

            {/* Review Added */}

            <Suspense fallback={
                <div className="loader-container">
                    <div className="loader-container-inner">
                        <h6 className="mt-5">
                            Please wait while we load all the Components examples
                            <small>Because this is a demonstration we load at once all the Components examples. This wouldn't happen in a real live app!</small>
                        </h6>
                    </div>
                </div>
            }>
                <Route path="/review-added" component={ReviewAdded}/>
            </Suspense>

            {/* Read reviews */}

            <Suspense fallback={
                <div className="loader-container">
                    <div className="loader-container-inner">
                        <h6 className="mt-5">
                            Please wait while we load all the Components examples
                            <small>Because this is a demonstration we load at once all the Components examples. This wouldn't happen in a real live app!</small>
                        </h6>
                    </div>
                </div>
            }>
                <Route path="/read-reviews" component={ReadReviews}/>
            </Suspense>

            {/* Search results */}

            <Suspense fallback={
                <div className="loader-container">
                    <div className="loader-container-inner">
                        <h6 className="mt-5">
                            Please wait while we load all the Components examples
                            <small>Because this is a demonstration we load at once all the Components examples. This wouldn't happen in a real live app!</small>
                        </h6>
                    </div>
                </div>
            }>
                <Route path="/return-search" component={ReturnResults}/>
            </Suspense> 

            {/* Home */}

            <Suspense fallback={
                <div className="loader-container">
                    <div className="loader-container-inner">
                        <h6 className="mt-3">
                            Please wait while we load all the Dashboard Widgets examples
                            <small>Because this is a demonstration we load at once all the Dashboard Widgets examples. This wouldn't happen in a real live app!</small>
                        </h6>
                    </div>
                </div>
            }>
                <Route path="/home" component={SiteHome}/>
            </Suspense>

            <Route exact path="/" render={() => (
                <Redirect to="/home"/>
            )}/>
            <ToastContainer/>
        </Fragment>
    )
};

export default AppMain;