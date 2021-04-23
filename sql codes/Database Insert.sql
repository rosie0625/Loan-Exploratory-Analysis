INSERT INTO default_rate_predict.emp_title (emp_title_name)
(SELECT DISTINCT emp_title_name FROM staging.LoanData WHERE emp_title_name IS NOT NULL);

USE default_rate_predict;
SELECT * FROM sub_account;
SELECT * FROM staging.LoanData;

INSERT INTO default_rate_predict.borrower(borrower_id, home_ownership, dti, hardship_flag, zip_code, addr_state,
emp_title_id, emp_length, annul_inc, verification_status, delinq_2yrs, mths_since_last_delinq, open_acc, total_acc,
revol_bal, revol_util)
(SELECT L.borrower_id, L.home_ownership, L.dti, case when L.hardship_flag = 'N' then 0 else 1 end, L.zip_code, L.addr_state,
e.emp_title_id, L.emp_length, L.annual_inc, L.verification_status, L.delinq_2yrs, L.mths_since_last_delinq,
L.open_acc, L.total_acc, L.revol_bal, L.revol_util FROM staging.LoanData L 
	INNER JOIN
default_rate_predict.emp_title e on e.emp_title_name = L.emp_title_name);

INSERT INTO default_rate_predict.account(tot_coll_amt, tot_cur_bal, inq_fi, chargeoff_within_12_mths, num_sats, 
pct_tl_nvr_dlq, Pub_rec_bankruptcies, tot_hi_cred_lim, borrower_id)
(SELECT L.tot_coll_amt, L.tot_cur_bal, L.inq_fi, L.chargeoff_within_12_mths, L.num_sats,
L.pct_tl_nvr_dlq, L.pub_rec_bankruptcies, L.total_il_high_credit_limit, L.borrower_id FROM staging.LoanData L);


INSERT INTO default_rate_predict.sub_grade(sub_grade)
(SELECT DISTINCT L.sub_grade FROM staging.LoanData L WHERE L.sub_grade IS NOT NULL);

INSERT INTO default_rate_predict.title_purpose(loan_purpose)
(SELECT DISTINCT L.loan_purpose FROM staging.LoanData L WHERE L.loan_purpose IS NOT NULL);

INSERT INTO default_rate_predict.loan(borrower_id, funded_amnt_inv, term, int_rate, installment, sub_grade_id,
loan_status, title_purpose_id, inq_last_6mths, initial_list_status, out_prncp_inv, total_rec_prncp, total_rec_int,
last_pymnt_amnt)
(SELECT L.borrower_id, L.funded_amnt_inv, L.term, L.int_rate, L.installment, s.sub_grade_id,
L.loan_status, t.title_purpose_id, L.inq_last_6mths, L.initial_list_status, L.out_prncp_inv,
L.total_rec_prncp, L.total_rec_int, L.last_pymnt_amnt FROM staging.LoanData L
	INNER JOIN 
default_rate_predict.sub_grade s on s.sub_grade = L.sub_grade
	INNER JOIN
default_rate_predict.title_purpose t on t.loan_purpose = L.loan_purpose);


INSERT INTO default_rate_predict.account_type(account_type_name)
VALUES("bankcard"),("installment"),("revolving");

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO default_rate_predict.sub_account (total_bal, num_act_act, num_trades, total_credit_lim,
account_type_id, account_id)
(SELECT total_bal, num_act_act, num_trades, total_credit_lim, account_type_id, account_id FROM
(select
total_bc_limit - bc_open_to_buy AS total_bal, 
num_actv_bc_tl AS num_act_act,
num_bc_sats AS num_trades,
total_bc_limit AS total_credit_lim,
1 AS account_type_id,
C.account_id AS account_id
FROM 
staging.LoanData AS A
	LEFT JOIN 
staging.bc_open_to_buy AS B 
	ON A.borrower_id = B.borrower_id 
	INNER JOIN
default_rate_predict.account C on C.borrower_id = A.borrower_id
union all
select
total_bal_il AS total_bal, 
open_act_il AS num_act_act,
num_il_tl AS num_trades,
total_il_high_credit_limit AS total_credit_lim,
2 AS account_type_id,
C.account_id AS account_id
FROM 
staging.LoanData AS A
	INNER JOIN
default_rate_predict.account C on C.borrower_id = A.borrower_id
union all
select
max_bal_bc AS total_bal, 
num_actv_rev_tl AS num_act_act,
num_op_rev_tl AS num_trades,
total_rev_hi_lim AS total_credit_lim,
3 AS account_type_id,
C.account_id AS account_id
FROM 
staging.LoanData AS A
	INNER JOIN
default_rate_predict.account C on C.borrower_id = A.borrower_id) Z
);

SET FOREIGN_KEY_CHECKS = 1;



# Truncate code
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE default_rate_predict.emp_title;
TRUNCATE default_rate_predict.borrower;

SET FOREIGN_KEY_CHECKS = 1;


SELECT SUM(S.num_trades) FROM sub_account S
	INNER JOIN
account_type T ON T.account_type_id = S.account_type_id
	INNER JOIN
account A on A.account_id = S.account_id
	INNER JOIN
borrower B ON B.borrower_id = A.borrower_id
WHERE T.account_type_name = 'revolving' AND B.addr_state = "WA";
