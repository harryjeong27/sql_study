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

-- 1.4Truncate : 객체 비우기
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

-- [ 중급 1. DDL(Data Definition Language) ]
-- 객체의 정의 언어
-- 객체 생성(create), 변경(alter), 삭제(drop)
-- 객체 비우기(truncate)
-- Create Table : 객체 생성 
-- Alter Table : 객체 변경 
-- Drop Table : 객체 삭제 
-- Truncate : 객체 비우기 
-- Cascade 

-- 1.1 create : 테이블 및 객체 생성
create table test2(
col1    varchar2(10) not null,
col2    number(10)
);

-- ** 테이블명은 다른 객체 이름과 중복될 수 없지만 유저가 다르면 중복된 테이블명을 사용할 수 있음
scott.emp
hr.emp
;

-- 테이블 복사하기
-- (CTAS : Create Table As Select)
create table emp_bak
as
select *
  from emp;

select * from emp_bak;

create table emp_bak2
as
select *
  from emp
 where DEPTNO = 10;

create table emp_bak3
as
select ename AS emp_name, deptno, sal
  from emp;

select * from emp_bak3;

create table emp_bak4
as
select to_char(empno) AS empno, ename AS emp_name, 
       deptno, sal
  from emp;
  
desc emp_bak4;

-- 빈 테이블 생성하기(구조만 복사)
create table emp_bak5
as
select * 
  from emp
 where 1=2;  -- 항상 거짓조건 전달, no date selected

select * from emp_bak5;

desc emp_bak5;

create table STUDENT_bak
as
select * from STUDENT;
desc STUDENT;

-- 다음 중 CTAS로 복제되지 않는 대상은? 5
-- 1. 컬럼이름
-- 2. 컬럼순서
-- 3. 컬럼타입
-- 4. 널여부
-- 5. 제약조건

-- DDL : auto commit (실행 시 즉시 반영, rollback 불가)
-- 1.1 create : 테이블 생성
-- 1.2 alter : 생성된 테이블 변경
--            (컬럼추가, 컬럼 삭제, 컬럼 데이터 타입 변경,
--            컬럼 not null 여부 변경, 컬럼 default값 변경)

-- 2-1) 컬럼 추가 : 맨 뒤에 컬럼 추가
alter table EMP_BAK2 add DEPTNO2 number(5);
alter table EMP_BAK2 add (DEPTNO3 number(5),
                          DEPTNO4 number(5));
alter table EMP_BAK2 add DEPTNO5 number(5) default 10;

-- 2-2) 컬럼 삭제 : 데이터 복원 불가
alter table EMP_BAK2 drop column DEPTNO4;
select * from EMP_BAK2;           
desc EMP_BAK2;

-- 2-3) 컬럼 데이터 타입 변경
alter table EMP_BAK2 modify ENAME VARCHAR2(15); 
--=> column size 늘리기 가능

alter table EMP_BAK2 modify ENAME VARCHAR2(1); 
--=> column size를 저장된 데이터 사이즈보다 작게 불가
  
alter table EMP_BAK2 modify ENAME VARCHAR2(6); 
--=> 저장된 데이터 사이즈보다 큰 사이즈로 줄이기 가능

alter table EMP_BAK2 modify ENAME number(10); 
--=> 컬럼이 비어있지 않으면 서로 다른 타입으로 변경 불가

alter table EMP_BAK2 modify deptno2 varchar2(10); 
--=> 빈컬럼은 데이터 타입 변경 가능

select max(lengthb(ename))
  from emp;
  
-- 2-4) 컬럼 이름 변경  
alter table EMP_BAK2 rename column deptno2 to deptno22;

-- 2-5) 테이블명 변경(객체명 변경)
rename EMP_BAK2 to EMP_BAKUP2;

