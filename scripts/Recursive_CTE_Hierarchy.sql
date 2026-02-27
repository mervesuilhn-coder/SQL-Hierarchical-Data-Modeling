
WITH hier AS (SELECT employeeAD, managerAD, 
        CAST(employeeAD AS VARCHAR(MAX)) AS HiyerarsiYolu 
    FROM employees
    WHERE managerAD IS NULL

    UNION ALL

    SELECT e.employeeAD, e.managerAD, 
        CAST(e.managerAD + ' > ' + e.employeeAD AS VARCHAR(MAX))
    FROM employees e 
    INNER JOIN hier h ON e.managerAD = h.employeeAD
)
SELECT * FROM hier;
--Burada daha sade haliyle sadece personeli ve en �st� g�r�yoruz.--
------------------------------------------------------------------
WITH hier AS (SELECT employeeAD, managerAD, 
        CAST(employeeAD AS VARCHAR(MAX)) AS HiyerarsiYolu 
    FROM employees
    WHERE managerAD IS NULL

    UNION ALL

    SELECT e.employeeAD, e.managerAD, 
        CAST(e.managerAD + ' > ' + e.employeeAD AS VARCHAR(MAX))
    FROM employees e 
    INNER JOIN hier h ON e.managerAD = h.employeeAD)
    ,
direct AS (
    -- ���nci par�a: Rapor say�lar�n� hesapla
    SELECT managerAD,COUNT(employeeAD) AS directreport
    FROM employees
    WHERE managerAD IS NOT NULL
    GROUP BY managerAD)
    ,
hier_direct AS(SELECT 
    h.employeeAD,
    h.managerAD,
    h.HiyerarsiYolu,
    COALESCE(d.directreport, 0) AS direct_reports 
FROM hier h 
LEFT JOIN direct d ON h.employeeAD = d.managerAD)
-------------------------------------------------------------
SELECT 
    m.employeeAD AS managerAD,          -- Y�netici tablosundaki isim
    m.HiyerarsiYolu AS m_HiyerarsiYolu,    -- Y�netici hiyerar�i yolu
    e.employeeAD AS employeeAD,         -- �al��an tablosundaki isim
    e.HiyerarsiYolu AS e_HiyerarsiYolu      -- �al��an hiyerar�i yolu

FROM hier_direct m LEFT JOIN  hier_direct e ON e.HiyerarsiYolu LIKE CONCAT(m.HiyerarsiYolu, '%');
    
