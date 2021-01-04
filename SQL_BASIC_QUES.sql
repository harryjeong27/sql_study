---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 1. Alias
-- DEPT 테이블을 사용하여 deptno를 부서#, dname 부서명, loc를 위치로 별명을 설정하여 출력하세요.
select deptno as "부서#",
       dname  as 부서명,
       loc    as 위치
  from dept;
  
-- 연습문제 2. Distinct
-- EMP 테이블에서 부서별(deptno)로 담당하는 업무(job)가 하나씩 출력되도록 하여라.
select distinct deptno, job
  from emp;
  
---------------------------------- 실 습 문 제 ----------------------------------- 
-- 실습문제 1.
-- 1) EMP 테이블에서 담당업무(JOB)가 Manager인 정보를 사원번호, 성명, 업무, 급여(SAL),
--    부서번호(deptno)를 출력하라.
select *
  from emp;

select empno, ename, job, sal, deptno
  from emp
 where job = 'MANAGER';
 
-- 2) EMP 테이블에서 급여가 1300에서 1700 사이인 사원의 성명, 업무, 급여,
--    부서번호(deptno)를 출력하라.
select ename, job, sal, deptno
  from emp
 where sal < 1700
   and sal > 1300;
  
SELECT ename, job, sal, deptno
  FROM EMP
 WHERE sal BETWEEN 1300 AND 1700;
   
-- 3) EMP 테이블에서 사원번호(empno)가 7902, 7788, 7566인 사원의 사원번호, 성명, 업무,
--    급여, 입사일자(hiredate)를 출력하라.
select empno, ename, job, sal, hiredate
  from emp
 where empno = 7902
    or empno = 7788
    or empno = 7566;
   
SELECT empno, ename, job, sal, hiredate
  FROM emp
 WHERE empno IN (7902, 7788, 7566);
    
-- 4) EMP 테이블에서 SAL이 3000보다 작은 직원들에 대해 다음과 같은 형식으로 출력하라.
--    ALLEN의 10% 인상된 연봉은 1760이다.
select ename || '의 10% 인상된 연봉은 ' || sal || '이다.'
  from EMP
 where sal < 3000;
-------------------------------------------------------------------------------- 

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 3
-- EMP 테이블에서 급여가 1100 이상이거나, 이름이 M으로 시작하지 않는 사원 출력
select *
  from EMP
 where sal >= 1100
    or ename != 'M%';
    
select *
  from EMP
 where sal >= 1100
    or ename not like 'M%';    
   
-- 연습문제 4
-- EMP 테이블에서 JOB이 Manager, Clerk, Analyst가 아닌 사원 출력
select *
  from EMP
 where initcap(job) not in ('Manager', 'Clerk', 'Analyst');   

-- 연습문제 5
-- EMP 테이블에서 JOB이 President이고 급여가 1500이상이거나 업무가 SALESMAN인 사원 출력
select *
  from EMP
 where upper(job) = upper('President')
   and sal >= 1500
    or upper(job) = upper('Salesman');
-- and와 or가 있으면 and가 먼저 묶임
   
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 6. student 테이블에서 여학생이면서 생년월일이 1975년 7월 1일 이후에 태어난 학생 추출
select *
  from student
 WHERE substr(IDNUM, 7, 1) = '2'
   AND birthdate > '1975/07/01';

select *
  from student
  where jumin like '______2%'
    and birthday > '1975/07/01';

-- 연습문제 7. student 테이블에서 78년 태어난 학생 추출
select *
  from student
 where substr(JUMIN, 1, 2) = '78';

alter session set nls_date_format = 'YY/MM/DD';

select name, BIRTHDAY, substr(BIRTHDAY, 1, 2)
  from student
 where substr(BIRTHDAY, 1, 2) = '78';

select name, BIRTHDAY, substr(BIRTHDAY, 1, 2)
  from student
 where BIRTHDAY like '78%';
 
alter session set nls_date_format = 'YYYY/MM/DD';
select name, BIRTHDAY, substr(BIRTHDAY, 1, 2)
  from student
 where BIRTHDAY like '1978%';
 
select name, BIRTHDAY, substr(BIRTHDAY, 1, 2)
  from student
 where BIRTHDAY between '1978/01/01' and '1978/12/31'; 
 
