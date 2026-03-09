-- =========================================================
-- Trade workflow examples
-- =========================================================

-- 1. Create a trade request
-- User 1 offers card 2 to User 2 in exchange for card 5
INSERT INTO trades (sender_id, receiver_id, offered_card_id, requested_card_id, status)
VALUES (1, 2, 2, 5, 'pending');


-- 2. View all pending trades for a user
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
WHERE t.receiver_id = 2
  AND t.status = 'pending';


-- 3. Accept a trade
UPDATE trades
SET status = 'accepted'
WHERE trade_id = 1
  AND status = 'pending';


-- 4. Reject a trade
UPDATE trades
SET status = 'rejected'
WHERE trade_id = 1
  AND status = 'pending';


-- 5. Transfer ownership after trade acceptance
-- This assumes each user already owns the card being traded.

-- Move offered card from sender to receiver
UPDATE cardsToUsers
SET user_id = 2
WHERE user_id = 1
  AND card_id = 2;

-- Move requested card from receiver to sender
UPDATE cardsToUsers
SET user_id = 1
WHERE user_id = 2
  AND card_id = 5;


-- 6. Wrap trade acceptance + ownership transfer in a transaction
BEGIN;

UPDATE trades
SET status = 'accepted'
WHERE trade_id = 1
  AND status = 'pending';

UPDATE cardsToUsers
SET user_id = 2
WHERE user_id = 1
  AND card_id = 2;

UPDATE cardsToUsers
SET user_id = 1
WHERE user_id = 2
  AND card_id = 5;

COMMIT;


-- 7. Safety check: confirm both users own the cards before accepting
SELECT *
FROM cardsToUsers
WHERE (user_id = 1 AND card_id = 2)
   OR (user_id = 2 AND card_id = 5);


-- 8. Cancel a trade request
UPDATE trades
SET status = 'cancelled'
WHERE trade_id = 1
  AND sender_id = 1
  AND status = 'pending';
