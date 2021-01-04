---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 32. student_backup 테이블에서 각 학년별 키가 가장 큰 학생 데이터를 삭제 후 저장
delete from student_backup
 where (grade, height) in (select grade, max(height)
                             from student_backup
                            group by grade);
commit;                 

-- 연습문제 33. emp_backup 테이블에서 각 부서별 평균연봉보다 작은 연봉을 받는 직원 데이터를 삭제 후 저장

               
select * from emp_backup;

delete from emp_backup e1
  where sal < (select avg(sal)
                 from emp_backup e2
                where e1.deptno = e2.deptno);
commit;

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 34. student_backup 테이블에 성별 컬럼을 추가, 각 학생의 성별을 남, 여로 update
alter table student_backup add gender varchar2(8);
select * from student_backup;

update student_backup
   set gender = decode(substr(jumin, 7, 1), '1', 'male', 'female');

-- 굳이 서브쿼리를 사용한다면,
update student_backup s1
   set gender = (select decode(substr(jumin, 7, 1), '1', 'male', 'female')
                   from student_backup s2
                  where s1.studno = s2.studno);    -- 첫번째 gender에 맞는 첫번째 행을 불러와야 하므로 where절 필요

-- 연습문제 35. professor_backup 테이블에서 각 학과별 평균연봉보다 낮은 연봉을 받는 교수의
--           연봉을 각 학과의 평균연봉으로 수정     
alter table professor_backup add avg_pay number(8);
select * from professor_backup;

update professor_backup p1
   set avg_pay = (select avg(pay)
                    from professor_backup p2
                   where p1.deptno = p2.deptno);
                   
rollback;                   

update professor_backup p1
   set avg_pay = (select avg(pay)
                    from professor_backup p2
                   where p1.deptno = p2.deptno)
 where pay < (select avg(pay)
                from professor_backup p3
               where p1.deptno = p3.deptno);
                              
commit;

---------------------------------- 실 습 문 제 ----------------------------------- 
-- 실습문제 7. 
-- 1) student2 테이블을 만들고 제1의 전공번호가 301인 학생들의 출생년도와 동일한 학생들을 삭제하여라.
create table student2 as select * from student;

select to_char(birthday, 'YYYY'), 
  from student2
 where deptno1 = 301;
 
delete from student2
 where to_char(birthday, 'YYYY') in (select to_char(birthday, 'YYYY')
                                       from student2
                                      where deptno1 = 301);
commit;
 
-- 2) student3 테이블을 만들고 비만여부를 나타내는 컬럼을 새로 추가하고, 각 학생들의 비만정보를 update 하여라.
-- 비만여부는 체중이 표준체중보다 크면 과체중, 작으면 저체중, 같으면 표준으로 분류하여라.
-- *표준체중 = (키-100)*0.9      ***
create table student3 as select * from student;
alter table student3 add fatness varchar2(10);

select * from student3;

select weight, (height - 100) * 0.9 as 표준체중,
       case when weight > (height - 100) * 0.9 then '과체중'
            when weight < (height - 100) * 0.9 then '저체중'
                                               else '표준'
        end as "비만여부"                                       
  from student3;
  
update student3 s1    -- 정답1) 단일 행 하위 질의 문제 날 경우
   set fatness = (select case when weight > (height - 100) * 0.9 then '과체중'
                             when weight < (height - 100) * 0.9 then '저체중'
                                                                else '표준'
                              end as "비만여부"
                   from student3 s2
                  where s1.studno = s2.studno);

update student3 s1    -- 정답2) 굳이 서브쿼리를 사용할 필요없이 케이스문만으로도 가능, 성능도 더 좋음.
   set fatness = case when weight > (height - 100) * 0.9 then '과체중'
                      when weight < (height - 100) * 0.9 then '저체중'
                                                         else '표준'
                  end;
                   
commit;

-- 3) student3 테이블의 주민번호를 아래와 같이 변경. (에러 발생 시 적절한 조치를 취한 후 수정)
-- 751023-1111111
select jumin, substr(jumin, 1, 6) || '-' || substr(jumin, 7)
  from student3;

update student3 
   set jumin = substr(jumin, 1, 6) || '-' || substr(jumin, 7, 7)

alter table student3 modify jumin char(16);
-- char()로 변경하면 Error => substr(jumin, 7)이 공백까지 같이 읽음. => varchar2로 하던가 substr을 변경

commit;

-- 4) emp_back2 테이블을 만들고 각 직원의 연봉을 직원과 각 직원의 상위관리자의 연봉의 평균으로 수정.
-- 단, 상위관리자가 없는 경우는 본인의 연봉의 10% 상승된 값을 상위관리자 연봉으로 취급 ****
create table emp_back2 as select * from emp;