alter session set nls_date_format = 'YY/MM/DD';    -- 2자리이지만 4자리로 사용해도 자동으로 읽음.
select name, BIRTHDAY, substr(BIRTHDAY, 1, 2)
  from student
 where BIRTHDAY between '1978/01/01' and '1978/12/31';  

alter session set nls_date_format = 'RR/MM/DD';
select name, BIRTHDAY, substr(BIRTHDAY, 1, 2)
  from student
 where BIRTHDAY between '78/01/01' and '78/12/31';   
 
-- alter session set nls_date_format = 'RR/MM/DD'; 
-- '78/01/01' => '1978/01/01'로 인식
-- alter session set nls_date_format = 'YY/MM/DD'; 
-- '78/01/01' => '2078/01/01'로 인식
--------------------------------------------------------------------------------   

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 8. student 테이블에서 지역번호만 추출
-- 055)381-2158 => 055
-- 02)6255-9875 => 02 
select tel,
       (instr(tel, ')')),
       substr(tel, 1, ((instr(tel, ')'))-1))
  from student;
--------------------------------------------------------------------------------

---------------------------------- 실 습 문 제 ----------------------------------- 
-- 실습문제 2.
-- 2.1 student 테이블에서 10월에 태어난 학생의
-- 이름, 학년, 생년월일을 출력하되 태어난 일이 작은 순서대로 정렬하라.
select *
  from student;

select name, grade, substr(jumin, 1, 6), substr(jumin, 5, 2)
  from student
 where jumin like '__10%'
 order by substr(jumin, 5, 2) asc;
 
select name, grade, substr(jumin, 1, 6), substr(jumin, 5, 2)
  from student
 where substr(jumin, 3, 2) = '10'
 order by substr(jumin, 5, 2) asc; 
 
-- 1975/10/23 00:00:00 => substr(birthday, 6, 2) => 안 됨. => 날짜 포맷이 다를거임.
-- 75/10/23            => substr(birthday, 4, 2)
select name, birthday, substr(birthday, 4, 2)
  from student
 where substr(birthday, 4, 2) = '10'
 order by substr(birthday, -2);

alter session set nls_date_format = 'YYYY/MM/DD';
select name, birthday, substr(birthday, 6, 2) as 월
  from student
 where substr(birthday, 6, 2) = '10'
 order by substr(birthday, -2); 
 
-- 2.2 student 테이블에서 각 학생의 국번 추출
--    051)426-1700  =>  426
--    02)6255-9875  =>  6255
select tel, instr(tel, ')'), instr(tel, '-'), substr(tel, instr(tel, ')') + 1, instr(tel, '-') - 1 - instr(tel, ')'))
  from student;

-- 2.3 student 테이블에서 성이 'ㅅ'인 학생의 학번, 이름, 학년을 출력하라.
SELECT *
  FROM STUDENT
 WHERE NAME >= '사'
   AND NAME < '아';

-- 2.4 EMPLOYEES 테이블에서 대소를 구분하지 않고 email에 last_name이 포함되어 있지 않은
--    사람의 EMPLOYEE_ID, FIRST_NAME, EMAIL을 출력하라. (EMPLOYEES 테이블은 hr 계정에서 조회 가능)
select employee_ID, first_name, email
  from employees
 where instr(EMAIL, upper(LAST_NAME)) = 0;
 
select employee_ID, first_name, email
  from employees
 where email not like '%' || upper(last_name) || '%';

select employee_ID, first_name, email, upper(last_name), substr(email, 2)    -- 잘못된 쿼리
  from employees
 where upper(substr(email, 2)) != upper(last_name);
--------------------------------------------------------------------------------

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 9
-- 9.1 PROFESSOR 테이블 교수 아이디에서 특수문자 모두 제거 후 출력
select *
  from professor;

select ID,
       replace(id, '-', ''),
       translate(id, 'a-_', 'a')    
  from professor;

-- 9.2 EMP 테이블에서 급여를 모두 동일한 자리수로 출력
select sal, length(sal), lpad(sal, 4, 0)
  from emp;

-- 9.3 STUDENT 테이블에서 이름의 두번째 글자를 # 처리
select *
  from student;
  