-- 2-6) default 값 생성 및 변경 
-- 컬럼 생성 시 default값 선언, 생성 시점에 값 할당
-- default : 값이 지정되지 않으면 자동으로 부여
-- default 지정 이후 입력된 데이터에 대해 부여
alter table EMP_BAK3 add (col1 varchar2(10),
                          col2 varchar2(10) default 'a');

alter table EMP_BAK3 modify col1 default 'b';    -- 처음에 하지 않으면 입력 안됨.

insert into EMP_BAK3 values('HONG', 10, 3000, NULL, NULL);    -- 추가된 데이터는 입력 됨.
insert into EMP_BAK3(EMP_NAME, DEPTNO, SAL)
            values('PARK', 20, 4000);
            
select * from emp_bak3;

commit;

-- [ 참고 : read only, read write ]
insert into EMP_BAK4 values(9000, 'kim', 30, 5000);
commit;

alter table EMP_BAK4 read only;
insert into EMP_BAK4 values(9001, 'park', 20, 5000);
-- 수정(insert,update,delete) 불가

alter table EMP_BAK4 add col1 number(4);
-- alter로 구조 변경 불가

drop table EMP_BAK4;
-- 테이블 삭제 가능 => 구조 삭제, 전체 데이터 삭제

-- 1.3 drop : 테이블 삭제(객체 삭제)
-- 삭제된 테이블은 휴지통에서 복구 가능
-- purge 옵션으로 삭제된 테이블은 복구 불가

-- [ 참고 : drop으로 삭제된 테이블의 복구 ]
select * from user_recyclebin;  -- 휴지통

select * from EMP_BAK4;  -- 조회 x

flashback table "BIN$x7B+A/YbTNic/qmo07vtew==$0"
to before drop;

select * from EMP_BAK4; -- 조회 o

-- 1.4 truncate : 테이블 구조 남기고 데이터 전체 삭제
alter table EMP_BAK4 read write;
truncate table EMP_BAK4;

select * from EMP_BAK4; -- 조회 o, 데이터 없음

--------------------------------------------------------------------------------

-- [ 중급 4. TCL(Transaction Control Language) ]
-- COMMIT
-- ROLLBACK
-- SAVEPOINT
[ commit / rollback 시점 ]
update 1
delete 2
commit 3 
insert 4
savepoint A
update 5
savepoint B
delete 6
1. rollback    -- commit 직후로 돌아감 => insert 이전
2. rollback to savepoint B    -- B시점으로 돌아감 => 6번만 취소
-- 현업에서는 각 행 후에 commit 넣어줌.
;
--------------------------------------------------------------------------------

-- [ 중급 5. 데이터 딕셔너리 ]
-- DBMS가 자동으로 관리하는 테이블 및 뷰
-- 주로 객체에 대한 변경 내용 및 성능, 보안과 관련된 정보를 기록
-- 5.1 static dictionary view : 객체 관련
-- 1) dba_XXX
-- - DBA 권한을 갖는 유저 조회 가능, 모든 객체정보 저장
-- 2) all_XXX
-- - 조회 유저 소유 혹은 권한이 있는 객체 정보출력
-- 3) user_XXX
-- - 조회 유저 소유의 객체 정보만 출력
select * from user_tables;    -- scott 소유 테이블
select * from all_tables;     -- scott 소유 + scott에 권한이 부여된 테이블
select * from dba_tables;     -- system 계정에서 조회가능
 
-- [ 유용한 딕셔너리 뷰 ] 
select * from user_indexes;        -- 인덱스 정보
select * from user_ind_columns;    -- 인덱스 컬럼정보
select * from user_constraints;    -- 제약조건 정보
select * from user_cons_columns;   -- 제약조건 컬럼정보
select * from user_tab_columns;    -- 테이블의 컬럼정보
select * from user_views;          -- 뷰 정보
select * from user_users;          -- user 정보

-- 5.2 dynamic performance view : 성능 관련
-- - v$XXX
-- dba 권한 혹은 각 뷰의 조회 권한이 있어야 함.
select * from v$session;    -- 현재 데이터베이스 내 존재하는 모든 세션에 대한 정보
select * from v$sql;
--------------------------------------------------------------------------------

