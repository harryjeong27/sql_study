-- [ 기초 1. 이것저것 ]

-- [ orange 단축키 ]
-- sql 실행 : ctrl + enter
-- sql문 재배치 : 드래그 후 ctrl + shift + f
-- 파일열기 : ctrl + o
-- 대문자 변경 : ctrl + shift + u
-- 소문자 변경 : ctrl + u

-- 1.1 테이블 레이아웃 확인
-- 테이블 : 행과 열의 구조를 갖는 데이터의 저장 단위
-- * : 전체라는 의미
desc emp;

-- [ 확인 가능 정보 ]
-- 1) 컬럼명/컬럼순서
-- 2) null(아직 정의되지 않은 상태) 여부 ex) NOT NULL : 반드시 값이 들어가야 함.
-- 3) 데이터 타입/크기
--   - NUMBER(4) : 4자리 숫자
--   - VARCHAR2(9) : 9바이트 가변형 문자 (최대 9바이트지만 실제 크기에 맞게 변형) ex) 'abcde'
--   - CHAR(9) : 9바이트 고정형 문자 (항상 9바이트) ex) 'abcde    '
--   - DATE : 날짜

-- [ 참고 ]
-- 문자 > 숫자
-- 문자 : 숫자 삽입 가능, 문자로 인식
-- 숫자 : 문자 삽입 불가능

-- 1.2 distinct : 행 중복 제거, select 뒤에 한번만 사용가능
select distinct DEPTNO
  from emp;
  
select distinct JOB, DEPTNO    -- 두 값 모두 같은 경우만 중복 제거
  from emp;
  
select *
  from employees;    -- hr 계정에서 조회가능
  
select empno, 1000, 'a'    -- 표현식 : 문자/날짜는 항상 ''와 함께 사용해야 인식
  from emp;

-- 1.3 컬럼 별칭(Alias) : as는 생략가능하나 보통 넣음.
select empno as "사원 번호",    -- 띄어쓰면 읽지 못하므로 쌍따옴표 넣어줌.
       ename "사원이름!",       -- 특수기호를 읽지 못하므로 쌍따옴표 넣어줌.
       sal "Salary"           -- 대문자 읽지 못하므로 쌍따옴표 넣어줌.
  from emp;
  
-- 1.4 연결연산자(||) : 서로 분리되어진 칼럼을 하나로 합침.

select empno || '-' || ename
  from emp;
  
select concat(empno, ename)    -- 연결연산자와 달리 함수 인자에 3개를 넣을 수 없음.
  from emp;
  
select concat(concat(empno, '-'), ename)    -- 함수는 2번 사용하지 않도록 한다.
  from emp;

-- 예제) 다음과 같은 형식으로 출력
-- SMITH의 연봉은 800입니다.
select ename || '의 연봉은 ' || sal || '입니다.'
  from emp
 WHERE ename = 'SMITH';

select *
  from emp
 where DEPTNO = 10;
 
-- 1.5 조건의 형태 : 대상(칼럼) 연산자 상수
  
-- 예제) emp 테이블에서 ALLEN의 이름, 부서번호, 연봉을 출력
select lower(ename), DEPTNO, sal
  from emp
 where lower(ename) = 'allen';
-- 문법에서는 대소문자 구문하지 않지만 데이터 내에는 대소문자 구분함.
-- 'allen'쓰면 검색 안됨. lower 함수(<-> upper)로 소문자로 바꿔주면 검색 됨.
 
select ename, DEPTNO, sal
  from emp
 where upper(ename) = 'ALLEN';

-- 예제) emp 테이블에서 sal이 2000이상인 직원의 이름, 부서번호, sal, comm 출력
select ename, deptno, sal, comm
  from emp
 where sal >= 2000; 
 
select ename, deptno, sal, comm
  from emp
 where sal >= 2000
   and deptno = 10; 

select ename, deptno, sal, comm
  from emp
 where sal >= 2000
    or deptno = 10; 
    
-- 1.6 update / delete / insert / merge 뒤에는 commit이 필요

