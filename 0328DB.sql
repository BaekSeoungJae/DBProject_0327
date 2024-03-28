-- 서브쿼리 : 쿼리문 내에 포함되는 쿼리문을 의미, 일반적으로 SELECT 문의 WHERE 절에서 사용
-- 단일행 서브쿼리와 다중행 서브쿼리가 있음
SELECT dname
FROM DEPT
WHERE DEPTNO = (SELECT DEPTNO 
                FROM emp
                WHERE ename = 'KING');

SELECT * 
FROM EMP
WHERE SAL > (SELECT SAL FROM EMP WHERE ENAME = 'JONES');

-- 서브 쿼리를 사용하여 EMP 테이블 사원 정보 중에서
-- 사원 이름이 ALLEN인 사원의 추가 수당 보다 많은 추가 수당을 받는 사원 정보를 구하도록 코드 작성

SELECT * 
FROM EMP
WHERE COMM > (SELECT COMM FROM EMP WHERE ENAME = 'ALLEN');

-- 단일행 서브쿼리
SELECT *
FROM EMP
WHERE HIREDATE < (SELECT HIREDATE FROM EMP
                    WHERE ENAME = 'JAMES');
                    
SELECT e.EMPNO, e.ENAME, e.JOB, e.SAL, d.DEPTNO, d.DNAME, d.LOC
FROM EMP e JOIN DEPT d
ON e.DEPTNO = d.DEPTNO
WHERE e.DEPTNO = 20
AND e.SAL > (SELECT AVG(SAL) FROM EMP);

-- 실행 결과가 여러개인 다중행 서브쿼리
-- IN : 메인 쿼리의 데이터가 서브쿼리의 결과 중 하나라도 일치한 데이터가 있으면 true
-- ANY, SUM : 메인 쿼리의 조건식을 만족하는 서브 쿼리의 결과가 하나 이상이면 true
-- ALL : 메인 쿼리의 조건식을 서브쿼리의 결과 모두가 만족하면 true
-- EXIST : 서브 쿼리의 결과가 존재하면 true
SELECT * FROM EMP
WHERE SAL IN (SELECT MAX(SAL)
                FROM EMP
                GROUP BY DEPTNO);
                
SELECT empno, ename, sal
FROM emp
WHERE sal > ANY(SELECT SAL FROM EMP WHERE JOB = 'SALESMAN');

SELECT empno, ename, sal
FROM emp
WHERE sal = ANY(SELECT SAL FROM EMP WHERE JOB = 'SALESMAN');

-- ALL : 다중행으로 반환되는 서브 쿼리의 결과를 모두 만족해야 true
SELECT * FROM EMP
WHERE SAL < ALL(SELECT SAL FROM EMP WHERE DEPTNO = 30);

SELECT empno, ename, sal
FROM EMP
WHERE sal > ALL(SELECT SAL FROM EMP WHERE JOB = 'MANAGER');

-- SCOTT 삽입
INSERT INTO EMP VALUES
        (7788, 'SCOTT', 'ANALYST', 7566,
        TO_DATE('09-12-1982', 'DD-MM-YYYY'), 3000, NULL, 20);

SELECT * FROM EMP
WHERE EXISTS(SELECT dname FROM dept WHERE DEPTNO = 10); 

-- 다중열 서브쿼리 : 서브쿼리의 결과가 두개 이상의 컬럽으로 반환되어 메인 쿼리에 전달
SELECT empno, ename, sal, deptno
FROM emp
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, SAL FROM EMP
                        WHERE DEPTNO = 30);

SELECT * FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL)
                        FROM EMP
                        GROUP BY DEPTNO);

-- FROM 절에서 사용하는 서브쿼리 : 인라인뷰라고 부름
-- 테이블 내에 데이터 규모가 너무 크거나 특정 열만 제공해야 하는 경우 사용
SELECT e10.empno, e10.ename, e10.deptno, d.dname, d.loc
FROM (SELECT empno, ename, deptno FROM EMP WHERE DEPTNO = 10) e10 JOIN DEPT d
ON e10.DEPTNO = D.DEPTNO;

-- SELECT 절에 사용하는 서브 쿼리 : 스칼라 서브 쿼리라고 부름
-- SELECT 절에 사용되는 서브 쿼리는 반드시 하나의 결과만 반환 되어야 함
SELECT empno, ename, job, sal, 
            (SELECT grade FROM SALGRADE
            WHERE e.sal BETWEEN losal AND hisal) AS SALGRADE, deptno,
            (SELECT dname FROM DEPT d
            WHERE e.DEPTNO = d.DEPTNO) AS DNAME
FROM EMP e;

-- 매 행마다 부서번호가 각 행의 부서번호와 동일한 사원들의 SAL 평균을 구해서 반환
SELECT ename, deptno, sal, (SELECT TRUNC(AVG(SAL)) FROM emp
                            WHERE deptno = e.deptno) AS "부서별 급여 평균"
FROM EMP e;

SELECT empno, ename, 
            CASE WHEN deptno = (SELECT deptno FROM dept WHERE loc = 'NEW YORK')
                THEN '본사'
                ELSE '분점'
            END AS 소속
FROM EMP
ORDER BY 소속 DESC;

-- DECODE : 주어진 데이터 값이 조건 값과 일치하는 값을 출력하고 일치하지 않으면 기본 값 출력
SELECT empno, ename, job, sal,
    DECODE(job,
        'MANAGER', sal * 1.1,
        'SALESMAN', sal * 1.05,
        'ANALYST', sal,
        sal * 1.03) AS "급여 인상"
FROM EMP;
-- CASE 문 :
SELECT empno, ename, job, sal,
    CASE job
        WHEN 'MANAGER' THEN sal * 1.1
        WHEN 'SALESMAN' THEN sal * 1.05
        WHEN 'ANALYST' THEN sal
        ELSE sal * 1.03
    END AS "급여 인상"
FROM emp;

-- 연습문제 1. 전체 사원 중 ALLEN과 같은 직책(JOB)인 사원들의 사원 정보, 부서 정보를 다음과 같이 출력하는 SQL문을 작성하세요.
SELECT e.empno, e.ename, e.sal, e.job, e.deptno, d.dname
FROM EMP e, DEPT d
WHERE e.deptno = d.deptno
    AND JOB = (SELECT JOB FROM EMP WHERE ENAME = 'ALLEN');

-- 연습문제 2. 전체 사원의 평균 급여(SAL)보다 높은 급여를 받는 사원들의 사원 정보, 부서 정보, 급여 등급 정보를 
-- 출력하는 SQL문을 작성하세요(단 출력할 때 급여가 많은 순으로 정렬하되 급여가 같을 경우에는 사원 번호를 기준으로 오름차순으로 정렬하세요).

-- 연습문제 3. 10번 부서에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원들의 사원 정보, 부서 정보를 다음과 같이 출력하는 SQL문을 작성하세요.

-- 연습문제 4. 직책이 SALESMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원들의 사원 정보, 급여 등급 정보를 다음과 같이 출력하는 SQL문을 작성하세요
-- (단 서브쿼리를 활용할 때 다중행 함수를 사용하는 방법과 사용하지 않는 방법을 통해 사원 번호를 기준으로 오름차순으로 정렬하세요).


        