-- [ 중급 6. 제약조건(constraint) ] ***
-- 데이터의 무결성(데이터의 결점이 없음)을 위해 생성하는 오브젝트
-- 각 컬럼마다 제약조건을 생성할 수 있음.
-- 6.1 unique : 중복값 허용 x ex) 주민번호
-- 6.2 not null : null값 허용 x
-- 6.3 primary key(기본키) : 각 행의 유일한 식별자 / 2개 생성 불가
--    unique + not null 제약조건의 형태
-- 6.4 check : 정해진 특정 값으로 입력 제한
-- 6.5 foreign key : 특정 테이블의 컬럼을 참조

-- 6.0 제약조건 생성
-- 1) 테이블 생성 시
create table 테이블명(
컬럼1 데이터타입 primary key,
컬럼2 데이터타입 references 모테이블(컬럼3));    -- 자식테이블에 외래키를 만듦.

create table cons_test1(
    no   number primary key,
    name varchar2(10) not null);
    
insert into cons_test1 values(1, '김길동');
insert into cons_test1 values(1, '홍길동');    -- Error => 식별자는 중복, null일 수 없음. (unique + not null)

create table cons_test2(
    no   number constraint test2_no_pk primary key,    -- constraint + 제약조건명(테이블명_컬럼명_제약조건)
    name varchar2(10) not null);

insert into cons_test2 values(1, '김길동');
insert into cons_test2 values(1, '홍길동');    -- Error => 위에서 작성한 제약조건명의 이름으로 오류 발생 => 오류 원인 찾기 쉬움.

-- 2) 이미 만들어진 테이블에 제약조건 추가
alter table 테이블명 add (constraint 테이블명_컬럼명_fk) foreign key(컬럼1)    -- 컬럼1을 foreign key라고 부름.
                     references 부모테이블(컬럼2);    -- 컬럼2를 reference key라고 부름.
                     
-- 예제) jumun 테이블과 cafe_prod테이블을 만들고 jumun 테이블의 product_no 컬럼이 
--       cafe_prod 테이블의 상품번호(no)를 참조하도록 테이블을 설계하라.
-- cafe_prod : no, name, price
-- jumun : jumun_no, qty, product_no
흐름상 cafe_prod가 부모테이블;

create table cafe_prod(
no      number,
name    varchar2(10),
price   number);

create table jumun(
jumun_no    number,
qty         number,
product_no  number references cafe_prod(no));
-- Error => foreign key의 전제조건 : 부모테이블의 reference key는 pk or uk 제약 필요

drop table cafe_prod;    -- 지우고 다시 만들기

create table cafe_prod(
no      number primary key,    -- reference key 전제조건
name    varchar2(10),
price   number);

create table jumun(
jumun_no    number,
qty         number,
product_no  number references cafe_prod(no));    -- 정상작동

alter table emp_backup 
      add constraint emp_empno_pk primary key(empno);

alter table emp_backup
      add unique(ename);     -- 이미 중복값이 있다면 불가
            
alter table emp_backup
      add not null(job);    -- Error => not null만 추가 불가
 
alter table emp_backup
      add constraint emp_job_nn not null(job);    -- Error => not null만 추가 불가 
 
alter table emp_backup
      modify job not null;    -- modify로 바꿔야 함. / 이미 null이 많다면 not null 불가
      
desc emp_backup;
select * from emp_backup; 

-- unique 조건 걸려있는 테이블에 null값 들어갈 수 있는지? unique에는 가능
insert into emp_backup(empno, ename, job)
       values(7000, null, 'CLERK');

-- primary key 2개 생성할 수 있는지? 같은 테이블에 불가능
alter table emp_backup 
      add constraint emp_empno_pk primary key(ename);    -- Error => 하나의 테이블에 2개 생성 불가       
 