-- 1.7 between A and B : A와 B사이 반환
-- A와 B는 포함, A가 더 작은 값이어야 함.
select *
  from EMP
 where sal between 1300 and 2000;
 
-- 1.8 in : 포함연산자, 여러 값과 일치하는 행을 리턴
 select *
   from student
  where GRADE in (1, 2);

select *
  from student
 where NAME in ('이윤나', '김진욱');
 
-- 1.9 null 조건
select *
  from EMP
 where COMM is null;
 
select *
  from EMP
 where COMM is not null;
 
-- 1.10
-- like : 패턴 연산자
-- % : 자리수 제한 없는 모든
-- _ : 한 자리수 모든

-- 예제) emp 테이블에서 이름이 S로 시작하는 직원 출력
select *
  from EMP
 where ename like 'S%';
 
-- 예제) student 테이블에서 이름의 두번째 글자가 '진'인 학생 정보 출력
select *
  from student
 where name like '_진_';
 
-- 1.11 부정 연산자
 select *
   from student
  where grade != 4;
  
-- 예제) student 테이블에서 3, 4학년이 아닌 학생
select *
  from student
 where grade != 3
   and grade != 4;
   
select *
  from student
 where grade not in (3, 4);
 
-- 예제) student에서 몸무게가 50 ~ 60이 아닌 학생 출력
select *
  from student
 where weight not between 50 and 60;

select ename, sal, sal * 1.1 AS "10% 인상된 연봉"
  from emp
 where sal * 1.1 <= 3000;
 
--------------------------------------------------------------------------------
-- [ 기초 2. 날짜 상수의 전달 ]
alter session set nls_date_format = 'RR/MM/DD';    -- 해당 세션(하나의 오렌지 창) 내 모든 날짜 포맷을 동일하게
-- 저장된 날짜 포맷 : 'YY/DD/DD'
-- 출력 날짜 포맷 : 'YYYY/MM/DD HH24:MI:SS'
-- 오렌지 툴에서는 저정된 날짜 포맷을 바꾸지는 못함 => CMD에서는 바뀜.
select *
  from emp
 where hiredate = '1980/12/17 00:00:00';    -- 해당 쿼리는 불가능

select *
  from emp
 where hiredate = '1980/12/17';

select *
  from emp
 where hiredate = '80/12/17';
 
-- 1980/12/17일 이후에 입사한 사원 출력
select *
  from emp
 where hiredate > '1980/12/17';
  
select *
  from emp
 where to_char(hiredate, 'YYYY/MM/DD HH24:MI:SS') > '1980/12/17 00:00:00';  

-- alter session set nls_date_format = 'RR/MM/DD'; 
-- '78/01/01' => '1978/01/01'로 인식
-- alter session set nls_date_format = 'YY/MM/DD'; 
-- '78/01/01' => '2078/01/01'로 인식
--------------------------------------------------------------------------------
  
-- [ 기초 3. 함수 ]
-- 함수란 : input value에 따라 output value가 달라지는 input과 output의 관계를 정의한 객체

-- 단일행 함수 : 1개의 input이 1개의 output return
-- 복수행 함수(그룹함수) : 여러 개의 input이 1개의 output return
select ename, lower(ename)
  from emp; 
  
select sum(sal)
  from emp;

-- 3.1 문자함수
-- 3.1.1 대소치환함수 : initcap, upper, lower => 단일행 함수
select 'abc def', initcap('abc def')
  from dual;    -- dual : 함수 테스트용 범인테이블
  
-- 3.1.2 substr : 문자열 추출 함수  
-- substr(대상, 추출위치, 추출개수)
select 'abcde',
       substr('abcde', 1, 2),
       substr('abcde', 3, 1),
       substr('abcde', 3)
  from dual;
     
-- 예제) emp 테이블에서 두번째 이름이 M인 직원 추출
select *
  from EMP
 where ename like '_M%';

select *
  from EMP
 where substr(ename, 2, 1) = 'M';

-- 3.1.4 length : 문자열의 길이 출력
-- 한글 1글자는 2Byte
select ename, length(ename)
  from emp;
  
