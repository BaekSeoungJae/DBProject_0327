SELECT *
FROM EMP;

-- 부서별 평균 급여 출력하기
SELECT AVG(sal), deptno
FROM emp
GROUP BY DEPTNO;

-- 집합을 사용해서 출력하기
SELECT AVG(sal) FROM emp WHERE DEPTNO = 10
UNION ALL
SELECT AVG(sal) FROM emp WHERE DEPTNO = 20
UNION ALL
SELECT AVG(sal) FROM emp WHERE DEPTNO = 30;

--부서 번호 및 직책별 평균 급여 정렬하기
SELECT DEPTNO, JOB, AVG(sal)
FROM EMP
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, JOB;

-- 부서 코드, 급여 합계, 부서 평균, 부서 코드 순 정렬로 출력하기
SELECT DEPTNO AS "부서 코드",
    SUM(SAL) AS "급여 합계",
    ROUND(AVG(SAL)) AS "급여 평균",
    COUNT(*) AS "인원수"
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- HAVING 절 : GROUP BY 절이 존재 할 때만 사용, GROUP BY 절을 통해 그룹화 된 결과 값의 범위를 제한하는데 사용
SELECT job, AVG(sal)
FROM emp
WHERE DEPTNO = 10
GROUP BY job
    HAVING AVG(sal) >= 2000
ORDER BY job;

-- 1. HAVING 절을 사용하여 부서별 직책의 평균 급여가 500 이상인 사원들의 부서번호, 직책, 부서별 직책의 평균 급여 출력
SELECT DEPTNO, JOB, AVG(SAL)
    FROM EMP
GROUP BY DEPTNO, JOB
    HAVING AVG(SAL) >= 500
ORDER BY DEPTNO, JOB;

-- 2. 부서 번호, 평균 급여, 최고 급여, 최저 급여, 사원수 출력, 단, 평균 급여는 소수점 제외하고 출력하고 부서 번호별 출력
SELECT DEPTNO, TRUNC(AVG(SAL)) AS "평균 급여", 
    MAX(SAL) AS "최고 급여",
    MIN(SAL) AS "최저 급여",
    COUNT(*) AS "사원 수"
FROM EMP
GROUP BY DEPTNO;

-- 3. 같은 직책에 종사하는 사원이 3명 이상인 직책과 인원을 출력
SELECT JOB AS "직업", 
    COUNT(*) AS "사원수"
FROM EMP
GROUP BY JOB
    HAVING COUNT(*) >= 3;

-- 4. 사원들의 입사 연도를 기준으로 부서별로 몇 명이 입사했는지 출력
SELECT TO_CHAR(HIREDATE, 'YYYY') AS "입사일",
       DEPTNO,
       COUNT(*) AS "사원수"
FROM EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY'), DEPTNO
ORDER BY "입사일";
    
-- 5. 추가 수당을 받는 사원 수와 받지 않는 사원수를 출력 (O, X로 표기 필요)
SELECT NVL2(comm, 'O', 'X') AS "추가 수당",
    count(*) AS "사원 수"
FROM EMP
GROUP BY NVL2(comm, 'O', 'X');

-- 6. 각 부서의 입사 연도별 사원 수, 최고 급여, 급여 합, 평균 급여를 출력
SELECT deptno,
    TO_CHAR(hiredate, 'YYYY') AS "입사년도",
    COUNT(*) AS "사원 수",
    MAX(sal) AS "최고 급여",
    ROUND(AVG(sal)) AS "평균 급여",
    SUM(sal) AS "급여 합계"
FROM emp
GROUP BY deptno, TO_CHAR(hiredate, 'YYYY')
ORDER BY deptno, "입사년도";

-- ROLLUP 함수 :
SELECT deptno, job, COUNT(*), MAX(sal), SUM(sal), AVG(sal)
FROM EMP
GROUP BY ROLLUP(DEPTNO, job);

-- 집합 연산자 : 두개 이상의 쿼리 결과를 하나로 결합하는 연산자(수직적 처리)
SELECT empno, ename, job
FROM EMP
WHERE job = 'SALESMAN'
UNION
SELECT empno, ename, job
from emp
where job = 'MANAGER';

