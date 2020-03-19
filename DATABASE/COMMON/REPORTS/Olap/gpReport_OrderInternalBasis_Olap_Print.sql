-- Function: gpReport_OrderInternalBasis_Olap ()

DROP FUNCTION IF EXISTS gpReport_OrderInternalBasis_Olap_Print (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderInternalBasis_Olap_Print (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inFromId             Integer   ,    -- от кого
    IN inToId               Integer   ,    -- кому 
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor   
AS
$BODY$
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpReport (DayOfWeekName TVarChar, DayOfWeekNumber Integer, GoodsGroupNameFull TVarChar, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, Amount TFloat) ON COMMIT DROP;
    
    INSERT INTO _tmpReport (DayOfWeekName, DayOfWeekNumber, GoodsGroupNameFull, GoodsCode, GoodsName, GoodsKindId, GoodsKindName, Amount)
    
         SELECT tmpReport.DayOfWeekName
              , tmpReport.DayOfWeekNumber
              , tmpReport.GoodsGroupNameFull
              , tmpReport.GoodsCode
              , tmpReport.GoodsName
              , tmpReport.GoodsKindId
              , tmpReport.GoodsKindName
              , tmpReport.Amount
         FROM gpReport_OrderInternalBasis_Olap (inStartDate, inEndDate, inGoodsGroupId, inGoodsId, inFromId, inToId, inSession) AS tmpReport
         WHERE COALESCE (tmpReport.Amount, 0) <> 0;

 
    -------

    OPEN Cursor1 FOR
    SELECT _tmpReport.GoodsGroupNameFull
         , _tmpReport.GoodsName
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount1_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount2_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount3_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount4_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount5_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount6_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount7_fr --"морож."  freeze
      
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount1 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount2 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount3 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount4 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount5 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount6 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount7 --"охл."
    FROM _tmpReport
    GROUP BY _tmpReport.GoodsGroupNameFull
           , _tmpReport.GoodsName
    HAVING SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0 
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND _tmpReport.GoodsKindId = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND _tmpReport.GoodsKindId <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
    ;
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
    SELECT inStartDate AS StartDate, inEndDate AS EndDate;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.20         *
*/

-- тест
--