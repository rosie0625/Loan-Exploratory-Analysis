USE default_rate_predict;

# Q1: What is the average account balance for borrowers who get loan with different sub grade levels?

SELECT
	S.sub_grade, AVG(A.tot_cur_bal) AS avgBalance
FROM
	account A
		INNER JOIN
	borrower B ON B.borrower_id = A.borrower_id
		INNER JOIN
	loan L ON L.borrower_id = B.borrower_id
		INNER JOIN
	sub_grade S ON S.sub_grade_id = L.sub_grade_id
GROUP BY S.sub_grade;

# Q2: Customers with which kinds of home ownership more likeyly fully paid their loan on time?
SELECT 
	B.home_ownership AS own, CONCAT(m.count/COUNT(L.loan_id) * 100, '%') AS paid_percentage
FROM
	loan L	
		INNER JOIN
	borrower B ON B.borrower_id = L.borrower_id
		INNER JOIN 
(SELECT 
	B.home_ownership AS own, COUNT(L.loan_id) AS count
FROM 
	loan L
		INNER JOIN
	borrower B ON B.borrower_id = L.borrower_id
WHERE L.loan_status = "Fully Paid"
GROUP BY B.home_ownership) m
	ON m.own = B.home_ownership
GROUP BY B.home_ownership;

# Q3: Borrowers with which kinds of purpose more likely to default the loan?

SELECT 
	l.loan_status,
    t.loan_purpose, 
    CONCAT(COUNT(l.loan_id)/count.count_all * 100, '%') AS percentage
FROM 
	loan l
		INNER JOIN
	title_purpose t
			ON l.title_purpose_id = t.title_purpose_id
		INNER JOIN
	(SELECT 
		t.loan_purpose AS purpose,
		COUNT(l.loan_id) AS count_all
	FROM 
		loan l
			INNER JOIN
		title_purpose t
				ON l.title_purpose_id = t.title_purpose_id
	GROUP BY 
		t.loan_purpose) count
			ON count.purpose = t.loan_purpose
	WHERE
		loan_status = 'charged off' OR 
		loan_status like '%late%' OR 
		loan_status = 'in grace period'
GROUP BY 
	t.loan_purpose,
    l.loan_status
ORDER BY 
	CASE 	WHEN loan_status = 'in grace period' THEN '1'
			WHEN loan_status = 'late (16-30 days)' THEN '2'
            WHEN loan_status = 'late (31-120 days)' THEN '3'
			ELSE loan_status END ASC,
	percentage DESC;


# Q4: How was the loan grade given based on the information provided  by borrowers？

SELECT 
	'A' AS grade,
    AVG(b.annul_inc) AS annual_income,
    AVG(b.dti) AS dti,
    AVG(b.delinq_2yrs) delinquency,
    AVG(b.total_acc)*1000 AS credit_line,
    AVG(b.revol_bal) AS revol_bal
FROM
	sub_grade s
		INNER JOIN
	loan l
			ON s.sub_grade_id = l.sub_grade_id
		INNER JOIN
	borrower b
			ON l.borrower_id = b.borrower_id
WHERE 
	sub_grade like '%A%'
    
UNION ALL
    
SELECT 
	'B' AS grade,
    AVG(b.annul_inc) AS annual_income,
    AVG(b.dti) AS dti,
    AVG(b.delinq_2yrs) delinquency,
    AVG(b.total_acc)*1000 AS credit_line,
    AVG(b.revol_bal) AS revol_bal
FROM
	sub_grade s
		INNER JOIN
	loan l
			ON s.sub_grade_id = l.sub_grade_id
		INNER JOIN
	borrower b
			ON l.borrower_id = b.borrower_id
WHERE 
	sub_grade like '%B%'
    
UNION ALL
    
SELECT 
	'C' AS grade,
    AVG(b.annul_inc) AS annual_income,
    AVG(b.dti) AS dti,
    AVG(b.delinq_2yrs) delinquency,
    AVG(b.total_acc)*1000 AS credit_line,
    AVG(b.revol_bal) AS revol_bal
FROM
	sub_grade s
		INNER JOIN
	loan l
			ON s.sub_grade_id = l.sub_grade_id
		INNER JOIN
	borrower b
			ON l.borrower_id = b.borrower_id
WHERE 
	sub_grade like '%C%'
    
UNION ALL
    
SELECT 
	'D' AS grade,
	AVG(b.annul_inc) AS annual_income,
    AVG(b.dti) AS dti,
    AVG(b.delinq_2yrs) delinquency,
    AVG(b.total_acc)*1000 AS credit_line,
    AVG(b.revol_bal) AS revol_bal
FROM
	sub_grade s
		INNER JOIN
	loan l
			ON s.sub_grade_id = l.sub_grade_id
		INNER JOIN
	borrower b
			ON l.borrower_id = b.borrower_id
WHERE 
	sub_grade like '%D%';