-- My
update emp_back2 e1
   set new_sal = (select trunc(nvl2(e2.sal, ((e1.sal + e2.sal) / 2), ((e1.sal + e1.sal * 1.1) / 2)))
                    from emp_back2 e2
                   where e1.mgr = e2.empno(+));

select * from emp_back2;
rollback;

-- 아래 방식으로도 가능
-- (e1.sal + e2.sal) / 2
-- (e1.sal + nvl(e2.sal, e1.sal * 1.1) / 2
update emp_back2 e1
   set new_sal = (select (e1.sal + nvl(e2.sal, e1.sal * 1.1) / 2)
                    from emp_back2 e2
                   where e1.mgr = e2.empno(+));
                   
-- 위 두 방식 모두 king의 sal이 업데이트 안됨. => 스칼라 서브쿼리처럼 사용해야 함.                 
select e1.ename, e1.sal,
       (select e1.sal + nvl(e2.sal, e1.sal * 1.1) / 2
          from emp_back2 e2
         where e1.mgr = e2.empno)
 from emp_back2 e1;

select e1.sal,    -- 스칼라 서브쿼리의 서브쿼리에 nvl써도 의미 없음. => select절 자체가 하나의 컬럼임.
       (select e2.sal from emp e2 where e1.mgr = e2.empno)
  from emp e1;

select e1.sal,    -- 서브쿼리 자체에 nvl을 넣어주어야 함.
       nvl((select e2.sal from emp e2 where e1.mgr = e2.empno), 5000)
  from emp e1; 

-- 따라서, 아래 느낌으로
select e1.ename, e1.sal,
       nvl((select (e1.sal + e2.sal) / 2
             from emp_back2 e2
            where e1.mgr = e2.empno),
          e1.sal + e1.sal * 1.1 / 2)
  from emp_back2 e1;

-- 정답
update emp_back2 e1
   set new_sal = nvl((select (e1.sal + e2.sal) / 2
                    from emp_back2 e2
                   where e1.mgr = e2.empno(+)),
                     (e1.sal + e1.sal * 1.1) / 2);  
                     
select * from emp_back2;     
commit;
--------------------------------------------------------------------------------

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 36. emp로부터 emp_t1, dept로부터 dept_t1 생성, emp_t1(deptno)
--           -> dept_t1(deptno)의 관계가 되도록 적절한 제약조건을 생성
-- ** CTAS 사용 시 제약조건은 따라오지 않음.
create table emp_t1 as select * from emp;
create table dept_t1 as select * from dept;

alter table dept_t1 add constraint deptt1_deptno_pk
      primary key(deptno);    -- 부모테이블에 먼저 pk 선언
      
alter table emp_t1 add constraint empt1_deptno_fk
      foreign key(deptno) references dept_t1(deptno);    -- 자식테이블을 외래키로 지정

select * from emp_t1;
select * from dept_t1;
commit;

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 37. user_constraints, user_cons_columns 뷰를 join하여 테이블명, 컬럼이름, 제약조건이름,
--           제약조건 종류를 출력하되 제약조건 종류는 다음과 같이 표현 (PK, UK, CHECK, NN, FK) ****
select * from user_constraints;
select * from user_cons_columns;

select c1.table_name, c2.column_name, c1.constraint_name, c1.constraint_type,
       decode(c1.constraint_type, 'P', 'PK',
                                  'U', 'UK',
                                  'R', 'FK',
                                  'C', decode(nullable, 'N', 'NN', 'CHECK'))
       as 제약조건종류
  from user_constraints c1, user_cons_columns c2, user_tab_columns c3
 where c1.constraint_name = c2.constraint_name
   and c2.column_name = c3.column_name
   and c2.table_name = c3.table_name;    -- column만 같으면 조건에 만족하지 않을 수 있음. 컬럼명만 같을 수도 있음.
-- Error => search_condition이 long 타입 => 타입변경도 어려움.
   
---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 38.
-- hr계정에서 scott 테이블 모두 조회 가능하도록 시노님 생성
-- scott계정에서 hr 테이블 모두 조회 가능하도록 시노님 생성

-- system 계정
select *
  from dba_tables
 where owner in ('SCOTT', 'HR');

-- 정답
select 'create or replace public synonym ' ||
       TABLE_NAME || ' for ' || owner || '.' || TABLE_NAME || ';'
  from dba_tables
 where owner in ('SCOTT', 'HR');

select * from hr.regions;
select * from regions;

-- ctrl + M
create or replace public synonym DEPT for SCOTT.DEPT;    -- 혹시 만들어져 있을 수 있으므로 replace 사용
create or replace public synonym EMP for SCOTT.EMP;
create or replace public synonym BONUS for SCOTT.BONUS;
create or replace public synonym SALGRADE for SCOTT.SALGRADE;
create or replace public synonym LOCATIONS for HR.LOCATIONS;
create or replace public synonym PROFESSOR for SCOTT.PROFESSOR;
create or replace public synonym DEPARTMENT for SCOTT.DEPARTMENT;
create or replace public synonym STUDENT for SCOTT.STUDENT;
create or replace public synonym EMP2 for SCOTT.EMP2;
create or replace public synonym DEPT2 for SCOTT.DEPT2;
create or replace public synonym CAL for SCOTT.CAL;
create or replace public synonym GIFT for SCOTT.GIFT;
create or replace public synonym GOGAK for SCOTT.GOGAK;
create or replace public synonym HAKJUM for SCOTT.HAKJUM;
create or replace public synonym EXAM_01 for SCOTT.EXAM_01;
create or replace public synonym P_GRADE for SCOTT.P_GRADE;
create or replace public synonym REG_TEST for SCOTT.REG_TEST;
create or replace public synonym P_01 for SCOTT.P_01;
create or replace public synonym P_02 for SCOTT.P_02;
create or replace public synonym PT_01 for SCOTT.PT_01;
create or replace public synonym PT_02 for SCOTT.PT_02;
create or replace public synonym P_TOTAL for SCOTT.P_TOTAL;
create or replace public synonym DML_ERR_TEST for SCOTT.DML_ERR_TEST;
create or replace public synonym TEST_NOVALIDATE for SCOTT.TEST_NOVALIDATE;
create or replace public synonym TEST_VALIDATE for SCOTT.TEST_VALIDATE;
create or replace public synonym TEST_ENABLE for SCOTT.TEST_ENABLE;
create or replace public synonym PRODUCT for SCOTT.PRODUCT;
create or replace public synonym PANMAE for SCOTT.PANMAE;
create or replace public synonym MEMBER for SCOTT.MEMBER;
create or replace public synonym REG_TEST2 for SCOTT.REG_TEST2;
create or replace public synonym TEST1 for SCOTT.TEST1;
create or replace public synonym PLAN_TABLE for SCOTT.PLAN_TABLE;
create or replace public synonym TEST2 for SCOTT.TEST2;
create or replace public synonym EMP_BAK for SCOTT.EMP_BAK;
create or replace public synonym EMP_BAKUP2 for SCOTT.EMP_BAKUP2;
create or replace public synonym EMP_BAK3 for SCOTT.EMP_BAK3;
create or replace public synonym EMP_BAK5 for SCOTT.EMP_BAK5;
create or replace public synonym STUDENT_BAK for SCOTT.STUDENT_BAK;
create or replace public synonym EMP_BACKUP for SCOTT.EMP_BACKUP;
create or replace public synonym BONUS_BACKUP for SCOTT.BONUS_BACKUP;
create or replace public synonym CAL_BACKUP for SCOTT.CAL_BACKUP;
create or replace public synonym DEPARTMENT_BACKUP for SCOTT.DEPARTMENT_BACKUP;
create or replace public synonym DEPT_BACKUP for SCOTT.DEPT_BACKUP;
create or replace public synonym DEPT2_BACKUP for SCOTT.DEPT2_BACKUP;
create or replace public synonym DML_ERR_TEST_BACKUP for SCOTT.DML_ERR_TEST_BACKUP;
create or replace public synonym EMP2_BACKUP for SCOTT.EMP2_BACKUP;
create or replace public synonym EMP_BACKUP_BACKUP for SCOTT.EMP_BACKUP_BACKUP;
create or replace public synonym EXAM_01_BACKUP for SCOTT.EXAM_01_BACKUP;
create or replace public synonym GIFT_BACKUP for SCOTT.GIFT_BACKUP;
create or replace public synonym GOGAK_BACKUP for SCOTT.GOGAK_BACKUP;
create or replace public synonym HAKJUM_BACKUP for SCOTT.HAKJUM_BACKUP;
create or replace public synonym MEMBER_BACKUP for SCOTT.MEMBER_BACKUP;
create or replace public synonym PANMAE_BACKUP for SCOTT.PANMAE_BACKUP;
create or replace public synonym PRODUCT_BACKUP for SCOTT.PRODUCT_BACKUP;
create or replace public synonym PROFESSOR_BACKUP for SCOTT.PROFESSOR_BACKUP;
create or replace public synonym PT_01_BACKUP for SCOTT.PT_01_BACKUP;
create or replace public synonym PT_02_BACKUP for SCOTT.PT_02_BACKUP;
create or replace public synonym P_01_BACKUP for SCOTT.P_01_BACKUP;
create or replace public synonym P_02_BACKUP for SCOTT.P_02_BACKUP;
create or replace public synonym P_GRADE_BACKUP for SCOTT.P_GRADE_BACKUP;
create or replace public synonym P_TOTAL_BACKUP for SCOTT.P_TOTAL_BACKUP;
create or replace public synonym REG_TEST_BACKUP for SCOTT.REG_TEST_BACKUP;
create or replace public synonym REG_TEST2_BACKUP for SCOTT.REG_TEST2_BACKUP;
create or replace public synonym SALGRADE_BACKUP for SCOTT.SALGRADE_BACKUP;
create or replace public synonym STUDENT_BACKUP for SCOTT.STUDENT_BACKUP;
create or replace public synonym TEST1_BACKUP for SCOTT.TEST1_BACKUP;
create or replace public synonym TEST2_BACKUP for SCOTT.TEST2_BACKUP;
create or replace public synonym TEST_ENABLE_BACKUP for SCOTT.TEST_ENABLE_BACKUP;
create or replace public synonym TEST_NOVALIDATE_BACKUP for SCOTT.TEST_NOVALIDATE_BACKUP;
create or replace public synonym TEST_VALIDATE_BACKUP for SCOTT.TEST_VALIDATE_BACKUP;
create or replace public synonym EMP_BAK2 for SCOTT.EMP_BAK2;
create or replace public synonym STUDENT_BAKUP for SCOTT.STUDENT_BAKUP;
create or replace public synonym STUDENT2 for SCOTT.STUDENT2;
create or replace public synonym STUDENT3 for SCOTT.STUDENT3;
create or replace public synonym EMP_BACK2 for SCOTT.EMP_BACK2;
create or replace public synonym CAFE_PROD for SCOTT.CAFE_PROD;
create or replace public synonym JUMUN for SCOTT.JUMUN;
create or replace public synonym EMP_T1 for SCOTT.EMP_T1;
create or replace public synonym DEPT_T1 for SCOTT.DEPT_T1;
create or replace public synonym CONS_TEST1 for SCOTT.CONS_TEST1;
create or replace public synonym CONS_TEST2 for SCOTT.CONS_TEST2;
create or replace public synonym EMP_T2 for SCOTT.EMP_T2;
create or replace public synonym DEPT_T2 for SCOTT.DEPT_T2;
create or replace public synonym MEMBER2 for SCOTT.MEMBER2;
create or replace public synonym POTENTIAL_MEMBER for SCOTT.POTENTIAL_MEMBER;
create or replace public synonym MEMBER_THIRD for SCOTT.MEMBER_THIRD;
create or replace public synonym MEMBER_FORTH for SCOTT.MEMBER_FORTH;
create or replace public synonym BOARD for SCOTT.BOARD;
create or replace public synonym COUNTRIES for HR.COUNTRIES;
create or replace public synonym EMPLOYEES for HR.EMPLOYEES;
create or replace public synonym REGIONS for HR.REGIONS;
create or replace public synonym JOB_HISTORY for HR.JOB_HISTORY;
create or replace public synonym DEPARTMENTS for HR.DEPARTMENTS;
create or replace public synonym JOBS for HR.JOBS;

---------------------------------- 연 습 문 제 ----------------------------------- 
-- 연습문제 39. 1981년 6월 9일에 입사한 사람 출력 후 각 쿼리의 실행계획 확인 (ctrl + e)
--           단, 입사일은 06/09/1981 형태로 전달

alter session set nls_date_format = 'MM/DD/YYYY';
create index emp_hd_idx on emp(hiredate);

select *
  from EMP
 where hiredate = '06/09/1981';

-- 1) hiredate 컬럼 수정
alter session set nls_date_format = 'YYYY/MM/DD';
select *
  from emp
 where to_char(hiredate, 'MM/DD/YYYY') = '06/09/1981';    -- full access => index 처리한 컬럼엔 함수 넣지 말기

