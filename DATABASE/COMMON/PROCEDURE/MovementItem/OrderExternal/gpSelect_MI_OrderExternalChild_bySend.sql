-- Function: gpSelect_MI_OrderExternalChild_bySend()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderExternalChild_bySend (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderExternalChild_bySend(
    IN inMovementId_send  Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer, LineNum Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsId_master Integer, GoodsCode_master Integer, GoodsName_master TVarChar
             , GoodsKindId_master Integer, GoodsKindName_master TVarChar
             , MeasureName TVarChar, MeasureName_master TVarChar
              /*   
             , AmountSecond TFloat
             , Amount TFloat, AmountSecond1 TFloat, AmountSecond2 TFloat
             , Amount_remains TFloat
             , AmountSh_send TFloat, AmountWeight_send TFloat
             , Amount_order TFloat, Amount_diff TFloat
               */
			 , AmountSecond     TFloat
             , AmountSh            TFloat
             , AmountShSecond1     TFloat
             , AmountShSecond2     TFloat 
             , AmountWeight          TFloat
             , AmountWeightSecond1   TFloat
             , AmountWeightSecond2   TFloat
             , AmountSh_remains      TFloat
             , AmountWeight_remains  TFloat
             , AmountSh_send     TFloat
             , AmountWeight_send TFloat
             , AmountSh_order TFloat
             , AmountWeight_order TFloat
             , AmountWeight_diff TFloat

             , MovementId_order Integer, InvNumber_order TVarChar, OperDate_order TDateTime
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
        tmpMI_bySend AS (SELECT MIFloat_Movement.MovementItemId        --MI child - из док заказа для тек. перемещения
                              , MovementItem.MovementId                --документ заказ
                         FROM MovementItemFloat AS MIFloat_Movement
                              LEFT JOIN MovementItem ON MovementItem.Id = MIFloat_Movement.MovementItemId
                         WHERE MIFloat_Movement.ValueData = inMovementId_send
                           AND MIFloat_Movement.DescId = zc_MIFloat_MovementId()
                         )
      , tmpMI_Send AS (SELECT MovementItem.ObjectId AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            , MovementItem.Amount   AS Amount
                            , MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END AS AmountSh
                            , MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS AmountWeight
                       FROM MovementItem
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                       WHERE MovementItem.MovementId = inMovementId_send
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                       ) 

       -- Существующие MovementItem
      , tmpMI_Child AS (SELECT MovementItem.ParentId
                             , MovementItem.MovementId
                             , MovementItem.Id
                             , MovementItem.ObjectId   AS GoodsId
                             , (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount ELSE 0 END) AS Amount
                             , (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 AND MIFloat_MovementId.ValueData =  inMovementId_send THEN MovementItem.Amount ELSE 0 END) AS AmountSecond1 
                             , (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 AND MIFloat_MovementId.ValueData <> inMovementId_send THEN MovementItem.Amount ELSE 0 END) AS AmountSecond2
                             
                             , (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount ELSE 0 END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight
                             , (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 AND MIFloat_MovementId.ValueData =  inMovementId_send THEN MovementItem.Amount ELSE 0 END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeightSecond1
                             , (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 AND MIFloat_MovementId.ValueData <> inMovementId_send THEN MovementItem.Amount ELSE 0 END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeightSecond2

                             , (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END ELSE 0 END) AS AmountSh
                             , (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 AND MIFloat_MovementId.ValueData =  inMovementId_send THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END ELSE 0 END) AS AmountShSecond1
                             , (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 AND MIFloat_MovementId.ValueData <> inMovementId_send THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END ELSE 0 END) AS AmountShSecond2

                             , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                             , ObjectFloat_Weight.ValueData           AS Weight 
                             , MovementItem.isErased
                        FROM MovementItem
                             INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                AND Movement.DescId = zc_Movement_OrderExternal()   
                             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                   ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                        WHERE MovementItem.DescId = zc_MI_Child()
                          AND (MovementItem.isErased = inIsErased OR inIsErased = TRUE)
                          AND MovementItem.MovementId IN (SELECT DISTINCT tmpMI_bySend.MovementId FROM tmpMI_bySend)
                        )

           -- Существующие MovementItem
      , tmpMI_Master AS (SELECT MovementItem.MovementId
                              , MovementItem.Id                AS MovementItemId
                              , MovementItem.ObjectId          AS GoodsId
                              , MILO_GoodsKind.ObjectId        AS GoodsKindId
                              , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                              , ObjectFloat_Weight.ValueData           AS Weight
                              , COALESCE (MovementItem.Amount,0) + COALESCE (MIF_AmountSecond.ValueData, 0) AS Amount
                              , (COALESCE (MovementItem.Amount,0) + COALESCE (MIF_AmountSecond.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END  AS AmountWeight
                              , (COALESCE (MovementItem.Amount,0) + COALESCE (MIF_AmountSecond.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END  AS AmountSh
                              , MovementItem.isErased
                         FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIF_AmountSecond
                                                          ON MIF_AmountSecond.MovementItemId = MovementItem.Id
                                                         AND MIF_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                              LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                               ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                    ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                   AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                         WHERE MovementItem.Id IN (SELECT DISTINCT tmpMI_Child.ParentId FROM tmpMI_Child)
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased   = FALSE
                        )

      , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                     FROM MovementItemLinkObject
                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                       AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                     )

      , tmpMI_Float AS (SELECT MovementItemFloat.*
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                          AND MovementItemFloat.DescId IN (zc_MIFloat_Remains())
                       )
      , tmpMI AS (SELECT MovementItem.ParentId
                       , MovementItem.MovementId                       AS MovementId_order
                       , MovementItem.GoodsId                          AS GoodsId 
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       
                       , SUM (MovementItem.AmountWeight) AS AmountWeight
                       , SUM (MovementItem.AmountWeightSecond1) AS AmountWeightSecond1
                       , SUM (MovementItem.AmountWeightSecond2) AS AmountWeightSecond2

                       , SUM (MovementItem.AmountSh) AS AmountSh
                       , SUM (MovementItem.AmountShSecond1) AS AmountShSecond1
                       , SUM (MovementItem.AmountShSecond2) AS AmountShSecond2

                       , SUM (MovementItem.Amount) AS Amount
                       , SUM (MovementItem.AmountSecond1) AS AmountSecond1
                       , SUM (MovementItem.AmountSecond2) AS AmountSecond2
                       ----
                       , SUM (COALESCE (MIFloat_Remains.ValueData, 0))       AS Amount_remains
                       , SUM (COALESCE (MIFloat_Remains.ValueData, 0) * CASE WHEN MovementItem.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END)                   AS AmountSh_remains
                       , SUM (COALESCE (MIFloat_Remains.ValueData, 0) * CASE WHEN MovementItem.MeasureId = zc_Measure_Sh() THEN MovementItem.Weight ELSE 1 END) AS AmountWeight_remains

                        , MovementItem.MeasureId
                        , MovementItem.Weight
                       --, MovementItem.isErased
                         -- № п/п
                       , ROW_NUMBER() OVER (PARTITION BY MovementItem.GoodsId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ORDER BY SUM (MovementItem.AmountSecond1) desc) AS Ord
                  FROM tmpMI_Child AS MovementItem
                       LEFT JOIN tmpMI_LO AS MILinkObject_GoodsKind
                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     
                       LEFT JOIN tmpMI_Float AS MIFloat_Remains
                                             ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                            AND MIFloat_Remains.DescId = zc_MIFloat_Remains() 
                  
                  GROUP BY MovementItem.ParentId
                         , MovementItem.MovementId
                         , MovementItem.GoodsId
                         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                         , MovementItem.MeasureId
                         , MovementItem.Weight
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
             0 :: Integer    AS Id
           , tmpMI.ParentId       :: Integer
           , CAST (row_number() OVER (Order BY Movement_Order.Id, tmpMI.ParentId) AS Integer) AS LineNum --CAST (row_number() OVER () AS Integer) AS LineNum

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

           , tmpMI.AmountSecond1       :: TFloat   AS AmountSecond
           , tmpMI.AmountSh            :: TFloat   AS AmountSh 
           , tmpMI.AmountShSecond1     :: TFloat   AS AmountShSecond1
           , tmpMI.AmountShSecond2     :: TFloat   AS AmountShSecond2 

           , tmpMI.AmountWeight            :: TFloat   AS AmountWeight
           , tmpMI.AmountWeightSecond1     :: TFloat   AS AmountWeightSecond1
           , tmpMI.AmountWeightSecond2     :: TFloat   AS AmountWeightSecond2
           
           , tmpMI.AmountSh_remains        :: TFloat
           , tmpMI.AmountWeight_remains    :: TFloat
           
           , CASE WHEN tmpMI.Ord = 1 THEN tmpMI_Send.AmountSh     ELSE 0 END ::TFloat AS AmountSh_send
           , CASE WHEN tmpMI.Ord = 1 THEN tmpMI_Send.AmountWeight ELSE 0 END ::TFloat AS AmountWeight_send   

           , tmpMI_Master.AmountSh     ::TFloat AS AmountSh_order
           , tmpMI_Master.AmountWeight ::TFloat AS AmountWeight_order
           
           , (COALESCE (tmpMI_Master.AmountWeight, 0)
             - (COALESCE (tmpMI.AmountWeight, 0) + COALESCE (tmpMI.AmountWeightSecond1, 0)+ COALESCE (tmpMI.AmountWeightSecond2, 0)) ):: TFloat AS AmountWeight_diff
             -- Заявка - переводим в ед.изм. - MeasureId_child
          /* , CASE WHEN tmpMI.Ord = 1
                       THEN CASE -- ничего не делать
                                 WHEN tmpMI_Master.MeasureId = tmpMI.MeasureId
                                      THEN tmpMI_Master.Amount
                                 -- Переводим в Вес
                                 WHEN tmpMI_Master.MeasureId  = zc_Measure_Sh() AND tmpMI.MeasureId <> zc_Measure_Sh()
                                      THEN tmpMI_Master.Amount * COALESCE (tmpMI_Master.Weight, 0)
                                 -- Переводим в ШТ
                                 WHEN tmpMI_Master.MeasureId <> zc_Measure_Sh() AND tmpMI.MeasureId   = zc_Measure_Sh()
                                      THEN CASE WHEN tmpMI_Master.Weight > 0
                                                     THEN tmpMI_Master.Amount / tmpMI_Master.Weight
                                                ELSE 0
                                           END
                                 -- ???ничего не делать
                                 ELSE tmpMI_Master.Amount
                            END
                  ELSE 0
             END :: TFloat AS Amount_order

           , (COALESCE (CASE WHEN tmpMI.Ord = 1
                                  THEN CASE -- ничего не делать
                                            WHEN tmpMI_Master.MeasureId = tmpMI.MeasureId
                                                 THEN tmpMI_Master.Amount
                                            -- Переводим в Вес
                                            WHEN tmpMI_Master.MeasureId  = zc_Measure_Sh() AND tmpMI.MeasureId <> zc_Measure_Sh()
                                                 THEN tmpMI_Master.Amount * COALESCE (tmpMI_Master.Weight, 0)
                                            -- Переводим в ШТ
                                            WHEN tmpMI_Master.MeasureId <> zc_Measure_Sh() AND tmpMI.MeasureId   = zc_Measure_Sh()
                                                 THEN CASE WHEN tmpMI_Master.Weight > 0
                                                                THEN tmpMI_Master.Amount / tmpMI_Master.Weight
                                                           ELSE 0
                                                      END
                                            -- ???ничего не делать
                                            ELSE tmpMI_Master.Amount
                                       END
                             ELSE 0
                        END, 0)
            - (COALESCE (tmpMI.Amount, 0) + COALESCE (tmpMI.AmountSecond1, 0))
             ) :: TFloat AS Amount_diff        
             */
             
           , Movement_Order.Id                   AS MovementId_order
           , Movement_Order.InvNumber            AS InvNumber_order
           , Movement_Order.OperDate             AS OperDate_order
           
           , CASE WHEN tmpPeresort.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPeresort
       
           , FALSE AS isErased --tmpMI.isErased

       FROM tmpMI_Send
            INNER JOIN tmpMI ON tmpMI.GoodsId = tmpMI_Send.GoodsId
                            AND tmpMI.GoodsKindId = tmpMI_Send.GoodsKindId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            
           /* LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure() */
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpMI.MeasureId

            LEFT JOIN tmpMI_Master ON tmpMI_Master.MovementItemId = tmpMI.ParentId

            LEFT JOIN (SELECT tmpPeresort.GoodsId, tmpPeresort.GoodsKindId
                       FROM tmpPeresort
                      UNION
                       SELECT tmpPeresort.GoodsId_sub AS GoodsId, tmpPeresort.GoodsKindId_sub AS GoodsKindId
                       FROM tmpPeresort
                      ) AS tmpPeresort ON tmpPeresort.GoodsId     = tmpMI.GoodsId
                                      AND tmpPeresort.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_Goods_master     ON Object_Goods_master.Id     = tmpMI_Master.GoodsId
            LEFT JOIN Object AS Object_GoodsKind_master ON Object_GoodsKind_master.Id = tmpMI_Master.GoodsKindId

          /*  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_master
                                 ON ObjectLink_Goods_Measure_master.ObjectId = tmpMI_Master.GoodsId
                                AND ObjectLink_Goods_Measure_master.DescId = zc_ObjectLink_Goods_Measure()  */
            LEFT JOIN Object AS Object_Measure_master ON Object_Measure_master.Id = tmpMI_Master.MeasureId
           /* LEFT JOIN ObjectFloat AS ObjectFloat_Weight_master
                                  ON ObjectFloat_Weight_master.ObjectId = tmpMI_Master.GoodsId
                                 AND ObjectFloat_Weight_master.DescId   = zc_ObjectFloat_Goods_Weight() */

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                  
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = tmpMI.MovementId_order 

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.22         *
*/

-- тест
--  
SELECT * FROM gpSelect_MI_OrderExternalChild_bySend (inMovementId_send:= 23086444  , inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())  
where goodsid = 4965

-- select * from movement where id  = 23086444   "304586"	"2022-07-24 00:00:00+03"
