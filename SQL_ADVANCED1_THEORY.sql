-- [ 중급 1. DDL(Data Definition Language) ]
-- 객체의 정의 언어
-- 객체 생성(create), 변경(alter), 삭제(drop)
-- 객체 비우기(truncate)
-- 1.1 Create Table : 객체 생성 
create table test2(
col1    varchar2(10) not null,
col2    number(10)
);
-- 테이블 복사하기 => 제약조건 빼고 다 복제함
-- (CTAS : Create Table As Select)
create table emp_bak2
as
select *
  from emp
 where DEPTNO = 10;

-- 1.2 Alter Table : 객체 변경 
-- 생성된 테이블 변경
-- (컬럼추가, 컬럼 삭제, 컬럼 데이터 타입 변경, 컬럼 not null 여부 변경, 컬럼 default값 변경)
alter table EMP_BAK2 add (DEPTNO3 number(5),
                          DEPTNO4 number(5) DEFAULT 10);
-- 컬럼 삭제 : 데이터 복원 불가
alter table EMP_BAK2 drop column DEPTNO4;
-- 컬럼 데이터 타입 변경
alter table EMP_BAK2 modify ENAME VARCHAR2(15); 
-- 컬럼 이름 변경  
alter table EMP_BAK2 rename column deptno2 to deptno22;
-- 테이블명 변경(객체명 변경)
rename EMP_BAK2 to EMP_BAKUP2;

alter table EMP_BAK4 read only;    -- 수정(insert,update,delete) 불가, alter로 구조 변경 불가, 테이블 삭제 가능 => 구조 삭제, 전체 데이터 삭제

-- 1.3 Drop Table : 객체 삭제 
-- 삭제된 테이블은 휴지통에서 복구 가능
-- purge 옵션으로 삭제된 테이블은 복구 불가
drop table EMP_BAK4;

-- 1.4 Truncate : 객체 비우기
-- 테이블 구조 남기고 데이터 전체 삭제
truncate table EMP_BAK4; 
-- Cascade 

-- [ 중급 2. DML(Data Manipulation Language) ]
-- 데이터 수정 언어
-- INSERT(insert, select, nologging)
insert into 테이블명 values(값1, 값2, ...);
insert into 테이블명(col1, col2, ...)
       values(값1, 값2, ...);
-- UPDATE(set) : 수정, 특정 컬럼의 값
update 테이블명
   set 컬럼명 = 수정값(서브쿼리가능)
 where 조건(서브쿼리가능);
-- DELETE : 행 단위 삭제
delete from 테이블명
 where 조건;    -- 서브쿼리 가능 / 인라인뷰 불가능
-- SELECT(from, where, group by, having, select, order by)

                drop    truncate    delete
                DDL     DDL         DML
즉시 반영       yes     yes         no, commit
구조 삭제       yes     no          no
전체 데이터     yes     no          no
복구가능        yes     삭제기록x   일부 행만 삭제가능, 삭제기록을 남김
저장공간        아예 삭제 / 컬럼명만 놓고 아예 삭제 / 공간만 놔두고 삭제
; 
 
-- [ 중급 3. DCL(Data Control Language) ]
-- GRANT
-- REVOKE

-- [ 중급 4. TCL(Transaction Control Language) ]
-- COMMIT
-- ROLLBACK
-- SAVEPOINT

-- [ 중급 5. 데이터 딕셔너리 ]
-- DBMS가 자동으로 관리하는 테이블 및 뷰
-- 주로 객체에 대한 변경 내용 및 성능, 보안과 관련된 정보를 기록

