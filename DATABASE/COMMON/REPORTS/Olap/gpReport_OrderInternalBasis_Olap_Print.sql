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
    DECLARE vbisFreezing Boolean;
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    --если НЕ склад мясн сырья и просто подписать в печати "кол-во"
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    INSERT INTO _tmpUnit (UnitId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup; --8446   --ЦЕХ колбаса+дел-сы
        
    IF EXISTS (SELECT 1 FROM _tmpUnit WHERE _tmpUnit.UnitId = inFromId)
    THEN
        vbisFreezing := TRUE;
    ELSE 
        vbisFreezing := FALSE;
    END IF;
    

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpReport (InvNumber TVarChar, OperDate TDateTime, DayOfWeekName TVarChar, DayOfWeekNumber Integer, GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, Amount TFloat) ON COMMIT DROP;
    
    INSERT INTO _tmpReport (InvNumber, OperDate, DayOfWeekName, DayOfWeekNumber, GoodsGroupNameFull, GoodsGroupName, GoodsCode, GoodsName, GoodsKindId, GoodsKindName, Amount)
    
         SELECT tmpReport.InvNumber
              , tmpReport.OperDate
              , tmpReport.DayOfWeekName
              , tmpReport.DayOfWeekNumber
              , tmpReport.GoodsGroupNameFull
              , tmpReport.GoodsGroupName
              , tmpReport.GoodsCode
              , tmpReport.GoodsName
              , tmpReport.GoodsKindId
              , tmpReport.GoodsKindName
              , tmpReport.Amount
         FROM gpReport_OrderInternalBasis_Olap (inStartDate, inEndDate, inGoodsGroupId, inGoodsId, inFromId, inToId, inSession) AS tmpReport
         WHERE COALESCE (tmpReport.Amount, 0) <> 0;
 
    -------

    OPEN Cursor1 FOR
    SELECT MAX (tmp.DayOfWeekName1) :: TVarChar AS DayOfWeekName1
         , MAX (tmp.DayOfWeekName2) :: TVarChar AS DayOfWeekName2
         , MAX (tmp.DayOfWeekName3) :: TVarChar AS DayOfWeekName3
         , MAX (tmp.DayOfWeekName4) :: TVarChar AS DayOfWeekName4
         , MAX (tmp.DayOfWeekName5) :: TVarChar AS DayOfWeekName5
         , MAX (tmp.DayOfWeekName6) :: TVarChar AS DayOfWeekName6
         , MAX (tmp.DayOfWeekName7) :: TVarChar AS DayOfWeekName7
         
         , STRING_AGG (DISTINCT tmp.OperDate1, '; ') :: TVarChar AS OperDate1
         , STRING_AGG (DISTINCT tmp.OperDate2, '; ') :: TVarChar AS OperDate2
         , STRING_AGG (DISTINCT tmp.OperDate3, '; ') :: TVarChar AS OperDate3
         , STRING_AGG (DISTINCT tmp.OperDate4, '; ') :: TVarChar AS OperDate4
         , STRING_AGG (DISTINCT tmp.OperDate5, '; ') :: TVarChar AS OperDate5
         , STRING_AGG (DISTINCT tmp.OperDate6, '; ') :: TVarChar AS OperDate6
         , STRING_AGG (DISTINCT tmp.OperDate7, '; ') :: TVarChar AS OperDate7

         , STRING_AGG (DISTINCT tmp.InvNumber1, '; ') :: TVarChar AS InvNumber1
         , STRING_AGG (DISTINCT tmp.InvNumber2, '; ') :: TVarChar AS InvNumber2
         , STRING_AGG (DISTINCT tmp.InvNumber3, '; ') :: TVarChar AS InvNumber3
         , STRING_AGG (DISTINCT tmp.InvNumber4, '; ') :: TVarChar AS InvNumber4
         , STRING_AGG (DISTINCT tmp.InvNumber5, '; ') :: TVarChar AS InvNumber5
         , STRING_AGG (DISTINCT tmp.InvNumber6, '; ') :: TVarChar AS InvNumber6
         , STRING_AGG (DISTINCT tmp.InvNumber7, '; ') :: TVarChar AS InvNumber7
         , vbisFreezing AS isFreezing
    FROM (SELECT CASE WHEN _tmpReport.DayOfWeekNumber = 1 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName1
               , CASE WHEN _tmpReport.DayOfWeekNumber = 2 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName2
               , CASE WHEN _tmpReport.DayOfWeekNumber = 3 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName3
               , CASE WHEN _tmpReport.DayOfWeekNumber = 4 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName4
               , CASE WHEN _tmpReport.DayOfWeekNumber = 5 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName5
               , CASE WHEN _tmpReport.DayOfWeekNumber = 6 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName6
               , CASE WHEN _tmpReport.DayOfWeekNumber = 7 THEN _tmpReport.DayOfWeekName ELSE NULL END :: TVarChar AS DayOfWeekName7
               
               , CASE WHEN _tmpReport.DayOfWeekNumber = 1 THEN zfConvert_DateToString(_tmpReport.OperDate) ELSE NULL END :: TVarChar AS OperDate1
               , CASE WHEN _tmpReport.DayOfWeekNumber = 2 THEN zfConvert_DateToString(_tmpReport.OperDate) ELSE NULL END :: TVarChar AS OperDate2
               , CASE WHEN _tmpReport.DayOfWeekNumber = 3 THEN zfConvert_DateToString(_tmpReport.OperDate) ELSE NULL END :: TVarChar AS OperDate3
               , CASE WHEN _tmpReport.DayOfWeekNumber = 4 THEN zfConvert_DateToString(_tmpReport.OperDate) ELSE NULL END :: TVarChar AS OperDate4
               , CASE WHEN _tmpReport.DayOfWeekNumber = 5 THEN zfConvert_DateToString(_tmpReport.OperDate) ELSE NULL END :: TVarChar AS OperDate5
               , CASE WHEN _tmpReport.DayOfWeekNumber = 6 THEN zfConvert_DateToString(_tmpReport.OperDate) ELSE NULL END :: TVarChar AS OperDate6
               , CASE WHEN _tmpReport.DayOfWeekNumber = 7 THEN zfConvert_DateToString(_tmpReport.OperDate) ELSE NULL END :: TVarChar AS OperDate7
               
               , CASE WHEN _tmpReport.DayOfWeekNumber = 1 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber1
               , CASE WHEN _tmpReport.DayOfWeekNumber = 2 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber2
               , CASE WHEN _tmpReport.DayOfWeekNumber = 3 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber3
               , CASE WHEN _tmpReport.DayOfWeekNumber = 4 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber4
               , CASE WHEN _tmpReport.DayOfWeekNumber = 5 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber5
               , CASE WHEN _tmpReport.DayOfWeekNumber = 6 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber6
               , CASE WHEN _tmpReport.DayOfWeekNumber = 7 THEN _tmpReport.InvNumber ELSE NULL END :: TVarChar AS InvNumber7
          FROM _tmpReport
          ) AS tmp
    ;
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
    SELECT _tmpReport.GoodsGroupNameFull
         , _tmpReport.GoodsGroupName
         , _tmpReport.GoodsCode
         , _tmpReport.GoodsName
         , _tmpReport.GoodsKindName
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount1_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount2_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount3_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount4_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount5_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount6_fr --"морож."  freeze
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount7_fr --"морож."  freeze
      
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND (COALESCE (_tmpReport.GoodsKindId,0) <> 8338 OR vbisFreezing = FALSE) THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount1 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND (COALESCE (_tmpReport.GoodsKindId,0) <> 8338 OR vbisFreezing = FALSE) THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount2 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND (COALESCE (_tmpReport.GoodsKindId,0) <> 8338 OR vbisFreezing = FALSE) THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount3 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND (COALESCE (_tmpReport.GoodsKindId,0) <> 8338 OR vbisFreezing = FALSE) THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount4 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND (COALESCE (_tmpReport.GoodsKindId,0) <> 8338 OR vbisFreezing = FALSE) THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount5 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND (COALESCE (_tmpReport.GoodsKindId,0) <> 8338 OR vbisFreezing = FALSE) THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount6 --"охл."
         , SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND (COALESCE (_tmpReport.GoodsKindId,0) <> 8338 OR vbisFreezing = FALSE) THEN _tmpReport.Amount ELSE 0 END) :: TFloat AS Amount7 --"охл."
    FROM _tmpReport
    GROUP BY _tmpReport.GoodsGroupNameFull
           , _tmpReport.GoodsGroupName
           , _tmpReport.GoodsName
           , _tmpReport.GoodsCode
           , _tmpReport.GoodsKindName
    HAVING SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0 
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND COALESCE (_tmpReport.GoodsKindId,0) = 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 1 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 2 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 3 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 4 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 5 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 6 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
        OR SUM (CASE WHEN _tmpReport.DayOfWeekNumber = 7 AND COALESCE (_tmpReport.GoodsKindId,0) <> 8338 THEN _tmpReport.Amount ELSE 0 END) <> 0
    ;
    
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