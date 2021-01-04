---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 17. student 테이블에서 각 학년별, 성별 학생수, 키/몸무게의 평균을 출력하세요.
select * from student;

select grade, decode(substr(jumin, 7, 1), '1', '남', '여'),    -- group by 말고 select절에만 표현해도 표현한대로 나옴.
       count(studno),
       round(avg(height), 1),
       round(avg(weight), 1)
  from student
 group by grade, substr(jumin, 7, 1);
 
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 18.
-- 18.1 EMP 테이블에서 10번 부서를 제외하고 나머지에 대해 부서별 평균 연봉을 구하라.
select * from emp;

-- where절 먼저 수행하는게 더 효율적
select deptno, (avg(sal))
  from EMP
 where deptno != 10
 group by deptno;

select deptno, (avg(sal))
  from EMP
 group by deptno
having deptno != 10;

-- => 일반조건은 where, having절 모두 사용 가능하나 where절에 사용하는 것이 성능상 유리 *

-- 18.2 EMP 테이블에서 부서 인원이 4명보다 많은 부서의 부서번호, 인원수, 급여의 합을 출력하라.
select * from emp;

select deptno, count(empno), sum(sal)
  from emp
 group by deptno
having count(empno) >= 4;

-- where절에는 그룹함수 사용불가
select deptno, count(empno), sum(sal)
  from emp
 where count(empno) > 4
 group by deptno;

-- 18.3 EMP 테이블에서 업무별 급여의 평균이 3000 이상인 업무에 대해서 업무명, 평균 급여, 급여의 합을 구하라.
SELECT * FROM emp;

select job, avg(sal), sum(sal)
  from EMP
 group by job
having avg(sal) >= 3000;

-- 다음과 같은 데이터에서 job별 sal의 총합과 함께
-- 부서번호를 함께 출력하여라
job   deptno sal
A     10     1000
A     10     2000 
B     20     3000

select job, sum(sal), deptno
  from a
 group by job, deptno;

A  10   3000
B  20   3000
;

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 19.
-- 19.1 STUDENT 테이블과 EXAM_01 테이블을 사용하여 각 학생의 학번, 이름, 학년, 시험성적을 함께 출력
select * from STUDENT, EXAM_01;

select s.studno, s.name, s.grade, e.total
  from STUDENT s, EXAM_01 e
 where s.studno = e.studno;

select s.studno, s.name, s.grade, e.total
  from STUDENT s join EXAM_01 e
    on s.studno = e.studno;

-- 19.2 위 결과를 사용하여 학년별 시험성적의 평균을 출력하세요.
select s.grade, avg(e.total)
  from STUDENT s, EXAM_01 e
 where s.studno = e.studno
 group by s.grade;

select s.GRADE, avg(e.TOTAL)
  from STUDENT s join EXAM_01 e
    on s.STUDNO = e.STUDNO
 group by s.GRADE;

--    2-2) non-equip join(비등가 조인) : 조인 조건이 '='이 아닌 경우
select g1.gname as 고객이름,
       g2.gname as 상품명
  from gogak g1, gift g2
 where g1.point between g2.g_start and g2.g_end;

-- 19.3 위 테이블을 사용하여 각 고객이 가져갈 수 있는 모든 상품 목록을 출력 **
select g1.gname, g2.gname
  from gogak g1, gift g2
 where g1.point >= g2.G_START
 order by 1;

-- 19.4 위 문제에서 준비할 상품의 최대 개수를 상품이름과 함께 출력하되, **
--           각 상품별 최소 포인트 조건과 최대 포인트 조건을 함께 출력하세요.
select g2.gname, count(g1.gname), g2.g_start, g2.g_end
  from gogak g1, gift g2
 where g1.point >= g2.g_start  
 group by g2.gname, g2.g_start, g2.g_end;
--------------------------------------------------------------------------------

---------------------------------- 실 습 문 제 ----------------------------------- 
-- 실습문제 5.
-- 5.1 EMP2 테이블에서 출생년도(1960, 1970, 1980, 1990) 별로 평균연봉을 구하라. ***
select * from emp2;

-- 정답 : 3자리를 가져오고 뒤에 0을 붙히는 방법, 4자리 가져오고 마지막 한자리를 0으로 만드는 방법(Trunc 함수)
select trunc(to_char(birthday, 'YYYY'), -1), round(avg(pay))
  from EMP2
 group by trunc(to_char(birthday, 'YYYY'), -1)
 order by 1; 