-- [ 중급 6. 제약조건(constraint) ] ***
-- 데이터의 무결성(데이터의 결점이 없음)을 위해 생성하는 오브젝트
-- 각 컬럼마다 제약조건을 생성할 수 있음.
-- 6.1 unique : 중복값 허용 x ex) 주민번호
-- 6.2 not null : null값 허용 x
-- 6.3 primary key(기본키) : 각 행의 유일한 식별자 / 2개 생성 불가
--    unique + not null 제약조건의 형태
-- 6.4 check : 정해진 특정 값으로 입력 제한
-- 6.5 foreign key : 특정 테이블의 컬럼을 참조
-- 1) 테이블 생성 시
create table 테이블명(
컬럼1 데이터타입 primary key,
컬럼2 데이터타입 references 모테이블(컬럼3));    -- 자식테이블에 외래키를 만듦.
-- 2) 이미 만들어진 테이블에 제약조건 추가
alter table 테이블명 add (constraint 테이블명_컬럼명_fk) foreign key(컬럼1)    -- 컬럼1을 foreign key라고 부름.
                     references 부모테이블(컬럼2);    -- 컬럼2를 reference key라고 부름.
--------------------------------------------------------------------------------

-- [ 중급 2. DML(Data Manipulation Language) ]
-- 2.1 조회 언어 : select문
select             -- 테이블 내 출력을 원하는 컬럼/표현식
  from 테이블명      -- 조회할 데이터가 포함된 테이블명
 where
 group by
having
 order by
;

select *
  from emp;    -- query : sql 문장 한 세트

select empno, ename
  from emp;    -- query
    
select empno, ename, sal, sal + 1000, 10000
  from emp;    -- query

select *
  from dept;   -- query
  
-- [ select문의 6가지 절 수행 순서]
-- select      -- 5
--   from      -- 1
--  where      -- 2 필요없는 데이터를 제거
--  group by   -- 3 
-- having      -- 4
--  order by   -- 6  
  
-- 2.1.1 order by절 : 정렬
select *
  from emp
 order by deptno asc;

select *
  from emp
 order by deptno desc;  
  
select *
  from EMP
 order by deptno, sal desc;
 
-- select절에서 사용된 컬럼 별칭의 재사용
select ename, deptno as 부서번호, SAL
  from EMP
 where 부서번호 = 10;    -- 별칭은 where절에서 불가
 
select ename, deptno as 부서번호, SAL
  from EMP
 order by 부서번호;      -- order by절에서만 가능
-- Why? 리딩 순서가 1) from 2) where 3) select 4) order by 이기 때문
 
select ename, deptno as 부서번호, SAL
  from EMP
 order by 1, 2;    -- select절에 나열된 컬럼 순서로 정렬
 
-- 2.1.2 group by 절 : 그룹별 그룹함수의 적용
-- 분리 - 적용 - 결합의 연산 수행
-- 그룹당 한 개의 행 리턴
-- group by에 명시되지 않은 컬럼 select절에 단독 사용불가
-- 그룹함수와 함께 사용 필요
select deptno, max(sal), hiredate    -- hiredate는 사용불가
  from emp
 group by deptno;

select deptno, max(sal)
  from emp
 group by deptno;
 
-- 2.1.3 having절 : 행의 조건 전달, 그룹 연산 결과의 조건 사용
-- 예제) student 테이블에서 한 학년별 평균키를 구하고 평균키가 170 이상인 학년만 출력
select grade, avg(height)
  from STUDENT
 group by grade
 having avg(height) >= 170;    -- 그룹함수는 where절 사용불가

-- 2.1.4 집합 연산자 : select 결과에 대한 집합을 구하는 연산
-- 1) union / union all : 합집합
-- 2) intersect : 교집합
-- 3) minus : 차집합
-- 주의 : 각 select절에 명시된 컬럼의 개수/순서/데이터 타입 등이 같아야 함.
select ename, deptno, sal * 1.1
  from EMP
 where deptno = 10
 union
select ename, deptno, sal * 1.2, to_char(comm)
  from EMP
 where deptno = 20;

-- union / union all이 차이 : 중복 제거 유무
select ename, deptno
  from EMP
 where deptno in (10, 20)
 union
