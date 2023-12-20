import React from 'react';
import Navbar from './components/Navbar';
import './App.css';
import Home from './components/pages/Home';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import Data from './components/pages/Data';
import Reports from './components/pages/Reports';
import Essays from './components/pages/Essays';
import About from './components/pages/About';
import SignUp from './components/pages/SignUp';

function App() {
  return (
    <>
      <Router>
        <Navbar />
        <Switch>
          <Route path='/' exact component={Home} />
          <Route path='/data' component={Data} />
          <Route path='/reports' component={Reports} />
          <Route path='/essays' component={Essays} />
          <Route path='/about' component={About} />
          <Route path='/sign-up' component={SignUp} />
        </Switch>
      </Router>
    </>
  );
}

export default App;