alter table emp_backup
      add constraint emp_empno_pk
          primary key(empno, ename);    -- 여러개 컬럼을 조합하여 한개의 pk를 만들 수 있음.
[ 참고 - 여러 개 컬럼을 조합하여 하나의 pk를 만드는 경우 ]
일자          창고
20200710        a
20200710        b
20200711        a;
          
-- 6.5 foreign key ex) student 테이블의 deptno 컬럼
-- 부모, 자식과의 관계를 갖는 자식 테이블에 설정
-- 참조대상(부모)의 컬럼을 reference key라고 함. ex) dept 테이블의 deptno 컬럼

-- 예제) emp 테이블에 50번 부서에 속하는 홍길동 행 추가
insert into emp(empno, ename, deptno)
       values(1000, '홍길동', 50);    -- Error => reference key가 없음.

-- 예제) emp 테이블에 SMITH 부서번호를 50으로 수정
update emp 
   set deptno = 50
 where ename = 'SMITH';    -- Error => reference key가 없음.

-- 예제) dept 테이블에 10번 부서 정보 삭제
delete from dept
 where deptno = 10;    -- Error => foreign key 발견
-- 자식 데이터가 있는 상태로 부모 데이터 삭제는 불가

자식테이블(emp)         부모테이블(dept)
         deptno   ->    deptno
    (foreign key)       (reference key)

insert, update 제약     delete 제약
                        pk or uk 제약 필요
;

-- 6.5.1 foreign key <-> reference key의 컬럼 삭제
-- reference key를 삭제하려면 (컬럼삭제)
-- 1) foreign key 컬럼을 먼저 삭제 후 삭제
-- 2) cascade constaints 옵션을 사용한 삭제 (foreign key는 남기고 싶은 경우)
alter table dept_t1 drop column deptno;    -- 불가
alter table dept_t1
      drop column deptno cascade constraints;    -- 가능 : 부모자식 관계를 끊고 (cascade constraints), 삭제

-- 6.6 제약조건 조회 뷰
-- 1) user_constraints (제약조건 컬럼 정보 없음)
select CONSTRAINT_NAME,   -- 제약조건 이름
       CONSTRAINT_TYPE,    -- C : CHECK OR NN, P: PK, U : UK, R : FK
       SEARCH_CONDITION,   -- C의 종류를 알 수 있음.
       TABLE_NAME,        -- 테이블명
       R_CONSTRAINT_NAME  -- 참조제약조건 이름 : reference key에 걸려있는 제약조건의 이름
  from user_constraints;
-- 해당 테이블의 정보만 들어있고, 다른 테이블의 정보는 없음.
-- => mgr - empno 문제처럼 selfjoin으로 상대테이블의 정보확인가능  

insert into dept2 values(1001, 'abc', 1000, 'abc');
-- Error => 무결성 제약조건 SYS_C0011049에 위배됩니다.

select CONSTRAINT_NAME,   
       CONSTRAINT_TYPE,   
       SEARCH_CONDITION, 
       TABLE_NAME,       
       R_CONSTRAINT_NAME  
  from user_constraints
 where constraint_name = 'SYS_C0011049';    -- 어떤 컬럼에 pk가 걸려있다는 것만 알 수 있음.

-- 2) user_cons_columns(제약조건 컬럼 정보 있음)
select *
  from user_cons_columns
 where CONSTRAINT_NAME = 'SYS_C0011049';    -- DCODE에 pk가 걸려있음.

insert into dept2 values(2001, 'abc', 1000, 'abc');
rollback;
-- 1), 2) join해서 동시 확인

select decode(nullable, 'N', 'NN', 'CHECK')
  from user_tab_columns;

user_constraints    user_cons_columns   user_tab_columns
table_name          table_name          table_name
constraints_name    constraints_name    column_name
                    column_name
;                    

-- 아래처럼 컬럼명만 같을 수 있음 => 같은 테이블 내로 제한해야 함.
cons_columns        tab_columns
A col1              A col1
A col2              B col2
;