-- 5.2 EMP2 테이블과 P_GRADE 테이블을 조회화여 사원들의 이름과 나이, 현재직급, 예상직급을 출력하세요.
--    예상직급은 나이로 계산하여 소수점 이하는 생략하세요. ***
select * from emp2;
select * from p_grade;

select e.name, (2020 - to_char(e.birthday, 'YYYY')) as 현재나이,
       e.position as 현재직급, p.position as 예상직급
  from emp2 e, p_grade p
 where (2020 - to_char(e.birthday, 'YYYY')) between p.s_age and p.e_age
 group by e.name, (2020 - to_char(e.birthday, 'YYYY')), e.position, p.position;
 
select e.name, e.position as 현재직급, p.position as 예상직급,
       trunc((sysdate - e.birthday) / 365) as 나이1, 
       2020 - to_char(e.birthday, 'YYYY') as 나이2
  from emp2 e, p_grade P
 where trunc((sysdate - e.birthday) / 365) between p.s_age and p.e_age;

-- 5.3 STUDENT 테이블과 PROFESSOR 테이블을 사용하여 3, 4학년 학생의 지도교수 정보를 함께 출력하여
--    각 지도교수별 지도학생이 몇명인지에 대한 정보를 교수이름, 직급과 함께 출력하라.
select * from student, professor;
 
select p.name as 교수이름, count(s.name) as 학생수 , p.position, p.pay, p.hiredate
  from student s, professor P
 where s.profno = p.PROFNO
   and s.grade in (3, 4)
 group by p.name, p.position, p.pay, p.hiredate;    -- group by에 인자를 더 넣을 수 있는 이유 : 동명이인이 없기 때문에 가능 있다면 더 세분화 될 것.

-- 5.4 레포트를 작성하고자 한다. ***
--    EMP 테이블을 이용하여 각 부서별 직원수를 출력하되 다음과 같은 형식으로 작성하라.
--   
--    레포트명         10_직원수      20_직원수      30_직원수
--    --------------------------------------------------------
--    본인이름 레포트         3             5              6

select * from emp;

select deptno, count(empno)
  from EMP
 group by deptno;

select '정성호 레포트' as 레포트명,
       sum(decode(deptno, 10, 1)) as "10_직원수",
       count(decode(deptno, 20, '있다', null)) as "20_직원수",
       count(decode(deptno, 30, 1)) as "30_직원수"
  from emp;
--------------------------------------------------------------------------------
 
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 20.1 STUDENT, EXAM_01, HAKJUM 테이블을 사용하여 각 학생의 이름, 시험점수, 학점을 출력하라.
s(studno) - e(studno, total) - h(min_point, max_point);

select s.name, e.total, h.grade
  from student s, exam_01 e, hakjum H
 where s.studno = e.STUDNO
   and e.total between h.min_point and h.max_point;

-- 연습문제 20.2 위 데이터를 활용하여 각 학점별 학생수 출력 (단, 학점은 A, B, C, D로 묶어서 출력)
select substr(h.grade, 1, 1) as 학점, count(s.studno) as 학생수, avg(e.total) as 평균점수
  from student s, exam_01 e, hakjum H
 where s.studno = e.STUDNO
   and e.total between h.min_point and h.max_point
 group by substr(h.grade, 1, 1);
 
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 21. STUDENT, DEPARTMENT 테이블을 사용하여 각 학생의 이름, 제2전공명, 학년을 함께 출력
select * from student;
select * from department;

select s.name, d.dname, s.grade
  from STUDENT s, DEPARTMENT d
 where s.deptno2 = d.deptno(+);
  
select s.name, d.dname, s.grade
  from STUDENT s left outer join DEPARTMENT d
    on s.deptno2 = d.deptno;
    
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 22. 
-- 22.1 DEPARTMENT 테이블을 사용하여 각 학과명과 상위학과명을 동시 출력,
--           단, 상위학과가 없는 경우도 출력 ***
select * from department;

select d1.dname as 학과명, d2.dname as 상위학과명
  from department d1, department d2
 where d1.part = d2.deptno(+);
 
-- 예제) 위 결과에서 상위학과가 없는 경우 상위학과 이름은 원래 학과 이름을 출력 ***
select d1.dname as 학과명, nvl(d2.dname, d1.dname) as 상위학과명
  from department d1, department d2
 where d1.part = d2.deptno(+);

