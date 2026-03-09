INSERT INTO users (username, email) VALUES
('mati', 'mati@example.com'),
('jordan', 'jordan@example.com'),
('sam', 'sam@example.com');

INSERT INTO cards (player_name, team, rarity, overall_rating) VALUES
('LeBron James', 'Lakers', 'Legendary', 97),
('Stephen Curry', 'Warriors', 'Epic', 96),
('Jayson Tatum', 'Celtics', 'Rare', 93),
('Nikola Jokic', 'Nuggets', 'Legendary', 98),
('Anthony Edwards', 'Timberwolves', 'Epic', 91);

INSERT INTO cardsToUsers (user_id, card_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(2, 5, 1),
(3, 4, 1);

INSERT INTO decks (deck_name) VALUES
('Starter Squad'),
('Legends Lineup');

INSERT INTO userToDecks (user_id, deck_id) VALUES
(1, 1),
(2, 2);

INSERT INTO trades (sender_id, receiver_id, offered_card_id, requested_card_id, status) VALUES
(1, 2, 3, 2, 'pending');

INSERT INTO battle_logs (user_one_id, user_two_id, winner_id) VALUES
(1, 2, 2),
(2, 3, 3);