-- 2) '06/09/1981' 수정
select *
  from EMP
 where hiredate = to_date('06/09/1981', 'MM/DD/YYYY');    -- index 사용
 
---------------------------------- 실 습 문 제 ----------------------------------- 
-- 실습문제 8. 
--[ 아래 수행 후 실습 - system 계정에서 수행 ]
create user kic identified by oracle;
grant create session to kic;

--1. 다음을 차례대로 수행
--1) menu_t1 테이블 생성(no, name, price)
create table menu_t1(
no number(10),
name varchar2(16),
price number(15)
);
--2) jumun_t1 테이블 생성(no, product_no, qty, jdate)
create table jumun_t1(
no number(10),
product_no number(10),
qty number(10),
jdate date
);
--3) jumun_t1 테이블의 product_no가 menu_t1 테이블의
--   no를 참조하도록 설정
alter table 테이블명 add (constraint 테이블명_컬럼명_fk) foreign key(컬럼1)    -- 컬럼1을 foreign key라고 부름.
                     references 부모테이블(컬럼2); 
                     
alter table jumun_t1 add constraint jumunt1_productno_fk foreign key(product_no)
                     references menu_t1(no);    -- 부모키 pk 설정 필요

-- 부모 테이블 지우고 다시 생성
drop table menu_t1;                     
create table menu_t1(
no number(10) primary key,
name varchar2(16),
price number(15)
);