select name,
       replace(name, substr(name, 2, 1), '#')
  from student;
  
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 10. EMP 테이블에서 각 사원의 현재 날짜 기준 퇴직금을 계산하라.
--           퇴직금 = 기본급(sal) / 12 * 근속년수
select ename,
       sal,
       hiredate,
       trunc(sysdate - hiredate) as 근무일수,
       trunc(trunc(sysdate - hiredate)/365) as 근속년수1,
       trunc((sysdate - hiredate)/365) as 근속년수2,
       trunc(sal / 12 * ((sysdate - hiredate) / 365)) as 퇴직금
  from emp; 
  
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 11.
-- 11.1 EMP 테이블에서 현재까지 근무일수가 몇 주, 몇 일인가를 출력하라.
-- 단, 근무일수가 많은 사람 순으로 출력하라.
select *
  from emp;
 
select ename,
       trunc(months_between(sysdate, hiredate) * 4) as 근무주수1,    -- 개월 수 구하는 공식 체크
       trunc((sysdate - hiredate) / 7) as 근무주수2,
       trunc(sysdate - hiredate) as 근무일수
  from emp
 order by trunc(sysdate - hiredate) desc;
  
-- 11.2 EMP 테이블에서 10번 부서원의 입사일자로부터 돌아오는 금요일을 계산하여 출력하라.
select ename,
       next_day(hiredate, 6),
       next_day(hiredate, 'fri')
  from emp
 where deptno = 10; 
 
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 12.
-- 12.1 2020/01/01로부터 90일 뒤의 날짜의 다음 월요일 리턴
select next_day(to_date('2020/01/01', 'YYYY/MM/DD') + 90, 2)
  from dual;

to_char(날짜, 포맷) : 날짜 포맷 변경
to_date(문자/숫자, 포맷) : 날짜로 해석(파싱)

-- 예제) 2020/06/30로부터 150일 뒤의 요일 출력
select to_char(to_date('2020/06/30', 'YYYY-MM-DD') + 150, 'Day')
  from dual;

-- 날짜 언어가 영문일 경우 날짜포맷의 대소 구분
alter session set nls_date_language = 'american';
select to_char(sysdate, 'Day'),
       to_char(sysdate, 'DAY'),
       to_char(sysdate, 'day')
  from dual;

-- 12.2 student 테이블에서 24일에 태어난 학생 출력
select *
  from student;
  
select *
  from student
 where to_char(birthday, 'DD') = '24';
 
-- 12.3 professor 테이블에서 2001년 이후에 입사한 교수 출력
select *
  from professor;

ALTER TABLE professor RENAME COLUMN userid TO ID;
COMMIT;
 
SELECT *
  FROM PROFESSOR
 WHERE to_char(hiredate, 'YYYY') >= 2001;      -- '2001'은 문자인가 숫자인가? 문자면 이 쿼리에서 안 먹혀야 하는 거 아닌가? => 묵시적 형변환

select *
  from professor
 where to_number(to_char(hiredate, 'YYYY')) > 2001;
 
select *
  from professor
 where (to_char(hiredate, 'YYYY')) > '2001';    -- 문자로는 안됨
--------------------------------------------------------------------------------

---------------------------------- 실 습 문 제 ----------------------------------- 
-- 실습문제 3.
-- 3.1 professor 테이블에서 각 교수의 이메일 아이디를 출력하되, 특수기호를 제거한 형태로 출력하여라.
SELECT * FROM professor;

select email, 
       substr(email, 1, instr(email, '@') - 1) as email_id,
       translate(substr(email, 1, instr(email, '@') - 1), 'a_-.', 'a') as deleted_id
  from professor;
   
-- 2. student 테이블에서의 tel을 다음의 형태로 변경
--    055)381-2158 => 055 381 2158
select *
  from student;

select tel, translate(tel, ')-', '  ')
  from student;
  
-- 3. emp 테이블을 이용하여 현재까지 근무일수를 XX년 XX개월 XX일 형태로 출력하세요.
--    ex) 474개월, 39년 X개월
select *
  from emp;
 
select ename,
       sysdate - hiredate,
       trunc(((sysdate - hiredate) / 365)) || '년 ' || 
       trunc(mod((sysdate - hiredate), 365) / 7) || '개월 ' || 
       trunc(mod(mod((sysdate - hiredate), 365), 7)) || '일 '
  from emp;
  