select ename, deptno
  from EMP
 where deptno = 10;

select ename, deptno
  from EMP
 where deptno in (10, 20)
 union all
select ename, deptno
  from EMP
 where deptno = 10;
 
-- union : 정렬 진행 후 중복 제거
-- union all : 정렬 없이 중복 포함 출력
-- 중복 값이 없다면 union all 쓰는게 훨씬 빠름.

-- intersect
select ename, deptno
  from EMP
 where deptno in (10, 20)
 intersect
select ename, deptno
  from EMP
 where deptno = 10;

-- minus
select ename, deptno
  from EMP
 where deptno in (10, 20)
 minus
select ename, deptno
  from EMP
 where deptno = 10;
 
-- 2.2 join
-- 2.2.1 cross join : 카타시안 곱 발생 (발생가능한 모든 경우의 수)
--    => 주로 조인조건 생략 혹은 부적절한 조인조건 전달 시
--    1) 오라클 표준 : from절에 테이블 나열
select *
  from emp, dept
 order by 1;
 
--    2) ANSI 표준 : from절에 join 종류 명확히 입력
select *
  from emp cross join dept
 order by 1;

-- 2.2.2 inner join : 조인조건에 맞는 행만 연결해서 출력
--    2-1) equip join(등가 조인) : 조인 조건이 '='
--    1) 오라클 표준
select emp.*, dname    -- 테이블명.*로 해당 테이블 전체 데이터 추출
  from emp, dept
 where emp.deptno = dept.deptno    -- 테이블명.컬럼명으로 추출
 order by 1;

--    2) ANSI 표준 : inner join은 join으로만 입력하면 됨.
select emp.*, dname
  from emp join dept
    on emp.deptno = dept.deptno
-- where : from on 뒤에 where 작성 가능
 order by 1;
 
-- [ 참고 : 테이블 별칭 사용 ]
-- 테이블 별칭을 사용하는 경우 반드시 컬럼명의 출처 전달 시 테이블 이름이 아닌 별칭 사용
select e.*, dname
  from emp e join dept d
    on e.deptno = d.deptno
 order by 1;

SQL : 국제적 표준 => ANSI 표준
      ORACLE 표준 => 대체적으로 ANSI 표준을 따르나 다른 부분도 있음 ex) Join 함수
;

-- 3개 이상 테이블 조인 예제
-- 예제) STUDENT과 PROFESSOR, DEPARTMENT 테이블을 조인하여
-- 3, 4학년 학생에 대해 각 학생의 이름, 제1전공명,
-- 지도교수 이름을 함께 출력
-- d - s - p 
select s.NAME, s.GRADE, d.DNAME, p.NAME
  from STUDENT s, PROFESSOR p, DEPARTMENT d
 where s.DEPTNO1 = d.DEPTNO
   and s.PROFNO = p.PROFNO
   and s.GRADE in (3,4);
   
-- 똑같은 테이블의 중복 조인 예제
d(deptno) - s(deptno, profno) - p(profno, deptno) - d(deptno)
;

select s.name, s.grade, s.deptno1, d1.dname,
       p.name, p.deptno, d2.dname
  from student s, professor p, department d1, department d2
 where s.profno = p.PROFNO
   and s.deptno1 = d1.deptno
   and p.deptno = d2.deptno
   and s.GRADE in (3, 4);

-- 2) outer join
-- inner join의 반대
-- 조인 조건에 맞지 않는 데이터도 출력 가능
-- 기준이 되는 테이블 방향에 따라
-- 1) left outer join : 왼쪽 테이블 기준
-- 2) right outer join : 오른쪽 테이블 기준
-- 3) full outer join : 양쪽 테이블 기준
  
-- 예제) 각 학생의 이름, 지도교수 이름을 출력하되, 지도교수가 없는 학생까지 전부 출력
-- - 오라클 표준
select s.name as 학생이름,
       p.name as 교수이름
  from STUDENT s, PROFESSOR p
 where s.PROFNO = p.PROFNO(+);    -- 기준이 되는 테이블의 반대쪽에 (+) 표시
 
