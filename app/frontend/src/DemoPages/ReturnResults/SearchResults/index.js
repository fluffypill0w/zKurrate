import React, {Fragment} from 'react';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import {
    Card, CardBody, CardTitle, CardText
} from 'reactstrap';

export default class SearchResults extends React.Component {
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
                    <Card className="main-card mb-3">
                        <CardBody>
                            <CardTitle>Results for Evil Corps</CardTitle>   
                        </CardBody>
                    </Card>
                    <Card className="main-card mb-3">
                        <CardBody>
                        <CardText>Evil Corps is a fantastic employer. They offer competitive salaries and great benefits, plus a stimulating work environment. Long live Evil Corps :)</CardText> 
                        </CardBody>
                    </Card>
                    <Card className="main-card mb-3">
                        <CardBody>
                            <CardText>Evil Corps rules! Evil Corps forever! A hundred years Evil Corps!</CardText>   
                        </CardBody>
                    </Card>
                </ReactCSSTransitionGroup>
            </Fragment>
        );
    }
}