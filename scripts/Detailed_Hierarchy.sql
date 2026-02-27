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