select ename,
       trunc(months_between(sysdate, hiredate) as 근무개월
       trunc(trunc(months_between(sysdate, hiredate)) / 12) 
       
  from emp;  

select trunc(months_between(sysdate,hiredate)) AS 근무개월수,
       trunc(trunc(months_between(sysdate,hiredate)) / 12) AS 근속년수,
       mod(trunc(months_between(sysdate,hiredate)), 12) AS "나머지 월수",
       trunc(sysdate - add_months(hiredate, trunc(months_between(sysdate,hiredate))))
  from emp;
-- 나머지일수 : sysdate - add_months(입사일, 근무개월수)
--------------------------------------------------------------------------------
 
--------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 13. student 테이블에서 jumin 칼럼을 사용, 각 학생의 태어난 날의 요일 출력
select *
  from student;

select jumin,
       substr(jumin, 1, 6),
       to_char(to_date(substr(jumin, 1, 6), 'RR/MM/DD'), 'Day')
  from student; 
  
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 14. student 테이블을 사용하여 4학년 학생의 이름, 제1전공명을 출력하라.
--           단, 101번은 경영, 102번은 경제, 103번은 수학, 나머지는 기타로 출력
select * from student;

select name, deptno1, decode(deptno1, 101, '경영', 102, '경제', 103, '수학', '기타')
  from student
 where grade = 4;
 
-- 예제) emp 테이블에서 10번 부서이면서 job이 'PRESIDENT'이면 사장, 그외 job은 staff, 그외 부서는 기타로 출력
select deptno, job, 
       decode(deptno, 10, decode(job, 'PRESIDENT', '사장', 'staff'), '기타')
  from emp;

-- deptno = 10 and job = 'PRESIDENT'  => '사장'
-- deptno = 10 and job != 'PRESIDENT' => 'staff'
-- deptno != 10                       => '기타'
-------------------------------------------------------------------------------- 
 
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 15. STUDENT 테이블에서 3, 4학년 학생에 대해 이름, 학년, 제1전공번호, 성별을 함께 출력
-- 단, 성별은 남자, 여자로 표현
select * from student;

select name, grade, deptno1, decode(substr(jumin, 7, 1), '2', '여자', '남자')
  from student
 where grade in (3, 4);
  
select name, grade, deptno1,
       case substr(jumin, 7, 1) when '2' then '여자'
                                         else '남자'
       end as 성별    
  from student
  where grade in (3, 4);
-------------------------------------------------------------------------------- 
 
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 16.
-- 16.1 PROFESSOR 테이블에서 홈페이지 주소가 없는 교수는 http://www.kic.com/email_id로 출력
select *
  from PROFESSOR;
   
select hpage,
       nvl(hpage, 'http://www.kic.com/' || substr(email, 1, instr(email, '@') - 1))
  from PROFESSOR;

-- 16.2 EMP 테이블에서 JOB이 ANALYST이면 급여 증가는 10%이고, CLERK이면 15%, MANAGER이면 20%,
--          다른 업무에 대해서는 급여 증가가 없다. 사원번호, 이름, 업무, 급여, 증가된 급여를 출력하라.
select * from emp;

SELECT EMPNO, ENAME, JOB, SAL,
						  decode(job, 'ANALYST', sal * 1.1, 'CLERK', sal * 1.15, 'MANAGER', sal * 1.2, sal)
  FROM emp;
  
select empno, ename, job, sal,
       case job when 'ANALYST' then sal * 1.1
                when 'CLERK'   then sal * 1.15
                when 'MANAGER' then sal * 1.2
                               else sal
       end as sal_increase
  from emp; 
  
---------------------------------- 실 습 문 제 ----------------------------------- 
-- 실습문제 4.
-- 4.1 EMP 테이블의 사원이름, 매니저번호(MGR)를 출력하고, 매니저번호가 null이면 '상위관리자'로 표시, 
--     매니저번호가 있으면 매니저번호담당으로 표시하여라
--     ex) mgr이 7869이면 7869담당
select * from emp;

select ename, mgr,
       nvl2(mgr, mgr || '담당', '상위관리자')    -- nvl2의 2, 3번째 인자는 같은 포맷이어야 함. 이 상황에서는 2번째 인자가 자동으로 문자로 변형됨. 아닐 경우는 to_char 써야 함.
  from emp;
  
-- 4.2 Student 테이블의 jumin 컬럼을 참조하여 학생들의 이름과 태어난 달, 그리고 분기를 출력하라.
--    ex) 태어난 달이 01-03월 은 1/4분기, 04-06월은 2/4 분기, 
--    07-09 월은 3/4 분기, 10-12월은 4/4 분기로 출력하라.
select * from student;