alter table jumun_t1 add constraint jumunt1_productno_fk foreign key(product_no)
                     references menu_t1(no);

--4) kic 유저에게 두 테이블을 조회할 권한 부여
grant select on hr.employees to scott;

grant select on scott.jumun_t1 to kic;
grant select on scott.menu_t1 to kic;

select *
  from scott.jumun_t1;

--5) kic 유저가 테이블명만으로 조회하도록 시노님 생성
-- system 계정에서 수행
create public synonym employees for hr.employees;     -- public은 공용
create synonym employees1 for hr.employees;   

create public synonym jumunt1 for scott.jumun_t1;
create public synonym menut1 for scott.menu_t1;

select * from jumunt1;

--6) 1000번부터 시작해서 9999의 값을 갖는 시퀀스를 생성,
--   menu_t1에 데이터 입력
create sequence 시퀀스 이름
increment by n      -- 증가값
start with n        -- 시작값
maxvalue n          -- 최대값, 재시작 시점 (minvalue와 개념 같음)
minvalue n          -- 최소값
-- minvalue 1) 증가값이 (-)일 경우 활용 2) 재시작 시점 : maxvalue, cycle 사용 시 어디부터 시작할지
cycle               -- 순환여부(번호 재사용 여부), maxvalue 사용할 때 유용
cache n             -- 캐싱사이즈
;