-- 22.2 PROFESSOR 테이블에서 교수의 번호, 교수이름, 입사일, 자신보다 입사일 빠른
-- 사람 인원수를 출력 (단, 자신보다 입사일이 빠른 사람수를 오름차순으로 출력)
select * from professor;

select p1.PROFNO, p1.NAME, p1.HIREDATE, count(p2.HIREDATE)
  from professor p1, professor p2
 where p1.hiredate > p2.hiredate(+)
 group by p1.profno, p1.name, p1.hiredate
 order by hiredate;

-- 22.3 STUDENT 테이블에서 각 학생의 이름, 학년, 키를 출력, 같은 학년 내에 각 학생
-- 보다 키가 큰 학생수 함께 출력
select * from student;

select s1.name, s1.grade, s1.height, count(s2.studno)
  from student s1, student s2
 where s1.grade = s2.GRADE(+)
   and s1.height > s2.height(+)
 group by s1.studno, s1.name, s1.grade, s1.height
 order by s1.name;
--------------------------------------------------------------------------------

---------------------------------- 실 습 문 제 ----------------------------------- 
-- 실습문제 6.  
-- 1) STUDENT 테이블에서 각 학생의 이름, 제1전공학과명을 출력하고 담당지도교수 이름과 지도교수의 소속 학과명도
--    함께 출력하라. 단, 지도교수가 없는 학생도 모두 출력 ***
select * from student;
select * from department;
select * from professor;

d2(+) - p(+) - s - d1;

select s.name as 학생이름, d1.dname as 제1전공명,
       p.name as 지도교수이름, d2.dname as 교수학과
  from student s, department d1,
       professor p, department d2
  where s.deptno1 = d1.deptno
    and s.profno = p.profno(+)
    and p.deptno = d2.deptno(+);
    
select s.name as 학생이름, d1.dname as 제1전공명,
       p.name as 지도교수이름, d2.dname as 교수학과
  from department d1 join student s
    on s.deptno1 = d1.deptno
       left outer join professor p
    on s.profno = p.profno
       left outer join department d2
    on p.deptno = d2.deptno;

-- 2) STUDENT 테이블과 EXAM_01, department 테이블을 이용하여 각 학과별 평균 점수와 최고 점수, 최저 점수를
--    나타내되 학과이름, 학과번호와 함께 출력 *
select * from student;
select * from exam_01;
select * from department;
d - s - e ;
select d.dname, d.deptno, 
       avg(e.total), min(e.total), max(e.total)
  from student s, exam_01 e, department d
 where s.studno = e.studno
   and s.deptno1 = d.deptno
 group by d.dname, d.deptno;
 
select d.dname, d.deptno, 
       avg(e.total), min(e.total), max(e.total)
  from student s join exam_01 e
    on s.studno = e.studno
       join department d
    on s.deptno1 = d.deptno
 group by d.dname, d.deptno; 

-- 3) EMP2 테이블에서 각 직원과 나이가 같으면서 취미가 같은 직원의 수를 직원의 이름, 부서이름, 취미,
--    PAY와 함께 출력하라. ***
select * from emp2;

select e1.name, e1.deptno, e1.hobby, e1.pay, count(e1.name)
  from emp2 e1, emp2 e2
 where (2020 - to_char(e1.birthday, 'YYYY')) = (2020 - to_char(e2.birthday, 'YYYY'))
   and e1.hobby = e2.hobby
 group by e1.name, e1.deptno, e1.hobby, e1.pay;
 
d - e1 - e2(+);
select e1.name as 직원이름, e1.birthday, 
       e1.hobby, e1.pay, d.dname,
       count(e2.name) as 친구수
  from emp2 e1, emp2 e2, dept2 d
 where e1.hobby = e2.hobby(+)
   and to_char(e1.birthday, 'yyyy') = 
       to_char(e2.birthday(+), 'yyyy')
   and e1.empno != e2.empno(+)
   and e1.deptno = d.dcode
 group by e1.empno, e1.name, e1.birthday, 
          e1.hobby, e1.pay, d.dname
 order by e1.empno;

select e1.name as 직원이름, e1.birthday, 
       e1.hobby, e1.pay, d.dname,
       count(e2.name) as 친구수
  from emp2 e1 left outer join emp2 e2
    on (e1.hobby = e2.hobby
   and to_char(e1.birthday, 'yyyy') = 
       to_char(e2.birthday, 'yyyy')
   and e1.empno != e2.empno)
       join dept2 d
   on  e1.deptno = d.dcode
 group by e1.empno, e1.name, e1.birthday, 
          e1.hobby, e1.pay, d.dname
 order by e1.empno;     

