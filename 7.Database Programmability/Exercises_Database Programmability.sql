--01.User-defined Function Full Name
CREATE or REPLACE FUNCTION fn_full_name(first_name varchar, last_name varchar)
RETURNS varchar 
AS
$$
	DECLARE 
	full_name varchar;
	BEGIN
		full_name := concat(INITCAP(first_name), ' ', INITCAP(last_name));
		return full_name;
	END;
$$
LANGUAGE plpgsql;


--02.User-defined Function Future Value
CREATE or REPLACE FUNCTION fn_calculate_future_value(
	initial_sum decimal,
	yearly_interest_rate decimal,
	number_of_years int
)
RETURNS decimal 
AS
$$
	DECLARE 
	output decimal;
	output1 decimal;
	BEGIN
		output := initial_sum * power(1 + yearly_interest_rate, number_of_years);
		output1 := trunc(output, 4);
	return output1;
	END;
$$
LANGUAGE plpgsql;

SELECT * FROM fn_calculate_future_value (1000, 0.1, 5)

--03.User-defined Function Is Word Comprised
CREATE or REPLACE FUNCTION fn_is_word_comprised(
	set_of_letters varchar(50),
	word varchar(50)
)
RETURNS boolean 
AS
$$
	BEGIN
		RETURN trim(lower(word), lower(set_of_letters)) = '';
	END;
$$
LANGUAGE plpgsql;


SELECT * FROM fn_is_word_comprised('aebc', 'cba');


--04.Game Over
CREATE or REPLACE FUNCTION difficulty_level(
	is_game_over boolean
)
RETURNS table(name varchar, game_type_id int, is_finished boolean) 
AS
$$
	BEGIN
		RETURN query 
		select 
			g.name,
			g.game_type_id,
			g.is_finished
		from games as g
		where g.is_finished = is_game_over;
	
	END;
$$
LANGUAGE plpgsql;

select *from fn_is_game_over(false);
	
select 
	name,
	game_type_id,
	is_finished
from games
where is_finished = true


--05.Difficulty Level
CREATE or REPLACE FUNCTION fn_difficulty_level(level int)
RETURNS varchar
AS
$$
DECLARE diff_level varchar;

	BEGIN
		if level <= 40 THEN
			diff_level :=  'Normal Difficulty';
		elseif level BETWEEN 41 and 60 THEN
			diff_level :=  'Nightmare Difficulty';
		else
			diff_level :=  'Hell Difficulty';
		end if;
		RETURN diff_level;
	END;
$$
LANGUAGE plpgsql;

select 
	user_id,
	level,
	cash,
	fn_difficulty_level(level)
from users_games
order by user_id asc;


--*06.Cash in User Games Odd Rows
CREATE OR REPLACE FUNCTION fn_cash_in_users_games(game_name VARCHAR (50))
RETURNS TABLE (total_cash NUMERIC)
AS
$$
BEGIN
	RETURN QUERY
	WITH ranked_games AS(
		SELECT
			cash,
			ROW_NUMBER() OVER (ORDER BY cash DESC) as row_num
		FROM
		users_games as ug
		JOIN games as g
		ON ug.game_id = g.id
		WHERE g.name = game_name
	)
	SELECT
		ROUND(SUM(cash), 2) AS total_cash
	FROM	
		ranked_games
	WHERE row_num % 2 <> 0;
END;
$$
LANGUAGE plpgsql;

SELECT * from fn_cash_in_users_games('Love in a mist')


--07.Retrieving Account Holders****

CREATE OR REPLACE PROCEDURE 
	sp_retrieving_holders_with_balance_higher_than(
		searched_balance NUMERIC)
AS
$$
DECLARE
	holder_info RECORD;
BEGIN
	FOR holder_info IN 
		SELECT
			first_name || ' ' || last_name AS full_name,
			SUM(balance) AS total_balance
		FROM account_holders AS ah
		JOIN accounts AS a
		ON ah.id = a.account_holder_id
		GROUP BY full_name 
		HAVING SUM(balance) > searched_balance
		ORDER BY full_name ASC
	LOOP
		RAISE NOTICE '% - %', holder_info.full_name, holder_info.total_balance;
	END LOOP;