select name,
       length(name) as "글자 수",
       lengthb(name) as "Byte size"
  from student;     
       
-- 3.1.5 lpad, rpad : 문자열의 삽입 (왼쪽, 오른쪽)
-- lpad(대상, 총길이[, 삽입문자])
select 'abcd',
       lpad('abcd', 5, '!'),
       rpad('abcd', 5, '!'),
       length(rpad('abcd', 5))    -- 4자리인데 5자리 입력하면 공백 삽입되어 5자리
  from dual;

-- 3.1.6 ltrim, rtrim, trim : 문자열의 제거
-- ltrim(대상[, 제거할 문자])
select 'ababa',
       ltrim('ababa', 'a'),
       rtrim('ababa', 'a'),
       rtrim('ababaaa', 'a'),       -- a 삭제하다가 다른 문자 나오면 멈춤.
       length(rtrim('ababa ')),     -- 제거할 문자가 공백이면 공백 제거.
       length(trim('     ababa '))  -- 양쪽 공백 제거.
  from dual;

-- [ 참고 : 테스트 - 문자열에 불필요한 공백 삽입 시 조회되지 않음 ]
-- 현업에서 매우 많이 발생하는 경우이므로 trim 활용해서 공백 반드시 체크하기
create table test1(col1 varchar2(5),
                   col2 char(5));
insert into test1 values('ab', 'ab');
commit;    -- 데이터 저장 명령어

select length(col1), length(col2)
  from test1
 where col1 = col2;    -- 각각 'ab' 'ab   '로 저장되어 조회되지 않음.
 
select *
  from test1
 where col1 = trim(col2);

-- 3.1.7 replace : 치환함수
-- replace(대상, 찾을 문자열, 바꿀 문자열)
select 'abcba',
       replace('abcba', 'ab', 'AB'),
       replace('abcba', 'ab', 'abx'),
       replace('abcba', 'ab', '12345'),
       replace('abcba', 'c', ''),
       replace('ab c  ba', ' ', '')
  from dual;
  
-- 3.1.8 translate : 치환함수(번역)
-- translate(대상, 찾을 문자열, 바꿀 문자열)
select 'abcba',
       replace('abcba', 'ab', 'AB'),
       translate('abcba', 'ab', 'AB'),    -- 각각 글자를 하나씩 치환 ex) a를 A로 b를 B로
       translate('1abcba', '1ab', '1'),    -- 1은 1로, a와 b는 삭제 (찾을 문자열이 더 크면 삭제)
       translate('abcba', 'ab', 'ABC')   -- a는 A로, b는 B로, C는 무시됨. (바꿀 문자열이 더 크면 무시)
  from dual;
  
-- 3.2 숫자 함수
-- 3.2.1 round : 반올림
-- 3.2.2 trunc : 내림
select '1234.56',
       round(1234.56, 1),    -- 소수점 두번째에서 반올림
       round(1234.56),       -- 소수점 첫번째에서 반올림
       trunc(1234.56, 1)     -- 소수점 두번째에서 내림
       round(1234.56, -3)    -- 백의 자리에서 반올림
  from dual;
  
select ename, sal, trunc(sal * 1.15) as "15% 인상된 SAL"
  from emp;
  
-- 3.2.3 mod : 나머지
select 7/3,
       trunc(7 / 3) as 몫,
       mod(7, 3) as 나머지
  from dual;
  
-- 3.2.4 floor :
-- 3.2.5 ceil :
select 2.33,
       floor(2.33) as "값보다 작은 최대 정수",
       ceil(2.33) as "값보다 큰 최소정수"
  from dual;
-- 3.2.6 abs : 절대값
select -2.3,
       abs(-2.3)
  from dual;

-- 3.2.7 sign : 부호판별
select sign(1.1),
       sign(-1.1),
       sign(0)
  from dual;

-- 3.3 날짜 함수
-- 3.3.1 sysdate : 현재날짜 및 시간
select sysdate
  from dual;

select sysdate + 100    -- 일수
  from dual;

