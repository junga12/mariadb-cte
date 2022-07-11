-- cte를 이용하여 특정 부서 사람들의 salary를 10% 증가 

CREATE TABLE `salaries2` (
  `emp_no` int(11) NOT NULL,
  `salary` int(11) NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  PRIMARY KEY (`emp_no`,`from_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


insert into salaries2 select * from salaries;

select * from salaries2;

-- salary를 10퍼센트 상승시킬 emp_no
with cte(id) as (select dept_no from departments where dept_name = 'Customer Service' or dept_name = 'Development')

select distinct salaries2.emp_no
from salaries2, dept_emp
where 
	salaries2.emp_no = dept_emp.emp_no 
and 
	exists (select * from cte where cte.id = dept_emp.dept_no)
	order by salaries2.emp_no;

-- update
-- cte는 하나의 쿼리에 종속적이여서 연속적으로 같은 cte를 사용하더라도 따로 선언해주어야 한다
-- update는 10.11버전에 추가될 예정... (https://jira.mariadb.org/browse/MDEV-18511)
with cte(id) as (select dept_no from departments where dept_name = 'Customer Service' or dept_name = 'Development')

update salaries2
set salaries2.salary = salary * 1.1;
where 
	exists (
		select * 
        from salaries2
		where emp_no in ( 
			select distinct salaries.emp_no
			from salaries, dept_emp
			where salaries.emp_no = dept_emp.emp_no and 
			exists (select * from cte where cte.id = dept_emp.dept_no)
		)
	); 