-- - ANSI 표준
select s.name as 학생이름,
       p.name as 교수이름
  from STUDENT s left outer join PROFESSOR p    -- 모든 학생 정보를 출력하되 지도교수를 맞춰라.
    on s.PROFNO = p.PROFNO; 
  
select s.name as 학생이름,
       p.name as 교수이름
  from PROFESSOR p right outer join STUDENT s    -- 모든 학생 정보를 출력하되 지도교수를 맞춰라.
    on s.PROFNO = p.PROFNO;   
  
-- 예제) STUDNET와 PROFESSOR의 full outer join 수행
select s.name as 학생이름, p.name as 교수이름
  from STUDENT s full outer join PROFESSOR p
    on s.PROFNO = p.PROFNO;

select s.name as 학생이름, p.name as 교수이름
  from STUDENT s, PROFESSOR p
    on s.PROFNO(+) = p.PROFNO(+);    -- Error

-- union으로 full outer join 실행
select s.name as 학생이름, p.name as 교수이름
  from STUDENT s, PROFESSOR p
  where s.PROFNO(+) = p.PROFNO
 union
select s.name as 학생이름, p.name as 교수이름
  from STUDENT s, PROFESSOR p
 where s.PROFNO = p.PROFNO(+);  
 
-- 순환 구조를 갖는 경우의 outer join
-- 예제) 각 학생의 이름, 학년, 지도교수 이름과 지도교수의 소속 학과명을 함께 출력하세요.
s - p(+) - d(+);

s - p(+) - d(+)
|
d;

select s.NAME as 학생이름, s.grade,
       p.name as 교수이름, d.dname
  from STUDENT s, PROFESSOR p, DEPARTMENT d
 where s.PROFNO = p.PROFNO(+)
   and p.DEPTNO = d.DEPTNO(+);

-- 3) self join : 하나의 테이블을 여러번 조인하는 경우
-- 한번의 스캔으로 동시 출력 불가능한 정보를 동일 테이블을 중복 스캔했을 경우 출력 가능한 경우
select e1.empno, e1.ename, e1.mgr, e2.ename
  from emp e1, emp e2
 where e1.mgr = e2.empno;

-- 예제) EMP 테이블을 사용하여 각 직원의 이름, sal, 상위관리자의 이름, sal을 동시 출력 ***
select e1.ENAME as 본인이름,
       e2.ENAME as 상위관리자이름
  from emp e1, emp e2
 where e1.MGR = e2.EMPNO(+);    -- 빈칸 문제 나옴.
 
select e1.ENAME as 본인이름,
       e2.ENAME as 상위관리자이름
  from emp e1, emp e2
 where e2.EMPNO = e1.MGR(+); 
 
-- 2.3 서브쿼리(sub-query) : 쿼리 안의 쿼리
-- ** 뷰 : 테이블처럼 저장공간을 갖진 않지만 테이블처럼 조회가 가능한 (미리보기) 객체
select col1, (select ...)          -- 스칼라 서브쿼리 : 컬럼의 대체
  from tab1, tab2, (select ...)    -- 인라인 뷰 **
 where col1 = (select ...)         -- 서브쿼리
;

-- 예제) EMP 테이블에서 ALLEN보다 SAL이 낮은 사람 출력
select *
  from EMP
 where sal < 1600;

select *
  from EMP
 where sal < (select SAL
                from EMP
               where ename = 'ALLEN');    -- CTRL + L

-- 2.3.1 where 절에 사용되는 서브쿼리
-- 1) 단일행 서브쿼리 : 서브쿼리의 결과가 단일행(한 컬럼)
select *
  from EMP
 where sal > (select SAL
                from EMP
               where ename = 'ALLEN');

