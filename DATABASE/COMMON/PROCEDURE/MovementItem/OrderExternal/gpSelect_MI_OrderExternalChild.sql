-- Function: gpSelect_MI_OrderExternalChild()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderExternalChild (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderExternalChild(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer, LineNum Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsId_master Integer, GoodsCode_master Integer, GoodsName_master TVarChar
             , GoodsKindId_master Integer, GoodsKindName_master TVarChar
             , MeasureName TVarChar, MeasureName_master TVarChar
             , Amount TFloat, AmountSecond TFloat, Amount_remains TFloat, Amount_order TFloat
             , MovementId_income Integer, InvNumber_income TVarChar, OperDate_income TDateTime
             , isPeresort Boolean, isErased Boolean

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);


    -- Результат 
     RETURN QUERY
      WITH 
           -- Существующие MovementItem
           tmpMI_Master AS (SELECT MovementItem.Id                AS MovementItemId
                                 , MovementItem.ObjectId          AS GoodsId
                                 , MILO_GoodsKind.ObjectId        AS GoodsKindId
                                 , MovementItem.Amount + COALESCE (MIF_AmountSecond.ValueData, 0) AS Amount
                                 , MovementItem.isErased
                            FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIF_AmountSecond
                                                             ON MIF_AmountSecond.MovementItemId = MovementItem.Id
                                                            AND MIF_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                                 LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                  ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                            --AND MovementItem.Amount + COALESCE (MIF_AmountSecond.ValueData, 0) > 0
                           )
        -- Существующие MovementItem
      , tmpMI_Child_all AS (SELECT MovementItem.Id
                                 , MovementItem.ParentId
                                 , MovementItem.ObjectId   AS GoodsId
                                 , MovementItem.Amount     AS Amount
                                 , MovementItem.isErased
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = tmpIsErased.isErased
                           )
          , tmpMI_Child AS (SELECT tmpMI_Child_all.Id
                                 , tmpMI_Child_all.ParentId
                                 , tmpMI_Child_all.GoodsId
                                 , tmpMI_Child_all.Amount
                                 , tmpMI_Child_all.isErased
                            FROM tmpMI_Child_all
                            WHERE tmpMI_Child_all.Amount <> 0
                           )
          , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                           AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                         )

          , tmpMI_Float AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                              AND MovementItemFloat.DescId IN (zc_MIFloat_Remains()
                                                             , zc_MIFloat_MovementId()
                                                              )
                           )

          , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.ParentId
                           , MovementItem.GoodsId                          AS GoodsId
                           , CASE WHEN COALESCE (MIFloat_Movement.ValueData, 0) = 0 THEN MovementItem.Amount ELSE 0 END AS Amount
                           , CASE WHEN COALESCE (MIFloat_Movement.ValueData, 0) > 0 THEN MovementItem.Amount ELSE 0 END AS AmountSecond
                           , COALESCE (MIFloat_Remains.ValueData, 0)       AS Amount_remains
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MIFloat_Movement.ValueData                    AS MovementId_income
                           , MovementItem.isErased
                             -- № п/п
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id DESC) AS Ord
                      FROM tmpMI_Child AS MovementItem
                           LEFT JOIN tmpMI_LO AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         
                           LEFT JOIN tmpMI_Float AS MIFloat_Remains
                                                 ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                                AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                           LEFT JOIN tmpMI_Float AS MIFloat_Movement
                                                 ON MIFloat_Movement.MovementItemId = MovementItem.Id
                                                AND MIFloat_Movement.DescId = zc_MIFloat_MovementId()
                     )
    , tmpPeresort AS (SELECT DISTINCT
                             tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId
                           , tmpMI.GoodsId AS GoodsId_sub, tmpMI_Master.GoodsKindId AS GoodsKindId_sub
                      FROM tmpMI
                           LEFT JOIN tmpMI_Master ON tmpMI_Master.MovementItemId = tmpMI.ParentId
                      WHERE tmpMI.GoodsId      <> tmpMI_Master.GoodsId 
                         OR tmpMI.GoodsKindId  <> tmpMI_Master.GoodsKindId
                     )
       -- Результат
       SELECT
             tmpMI.MovementItemId :: Integer    AS Id
           , tmpMI.ParentId       :: Integer
           , CAST (row_number() OVER (ORDER BY tmpMI.MovementItemId) AS Integer) AS LineNum

           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName

           , Object_Goods_master.Id             AS GoodsId_master
           , Object_Goods_master.ObjectCode     AS GoodsCode_master
           , Object_Goods_master.ValueData      AS GoodsName_master
           , Object_GoodsKind_master.Id         AS GoodsKindId_master
           , Object_GoodsKind_master.ValueData  AS GoodsKindName_master

           , Object_Measure.ValueData           AS MeasureName
           , Object_Measure_master.ValueData    AS MeasureName_master

           , tmpMI.Amount           :: TFloat   AS Amount
           , tmpMI.AmountSecond     :: TFloat   AS AmountSecond
           , tmpMI.Amount_remains   :: TFloat   AS Amount_remains
           , CASE WHEN tmpMI.Ord = 1 THEN tmpMI_Master.Amount ELSE 0 END :: TFloat AS Amount_order

           , Movement_Income.Id                 AS MovementId_income
           , Movement_Income.InvNumber          AS InvNumber_income
           , Movement_Income.OperDate           AS OperDate_income
           
           , CASE WHEN tmpPeresort.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPeresort
       
           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpMI_Master ON tmpMI_Master.MovementItemId = tmpMI.ParentId

            LEFT JOIN (SELECT tmpPeresort.GoodsId, tmpPeresort.GoodsKindId
                       FROM tmpPeresort
                      UNION
                       SELECT tmpPeresort.GoodsId_sub AS GoodsId, tmpPeresort.GoodsKindId_sub AS GoodsKindId
                       FROM tmpPeresort
                      ) AS tmpPeresort ON tmpPeresort.GoodsId     = tmpMI.GoodsId
                                      AND tmpPeresort.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_Goods_master     ON Object_Goods_master.Id     = tmpMI_Master.GoodsId
                                                       AND (tmpMI_Master.GoodsId     <> tmpMI.GoodsId
                                                         OR tmpMI_Master.GoodsKindId <> tmpMI.GoodsKindId
                                                           )
            LEFT JOIN Object AS Object_GoodsKind_master ON Object_GoodsKind_master.Id = tmpMI_Master.GoodsKindId
                                                       AND (tmpMI_Master.GoodsId     <> tmpMI.GoodsId
                                                         OR tmpMI_Master.GoodsKindId <> tmpMI.GoodsKindId
                                                           )
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_master
                                 ON ObjectLink_Goods_Measure_master.ObjectId = tmpMI_Master.GoodsId
                                AND ObjectLink_Goods_Measure_master.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_master ON Object_Measure_master.Id = ObjectLink_Goods_Measure_master.ChildObjectId


            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                  
            LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpMI.MovementId_income
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.06.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderExternalChild (inMovementId:= 25173, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
