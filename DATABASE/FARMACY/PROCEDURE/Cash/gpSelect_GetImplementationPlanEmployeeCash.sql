-- Function: gpSelect_GetImplementationPlanEmployeeCash()

DROP FUNCTION IF EXISTS gpSelect_GetImplementationPlanEmployeeCash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GetImplementationPlanEmployeeCash(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (UserId Integer,
               GoodsCode Integer,
               Color Integer,
               AmountPlan TFloat,
               AmountPlanAward TFloat,
               isFixedPercent Boolean
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCurName1 TVarChar;
   DECLARE vbRec Record;
   DECLARE text_var1 text;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbUserId := lpGetUserBySession (inSession);

    CREATE TEMP TABLE tmpResultData (
             UserId Integer,
             GoodsCode Integer,
             Color Integer,
             AmountPlan TFloat,
             AmountPlanAward TFloat,
             isFixedPercent Boolean
    ) ON COMMIT DROP;
      
    BEGIN
      SELECT zfCalc_Word_Split (tmp.CurName_all, ';', 5) AS CurName5
      INTO vbCurName1
      FROM (SELECT STRING_AGG (tmp.CurName, ';') AS CurName_all
            FROM (SELECT gpReport_ImplementationPlanEmployeeCash (CURRENT_DATE, inSession) :: TVarChar AS CurName) AS tmp
            ) AS tmp;
        
      FOR vbRec IN EXECUTE 'FETCH ALL IN' || QUOTE_IDENT (vbCurName1)
      LOOP
         INSERT INTO tmpResultData 
          VALUES (vbUserId, vbRec.GoodsCode, CASE WHEN vbRec.AmountCash < vbRec.AmountPlanCash THEN 1       -- Red
                                                  WHEN vbRec.AmountCash < vbRec.AmountPlanAwardCash 
                                                   AND COALESCE(vbRec.AmountPlanAwardCash, 0) > 0 THEN 2    -- Green
                                                  ELSE 3 END::Integer,                                      -- Blue
                  CASE WHEN vbRec.AmountCash < vbRec.AmountPlanCash THEN vbRec.AmountPlanCash - vbRec.AmountCash ELSE 0 END,
                  CASE WHEN vbRec.AmountCash < vbRec.AmountPlanAwardCash
                        AND COALESCE(vbRec.AmountPlanAwardCash, 0) > 0 THEN vbRec.AmountPlanAwardCash - vbRec.AmountCash ELSE 0 END,
                  vbRec.isFixedPercent);
      END LOOP;
    EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
    END;
    
    RETURN QUERY
    SELECT *
    FROM tmpResultData
    ORDER BY GoodsCode;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 04.12.19         *
*/

-- ����
-- 
select * from gpSelect_GetImplementationPlanEmployeeCash(inSession := '12625219');