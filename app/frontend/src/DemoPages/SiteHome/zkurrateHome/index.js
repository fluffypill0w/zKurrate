import React, {Fragment} from 'react';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import {
    Col, Card, CardBody,
    CardTitle, Button, Form, FormGroup, Label, Input, 
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
                            heading="Basic Dashboard"
                            subheading="This is an example dashboard created using build-in elements and components."
                            icon="pe-7s-car icon-gradient bg-mean-fruit"
                    />
                    <Card className="main-card mb-3">
                        <CardBody>
                            <CardTitle>Add a review</CardTitle>
                            <Form>
                                <FormGroup row>
                                    <Label for="employerName" sm={2}>Employer name</Label>
                                    <Col sm={10}>
                                        <Input type="text" name="employerName" id="employerName"
                                               placeholder="Write the employer name exactly as it appears on your bank statement."/>
                                    </Col>
                                </FormGroup>
                                <FormGroup row>
                                    <Label for="employeeName" sm={2}>Your name</Label>
                                    <Col sm={10}>
                                        <Input type="text" name="employeeName" id="employeeName"
                                               placeholder="Write your name exactly as it appears on your bank statement."/>
                                    </Col>
                                </FormGroup>
                                <FormGroup row>
                                    <Label for="bank" sm={2}>Bank</Label>
                                    <Col sm={10}>
                                        <Input type="select" name="selectBank" id="selectBank"/> 
                                    </Col>
                                </FormGroup>
                                <FormGroup row>
                                    <Label for="reviewText" sm={2}>Review</Label>
                                    <Col sm={10}>
                                        <Input type="textarea" name="reviewText" id="reviewText"/>
                                    </Col>
                                </FormGroup>
                                <FormGroup check row>
                                    <Col sm={{size: 30, offset: 0}}>
                                    <Button className="mb-2 mr-2 btn-hover-shine" color="primary">Submit</Button>
                                    </Col>
                                </FormGroup>
                            </Form>
                        </CardBody>
                    </Card>
                    </div>
                </ReactCSSTransitionGroup>
            </Fragment>
        );
    }
}