-- 3) role(권한의 묶음)을 통한 권한 부여
grant dba to hr;    -- dba가 권한의 묶음

create role test_role;    -- role 권한 만들고
grant select on hr.employees to test_role;    -- role에 권한 넣고
grant test_role to scott;    -- role(권한의 묶음)을 scott에게 전달

grant dba to kic;

create role test_role1;
grant select on scott.jumun_t1 to test_role1;
grant select on scott.menu_t1 to test_role1;

grant test_role1 to kic;

-- system 계정
create sequence test_seq5
increment by 1
start with 1000
maxvalue 9999;

insert into menut1 values(test_seq5.nextval, 'americano', 3000);
insert into menut1 values(test_seq5.nextval, 'latte', 4000);
insert into menut1 values(test_seq5.nextval, 'mocha', 4000);
insert into menut1 values(test_seq5.nextval, 'icecream', 2500);
insert into menut1 values(test_seq5.nextval, 'greentea', 4000);

select * from menut1;

--7) 1번 부터 시작해서 100의 값을 갖는 시퀀스 생성,
--   jumun_t1에 데이터 입력
create sequence test_seq6
increment by 1
start with 1
maxvalue 100;

no number(10), product_no number(10), qty number(10), jdate date;

insert into jumunt1 values(test_seq6.nextval, 1001, 1, '2020/07/01');
insert into jumunt1 values(test_seq6.nextval, 1002, 2, '2020/07/01');
insert into jumunt1 values(test_seq6.nextval, 1003, 4, '2020/07/01');
insert into jumunt1 values(test_seq6.nextval, 1004, 2, '2020/07/01');
insert into jumunt1 values(test_seq6.nextval, 1005, 3, '2020/07/01');

select * from jumunt1;

--8) 두 테이블 조인하여 주문일자, 상품명, 주문수량, 
--   상품가격을 동시 출력하는 뷰 생성
create view menu_jumun
as
select j1.jdate, m1.name, j1.qty, m1.price
  from menut1 m1, jumunt1 j1
 where m1.no = j1.product_no;

--2. 다음을 수행하여라.
create table emp_test1 as select * from emp;
insert into emp_test1 
select * from emp where deptno = 10;

--emp_test1 테이블의 empno에 pk를 생성, 중복된 행을 찾아 제거 후 생성
select * from emp_test1;               

alter table emp_test1 add constraint emptest1_empno_pk primary key(empno);
-------------------------------------------------------------------------------- 