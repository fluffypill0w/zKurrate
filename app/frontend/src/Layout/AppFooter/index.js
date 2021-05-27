import React, {Fragment} from 'react';

class AppFooter extends React.Component {
    render() {


        return (
            <Fragment>
                <div className="app-footer">
                    <div className="app-footer__inner">
                        <div className="app-footer-left">
                            <ul className="nav">
                                <li className="nav-item">
                                <a href="https://gitcoin.co/hackathon/0x-hack/projects/5359/zkurrate" className="nav-link">
-                                        Made with love and kittens for gitcoin's 0xHack hackathon
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </Fragment>
        )}
}

export default AppFooter;