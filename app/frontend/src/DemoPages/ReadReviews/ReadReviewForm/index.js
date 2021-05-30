import React, {Fragment} from 'react';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import {
    Col, Card, CardBody,
    CardTitle, Button, Form, FormGroup, Label, Input, FormText
} from 'reactstrap';

export default class ReadReviewForm extends React.Component {
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
                            <CardTitle>Search reviews</CardTitle>
                            <Form>
                                <FormGroup row>
                                    <Label for="employerName" sm={2}>Employer name</Label>
                                    <Col sm={10}>
                                        <Input type="text" name="employerName" id="employerName"
                                               placeholder="Search the employer name exactly as it appears on bank statements."/>
                                    </Col>
                                </FormGroup>
                                <FormGroup check row>
                                    <Col sm={{size: 30, offset: 0}}>
                                    <Button className="mb-2 mr-2 btn-hover-shine" color="primary">Search</Button>
                                    </Col>
                                </FormGroup>
                            </Form>
                        </CardBody>
                    </Card>
                </ReactCSSTransitionGroup>
            </Fragment>
        );
    }
}
