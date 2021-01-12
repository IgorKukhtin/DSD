-- Function: gpSelect_GetImplementationPlanEmployeeCash()

DROP FUNCTION IF EXISTS gpSelect_GetImplementationPlanEmployeeCash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GetImplementationPlanEmployeeCash(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UserId Integer,
               GoodsCode Integer,
               Color Integer
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCurName1 TVarChar;
   DECLARE vbRec Record;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbUserId := lpGetUserBySession (inSession);
    
    SELECT zfCalc_Word_Split (tmp.CurName_all, ';', 5) AS CurName5
    INTO vbCurName1
    FROM (SELECT STRING_AGG (tmp.CurName, ';') AS CurName_all
          FROM (SELECT gpReport_ImplementationPlanEmployeeCash (CURRENT_DATE, inSession) :: TVarChar AS CurName) AS tmp
          ) AS tmp;

    CREATE TEMP TABLE tmpResultData (
             UserId Integer,
             GoodsCode Integer,
             Color Integer
    ) ON COMMIT DROP;
      
    FOR vbRec IN EXECUTE 'FETCH ALL IN' || QUOTE_IDENT (vbCurName1)
    LOOP
       INSERT INTO tmpResultData 
        VALUES (vbUserId, vbRec.GoodsCode, CASE WHEN COALESCE(vbRec.AmountPlanAwardCash, 0) = 0 THEN 0
                                                WHEN vbRec.AmountCash < vbRec.AmountPlanCash THEN 1       -- Red
                                                WHEN vbRec.AmountCash < vbRec.AmountPlanAwardCash THEN 2  -- Green
                                                ELSE 3 END::Integer);                      -- Blue
    END LOOP;
    
    RETURN QUERY
    SELECT *
    FROM tmpResultData
    ORDER BY GoodsCode;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 04.12.19         *
*/

-- тест
-- select * from gpSelect_GetImplementationPlanEmployeeCash(inSession := '3');