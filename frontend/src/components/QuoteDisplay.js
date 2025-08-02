import React from 'react';
import './QuoteDisplay.css';

const QuoteDisplay = ({ quote }) => {
  if (!quote) {
    return (
      <div className="quote-container">
        <div className="quote-placeholder">
          <div className="loading-spinner"></div>
          <p>Waiting for quotes...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="quote-container">
      <div className="quote-card">
        <blockquote className="quote-text">
          "{quote.text}"
        </blockquote>
        <cite className="quote-author">
          — {quote.author}
        </cite>
        <div className="quote-timestamp">
          Received: {new Date().toLocaleTimeString()}
        </div>
      </div>
    </div>
  );
};

export default QuoteDisplay;