-- 4) EMP 테이블을 이용하여 본인과 상위관리자의 평균 연봉보다 많은 연봉을 받는 직원의 이름, 부서명, 연봉,
--    상위관리자명을 출력하여라. ****
select * from emp;
 
e2(+) - e1 - d;
select e1.ename as 직원이름, e1.sal, d.dname,
       e2.ename as 매니저이름, e2.sal,
       (e1.sal + nvl(e2.sal, e1.sal)) / 2 as 평균연봉
  from emp e1, emp e2, dept d
 where e1.mgr = e2.empno(+)                         -- e1과 e2의 관계중 이 조건만 아우터조인 필요
   and e1.sal >= (e1.sal + nvl(e2.sal, e1.sal)) / 2   -- 이 조건은 아우터 조인 필요 없음
   and e1.deptno = d.deptno;

select e1.ename as 직원이름, e1.sal, d.dname,
       e2.ename as 매니저이름, e2.sal,
       (e1.sal + nvl(e2.sal, e1.sal))/2 as 평균연봉
  from emp e1 join emp e2                            -- e1과 e2를 left outer join을 걸면 각 직원의 연봉이 상위관리자와의 평균 연봉보다 높은 조건에 만족하지 않아도 모두 출력됌
    on (e1.mgr = e2.empno
   and e1.sal >= (e1.sal + nvl(e2.sal, e1.sal))/2)
       join dept d
    on e1.deptno = d.deptno;
--------------------------------------------------------------------------------

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 23. 이름이 M으로 시작하는 직원과 같은 부서에 있는 직원을 모두 출력(이름이 M으로 시작하는 
--            직원포함) 
select *
  from EMP
 where deptno in (select deptno
                    from EMP
                   where ename like 'M%');   

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 24.  STUDENT 테이블에서 4학년 학생 중 키가 가장 작은 학생보다 작은 학생을 출력하세요.
select *
  from STUDENT
 where height < all(select height
                      from STUDENT
                     where grade = 4);

select *
  from STUDENT
 where height < (select min(height)
                      from STUDENT
                     where grade = 4);                  
                     
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 25. PROFESSOR 테이블에서 각 position별 가장 먼저 입사한 사람의 이름, 입사일, position, pay 출력
select name, hiredate, position, sal
  from PROFESSOR
 where (position, hiredate) in (select position, min(hiredate)
                                  from professor
                                 group by position);                            
                                 
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 26.
-- 26.1 STUDENT 테이블에서 같은 성별 내에 평균몸무게보다 작은 학생의 이름, 성별, 학년, 몸무게 출력
select name, decode(substr(s.jumin, 7, 1), '1', '남성', '여성'), grade, weight
  from STUDENT s, (select substr(jumin, 7, 1) as same_sex,
                          avg(weight) as avg_weight
                     from STUDENT
                    group by substr(jumin, 7, 1)) w
 where substr(s.jumin, 7, 1) = w.same_sex
   and s.weight < w.avg_weight;

-- 26.2 PROFESSOR 테이블에서 입사년도별 평균연봉보다 높은 교수의 이름, 소속학과명, PAY, 지도학생 수를 함께 출력 ***
d - p - i
    |
    s(+)
;
select * from PROFESSOR;
select * from department;
select * from student;

select p.name, d.dname, p.pay, count(S.NAME) AS 지도학생수
  from PROFESSOR p, 
       department d,
       STUDENT s,
       (select to_char(hiredate, 'YYYY') as hireyear, avg(pay) as avg_pay
          from PROFESSOR
         group by to_char(hiredate, 'YYYY')) i
 where to_char(p.hiredate, 'YYYY') = i.hireyear
   and p.pay > i.avg_pay
   and p.deptno = d.deptno
   and p.profno = s.profno(+)
  group by p.profno, p.name, d.dname, p.pay
   ;
--------------------------------------------------------------------------------     

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 27. PROFESSOR 테이블에서 소속학과별 PAY가 가장 큰 교수의 정보 출력
select * from PROFESSOR;                

-- 1) 다중컬럼 => where절에 넣고 동시비교
SELECT *
  FROM professor
 WHERE sal IN (SELECT max(SAL)
 				 FROM professor
 				GROUP BY deptno);

SELECT *
  FROM professor
 WHERE (deptno, sal) IN (SELECT deptno, max(sal)
  						   FROM professor
  						  GROUP BY deptno);