-- 예제) ALLEN의 부서와 같은 부서에 속한 직원 정보 출력
select deptno
  from EMP
 where ename = 'ALLEN'

select *
 from EMP
 where deptno = 30;

-- 위 2개를 합친게 아래 쿼리
select *
  from EMP
 where deptno = (select deptno
                   from EMP
                  where ename = 'ALLEN');
                  
-- 2) 다중행 서브쿼리 : 서브쿼리의 결과가 여러행(한 컬럼)
-- where절에 사용되는 연산자에 =, 대소비교 사용 불가 => in 연산자로 대체
                 
-- 예제) 이름이 M으로 시작하는 직원의 연봉보다 높은 직원 출력
-- 단일행 연산자(>)에 맞게 서브쿼리 수정(1개 행 리턴)
select *
  from EMP
 where sal > (select max(sal)    -- avg, min, max / 1300
                from EMP
               where ename like 'M%');    -- 1250, 1300

-- 다중행 서브쿼리에 맞게 연산자 수정(ALL)
select *
  from EMP
 where sal > all(select sal    -- 1300
                   from EMP
                  where ename like 'M%');    -- 1250, 1300
                  
-- > all(1250, 1300) : 둘보다 커야한다 => > 1300 : 최대값 리턴
-- < all(1250, 1300) : 둘보다 작아야한다 => < 1250 : 최소값 리턴
-- > any(1250, 1300) : 둘보다 커야한다 => > 1250 : 최소값 리턴
-- < any(1250, 1300) : 둘보다 작아야한다 => < 1300 : 최대값 리턴
-- all과 any는 현업에서 자주 사용하지 않지만 알아두긴 해야 함.

-- 3) 다중컬럼 서브쿼리 : 서브쿼리 출력 결과가 여러 컬럼
-- 그룹내 대소 비교 불가 => 상호연관, 인라인뷰 대체
-- 예제) EMP 테이블에서 각 부서별 최대 연봉과 함께 각 부서별 최대 연봉을 갖는 직원 이름 출력
select max(sal), deptno
  from EMP
 group by deptno;
 
select *
  from EMP
 where (deptno, sal) in (10, 5000);    -- 이와 같이 콤마로 각각 비교가능 (단, 상수는 안 됨.)
 
select *
  from EMP
 where (deptno, sal) in (select deptno, max(sal)
                           from EMP
                          group by deptno);        
                         
-- 예제) EMP 테이블에서 각 부서별 평균연봉보다 높은 연봉을 받는 직원의 정보 출력
select *
  from EMP
 where (deptno, sal) > (select deptno, avg(sal)
                          from EMP
                         group by deptno);    -- Error => 다중컬럼은 대소비교 안됨.

select *
  from EMP
 where deptno in (select deptno
                   from EMP
                  group by deptno)
   and sal > (select avg(sal)
                   from EMP
                  group by deptno);                 

-- 4) 상호연관 서브쿼리 : 메인쿼리와 서브쿼리의 조건 결합

-- 2.3.2 from절에 사용되는 서브쿼리(인라인뷰)
select *
  from emp e, (select deptno, avg(sal) as avg_sal
                 from EMP
                group by deptno) i
 where e.deptno = i.deptno
   and e.sal > i.avg_sal;                         
                 
-- 2.3.1 where절 서브쿼리
--    1) 단일행 서브쿼리 : =, 대소비교 가능
--    2) 다중행 서브쿼리 : =, 대소비교 불가 => in, any, all
--    3) 다중컬럼 서브쿼리 : 그룹내 동등비교 가능,
--                       그룹내 대소비교 불가 => 인라인뷰
--    4) 상호연관 서브쿼리 : 그룹내 대소비교 가능
-- 예제) EMP 테이블에서 각 job별 최소연봉을 받는 지원의 이름, job, sal 출력
select *
  from EMP
 where job in (select job
                 from EMP
                group by job)    -- 그룹비교로 좋지 않음. why? 무조건 참
   and sal in (select min(sal)
                 from EMP
                group by job);   -- Error x => 그룹 내 비교 발생 X
                
