SELECT *
FROM EMP;

-- �μ��� ��� �޿� ����ϱ�
SELECT AVG(sal), deptno
FROM emp
GROUP BY DEPTNO;

-- ������ ����ؼ� ����ϱ�
SELECT AVG(sal) FROM emp WHERE DEPTNO = 10
UNION ALL
SELECT AVG(sal) FROM emp WHERE DEPTNO = 20
UNION ALL
SELECT AVG(sal) FROM emp WHERE DEPTNO = 30;

--�μ� ��ȣ �� ��å�� ��� �޿� �����ϱ�
SELECT DEPTNO, JOB, AVG(sal)
FROM EMP
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, JOB;

-- �μ� �ڵ�, �޿� �հ�, �μ� ���, �μ� �ڵ� �� ���ķ� ����ϱ�
SELECT DEPTNO AS "�μ� �ڵ�",
    SUM(SAL) AS "�޿� �հ�",
    ROUND(AVG(SAL)) AS "�޿� ���",
    COUNT(*) AS "�ο���"
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- HAVING �� : GROUP BY ���� ���� �� ���� ���, GROUP BY ���� ���� �׷�ȭ �� ��� ���� ������ �����ϴµ� ���
SELECT job, AVG(sal)
FROM emp
WHERE DEPTNO = 10
GROUP BY job
    HAVING AVG(sal) >= 2000
ORDER BY job;

-- 1. HAVING ���� ����Ͽ� �μ��� ��å�� ��� �޿��� 500 �̻��� ������� �μ���ȣ, ��å, �μ��� ��å�� ��� �޿� ���
SELECT DEPTNO, JOB, AVG(SAL)
    FROM EMP
GROUP BY DEPTNO, JOB
    HAVING AVG(SAL) >= 500
ORDER BY DEPTNO, JOB;

-- 2. �μ� ��ȣ, ��� �޿�, �ְ� �޿�, ���� �޿�, ����� ���, ��, ��� �޿��� �Ҽ��� �����ϰ� ����ϰ� �μ� ��ȣ�� ���
SELECT DEPTNO, TRUNC(AVG(SAL)) AS "��� �޿�", 
    MAX(SAL) AS "�ְ� �޿�",
    MIN(SAL) AS "���� �޿�",
    COUNT(*) AS "��� ��"
FROM EMP
GROUP BY DEPTNO;

-- 3. ���� ��å�� �����ϴ� ����� 3�� �̻��� ��å�� �ο��� ���
SELECT JOB AS "����", 
    COUNT(*) AS "�����"
FROM EMP
GROUP BY JOB
    HAVING COUNT(*) >= 3;

-- 4. ������� �Ի� ������ �������� �μ����� �� ���� �Ի��ߴ��� ���
SELECT TO_CHAR(HIREDATE, 'YYYY') AS "�Ի���",
       DEPTNO,
       COUNT(*) AS "�����"
FROM EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY'), DEPTNO
ORDER BY "�Ի���";
    
-- 5. �߰� ������ �޴� ��� ���� ���� �ʴ� ������� ��� (O, X�� ǥ�� �ʿ�)
SELECT NVL2(comm, 'O', 'X') AS "�߰� ����",
    count(*) AS "��� ��"
FROM EMP
GROUP BY NVL2(comm, 'O', 'X');

-- 6. �� �μ��� �Ի� ������ ��� ��, �ְ� �޿�, �޿� ��, ��� �޿��� ���
SELECT deptno,
    TO_CHAR(hiredate, 'YYYY') AS "�Ի�⵵",
    COUNT(*) AS "��� ��",
    MAX(sal) AS "�ְ� �޿�",
    ROUND(AVG(sal)) AS "��� �޿�",
    SUM(sal) AS "�޿� �հ�"
FROM emp
GROUP BY deptno, TO_CHAR(hiredate, 'YYYY')
ORDER BY deptno, "�Ի�⵵";

-- ROLLUP �Լ� :
SELECT deptno, job, COUNT(*), MAX(sal), SUM(sal), AVG(sal)
FROM EMP
GROUP BY ROLLUP(DEPTNO, job);

-- ���� ������ : �ΰ� �̻��� ���� ����� �ϳ��� �����ϴ� ������(������ ó��)
SELECT empno, ename, job
FROM EMP
WHERE job = 'SALESMAN'
UNION
SELECT empno, ename, job
from emp
where job = 'MANAGER';

