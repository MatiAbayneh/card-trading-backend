-- Drop tables in dependency order if they already exist
DROP TABLE IF EXISTS battle_logs;
DROP TABLE IF EXISTS trades;
DROP TABLE IF EXISTS userToDecks;
DROP TABLE IF EXISTS decks;
DROP TABLE IF EXISTS cardsToUsers;
DROP TABLE IF EXISTS cards;
DROP TABLE IF EXISTS users;

-- Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cards table
CREATE TABLE cards (
    card_id SERIAL PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    team VARCHAR(100),
    rarity VARCHAR(30) NOT NULL,
    overall_rating INT CHECK (overall_rating BETWEEN 0 AND 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Junction table mapping cards to users
CREATE TABLE cardsToUsers (
    card_instance_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    card_id INT NOT NULL,
    quantity INT DEFAULT 1 CHECK (quantity >= 0),
    acquired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (card_id) REFERENCES cards(card_id) ON DELETE CASCADE,
    UNIQUE (user_id, card_id)
);

-- Decks table
CREATE TABLE decks (
    deck_id SERIAL PRIMARY KEY,
    deck_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Junction table mapping users to decks
CREATE TABLE userToDecks (
    user_deck_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    deck_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (deck_id) REFERENCES decks(deck_id) ON DELETE CASCADE,
    UNIQUE (user_id, deck_id)
);

-- Trades table
CREATE TABLE trades (
    trade_id SERIAL PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    offered_card_id INT NOT NULL,
    requested_card_id INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'accepted', 'rejected', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (offered_card_id) REFERENCES cards(card_id) ON DELETE CASCADE,
    FOREIGN KEY (requested_card_id) REFERENCES cards(card_id) ON DELETE CASCADE
);

-- Battle logs table
CREATE TABLE battle_logs (
    battle_id SERIAL PRIMARY KEY,
    user_one_id INT NOT NULL,
    user_two_id INT NOT NULL,
    winner_id INT,
    battle_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_one_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (user_two_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (winner_id) REFERENCES users(user_id) ON DELETE SET NULL
);