select *
  from EMP e1
 where e1.job = e2.job           -- Error => 서브쿼리를 읽기 전이므로 e2 테이블 못 읽음.
   and job in (select min(sal)
                 from EMP e2
                group by job);

-- 상호연관 서브쿼리의 실행순서 ***
select *
  from EMP e1
 where e1.sal in (select min(sal)
                 	from EMP e2
               	   where e1.job = e2.job    -- 서브쿼리로 이동
               	   group by job);	
                
1) 첫번째 행의 sal 확인 : 800     
2) 서브쿼리로 넘어가서 from -> where절 순으로 읽음
3) where절에서 e1.job 요구 : 메인쿼리로 이동해서 CLERK 읽음
4) 서브쿼리의 where절이 'CLERK' = e2.job 수행    => sal(800)과 CLERK의 최소 sal(800)과 비교 => group by절은 필요 없음.
5) 서브쿼리에서 job이 'CLERK'인 행의 min(sal) 연산 : 800    => CLERK와 e2.job의 모든 행을 비교하므로 중복된 값이 있는 경우 성능에 좋지 않음.
6) 메인쿼리의 where절은 800 = 800이므로 첫번째 행 선택
7) 나머지 행 모두 반복
;  

-- 2.3.2 from절 서브쿼리 (인라인뷰)
-- 2.3.3 select절 서브쿼리 (스칼라 서브쿼리)
-- select절에 사용되는 서브쿼리

-- 1) 하나의 상수를 대체하기 위한 용도
-- 예제) ALLEN의 이름, job, sal, deptno를 출력하되, ALLEN의 부서는 SMITH의 부서와 동일하게 출력
SELECT * FROM emp;

select ename, job, sal, 20 as deptno
  from emp
 where ename = 'ALLEN';
  
select ename, job, sal, 
       (select deptno
          from EMP
         where ename = 'SMITH') as deptno
  from emp
 where ename = 'ALLEN';
 
-- 예제) ALLEN의 이름, job, sal, deptno를 출력하되,
-- ALLEN의 부서는 M으로 시작하는 직원의 부서정보로 출력
select ename, job, sal, 
       (select deptno
          from EMP
         where ename like 'M%') as deptno    -- Error => select절 내 select의 행이 2개 이상이므로
  from emp
 where ename = 'ALLEN'; 

-- 2) join의 대체 연산 (특정 컬럼의 표현)
-- join 조건에 맞지 않는 데이터도 출력 (outer join 대체)

-- [ 참고 : 순환 구조를 갖는 경우의 outer join 연산 ]
--        => 서브쿼리 사용
a - b(+)
|   |
d - c

a(+) - b(+)
|      |       : 순환구조 에러 발생
d(+) - c(+)
 
(a - d) - (b - c)(+) 
;
--------------------------------------------------------------------------------

-- 2.4 INSERT(insert, select, nologging)
insert into 테이블명 values(값1, 값2, ...);
insert into 테이블명(col1, col2, ...)
       values(값1, 값2, ...);
       
insert into emp_bak3 values('hong', 10, 1500, 'a', 'b');
insert into emp_bak3(emp_name, deptno)
       values('kim', 20);
insert into emp_bak3 values('park', 20, 1500, null, null);

insert into emp_bak
select * from emp where deptno = 10;

-- insert into student(studno, name)
--        values(9000, '홍길동');    => not null 컬럼이 4개 있으므로 최소 4개의 데이터는 입력해야 함.
commit;

create table emp_backup as select * from emp;

select 'create table ' || TNAME ||
       '_backup as select * from ' || TNAME || ';'
  from tab
 where TNAME not like '%BAK%';
 
select *
  from tab
 where tname like '%BACKUP';
 