select ename, trunc(sysdate - hiredate) as 근무일수
  from emp; 
  
-- 3.3.2 months_between : 두 날짜 사이 개월 수 리턴
select ename, hiredate,
       sysdate - hiredate as 근무일수,
       months_between(sysdate, hiredate) as 근무월수,
       trunc((sysdate - hiredate) / 365) as 근속년수,
       trunc(months_between(sysdate, hiredate) / 12) as 근속년수2
  from emp;

select sysdate,
       sysdate + 3 * 31,     -- 부정확한 3개월 뒤 날짜
       add_months(sysdate, 3) -- 정확한 3개월 뒤 날짜
  from dual;
  
-- 3.3.3 next_day : 바로 뒤에 오는 특정 요일의 날짜 리턴
-- 1 : 일요일, 2 : 월요일, ...
select sysdate,
       next_day(sysdate, 1),
       next_day(sysdate, '월'),
  from dual;

alter session set nls_date_language = 'american';
select sysdate,
       next_day(sysdate, 1),
       next_day(sysdate, 'mon')    -- 기본 포맷이 다르기 때문에 조회가 안 됨.
  from dual;

alter session set nls_date_format = 'MM/DD/YYYY';
select sysdate from dual;    -- 2020/07/02 14:22:13 => 툴 내에서는 출력 포맷을 바꾸지는 않음. (<-> CMD에서는 출력 포맷도 바뀜.)

-- 3.3.4 last_day : 해당 날짜가 속한 달의 마지막 날짜 리턴
select sysdate,
       last_day(sysdate)
  from dual; 
  
-- 3.4 변환함수 : 데이터의 타입을 변환
-- 3.4.1 to_char : 문자가 아닌 값을 문자로 변환
--    1) 숫자 -> 문자
--       1000 -> 1,000
--       1000 -> $1000
--    2) 날짜 -> 문자
--       1981/06/09 -> 06
--       1981/06/09 -> 81-06-09
select 1000,
       to_char(1000, '9,999'),
       to_char(1000, '999.99'),    -- #######
       to_char(1000, '9999.99'),
       to_char(1000, '99999'),     -- ' 1000'
       to_char(1000, '09999'),     -- '01000'
       to_char(1000, '$9,999'),
       to_char(1000, '9,999') || '\'
  from dual;

-- 2020/07/02 15:19:13 => 07/02/2020
select sysdate,
       to_char(sysdate, 'MM/DD/YYYY')    -- 문자이므로 숫자와 연산 불가
  from dual;
  
-- 예제) EMP 테이블에서 1981년 2월 22일에 입사한 사람 출력
select *
  from EMP
 where to_char(hiredate, 'YYYY/MM/DD') = '1981/02/22';

select *
  from EMP
 where hiredate = '1981/02/22';

select *
  from EMP
 where hiredate = to_char('1981/02/22', 'RR/MM/DD');
-- Error => to_char의 첫번째 인수는 문자 불가
 
-- 3.4.2 to_number : 숫자가 아닌(숫자로 변경 가능한) 값을 숫자로 변경
-- 3.4.3 to_date : 날짜가 아닌 값을 날짜로 변환(파싱)
select to_date('2020/06/30', 'YYYY/MM/DD') + 100    -- 이렇게 변경이 아니라 해석하라는 의미 => 오렌지 포맷으로 출력됨.
  from dual;

select to_date('09/07/2020', 'MM/DD/YYYY'),
       to_date('09/07/2020', 'DD/MM/YYYY')
  from dual;

select *
  from EMP
 where hiredate = to_date('1981/02/22', 'YYYY/MM/DD');    -- 상수를 날짜로 변경 -> 진짜 날짜와 비교 -> 포맷이 달라도 알아서 비교해서 조회함.

select *
  from student
 where to_char(birthday, 'MM') = '06';

SELECT * FROM student;

ALTER TABLE student RENAME COLUMN userid TO ID;
ALTER TABLE student RENAME COLUMN IDNUM TO JUMIN;
ALTER TABLE student RENAME COLUMN birthdate TO birthday;
COMMIT;