select name, jumin,
       to_char(to_date(substr(jumin, 1, 6), 'RR/MM/DD'), 'Month'),
       to_char(to_date(substr(jumin, 1, 6), 'RR/MM/DD'), 'q') || '/4분기'       
  from student;
  
select name, jumin, substr(jumin, 3, 2),
       case when to_number(substr(jumin, 3, 2)) between 1 and 3
            then '1/4분기'
            when to_number(substr(jumin, 3, 2)) between 4 and 6
            then '2/4분기'
            when to_number(substr(jumin, 3, 2)) between 7 and 9
            then '3/4분기'
            else '4/4분기'
       end 분기1
  from student;

-- 4.3 emp 테이블에서 인상된 연봉을 기준으로 2000 미만은 'C', 2000이상 4000미만은 'B', 4000이상은 'A' 등급을 
--    부여하여 각 직원의 현재 연봉과 함께 출력
--    *인상된 연봉 = 기존 연봉 15% 인상 + 보너스(comm)
select * from emp;

select ename, sal,
       nvl(comm, 0),
       sal * 1.15 + nvl(comm, 0),
       case when (sal * 1.15 + nvl(comm, 0)) >= 4000 then 'A'
            when (sal * 1.15 + nvl(comm, 0)) >= 2000 then 'B'    -- 위에서 4000 이상이라고 했으면 그 범위는 다시 카운트 안 됨. 즉, 3999 ~ 2000 범위가 잡힘.
            when (sal * 1.15 + nvl(comm, 0)) < 2000 then 'C'
            end as 인상된연봉
  from emp;

-- 4.4 EMP 테이블을 이용하여 사원이름, 입사일 및 급여검토일을 표시합니다. 
--    급여검토일은 여섯달 근무 후 해당되는 첫번째 월요일 
--    날짜는 "Sunday the Seventh of September, 1981" 형식으로 표시. 열 이름은 check로 한다.
select * from emp;

alter session set nls_date_language = 'american';
select ename, hiredate,
       next_day((hiredate + 180), 2) as 급여검토일,
       to_char(next_day((hiredate + 180), 2), 'Day') || 'the ' ||
       to_char(next_day((hiredate + 180), 2), 'Ddspth ') || 'of ' ||
       to_char(next_day((hiredate + 180), 2), 'Month') || ', ' ||
       to_char(next_day((hiredate + 180), 2), 'YYYY')
  from emp;     
  
select ename, hiredate,
       to_char(next_day(add_months(hiredate, 6), 'mon'), 'Day "the" Ddspth "of" Month, YYYY'),    -- 문자 공백 => 가장 큰 자리수에 맞춰서 문자 길이 세팅 + 쌍따옴표로 문자 삽입
       trim(to_char(next_day(add_months(hiredate, 6), 'mon'), 'Day')) || ' the ' ||
       trim(to_char(next_day(add_months(hiredate, 6), 'mon'), 'Ddspth')) || ' of ' ||
       trim(to_char(next_day(add_months(hiredate, 6), 'mon'), 'Month')) ||
       trim(to_char(next_day(add_months(hiredate, 6), 'mon'), ',YYYY'))    -- 콤마는 날짜 형식 등에 넣어도 인식함.
  from emp;
  
-- 4.5 emp 테이블을 사용하여 연봉기준 등급을 아래의 기준에 맞게 표현하세요.
--    2000미만 'C', 2000이상 3000이하 'B', 3000초과 'A'
--    decode문 작성
select * from emp;

select ename, sal, 
       decode(trunc(sal / 2000), 0, 'C', 1, 'B', 1.5, 'B', 'A')
  from emp;

select ename, sal, 
       sign(sal - 2000),    -- sal < 2000 => -1 
       sign(sal - 3000),    -- sal > 3000 => 1
       decode(sign(sal - 2000), -1, 'C', decode(sign(sal - 3000), 1, 'A', 'B')),
       decode((sign(sal - 2000) + sign(sal - 3000)), -2, 'C', 2, 'A', 'B'),    -- decode 활용 *
       decode(trunc(sal / 2000), 0, 'C', 1, 'B', 1.5, 'B', 'A')
  from emp
 order by sal;
-------------------------------------------------------------------------------- 