END;
$$
LANGUAGE plpgsql;

CALL sp_retrieving_holders_with_balance_higher_than(20000)


--08.Deposit Money
create or replace procedure sp_deposit_money(
	account id int,
	money_amount NUMERIC()
)
AS
$$
BEGIN
	update accounts
	SET 
	balance = balance + money_amount
	where 
	id = account_id;
	
END;
$$
LANGUAGE plpgsql;


CALL sp_deposit_money(1,200)
select * from accounts 
where id = 1


--09.Withdraw Money
CREATE OR REPLACE PROCEDURE sp_withdraw_money(
		account_id INT,
		money_amount NUMERIC(10, 4))
AS
$$
DECLARE current_balance NUMERIC;
BEGIN
	current_balance := (SELECT balance FROM accounts WHERE id=account_id);
	IF (current_balance -money_amount) > 0 THEN
		UPDATE accounts
		SET balance = balance - money_amount
		WHERE id = account_id;
	ELSE
		RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
	END IF;	
END;
$$
LANGUAGE plpgsql;

CALL sp_withdraw_money(3, 5050.7500);
SELECT * FROM accounts WHERE id = 3

--10.Money Transfer
CREATE OR REPLACE PROCEDURE sp_transfer_money(
		sender_id INT,
		receiver_id INT,
		amount NUMERIC)
AS
$$
DECLARE 
	current_balance NUMERIC;
BEGIN
	CALL sp_withdraw_money(sender_id, amount);
	CALL sp_deposit_money(receiver_id, amount);
	SELECT balance INTO current_balance FROM accounts WHERE id = sender_id;
	--current_balance := (SELECT balance FROM accounts WHERE id = sender_id;)
	IF (current_balance < 0) THEN
		ROLLBACK;
	END IF;
END;
$$
LANGUAGE plpgsql;

CALL sp_transfer_money(5, 1, 5000.0000);

SELECT * FROM accounts WHERE id = 1

--11.Delete Procedure
DROP PROCEDURE sp_retrieving_holders_with_balance_higher_than;

--12.Log Accounts Trigger
CREATE TABLE logs(
	id SERIAL PRIMARY KEY,
	account_id INT,
	old_sum NUMERIC(20,4),
	new_sum NUMERIC(20,4)
);

CREATE OR REPLACE FUNCTION trigger_fn_insert_new_entry_into_logs()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO logs(account_id, old_sum, new_sum)
	VALUES (old.id, old.balance, new.balance);
	
	RETURN NEW ; --кагато искаме да върнем новия запис, имаме BEFORE
	--RETURN OLD - когато искаме да изтрием нещо
	--RETURN NULL - когато сме имали валидация и тя не е ъпдейтнала нищо
	
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_account_balance_change
AFTER UPDATE OF balance ON accounts
FOR EACH ROW 
	WHEN (new.balance <> old.balance)
	EXECUTE FUNCTION trigger_fn_insert_new_entry_into_logs();


--13.Notification Email on Balance Change
CREATE TABLE notification_emails(
	id SERIAL PRIMARY KEY,
	recepient_id INT,
	subject VARCHAR (255),
	body TEXT);

CREATE OR REPLACE FUNCTION trigger_fn_send_email_on_balance_change()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO notification_emails(recepient_id, subject, body)
	VALUES(
		new.account_id,
		'Balance change for account: ' ||new.account_id,
		'On' || DATA() || ' your balance was changed from ' || new.old_sum ' to ' || new.new_sum ||'.');
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_send_email_on_balance_change
AFTER UPDATE ON logs
FOR EACH ROW
	WHEN (old.new_sum <> new.new_sum)
	EXECUTE FUNCTION trigger_fn_send_email_on_balance_change();
