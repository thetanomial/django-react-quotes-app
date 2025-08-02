import React, { useState, useEffect } from 'react';
import './App.css';
import QuoteDisplay from './components/QuoteDisplay';

function App() {
  const [currentQuote, setCurrentQuote] = useState(null);
  const [connectionStatus, setConnectionStatus] = useState('Connecting...');
  const [socket, setSocket] = useState(null);

  useEffect(() => {
    const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const wsUrl = `${wsProtocol}//${window.location.hostname}/ws/quotes/`;
    
    const newSocket = new WebSocket(wsUrl);

    newSocket.onopen = () => {
      console.log('WebSocket connected');
      setConnectionStatus('Connected');
    };

    newSocket.onmessage = (event) => {
      const data = JSON.parse(event.data);
      if (data.type === 'quote' && data.data) {
        setCurrentQuote(data.data);
      }
    };

    newSocket.onclose = () => {
      console.log('WebSocket disconnected');
      setConnectionStatus('Disconnected');
    };

    newSocket.onerror = (error) => {
      console.error('WebSocket error:', error);
      setConnectionStatus('Error');
    };

    setSocket(newSocket);

    return () => {
      newSocket.close();
    };
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Live Quotes</h1>
        <div className="connection-status">
          Status: <span className={`status ${connectionStatus.toLowerCase()}`}>
            {connectionStatus}
          </span>
        </div>
      </header>
      <main>
        <QuoteDisplay quote={currentQuote} />
      </main>
    </div>
  );
}

export default App;