-- 2.6 delete : 행 단위 삭제
delete from 테이블명
 where 조건;    -- 서브쿼리 가능 / 인라인뷰 불가능
 
select * from emp_bak3;
delete from emp_bak3;

select * from emp_bak;
delete from emp_bak
 where empno = 7369;
commit;    -- DML은 commit 쓰지 않으면 저장 안됨, 구조삭제 x, 전체 데이터 삭제 x, 일부행만 남기기 가능

                drop    truncate    delete
                DDL     DDL         DML
즉시 반영       yes     yes         no, commit
구조 삭제       yes     no          no
전체 데이터     yes     no          no
복구가능        yes     삭제기록x   일부 행만 삭제가능, 삭제기록을 남김
저장공간        아예 삭제 / 컬럼명만 놓고 아예 삭제 / 공간만 놔두고 삭제
;

-- 예제) student_bakup 테이블에서 서진수와 학년이 같은 학생 데이터 모두 삭제(서진수 포함)
select * from student_backup;

delete from student_backup
 where grade = (select grade
                  from student_backup
                 where NAME = '서진수');    -- 4학년
                 
rollback;

-- 2.6.1 DML 복구 방법
-- 위의 emp_backup 테이블에서 삭제된 데이터 확인 후 다시 원래대로 복구
-- SOL1) (전체 - 지워진 데이터)를 복구
insert into emp_backup
select *
  from emp_backup as of timestamp
       to_date('2020/07/13 11:00', 'YYYY/MM/DD HH24:MI')    
-- PC에서 자동으로 데이터 스냅샷을 찍어서 변경 기록들을 남겨둠.
-- 대용량 데이터의 경우 저장 안 될수도 있음.
-- DDL이 수행된 시점 이전으로는 스냅샷을 확인할 수 없음.
 minus
select *
  from emp_backup;
  
commit;

select * from emp_backup;

-- SOL2) 전부 삭제 후 복구
delete from emp_backup;
insert into emp_backup
select *
  from emp_backup as of timestamp
       to_date('2020/07/13 11:00', 'YYYY/MM/DD HH24:MI');
       
-- 2.5 update : 수정, 특정 컬럼의 값
update 테이블명
   set 컬럼명 = 수정값(서브쿼리가능)
 where 조건(서브쿼리가능);
 
-- 예제) student_backup 테이블에서 이미경 학생의 키를 160으로 수정;
select * from student_backup;

update student_backup
   set height = 160
 where name = '이미경';

select *
  from student_backup;

-- 예제) student_backup의 아이디를 앞의 4자로 모두 수정
update student_backup
   set id = substr(id, 1, 4);    -- 굳이 서브쿼리 사용하지 않고도 가능

-- 연습문제) student_backup 테이블에서 avg_height 컬럼추가 각 학년의 키 평균값으로 수정
alter table student_backup add avg_height number(8);
select * from student_backup;

update student_backup s1
   set avg_height = (select avg(height)
                        from student_backup s2
                       where s1.grade = s2.grade
                       group by grade);      
                       
-- 2.7 merge    => 빈칸 채우기 시험문제
-- 두 테이블의 병합
-- insert, update, delete가 동시 수행
-- 현업에서는 잘 사용하지 않음.
merge into 변경테이블명
using 참조테이블명
   on 조건    -- 대괄호로 묶기
 when matched then
 update
 when not matched then
 insert / delete;

-- 예제) pt_01 테이블을 pt_02을 참조하여 변경, pt_02에만 있는 데이터는 입력,
--       양쪽에 있는 데이터는 pt_02 기준으로 수정
insert into pt_02 values(12010103, 1003, 1, 400);

merge into pt_01 p1
using pt_02 p2
   on (p1.판매번호 = p2.판매번호)
 when matched then 
update 
   set p1.금액 = p2.금액
 when not matched then
insert values(p2.판매번호, p2.제품번호, p2.수량, p2.금액);

commit;
select * from pt_01;
select * from pt_02;                      