-- 테이블명, 컬럼명, 제약조건 이름, 종류, 부모테이블명, reference key 조회
select * from user_constraints;
select * from user_cons_columns;

c3 - c1 - c2(+) - c4(+);

user_constraints    user_cons_columns
fk_deptno           fk_deptno  deptno
;

select c1.table_name as "테이블명(자식테이블)",
       c3.column_name as 컬럼명,
       c1.constraint_name as 제약조건이름,
       c1.constraint_type as 제약조건종류,
       c2.table_name as 부모테이블명,
       c4.column_name as "reference key"
  from user_constraints c1, user_constraints c2,
       user_cons_columns c3, user_cons_columns c4
 where c1.r_constraint_name = c2.constraint_name(+)
   and c1.constraint_name = c3.constraint_name
   and c2.constraint_name = c4.constraint_name(+);

select c1.table_name, c2.column_name, c1.constraint_name, c1.constraint_type,
       decode(c1.constraint_type, 'P', 'PK',
                                  'U', 'UK',
                                  'R', 'FK',
                                  'C', decode(nullable, 'N', 'NN', 'CHECK'))
       as 제약조건종류,
       c4.table_name as reference_table,
       c2.column_name as reference_key -- user_constraints의 r_constraints_name 사용하여 테이블명과 컬럼명 추출가능
  from user_constraints c1, user_cons_columns c2, user_tab_columns c3, user_constraints c4
 where c1.constraint_name = c2.constraint_name
   and c2.column_name = c3.column_name
   and c2.table_name = c3.table_name
   and c1.r_constraint_name = c4.constraint_name(+);
   
-- 6.5.2 foreign key 생성 옵션
자식테이블    - 부모 테이블
foregin key     reference key

1. on delete cacade : 부모 데이터 삭제 시 자식 데이터 함께 삭제
2. on delete set null : 부모 데이터 삭제 시 자식 데이터에서 null로 업데이트, 부모테이블에서는 삭제
;

create table emp_t2 as select * from emp;
create table dept_t2 as select * from dept;

alter table dept_t2 add constraint deptt2_deptno_pk
                    primary key(deptno);

-- case 1) foreign key 옵션 없이 생성 시 delete
alter table emp_t2 add constraint empt2_deptno_fk
      foreign key(deptno) references dept_t2(deptno);
      
delete from dept_t2 where deptno = 10;    -- Error => 무결성 제약조건 오류 (자식이 있기에 부모 삭제 불가)

-- case 2) on delete cascade 옵션으로 생성 시 delete
alter table emp_t2 drop constraint empt2_deptno_fk;    -- 제약조건 삭제

alter table emp_t2 add constraint empt2_deptno_fk
      foreign key(deptno) references dept_t2(deptno)
      on delete cascade;
      
delete from dept_t2 where deptno = 10;    -- 가능, 10번 부서 데이터 함께 삭제      
select * from emp_t2;

rollback;

-- case 3) on delete set null 옵션으로 생성 시 delete
alter table emp_t2 add constraint empt2_deptno_fk
      foreign key(deptno) references dept_t2(deptno)
      on delete set null;

delete from dept_t2 where deptno = 10;    -- 가능, 10번 부서 데이터만 null로 수정
select * from emp_t2;
select * from dept_t2;

-- [ 참고 : 테이블 및 컬럼 comment 조회 및 부여하기 ]
-- 1) 조회
select *
  from all_tab_comments;    -- 테이블 설명

select *
  from all_col_comments;    -- 컬럼 설명  

-- 2) comment 부여
comment on column 테이블명 is 설명;
comment on column 테이블명.컬럼1 is 설명;

comment on column emp_t2 is 'emp test table';
comment on column emp_t2.empno is '사원번호';