-- ����(JOIN) : �ΰ� �̻��� ���̺��� �����͸� �����ͼ� �����ϴµ� ���Ǵ� SQL ���
-- ���̺� ���� �ĺ� ���� Primary Key�� ���̺� �� ���� ���� Foreign Key  ���� ����Ͽ� ����
-- ���� ����(���� ����, inner join)�̸� ����Ŭ ���, ���ʿ� ������ �÷��� �ִ� ��� ���̺� �̸��� ǥ���ؾ� ��
SELECT e.empno, ename, mgr, sal, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal >= 3000;
-- ANSI ���
SELECT EMPNO, ENAME, MGR, e.DEPTNO
FROM EMP e JOIN DEPT d
ON e.DEPTNO = d.DEPTNO
WHERE sal >= 3000;

-- EMP ���̺� ��Ī�� E�� DEPT ���̺� ��Ī�� D�� �Ͽ� ������ ���� � ������ ���� ��,
-- �޿��� 2500 �����̰� �����ȣ�� 9999 ������ ����� ������ ��µǵ��� �ۼ�
SELECT E.EMPNO, E.ENAME, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE sal <= 2500 AND empno <= 9999
ORDER BY EMPNO;

-- �� ���� : ������ �÷��� ���� �� ����ϴ� ����(�Ϲ������� ���� �������� ����)
SELECT * FROM EMP;
SELECT * FROM SALGRADE;
SELECT e.ENAME, e.SAL, s.GRADE
FROM EMP e join SALGRADE s
ON e.SAL BETWEEN s.LOSAL AND s.HISAL;

-- ��ü ���� : ���� ���̺��� �����ؼ� ���� ����� ã�Ƴ��� ���
SELECT e1.EMPNO, e1.ENAME, e1.MGR, 
    e2.EMPNO AS "��� �����ȣ",
    e2.ENAME AS "��� �̸�"
FROM EMP e1 JOIN EMP e2
ON e1.MGR = e2.EMPNO;

-- �ܺ� ���� (Left outer join) = ������ �κ��� �ִ� ���� �ִ� ���̺� (+)
SELECT e.ENAME, e.DEPTNO, d.DNAME
FROM EMP e, DEPT d
WHERE e.DEPTNO(+) = d.DEPTNO
ORDER BY e.DEPTNO;

SELECT e.ENAME, e.DEPTNO, d.DNAME
FROM EMP e RIGHT OUTER JOIN DEPT D
ON e.DEPTNO = d.DEPTNO
ORDER BY e.DEPTNO;

-- NATURAL JOIN : ���� ������ ����ϴ� �ٸ� ���, ������ ���� ���, �� ���̺��� ���� ���� �ڵ����� ����
SELECT EMPNO, ENAME, DNAME, DEPTNO
FROM EMP NATURAL JOIN DEPT;

-- JOIN ~ USING : ���� ����(� ����)�� ����ϴ� ��� ���� �ϳ�
SELECT e.EMPNO, e.ENAME, d.DNAME, DEPTNO, e.SAL
FROM EMP e JOIN DEPT d USING(DEPTNO)
WHERE SAL >= 3000
ORDER BY DEPTNO, e.EMPNO;

-- �������� 1 : �޿��� 2000 �ʰ��� ������� �μ� ����, ��� ���� ���
SELECT DEPTNO, DNAME, EMPNO, ENAME, SAL
FROM EMP NATURAL JOIN DEPT
WHERE SAL >= 2000;

-- �������� 2 : �μ��� ���, �ִ� �޿�, �ּ� �޿�, ��� �� ��� (ANSI JOIN)
SELECT d.DEPTNO, d.DNAME,
    ROUND(AVG(SAL)) AS "��� �޿�",
    MAX(SAL) AS "�ִ� �޿�",
    MIN(SAL) AS "�ּ� �޿�",
    COUNT(*) AS "��� ��"
FROM EMP e JOIN DEPT d
ON e.DEPTNO = d.DEPTNO
GROUP BY d.DEPTNO, d.DNAME;

-- �������� 3 : ��� �μ� ������ ��� ������ �μ���ȣ, ��� �̸������� �����ؼ� ���
SELECT d.DEPTNO, d.DNAME, e.EMPNO, e.ENAME, e.JOB, e.SAL
FROM EMP e RIGHT OUTER JOIN DEPT d
ON e.DEPTNO = d.DEPTNO
ORDER BY d.DEPTNO, e.ENAME;
