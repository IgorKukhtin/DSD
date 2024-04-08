-- Function: gpReport_ProductionSeparate_CheckPrice ()

DROP FUNCTION IF EXISTS gpReport_ProductionSeparate_CheckPrice (TDateTime, TDateTime, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProductionSeparate_CheckPrice (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inFromId       Integer   ,
    IN inToId         Integer   ,
    IN inPriceListId  Integer   ,
    IN inPersent      TFloat    ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (Id Integer, InvNumber TVarChar, OperDate TDateTime
              , FromId Integer, FromName TVarChar
              , ToId Integer, ToName TVarChar
              , GoodsGroupName TVarChar
              , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
              , GoodsKindName TVarChar
              , Amount          TFloat
              , PriceIn         TFloat
              , Price           TFloat
              , SummaIn         TFloat
              , Summa           TFloat
              , ValuePrice_min  TFloat
              , ValuePrice_max  TFloat
              , Diff_in         TFloat
              , Diff_max        TFloat
              , Diff            TFloat
              )  
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

   -- если пустое значение прайс-листа тогда  - 2707438   -- расчет цен по дням - обвалка
   IF COALESCE (inPriceListId, 0) = 0
   THEN 
       inPriceListId = 2707438;
   END IF;
   
   RETURN QUERY
    WITH
    
     tmpPiceSeparate AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId
                              , ObjectHistory_PriceListItem.StartDate
                              , ObjectHistory_PriceListItem.EndDate
                              , ObjectHistoryFloat_PriceListItem_Value.ValueData :: tfloat  AS Price
                         FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                              LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                   ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                  AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

                              LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                      ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                     AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                           ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                          AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                         WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                           AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId --2707438  --
                           AND ObjectHistory_PriceListItem.StartDate <= inEndDate
                           AND ObjectHistory_PriceListItem.EndDate > inStartDate
                         )
   , tmpUnitFrom AS (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS tmp WHERE inFromId <> 0 
               UNION SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND inFromId = 0
                     )
   , tmpUnitTo   AS (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS tmp WHERE inToId <> 0 
               UNION SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND inToId = 0
                     )

   /*, tmpMinMax AS (SELECT tmpPiceSeparate.GoodsId
                        , MIN (tmpPiceSeparate.Price) :: tfloat  AS ValuePrice_min
                        , MAX (tmpPiceSeparate.Price) :: tfloat  AS ValuePrice_max
                   FROM tmpPiceSeparate            
                   GROUP BY tmpPiceSeparate.GoodsId
                   )
   */

   , tmpMovement AS (SELECT Movement.*
                          , MovementLinkObject_From.ObjectId AS FromId
                          , MovementLinkObject_To.ObjectId   AS ToId
                     FROM Movement 
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                       AND MovementLinkObject_From.ObjectId IN (SELECT tmpUnitFrom.UnitId FROM tmpUnitFrom)

                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                       AND MovementLinkObject_To.ObjectId IN (SELECT tmpUnitTo.UnitId FROM tmpUnitTo)
                          
                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                       AND Movement.DescId = zc_Movement_ProductionSeparate() 
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                     --  and Movement.Id = 10937044
                     )
   , tmpMI AS (SELECT Movement.OperDate
                    , Movement.Invnumber
                    , Movement.FromId
                    , Movement.ToId
                    , MovementItem.*
               FROM tmpMovement AS Movement
                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId     = zc_MI_Child()
                                          AND MovementItem.IsErased   = FALSE
              )
   , tmpSummIn AS (SELECT MIContainer.MovementId       AS MovementId
                        , MIContainer.MovementItemId   AS MovementItemId
                        , 1 * SUM (MIContainer.Amount) AS SummIn
                   FROM MovementItemContainer AS MIContainer
                   WHERE MIContainer.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                     AND MIContainer.DescId     = zc_MIContainer_Summ()
                     AND MIContainer.isActive   = TRUE
                   GROUP BY MIContainer.MovementId
                          , MIContainer.MovementItemId
                   )
   , tmpData_All AS (SELECT tmpMI.MovementId AS MovementId
                          , tmpMI.OperDate
                          , tmpMI.Invnumber
                          , tmpMI.FromId
                          , tmpMI.ToId
                          , tmpMI.Id         AS MovementItemId
                          , tmpMI.ObjectId   AS GoodsId
                          , tmpMI.Amount     AS Amount
                          , CASE WHEN tmpMI.Amount <> 0 THEN tmpSummIn.SummIn / tmpMI.Amount ELSE 0 END :: TFloat AS PriceIn
                          , tmpPiceSeparate.Price
                          , tmpSummIn.SummIn
                        
                     FROM tmpMI
                          LEFT JOIN tmpSummIn ON tmpSummIn.MovementId = tmpMI.MovementId
                                             AND tmpSummIn.MovementItemId = tmpMI.Id
                          LEFT JOIN tmpPiceSeparate ON tmpPiceSeparate.GoodsId = tmpMI.ObjectId
                                                   AND tmpPiceSeparate.StartDate <= tmpMI.OperDate
                                                   AND tmpPiceSeparate.EndDate > tmpMI.OperDate
                        )
   , tmpMinMax AS (SELECT tmpData_All.GoodsId
                        , MIN (tmpData_All.PriceIn) :: tfloat  AS ValuePrice_min
                        , MAX (tmpData_All.PriceIn) :: tfloat  AS ValuePrice_max
                   FROM tmpData_All            
                   GROUP BY tmpData_All.GoodsId
                   )

   , tmpData AS (SELECT tmpData.MovementId
                      , tmpData.OperDate
                      , tmpData.Invnumber
                      , tmpData.FromId
                      , tmpData.ToId
                      , tmpData.MovementItemId
                      , tmpData.GoodsId
                      , tmpData.Amount
                      , tmpData.PriceIn
                      , tmpData.Price
                      , tmpData.SummIn

                      , tmpData.ValuePrice_min
                      , tmpData.ValuePrice_max
                      , tmpData.Diff_in
                      , tmpData.Diff_max
                      , tmpData.Diff

                 FROM (SELECT tmpData.MovementId
                            , tmpData.OperDate
                            , tmpData.Invnumber
                            , tmpData.FromId
                            , tmpData.ToId
                            , tmpData.MovementItemId
                            , tmpData.GoodsId
                            , tmpData.Amount
                            , COALESCE (tmpData.PriceIn, 0)  AS PriceIn
                            , tmpData.Price
                            , tmpData.SummIn
                            , CAST (COALESCE (tmpMinMax.ValuePrice_min, 0) AS NUMERIC (16,2))  AS ValuePrice_min
                            , CAST (COALESCE (tmpMinMax.ValuePrice_max, 0) AS NUMERIC (16,2))  AS ValuePrice_max
                            , CAST (CASE WHEN COALESCE (tmpMinMax.ValuePrice_min, 0) <> 0 AND COALESCE(tmpData.PriceIn, 0) <> 0 
                                              THEN (COALESCE(tmpData.PriceIn, 0) - COALESCE (tmpMinMax.ValuePrice_min, 0)) * 100 / COALESCE (tmpMinMax.ValuePrice_min, 0) 
                                         WHEN COALESCE (tmpMinMax.ValuePrice_min, 0) <> 0 AND COALESCE(tmpData.PriceIn, 0) = 0 
                                              THEN 100
                                         ELSE 0
                                    END  AS NUMERIC (16,0))  AS Diff_in
       
                            , CAST (CASE WHEN COALESCE (tmpMinMax.ValuePrice_max, 0) <> 0 AND COALESCE(tmpMinMax.ValuePrice_min, 0)<> 0 
                                             THEN (COALESCE (tmpMinMax.ValuePrice_max, 0) - COALESCE(tmpMinMax.ValuePrice_min, 0)) * 100 / COALESCE (tmpMinMax.ValuePrice_min, 0) 
                                         WHEN COALESCE (tmpMinMax.ValuePrice_max, 0) = 0 AND COALESCE(tmpMinMax.ValuePrice_min, 0) <> 0
                                             THEN 100
                                         ELSE 0
                                    END  AS NUMERIC (16,0))  AS Diff_max
       
                            , CAST (CASE WHEN COALESCE (tmpData.Price, 0) <> 0 AND COALESCE(tmpMinMax.ValuePrice_min, 0) <> 0 
                                             THEN (COALESCE (tmpData.Price, 0) - COALESCE(tmpMinMax.ValuePrice_min, 0)) * 100 / COALESCE (tmpMinMax.ValuePrice_min, 0) 
                                         WHEN COALESCE (tmpData.Price, 0) <> 0 AND COALESCE(tmpMinMax.ValuePrice_min, 0) = 0
                                             THEN 100
                                         ELSE 0
                                    END  AS NUMERIC (16,0))  AS Diff
                       FROM tmpData_All AS tmpData
                            LEFT JOIN tmpMinMax ON tmpMinMax.GoodsId = tmpData.GoodsId
                      ) AS tmpData
                 WHERE tmpData.PriceIn = 0 OR tmpData.Diff_in >= inPersent
                 )

     --Результат
     SELECT tmpData.MovementId          AS Id
          , tmpData.InvNumber           AS InvNumber
          , tmpData.OperDate            AS OperDate
          , Object_From.Id              AS FromId
          , Object_From.ValueData       AS FromName
          , Object_To.Id                AS ToId
          , Object_To.ValueData         AS ToName
          , Object_GoodsGroup.ValueData AS GoodsGroupName
          , Object_Goods.Id             AS GoodsId
          , Object_Goods.ObjectCode     AS GoodsCode
          , Object_Goods.ValueData      AS GoodsName
          , Object_GoodsKind.ValueData  AS GoodsKindName
          , tmpData.Amount  :: TFloat   AS Amount
          , CAST (tmpData.PriceIn AS NUMERIC (16,2))  :: TFloat AS PriceIn
          , CAST (tmpData.Price AS NUMERIC (16,2))    :: TFloat AS Price
          , tmpData.SummIn                            :: TFloat AS SummaIn
          , (tmpData.Amount * tmpData.Price)          :: TFloat AS Summa

          , tmpData.ValuePrice_min   :: TFloat
          , tmpData.ValuePrice_max   :: TFloat
          , tmpData.Diff_in          :: TFloat
          , tmpData.Diff_max         :: TFloat
          , tmpData.Diff             :: TFloat
          
     FROM tmpData
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
          LEFT JOIN Object AS Object_To ON Object_To.Id = tmpData.ToId
          
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = tmpData.MovementItemId
                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpData.GoodsId
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          --LEFT JOIN tmpMinMax ON tmpMinMax.GoodsId = tmpData.GoodsId
     ;
    
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.10.18         *
*/

-- тест
--