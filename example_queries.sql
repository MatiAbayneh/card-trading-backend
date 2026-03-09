-- =========================================================
-- Example queries for the trading card platform
-- =========================================================

-- 1. Get all users
SELECT *
FROM users;


-- 2. Get all cards
SELECT *
FROM cards;


-- 3. View a specific user's card collection
SELECT
    u.username,
    c.card_id,
    c.player_name,
    c.team,
    c.rarity,
    c.overall_rating,
    ctu.quantity
FROM cardsToUsers ctu
JOIN users u ON ctu.user_id = u.user_id
JOIN cards c ON ctu.card_id = c.card_id
WHERE u.user_id = 1;


-- 4. View all decks owned by a specific user
SELECT
    u.username,
    d.deck_id,
    d.deck_name,
    d.created_at
FROM userToDecks utd
JOIN users u ON utd.user_id = u.user_id
JOIN decks d ON utd.deck_id = d.deck_id
WHERE u.user_id = 1;


-- 5. Show all pending trades
SELECT
    t.trade_id,
    u1.username AS sender,
    u2.username AS receiver,
    c1.player_name AS offered_card,
    c2.player_name AS requested_card,
    t.status
FROM trades t
JOIN users u1 ON t.sender_id = u1.user_id
JOIN users u2 ON t.receiver_id = u2.user_id
JOIN cards c1 ON t.offered_card_id = c1.card_id
JOIN cards c2 ON t.requested_card_id = c2.card_id
WHERE t.status = 'pending';


-- 6. Show trade history for a given user
SELECT
    t.trade_id,
    u1.username AS sender,
    u2.username AS receiver,
    c1.player_name AS offered_card,
    c2.player_name AS requested_card,
    t.status,
    t.created_at
FROM trades t
JOIN users u1 ON t.sender_id = u1.user_id
JOIN users u2 ON t.receiver_id = u2.user_id
JOIN cards c1 ON t.offered_card_id = c1.card_id
JOIN cards c2 ON t.requested_card_id = c2.card_id
WHERE t.sender_id = 1
   OR t.receiver_id = 1
ORDER BY t.created_at DESC;


-- 7. Count how many cards each user owns
SELECT
    u.username,
    COALESCE(SUM(ctu.quantity), 0) AS total_cards
FROM users u
LEFT JOIN cardsToUsers ctu ON u.user_id = ctu.user_id
GROUP BY u.user_id, u.username
ORDER BY total_cards DESC;


-- 8. Find the highest-rated cards in the system
SELECT
    player_name,
    team,
    rarity,
    overall_rating
FROM cards
ORDER BY overall_rating DESC;


-- 9. Show battle history
SELECT
    b.battle_id,
    u1.username AS player_one,
    u2.username AS player_two,
    uw.username AS winner,
    b.battle_date
FROM battle_logs b
JOIN users u1 ON b.user_one_id = u1.user_id
JOIN users u2 ON b.user_two_id = u2.user_id
LEFT JOIN users uw ON b.winner_id = uw.user_id
ORDER BY b.battle_date DESC;


-- 10. Show users who own rare cards
SELECT DISTINCT
    u.username,
    c.player_name,
    c.rarity
FROM cardsToUsers ctu
JOIN users u ON ctu.user_id = u.user_id
JOIN cards c ON ctu.card_id = c.card_id
WHERE c.rarity IN ('Epic', 'Legendary')
ORDER BY u.username;