-- => from절이 아닌 where절에 있으므로 select절에서 원하는 컬럼만 빼낼 수 없음.                              
                   
-- 2) 인라인뷰 => from절에 넣기			 
SELECT *
  FROM professor p1, (SELECT deptno, max(sal) max_sal
  					 FROM professor
  					GROUP BY deptno) p2
 WHERE p1.deptno = p2.deptno
   AND p1.sal = p2.max_sal;

-- 3) 상호연관 => where절에 넣고, where절 또 넣기
select *
  from PROFESSOR p1
 where p1.pay = (select max(p2.pay)
                    from PROFESSOR p2
                   where p1.deptno = p2.deptno);
-- => from절이 아닌 where절에 있으므로 select절에서 원하는 컬럼만 빼낼 수 없음.                     
--------------------------------------------------------------------------------   
                  
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 28. EMP2 테이블에서 고용타입(EMP_TYPE)별 평균 PAY보다 적게 받는 직원을 출력
select * from emp2;

-- 1) 인라인뷰
select *
  from emp2 e1, (select avg(pay) as avg_pay, emp_type
                   from EMP2
                  group by emp_type) i
 where e1.emp_type = i.emp_type
   and e1.pay < i.avg_pay;

-- 2) 상호연관                  
select *
  from emp2 e1
 where 1 = 1    -- 생략하고 싶은 조건을 쉽게 생략하기 위해 1 = 1을 넣고 다른 행을 주석처리
   and e1.pay = (select avg(pay) as avg_pay
                   from EMP2 e2
                  where e1.emp_type = e2.emp_type);       
                  
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 29.1 EMP, DEPT 테이블에서 각 직원의 이름, sal, 부서명을 함께 출력(스칼라 서브쿼리)
-- join
SELECT * FROM emp;
SELECT * FROM dept;

select e.ename, sal, d.dname
  from emp e, dept d
 where e.deptno = d.deptno;

-- 스칼라 서브쿼리
select e.ename, sal,
       (select dname
          from DEPT d
         where e.deptno = d.deptno) as dname
  from emp e;
 
-- 연습문제 29.2 EMP 테이블을 사용하여 각 직원의 이름, 상위관리자 이름을 동시 출력(스칼라 서브쿼리)
-- join
select e1.ename, e2.ename
  from emp e1, emp e2
 where e1.mgr = e2.empno;
 
 select * from emp;

-- 스칼라 서브쿼리
select e1.ename,
       (select e2.ename
          from emp e2
         where e1.mgr = e2.empno)    -- outer join이 자동으로 실행
  from emp e1;
         
-- 연습문제 30. STUDENT, PROFESSOR 테이블을 사용하여 학생이름, 지도교수이름을 출력
--           단, 지도교수 이름이 없는 경우 '홍길동' 출력
select * from STUDENT;
select * from PROFESSOR;

-- join
select s.name,
       nvl(p.name, '홍길동')
 from STUDENT s, PROFESSOR p
where s.profno = p.profno(+);

-- 스칼라 서브쿼리
select s.name,
       nvl((select p.name
          from PROFESSOR p
         where s.profno = p.profno), '홍길동')    -- 스칼라 서브쿼리 자체가 하나의 컬럼 **
  from STUDENT s;
 
select comm, nvl(comm, 0)
          from emp;
          
-- 연습문제 31. STUDENT, EXAM_01, HAKJUM 테이블을 사용하여 각 학생의 이름, 시험성적, 학점을 출력하되
--           스칼라 서브쿼리를 2개 사용
select * from STUDENT;
select * from EXAM_01;
select * from HAKJUM;

-- join
select s.name,    -- s - e는 관계가 있으나 s - h는 관계가 없음 => e를 기준으로 풀어야 함. **
       e.total,
       h.GRADE
  from student s, exam_01 e, hakjum h
 where s.studno = e.STUDNO
   and e.total between h.min_point and h.MAX_POINt;

-- 스칼라 서브쿼리
select e.total,
       (select s.name
          from STUDENT s
         where s.studno = e.studno),    -- 2번째 서브쿼리, 3번째 서브쿼리는 거의 동시에 수행된다고 보면 됨.
       (select h.grade                  -- 따라서, 3번째 서브쿼리에서는 e 테이블을 읽을 수 없음.
          from HAKJUM h
         where e.total between h.min_point and h.max_point)
  from exam_01 e;
  
 