-- DDL_예제문제 1
-- purge : 휴지통에 담기지 않고 바로 삭제
-- 1) member2 테이블 생성
create table member2(
USERID varchar2(10),
USERNAME varchar2(10),
PASSWD varchar2(10),
IDNUM varchar2(13),
PHONE number(13),
ADDRESS varchar2(20),
REGDATE date,
INTEREST varchar2(15)
);

-- 2) 회원 정보 입력 => Q.전화번호 입력 => 데이터 타입 변경, 날짜는 to_date 활용
insert into member2
       values('sunshinLee', '이순신', 'ssl000', '8701011120200', 023332123, '서울', '2015/07/05', '컴퓨터');

-- 3) 테이블 복사
create table member_second as select * from member2;

-- 4) 테이블과 특정컬럼만 복사
create table member_third as select userid, username, passwd from member2;

-- 5) 테이블 구조만 복사
create table member_forth as select * from member2 where 0 = 1;

-- 6) 컬럼 추가
alter table member2
        add email varchar2(50);
        
-- 7) 컬럼 추가 및 default 지정
alter table member2
        add country varchar2(50) default 'Korea';
        
-- 8) 컬럼 삭제
alter table member2
       drop column email;
       
-- 9) 컬럼 데이터 크기 변경
alter table member2
      modify address varchar2(30);
      
-- 10) 테이블명 변경
rename member_second to potential_member;

select * from member2;

-- DDL 예제문제 2
-- 1) 제약조건 추가
alter table member2
        add constraint member2_userid_pk primary key(userid);    -- Q. NN, U까지 추가 가능? 아니면 포함? 포함!
alter table member2
      modify userid not null;
alter table member2
      modify passwd not null;   
alter table member2
        add constraint member2_idnum_uk unique(idnum);
        
-- 2) 테이블 및 무결성 제약조건 생성
create table board(
NO number(4) constraint board_no_pk primary key,
SUBJECT varchar2(50) constraint board_subject_nn not null,
CONTENT varchar2(100),
RDATE date,
USERID varchar2(10) constraint board_userid_fk references member2(userid)
);

-- 3) 두 테이블 참조, 무결성 제약조건을 위반하지 않는 데이터 3건씩 입력
select * from member2;
select * from board;

insert into member2
values('seongho', '정성호', 'coll0813', '9008131063611', 0236634767, '서울', '2020/07/05', '노트북', 'KOREA');
insert into member2
values('seongh', '정성호', 'coll0813', '9008131063611', 0236634767, '서울', '2020/07/05', '노트북', 'KOREA');
insert into member2
values('seong', '정성호', 'coll0813', '9008131063611', 0236634767, '서울', '2020/07/05', '노트북', 'KOREA');

--------------------------------------------------------------------------------------------------------------

-- [ 기타 1. 오브젝트 ]
-- 1.1 뷰
-- 실제 저장공간을 갖지 않고 특정 쿼리의 결과를 출력
-- 뷰를 테이블처럼 조회 가능
-- 단순뷰(테이블 한개) / 복합뷰(여러 테이블)
-- 1) 생성
create [or replace] view
as
subquery;

-- system 계정에서 아래 수행
grant dba to scott;

-- 리세션(재접속) 후 scott 계정에서 뷰 생성
-- 단순뷰
create view emp_view1
as
select empno, ename    -- 서브쿼리
  from emp;
  
create or replace view emp_view1    -- 처음 생성이면 그냥 생성, 기존에 있다면 대체
as
select empno, ename, sal    -- 서브쿼리
  from emp;  

select *
  from emp_view1;    -- 뷰를 실행하면 자동으로 위 서브쿼리를 실행
-- 사용시기 : 테이블명을 알려주기 싫을때 뷰 사용 (원본 데이터 보호차원)

-- 복합뷰 => 데이터 수정 어려움.
create view student_hakjum
as
select s.studno, s.name, e.total, h.grade
  from student s, exam_01 e, hakjum h
 where s.studno = e.studno
   and e.total between h.min_point and h.max_point;

