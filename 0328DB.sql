-- �������� : ������ ���� ���ԵǴ� �������� �ǹ�, �Ϲ������� SELECT ���� WHERE ������ ���
-- ������ ���������� ������ ���������� ����
SELECT dname
FROM DEPT
WHERE DEPTNO = (SELECT DEPTNO 
                FROM emp
                WHERE ename = 'KING');

SELECT * 
FROM EMP
WHERE SAL > (SELECT SAL FROM EMP WHERE ENAME = 'JONES');

-- ���� ������ ����Ͽ� EMP ���̺� ��� ���� �߿���
-- ��� �̸��� ALLEN�� ����� �߰� ���� ���� ���� �߰� ������ �޴� ��� ������ ���ϵ��� �ڵ� �ۼ�

SELECT * 
FROM EMP
WHERE COMM > (SELECT COMM FROM EMP WHERE ENAME = 'ALLEN');

-- ������ ��������
SELECT *
FROM EMP
WHERE HIREDATE < (SELECT HIREDATE FROM EMP
                    WHERE ENAME = 'JAMES');
                    
SELECT e.EMPNO, e.ENAME, e.JOB, e.SAL, d.DEPTNO, d.DNAME, d.LOC
FROM EMP e JOIN DEPT d
ON e.DEPTNO = d.DEPTNO
WHERE e.DEPTNO = 20
AND e.SAL > (SELECT AVG(SAL) FROM EMP);

-- ���� ����� �������� ������ ��������
-- IN : ���� ������ �����Ͱ� ���������� ��� �� �ϳ��� ��ġ�� �����Ͱ� ������ true
-- ANY, SUM : ���� ������ ���ǽ��� �����ϴ� ���� ������ ����� �ϳ� �̻��̸� true
-- ALL : ���� ������ ���ǽ��� ���������� ��� ��ΰ� �����ϸ� true
-- EXIST : ���� ������ ����� �����ϸ� true
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

-- ALL : ���������� ��ȯ�Ǵ� ���� ������ ����� ��� �����ؾ� true
SELECT * FROM EMP
WHERE SAL < ALL(SELECT SAL FROM EMP WHERE DEPTNO = 30);

SELECT empno, ename, sal
FROM EMP
WHERE sal > ALL(SELECT SAL FROM EMP WHERE JOB = 'MANAGER');

-- SCOTT ����
INSERT INTO EMP VALUES
        (7788, 'SCOTT', 'ANALYST', 7566,
        TO_DATE('09-12-1982', 'DD-MM-YYYY'), 3000, NULL, 20);

SELECT * FROM EMP
WHERE EXISTS(SELECT dname FROM dept WHERE DEPTNO = 10); 

-- ���߿� �������� : ���������� ����� �ΰ� �̻��� �÷����� ��ȯ�Ǿ� ���� ������ ����
SELECT empno, ename, sal, deptno
FROM emp
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, SAL FROM EMP
                        WHERE DEPTNO = 30);

SELECT * FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL)
                        FROM EMP
                        GROUP BY DEPTNO);

-- FROM ������ ����ϴ� �������� : �ζ��κ��� �θ�
-- ���̺� ���� ������ �Ը� �ʹ� ũ�ų� Ư�� ���� �����ؾ� �ϴ� ��� ���
SELECT e10.empno, e10.ename, e10.deptno, d.dname, d.loc
FROM (SELECT empno, ename, deptno FROM EMP WHERE DEPTNO = 10) e10 JOIN DEPT d
ON e10.DEPTNO = D.DEPTNO;

-- SELECT ���� ����ϴ� ���� ���� : ��Į�� ���� ������� �θ�
-- SELECT ���� ���Ǵ� ���� ������ �ݵ�� �ϳ��� ����� ��ȯ �Ǿ�� ��
SELECT empno, ename, job, sal, 
            (SELECT grade FROM SALGRADE
            WHERE e.sal BETWEEN losal AND hisal) AS SALGRADE, deptno,
            (SELECT dname FROM DEPT d
            WHERE e.DEPTNO = d.DEPTNO) AS DNAME
FROM EMP e;

-- �� �ึ�� �μ���ȣ�� �� ���� �μ���ȣ�� ������ ������� SAL ����� ���ؼ� ��ȯ
SELECT ename, deptno, sal, (SELECT TRUNC(AVG(SAL)) FROM emp
                            WHERE deptno = e.deptno) AS "�μ��� �޿� ���"
FROM EMP e;

SELECT empno, ename, 
            CASE WHEN deptno = (SELECT deptno FROM dept WHERE loc = 'NEW YORK')
                THEN '����'
                ELSE '����'
            END AS �Ҽ�
FROM EMP
ORDER BY �Ҽ� DESC;

-- DECODE : �־��� ������ ���� ���� ���� ��ġ�ϴ� ���� ����ϰ� ��ġ���� ������ �⺻ �� ���
SELECT empno, ename, job, sal,
    DECODE(job,
        'MANAGER', sal * 1.1,
        'SALESMAN', sal * 1.05,
        'ANALYST', sal,
        sal * 1.03) AS "�޿� �λ�"
FROM EMP;
-- CASE �� :
SELECT empno, ename, job, sal,
    CASE job
        WHEN 'MANAGER' THEN sal * 1.1
        WHEN 'SALESMAN' THEN sal * 1.05
        WHEN 'ANALYST' THEN sal
        ELSE sal * 1.03
    END AS "�޿� �λ�"
FROM emp;

-- �������� 1. ��ü ��� �� ALLEN�� ���� ��å(JOB)�� ������� ��� ����, �μ� ������ ������ ���� ����ϴ� SQL���� �ۼ��ϼ���.
SELECT e.empno, e.ename, e.sal, e.job, e.deptno, d.dname
FROM EMP e, DEPT d
WHERE e.deptno = d.deptno
    AND JOB = (SELECT JOB FROM EMP WHERE ENAME = 'ALLEN');

-- �������� 2. ��ü ����� ��� �޿�(SAL)���� ���� �޿��� �޴� ������� ��� ����, �μ� ����, �޿� ��� ������ 
-- ����ϴ� SQL���� �ۼ��ϼ���(�� ����� �� �޿��� ���� ������ �����ϵ� �޿��� ���� ��쿡�� ��� ��ȣ�� �������� ������������ �����ϼ���).

-- �������� 3. 10�� �μ��� �ٹ��ϴ� ��� �� 30�� �μ����� �������� �ʴ� ��å�� ���� ������� ��� ����, �μ� ������ ������ ���� ����ϴ� SQL���� �ۼ��ϼ���.

-- �������� 4. ��å�� SALESMAN�� ������� �ְ� �޿����� ���� �޿��� �޴� ������� ��� ����, �޿� ��� ������ ������ ���� ����ϴ� SQL���� �ۼ��ϼ���
-- (�� ���������� Ȱ���� �� ������ �Լ��� ����ϴ� ����� ������� �ʴ� ����� ���� ��� ��ȣ�� �������� ������������ �����ϼ���).


        