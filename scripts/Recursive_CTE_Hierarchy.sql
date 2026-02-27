
 WITH hier AS (
    SELECT 
       -- Burada en �stte istedi�imiz ki�i m�d�r yani kimseye ba�l� olmayan ki�i
    --ilk bu k�sm� olu�turduk sonra with recursive dedik.
        employeeAD, 
        managerAD, 
        CAST(employeeAD AS VARCHAR(MAX)) AS HiyerarsiYolu -- Hiyerar�iyi takip etmek i�in
    FROM employees
    WHERE managerAD IS NULL

    UNION ALL

    -- 2. ADIM: �zyineleme (Recursive) - �al��anlar� m�d�rlerine ba�l�yoruz
    SELECT 
        e.employeeAD, 
        e.managerAD, 
        CAST(h.HiyerarsiYolu + ' > ' + e.employeeAD AS VARCHAR(MAX))
    FROM employees e 
    INNER JOIN hier h ON e.managerAD = h.employeeAD
)
SELECT * FROM hier;
--burada t�m hiyerar�iyi g�rd�k s�ral� bir �ekilde
----------------------------------------------------
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
    