-- 3.4 변환함수
-- 3.4.1 to_char
--    1) to_char(숫자, 숫자포맷)
--    2) to_char(날짜, 날짜포맷)
select sysdate,
       to_char(sysdate, 'Day'),      -- 요일
       to_char(sysdate, 'month'),    -- 월
       to_char(sysdate, 'year'),     -- 년도
       to_char(sysdate, 'ddth'),     -- 일의 서수표현
       to_char(sysdate, 'ddspth'),   -- 일의 영문 서수표현
       to_char(sysdate, 'q')         -- 분기
  from dual;

select '91/12/24', 
       to_date('91/12/24', 'YY/MM/DD'),   -- 2000년대
       to_date('91/12/24', 'RR/MM/DD')    -- 1900년대
  from dual;
  
 
SELECT deptno, count(*) FROM student
 GROUP BY deptno
 HAVING count(*) > 4; 
 
-- 3.4.2 to_date
--    1) to_date(문자, 날짜포맷)
select '12/05/20',
       to_date('12/05/20', 'MM/DD/YY')   -- 포맷만 변경, 출력 변경 x
  from dual;

--    2) to_date(숫자, 날짜포맷)
select 120520,
       to_date(120520, 'MM/DD/YY')      -- 숫자도 변경은 가능
  from dual;     
  
-- 3.4.3 to_number(문자)
select '1' + 1,
       to_number('1') + 1    -- 묵시적 형 변환 : 잘못 쓴 내용에 대해 자동으로 처리. '1' (문자) + 1 (숫자)는 불가능
  from dual;

-- ** 묵시적 형 변환이 발생하는 경우 (성능저하)
select *
  from STUDENT
  where to_char(birthday, 'MM') = 12;    -- 이렇게 수행하면 자동으로 to_number(to_char(birthday, 'MM')) = 12; 가 됨 => 느려짐.

select *
  from STUDENT
 where STUDNO = 9411;    -- where절 사용할 경우 데이터의 목차를 만들고 최대한 빠르게 색인을 하게 되는데, 함수를 쓰면 변형되어 느려짐. => 최대한 함수 덜 쓰고 오른쪽 상수를 변경하기.

-- 예제) 형 변환이 필요한 경우 
select trunc(sysdate - to_date('2020/06/30', 'YYYY/MM/DD')) || '일'
  from dual;

select to_char(3) || '일'    -- 문자열을 필요로 하는 경우
  from dual;                 -- 표현식에 to_char 사용
  
-- 3.5 일반함수
-- 3.5.1 decode : if문(조건문)의 축약형태

-- [ 보통의 조건문 ]
-- if 조건 then 치환
--         else 치환
-- if deptno = 10 then '총무부'
--                else '재무부'
-- => decode(deptno, 10, '총무부', '재무부')
-- 성능이 그렇게 좋지는 않아, decode(decode())는 잘 쓰지 않음.

-- 예제) emp 테이블에서 10번 부서는 총무부, 20번 재무부, 30번은 인사부로 리턴
select deptno, decode(deptno, 10, '총무부', 20, '재무부', 30, '인사부', '기타부서') as 부서명
  from emp;
  
-- 3.5.2 case : 조건문
-- [ case 기본 문법 ]
-- case when 조건1 then 리턴1
--      when 조건2 then 리턴2
--                 else 리턴3   -- else 생략 시 NULL 리턴
-- end

-- 예제) 위 deptno를 활용한 부서명 출력
select deptno,
       case when deptno = 10 then '총무부'
            when deptno = 20 then '재무부'
                             else '인사부'
        end as 부서명
  from emp;

-- [ case 축약 문법 - equal 비교일때만 ]
-- case 대상 when 상수1 then 리턴1
--           when 상수2 then 리턴2
--                      else 리턴3   -- else 생략 시 NULL 리턴
-- end

select deptno,
       case deptno when 10 then '총무부'
                   when 20 then '재무부'
                           else '인사부'
        end as 부서명
  from emp; 
  