-- 2) 뷰 조회
select * from user_views;    -- TEXT 컬럼에 서브쿼리가 그대로 있음.

-- 3) 뷰를 통한 원본 테이블 수정
update emp_view1
   set ename = 'smith'
 where ename = 'SMITH';
 
select * from emp;
rollback;

-- 4) 뷰 삭제
drop view emp_view1;

-- 1.2 시퀀스
-- 연속적인 번호의 자동 부여 ex) 은행 대기번호표, 주문번호
-- 시퀀스만 가능한건 아님.
-- 1) 생성
create sequence 시퀀스 이름
increment by n      -- 증가값
start with n        -- 시작값
maxvalue n          -- 최대값, 재시작 시점 (minvalue와 개념 같음)
minvalue n          -- 최소값
-- minvalue 1) 증가값이 (-)일 경우 활용 2) 재시작 시점 : maxvalue, cycle 사용 시 어디부터 시작할지
cycle               -- 순환여부(번호 재사용 여부), maxvalue 사용할 때 유용
cache n             -- 캐싱사이즈
;

-- [ sequence를 사용한 자동 번호 부여 test ]
-- 1) sequence 생성
-- rollback 되지 않음.
-- 1-1) test1
create sequence test_seq1
increment by 1
start with 100
maxvalue 110
;

-- 1-2) test2
create sequence test_seq2
increment by 1
start with 100
maxvalue 110
minvalue 100
cycle
cache 2
;

-- 1-3) test3 : no가 100이 아니라 101부터 나오는 이유
-- 테이블 생성 -> 저장공간 바로 부여하지 않고 테이블만 생성 -> 테이블에 무언가 넣을 경우 저장공간 생성
-- 따라서, 처음 만든 테이블의 경우 100번 넣었을때 거절당하고 저장공간 생성되고 101번으로 들어가게 됨.
-- defered table segment
create sequence test_seq3
increment by 1
start with 100
maxvalue 110
minvalue 100
cycle
cache 2
;

-- 2) test table 생성
-- 2-1) test1
create table jumun1(
no   number,
name varchar2(10),
qty  number
);

-- 2-2) test2
create table jumun2(
no   number,
name varchar2(10),
qty  number
);

-- 3) sequence를 사용한 데이터 입력
-- 3-1) test1 : nocycle로 생성 시 insert 여러번 반복 => max를 초과하는 순간 에러 발생
--    해당 sequence 사용 불가
insert into jumun1 values(test_seq1.nextval, 'latte', 2);
select * from jumun1;

-- 3-2) test2 : cycle 생성 시 insert 여러번 반복 => maxvalue 초과하는 순간 minvalue값  사용
--    해당 sequence 계속 사용 가능
insert into jumun2 values(test_seq2.nextval, 'latte', 2);
select * from jumun2;
rollback;

-- 3-3) test3
insert into jumun2 values(test_seq3.nextval, 'latte', 2);
select * from jumun2;

-- 4) sequence 현재 번호 확인
-- 4-1)
select test_seq1.nextval
  from dual;

select *
  from user_sequences;    -- TEST_SEQ1 of LAST_NUMBER : 111 => maxvalue 초과

-- 4-2) 정상적인 상황에서 sequence 현재 번호 확인
select test_seq2.currval
  from dual;

select *
  from user_sequences;    -- LAST_NUMBER는 cache 사이즈까지 반영된 번호

-- cache : 허용하는 동시 접속자 수
-- 장점 : 동시 접속자 수 들어와 빠른 데이터처리
-- 단점 : 높은 cache 지정했다가 꺼지게되면 cache 포함된 번호까지 날라감.
-- ex) 은행 번호표 순서대로 vs 5개씩

-- 1.3 시노님 : 광범위하게 사용 가능한 테이블 별칭
-- 1) 생성
create [or replace] [public] synonym 별칭명
        for 테이블명;
       
create synonym emp_test for emp;
select * from emp_test;

