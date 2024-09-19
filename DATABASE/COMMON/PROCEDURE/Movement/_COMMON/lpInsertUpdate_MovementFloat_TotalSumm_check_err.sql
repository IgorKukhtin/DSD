-- Function: lpInsertUpdate_MovementFloat_TotalSumm_check_err ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm_check_err ();

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm_check_err()
RETURNS TABLE (MovementId Integer, S1 TFloat, S2 TFloat)
AS
$BODY$
BEGIN
-- SELECT                                 
--         lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), Id, s1)
--       , lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), Id, s2)
--       , lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), Id, s2)
--from ( 

    -- –ÂÁÛÎ¸Ú‡Ú
    RETURN QUERY

      SELECT a.Id :: Integer
           , a.s1 :: TFloat
           , a.s2 :: TFloat
      FROM (

      SELECT 28785530 :: Integer as Id
            , 1061010  :: TFloat as s1
            , 1273212  :: TFloat   as s2
      union
       SELECT 28666427 as Id
            , 1176732.02 as s1
            , 1412078.42 as s2

      union
       SELECT 28779783   as Id
            , 1266053.23
            , 1519263.87

      union
       SELECT 28779783   as Id
            , 1266053.23
            , 1519263.87


    --union
    -- SELECT 28906044   as Id
    --      , 848090
    --      , 1017708

--

      union
       SELECT 28607595  as Id
            , 1826385.63
            , 2191662.76

      union
       SELECT 28652649  as Id
            , 1716552.42
            , 2059862.9

--
union
       SELECT 28666983, 1565803.75, 1878964.5
union
       SELECT 28669666, 1071921.97, 1286306.36
union
       SELECT 28712992, 991775.69, 1190130.83
union
       SELECT 28755704, 999043.64, 1198852.37
union
       SELECT 28783416, 798580.47, 958296.56
union
       SELECT 28784531, 2168759.62, 2602511.54
union
       SELECT 28794368, 1037847.70, 1245417.24
union
       SELECT 28810632, 707287.55, 848745.06
union
       SELECT 28861783, 1724943.37, 2069932.04
union
       SELECT 28872742, 738225.30, 885870.36
union
       SELECT 28874886, 1674367.07, 2009240.48

--Ó union
--Ó        SELECT 28883624, 185998.80, 223198.56
--Ó union
--Ó       SELECT 28902614, 596654.93, 715985.92

--union
--       SELECT 28903748, 1819085.78, 2182902.94

--Ó union
--Ó        SELECT 28906249, 452349.50, 542819.4
--Ó union
--Ó        SELECT 28906851, 141031.05, 169237.26
--Ó union
--Ó        SELECT 28920554, 1323123.15, 1587747.78

--*union
--*       SELECT 28946823, 632929.90, 759515.88

--Ó union
--Ó       SELECT 28947980, 409427.39, 491312.87

--Ó union
--Ó        SELECT 28964132, 717362.83, 860835.4

--union
--       SELECT 28965398, 1033423.62, 1240108.34
--union
--       SELECT 28966711, 171354.24, 205625.09

--Ó union
--Ó        SELECT 28980380, 672499.54, 806999.45

--*union
--*       SELECT 29005882, 786261.59, 943513.91

/*       
union
       SELECT 28903748, cast (2182901.94/1.2 as numeric (16,2)), 2182901.94
union
       SELECT 28966711, cast (205624.09/1.2 as numeric (16,2)), 205624.09
union
       SELECT 28965398, cast (1240107.34/1.2 as numeric (16,2)), 1240107.34
*/

     ) as a
--     ) as a
;
     



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 22.08.24                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM lpInsertUpdate_MovementFloat_TotalSumm_check_err()
