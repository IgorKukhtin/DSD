-- Function: gpSelect_Movement_Inventory_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Inventory_Print (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Inventory_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Inventory_Print(
    IN inMovementId        Integer  ,  -- ключ Документа
    IN inIsAll             Boolean  ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbUnitId   Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime; 
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- Данные для остатков
     SELECT Movement.OperDate, Movement.StatusId, MLO_Unit.ObjectId
            INTO vbOperDate, vbStatusId, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = inMovementId
                                      AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;

   OPEN Cursor1 FOR
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , MovementFloat_TotalCount.ValueData                AS TotalCount
           , Object_Unit.ValueData                             AS UnitName
           , MovementString_Comment.ValueData                  AS Comment
           , COALESCE (MovementBoolean_List.ValueData, FALSE) ::Boolean AS isList
       FROM Movement
            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_List 
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId 
       WHERE Movement.Id = inMovementId 
         AND Movement.DescId = zc_Movement_Inventory()
     ;   

   RETURN NEXT Cursor1;


   OPEN Cursor2 FOR 
/*   
        SELECT spSelect.*
        FROM gpSelect_MovementItem_Inventory (inMovementId, FALSE, inSession) AS spSelect
        ;   
 */
   
   WITH 
   tmpMIScan AS (SELECT MovementItem.ObjectId AS GoodsId
                      , SUM(MovementItem.Amount)::TFloat             AS Amount
                      , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                      , MAX(MovementItem.Id)                         AS MaxId  
                 FROM MovementItem
                      LEFT JOIN MovementItemString AS MIString_PartNumber
                                                   ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                  AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Scan()
                   AND MovementItem.isErased   = FALSE                                    
                 GROUP BY MovementItem.ObjectId
                        , COALESCE (MIString_PartNumber.ValueData, '')
                )
 , tmpMIMaster AS (SELECT MovementItem.Id
                        , MovementItem.ObjectId AS GoodsId
                        , MovementItem.PartionId
                        , MovementItem.Amount
                        , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                   FROM MovementItem
                        LEFT JOIN MovementItemString AS MIString_PartNumber
                                                     ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                    AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
  
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId     = zc_MI_Master()
                     AND MovementItem.isErased   = FALSE
                  )
                           
          , tmpMI AS (SELECT tmpMIMaster.Id
                           , COALESCE(tmpMIMaster.GoodsId, tmpMIScan.GoodsId)             AS GoodsId
                           , tmpMIMaster.PartionId
                           , COALESCE(tmpMIMaster.Amount, tmpMIScan.Amount)               AS Amount
                           , tmpMIScan.Amount                                             AS AmountScan
                           , COALESCE(tmpMIMaster.PartNumber, tmpMIScan.PartNumber)       AS PartNumber
                      FROM tmpMIMaster
                      
                           FULL JOIN tmpMIScan ON tmpMIScan.GoodsId = tmpMIMaster.GoodsId
                                              AND tmpMIScan.PartNumber = tmpMIMaster.PartNumber
                      )

     , tmpRemains AS (SELECT Container.Id       AS ContainerId
                           , Container.ObjectId AS GoodsId
                           , Container.Amount
                           , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                                         THEN COALESCE (MIContainer.Amount, 0)
                                                                    WHEN MIContainer.OperDate > vbOperDate
                                                                         THEN COALESCE (MIContainer.Amount, 0)
                                                                    ELSE 0
                                                               END)
                                                        , 0) AS Remains
                           , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                      FROM Container
                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                       AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                           LEFT JOIN MovementItemContainer AS MIContainer
                                                           ON MIContainer.ContainerId =  Container.Id
                                                          AND MIContainer.OperDate    >= vbOperDate
                                                          AND vbStatusId              =  zc_Enum_Status_Complete()
                      WHERE Container.WhereObjectId = vbUnitId
                        AND Container.DescId        = zc_Container_Count()
                        AND (Container.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) OR inIsAll = TRUE)
                      GROUP BY Container.Id
                             , Container.ObjectId
                             , Container.Amount
                             , COALESCE (MIString_PartNumber.ValueData, '')
                      HAVING Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate = vbOperDate AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                                                         THEN COALESCE (MIContainer.Amount, 0)
                                                                    WHEN MIContainer.OperDate > vbOperDate
                                                                         THEN COALESCE (MIContainer.Amount, 0)
                                                                    ELSE 0
                                                               END)
                                                        , 0) <> 0
                          OR Container.Amount <> 0
                 )

       -- Результат
       SELECT
             Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , CASE WHEN Object_Goods.isErased = TRUE THEN '***удален ' || Object_Goods.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
           , ObjectString_Article.ValueData      AS Article 
           , zfCalc_Article_all (ObjectString_Article.ValueData) AS Article_all
           , ObjectString_EAN.ValueData          AS EAN
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.Id                        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , Object_Measure.ValueData                    AS MeasureName
           , Object_ProdColor.ValueData                  AS ProdColorName

           , tmpMI.Amount                                               AS Amount
           , tmpMI.AmountScan                                           AS AmountScan
           , tmpRemains.Remains                                ::TFloat AS AmountRemains
           , (tmpMI.Amount - COALESCE (tmpRemains.Remains, 0)) ::TFloat AS AmountDiff
           , tmpRemains.Amount                                 ::TFloat AS AmountRemains_curr

           , tmpMI.PartNumber             ::TVarChar

       FROM tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN ObjectLink AS OL_Goods_GoodsGroup
                                 ON OL_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id  = OL_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS OL_Goods_Measure
                                 ON OL_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                 ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_EAN
                                   ON ObjectString_EAN.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()
            LEFT JOIN (SELECT tmpRemains.GoodsId, tmpRemains.PartNumber, SUM (tmpRemains.Amount) AS Amount, SUM (tmpRemains.Remains) AS Remains
                       FROM tmpRemains
                       GROUP BY tmpRemains.GoodsId, tmpRemains.PartNumber
                      ) AS tmpRemains ON tmpRemains.GoodsId    = tmpMI.GoodsId
                                     AND tmpRemains.PartNumber = tmpMI.PartNumber
       WHERE inIsAll = FALSE

            --LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId
            --LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = Object_PartionGoods.MeasureId
            --LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = Object_PartionGoods.ProdColorId
     UNION
       SELECT
             Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , CASE WHEN Object_Goods.isErased = TRUE THEN '***удален ' || Object_Goods.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
           , ObjectString_Article.ValueData      AS Article 
           , zfCalc_Article_all (ObjectString_Article.ValueData) AS Article_all
           , ObjectString_EAN.ValueData          AS EAN
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.Id                        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , Object_Measure.ValueData                    AS MeasureName
           , Object_ProdColor.ValueData                  AS ProdColorName

           , tmpMI.Amount                                               AS Amount
           , tmpMI.AmountScan                                           AS AmountScan
           , tmpRemains.Remains                                ::TFloat AS AmountRemains
           , (COALESCE (tmpMI.Amount,0) - COALESCE (tmpRemains.Remains, 0)) ::TFloat AS AmountDiff
           , tmpRemains.Amount                                 ::TFloat AS AmountRemains_curr

           , COALESCE (tmpMI.PartNumber, tmpRemains.PartNumber) ::TVarChar AS PartNumber

       FROM tmpMI
            FULL JOIN (SELECT tmpRemains.GoodsId, tmpRemains.PartNumber, SUM (tmpRemains.Amount) AS Amount, SUM (tmpRemains.Remains) AS Remains
                       FROM tmpRemains
                       GROUP BY tmpRemains.GoodsId, tmpRemains.PartNumber
                      ) AS tmpRemains ON tmpRemains.GoodsId    = tmpMI.GoodsId
                                     AND tmpRemains.PartNumber = tmpMI.PartNumber

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpMI.GoodsId, tmpRemains.GoodsId)

            LEFT JOIN ObjectLink AS OL_Goods_GoodsGroup
                                 ON OL_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND OL_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id  = OL_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS OL_Goods_Measure
                                 ON OL_Goods_Measure.ObjectId = Object_Goods.Id
                                AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                 ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_Goods.Id
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_EAN
                                   ON ObjectString_EAN.ObjectId = Object_Goods.Id
                                  AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()
       WHERE inIsAll = TRUE  
         AND (COALESCE (tmpRemains.Remains,0) <> 0 OR COALESCE (tmpMI.Amount,0) <> 0)
        ; 
 
   RETURN NEXT Cursor2;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.22         *
*/

-- тест
-- 
SELECT * FROM gpSelect_Movement_Inventory_Print (inMovementId:= 3281, inIsAll:=FALSE, inSession:= zfCalc_UserAdmin())
