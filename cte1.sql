-- 사용법

with cte(no, name) as (select * 
from departments)

select (select name from cte where no = dept_no) as depat_name, count(*)
from dept_emp
group by dept_emp.dept_no;


select dept_name, count(*)
from dept_emp, departments
where dept_emp.dept_no = departments.dept_no
group by dept_emp.dept_no;