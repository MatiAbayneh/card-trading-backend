# Card Trading Backend

Backend data model for a digital trading card platform.

Users can collect cards, create decks, and trade with other players.

## System Design

The relational schema supports:

- card ownership tracking
- deck construction
- trade request workflow
- battle log history

## Tables

- users
- cards
- cardsToUsers
- decks
- userToDecks
- trades
- battle_logs

## Tech Stack

PostgreSQL  
TypeScript  
Node.js
