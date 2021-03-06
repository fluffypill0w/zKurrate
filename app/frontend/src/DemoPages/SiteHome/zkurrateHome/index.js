import React, {Fragment} from 'react';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import {
    Col, Card, CardBody,
    CardTitle, Button, Form, FormGroup, Label, Input 
} from 'reactstrap';

import PageTitle from '../../../Layout/AppMain/PageTitle';

export default class SiteHome extends React.Component {
    render() {
        return (
            <Fragment>
                <ReactCSSTransitionGroup
                    component="div"
                    transitionName="TabsAnimation"
                    transitionAppear={true}
                    transitionAppearTimeout={0}
                    transitionEnter={false}
                    transitionLeave={false}>
                    <div>
                    <PageTitle
                            heading="zKurrate"
                            subheading="A dapp for anonymously reviewing employers which proves that all reviewers have been paid by the companies that they review."
                            icon="pe-7s-comment icon-gradient bg-mean-fruit"
                    />
                    </div>
                </ReactCSSTransitionGroup>
            </Fragment>
        );
    }
}