-- 조인(JOIN) : 두개 이상의 테이블에서 데이터를 가져와서 연결하는데 사용되는 SQL 기능
-- 테이블 대한 식별 값인 Primary Key와 테이블 간 공통 값인 Foreign Key  값을 사용하여 조인
-- 내부 조인(동등 조인, inner join)이며 오라클 방식, 양쪽에 동일한 컬럼이 있는 경우 테이블 이름을 표시해야 함
SELECT e.empno, ename, mgr, sal, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal >= 3000;
-- ANSI 방식
SELECT EMPNO, ENAME, MGR, e.DEPTNO
FROM EMP e JOIN DEPT d
ON e.DEPTNO = d.DEPTNO
WHERE sal >= 3000;

-- EMP 테이블 별칭을 E로 DEPT 테이블 별칭은 D로 하여 다음과 같이 등가 조인을 했을 때,
-- 급여가 2500 이하이고 사원번호가 9999 이하인 사원의 정보가 출력되도록 작성
SELECT E.EMPNO, E.ENAME, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE sal <= 2500 AND empno <= 9999
ORDER BY EMPNO;

-- 비등가 조인 : 동일한 컬럼이 없을 때 사용하는 조인(일반적으로 많이 사용되지는 않음)
SELECT * FROM EMP;
SELECT * FROM SALGRADE;
SELECT e.ENAME, e.SAL, s.GRADE
FROM EMP e join SALGRADE s
ON e.SAL BETWEEN s.LOSAL AND s.HISAL;

-- 자체 조인 : 현재 테이블을 조인해서 뭔가 결과를 찾아낼때 사용
SELECT e1.EMPNO, e1.ENAME, e1.MGR, 
    e2.EMPNO AS "상관 사원번호",
    e2.ENAME AS "상관 이름"
FROM EMP e1 JOIN EMP e2
ON e1.MGR = e2.EMPNO;

-- 외부 조인 (Left outer join) = 부족한 부분이 있는 행이 있는 테이블에 (+)
SELECT e.ENAME, e.DEPTNO, d.DNAME
FROM EMP e, DEPT d
WHERE e.DEPTNO(+) = d.DEPTNO
ORDER BY e.DEPTNO;

SELECT e.ENAME, e.DEPTNO, d.DNAME
FROM EMP e RIGHT OUTER JOIN DEPT D
ON e.DEPTNO = d.DEPTNO
ORDER BY e.DEPTNO;

-- NATURAL JOIN : 동등 조인을 사용하는 다른 방법, 조건절 없이 사용, 두 테이블의 같은 열을 자동으로 연결
SELECT EMPNO, ENAME, DNAME, DEPTNO
FROM EMP NATURAL JOIN DEPT;

-- JOIN ~ USING : 동등 조인(등가 조인)을 대신하는 방식 중의 하나
SELECT e.EMPNO, e.ENAME, d.DNAME, DEPTNO, e.SAL
FROM EMP e JOIN DEPT d USING(DEPTNO)
WHERE SAL >= 3000
ORDER BY DEPTNO, e.EMPNO;

-- 연습문제 1 : 급여가 2000 초과인 사원들의 부서 정보, 사원 정보 출력
SELECT DEPTNO, DNAME, EMPNO, ENAME, SAL
FROM EMP NATURAL JOIN DEPT
WHERE SAL >= 2000;

-- 연습문제 2 : 부서별 평균, 최대 급여, 최소 급여, 사원 수 출력 (ANSI JOIN)
SELECT d.DEPTNO, d.DNAME,
    ROUND(AVG(SAL)) AS "평균 급여",
    MAX(SAL) AS "최대 급여",
    MIN(SAL) AS "최소 급여",
    COUNT(*) AS "사원 수"
FROM EMP e JOIN DEPT d
ON e.DEPTNO = d.DEPTNO
GROUP BY d.DEPTNO, d.DNAME;

-- 연습문제 3 : 모든 부서 정보와 사원 정보를 부서번호, 사원 이름순으로 정렬해서 출력
SELECT d.DEPTNO, d.DNAME, e.EMPNO, e.ENAME, e.JOB, e.SAL
FROM EMP e RIGHT OUTER JOIN DEPT d
ON e.DEPTNO = d.DEPTNO
ORDER BY d.DEPTNO, e.ENAME;