-- 3.5.3 null 치환 : nvl, nvl2
-- nvl(대상, 치환값)
-- nvl2(대상, null이 아닐 때 치환값, null일 때 치환값)

-- 예제) emp 테이블에서 사원이름, sal, comm값 출력
-- 단, 현재 comm이 정해지지 않은 사원은 기본으로 100부여
select ename, sal, comm,
       nvl(comm, 100) as new_comm
  from emp;
  
select ename, sal, comm,
       nvl(comm, ' ') as new_comm    -- 공백은 타입이 다르므로 들어갈 수 없음.
  from emp;  
  
select ename, sal, comm,
       nvl(comm, 0) as new_comm      -- 0은 가능
  from emp;    
  
-- 예제) emp 테이블에서 사원이름, sal, comm값 출력
-- 단, 현재 comm이 정해지지 않은 사원은 기본으로 500부여  
-- comm이 있는 직원은 10% 이상
select ename, sal, comm,
       nvl2(comm, comm * 1.1, 500) as new_comm
  from emp;
  
-- [ nvl 사용 시 주의사항 ]
-- nvl(대상, 치환값) : 대상과 치환값이 하나의 컬럼으로 표현되므로 서로 같은 데이터 타입 요구
select ename, sal, comm,
       nvl(comm, '보너스 없음')    -- comm 칼럼은 숫자이기 때문에 안 됨. 하나의 행에는 같은 포맷만 가능
  from emp;

select ename, sal, comm,
       nvl(to_char(comm), '보너스 없음')    -- 해결책 : comm 칼럼을 문자로 바꿔서 적용
  from emp;
  
select nvl('abc', 1)    -- 리턴 데이터타입은 문자 (문자열에는 숫자 들어감.)
  from dual;

select nvl(1, 'abc')    -- 앞에 데이터타입 따라가는데 숫자에는 문자 못 넣음.
  from dual;

-- [ nvl2 사용 시 주의사항 ]
-- nvl2(대상, 치환1, 치환2) : 치환1, 치환2가 같은 컬럼에 있으므로 데이터타입 일치해야 함.
select comm,
       nvl2(comm, '보너스 있음', '보너스 없음')
  from emp;

select comm,
       nvl2(comm, '보너스 있음', 0)    -- 치환1의 데이터타입 따라가는데 문자이므로 숫자가 들어감. (<-> 숫자에 문자는 안됨.)
  from emp; 
  
-- 3.5.4 그룹함수(복수행함수) : 여러 개 행이 input, 하나 또는 그룹별 하나 output
-- sum, count, avg, min, max
select SAL
  from EMP;
  
select sum(sal)
  from emp;
  
select deptno, sum(sal)
  from emp
 group by deptno;

select deptno, max(sal), ename    -- 그룹으로 묶은 상태에서 단일행에 대한 정보를 불러올 순 없음.
  from EMP
 group by deptno;
 
select deptno, max(sal), hiredate
  from EMP
 group by deptno;

-- group by절에 명시되지 않은 컬럼은 select절에 단독으로 사용할 수 없음.
-- (그룹정보와 개별정보는 함께 표현 불가능) 

-- 3.5.4 그룹함수
-- 1) sum
select sum(sal), sum(comm)
  from emp;

-- 2) count : 행의 개수 (NULL은 카운트 하지 않음.)
select count(*),      -- 전체 컬럼 카운트 => 전체 컬럼이 NULL일 수는 없으므로 가장 정확한 행의 수 리턴, but 느림.
       count(empno),  -- 절대 NULL이 들어가지 않을 컬럼을 찾아서 조회하는게 가장 빠름 by using DESC
       count(comm)
  from emp;

-- 3) avg
select avg(comm),        -- NULL 제외 후 평균 연산 (4명의 평균)
       sum(comm) / count(comm),    -- avg 수행결과와 동일
       sum(comm) / 14,    -- 14명(전체)의 평균
       avg(nvl(comm, 0))    -- 14명(전체)의 평균
  from emp;
  
-- 4) min, max
select min(comm), max(comm)
  from emp;