-- scott 계정에서 수행
select * from employees;    -- Error

-- system 계정에서 수행
-- scott에게 hr의 employees 테이블 조회 권한 부여
grant select on hr.employees to scott;

-- scott 계정에서 수행
select * from employees;    -- Error => 본인 소유가 아닌데 타 계정에서 조회 시 풀네임 써야 함.
select * from hr.employees;

-- system 계정에서 수행
create public synonym employees for hr.employees;     -- public은 공용
create synonym employees1 for hr.employees;           -- private(생략가능)은 생성자만 사용 (system 계정)

-- scott 계정에서 수행
select * from employees;
select * from employees1;    -- 생성자만 사용 (system 계정)

-- 2) 조회
select *
  from user_synonyms;
  
select *
  from all_synonyms
 where table_name = 'EMPLOYEES';

-- 3) 삭제(system 계정에서 수행)
drop synonym employees1;
drop public synonym employees;  

-- 1.4 index
-- index : 데이터의 위치값을 기록해놓은 오브젝트
-- 사용자들이 많이 찾고자 하는 컬럼으로 index 하기 like pk column
-- primary data로 하면 자동으로 index 됨.
select *
  from emp
 where empno = 7369;    -- 7369까지 모든 데이터를 순서대로 검색함 => 오래 걸림.

select rowid, empno     -- rowid : 열 주소 (유일한 값)
  from emp;             -- 7369의 주소를 찾아서 읽어줌 => 빠름

select hiredate, rowid
  from emp
 order by 1; 

-- 1) 생성
create index 인덱스명 on 테이블명(컬럼명);

create index emp_hd_idx on emp(hiredate);

-- FBI(Function Based INDEX)
-- 예제) 1981년에 입사한 사람을 출력하는 쿼리 작성 후 인덱스 스캔이 가능하게 하라.
-- index supressing : 인덱스가 제대로 스캔되지 않았다. (by 묵시적 형변환 in this case)
select *
  from emp
 where to_char(hiredate, 'YYYY') = 1980;
-- 꼭 이 상태로 쿼리를 만들어야 한다면? to_char(hiredate, 'YYYY') 모양으로 index 만들면 됨.
 
create index emp_hd_fbi
       on emp(to_char(hiredate, 'YYYY'));

select *
  from emp
 where to_char(hiredate, 'YYYY') = '1980';  -- 문자로 바꾸어야 index 됨. otherwise to_number 자동으로 씌어짐.

-- 2) index의 장점
select *
  from emp
 where hiredate = '1981/06/09';
 -- ctrl + e : INDEX (RANGE SCAN => 인덱스만 색인
 --            cost = 2와 cost = 1이 있는데 cost = 1이 더 효율적이라 이렇게 진행

drop index emp_hd_idx;
select *
  from emp
 where hiredate = '1981/06/09';    -- ctrl + e : TABLE ACCESS (FULL) => 전체 데이터 검색
--------------------------------------------------------------------------------

-- [ 중급 3. DCL(Data Control Language) ]
-- GRANT
-- REVOKE
-- 권한(대체적으로 관리자 계정으로 수행)
-- 3.1 부여
-- 1) 오브젝트 권한 (오브젝트마다 권한 전달)
grant 권한명 to 유저명;
grant select on scott.emp to hr;
grant select on scott.dept to hr;
grant select on scott.sal to hr;
grant select on scott.deptno to hr;

-- 2) 시스템 권한
-- 위와 같이 하나씩 다 써야하는 문제 해결
grant create view to hr;

-- 3) role(권한의 묶음)을 통한 권한 부여
grant dba to hr;    -- dba가 권한의 묶음

create role test_role;    -- role 권한 만들고
grant select on hr.employees to test_role;    -- role에 권한 넣고
grant test_role to scott;    -- role(권한의 묶음)을 scott에게 전달

select * from emp;

-- 3.2 회수
revoke 권한명 from 유저명;
-------------------------------------------------------------------------------- 