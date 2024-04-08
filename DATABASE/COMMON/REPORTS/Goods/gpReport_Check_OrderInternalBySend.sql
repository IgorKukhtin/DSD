-- Function: gpReport_Check_OrderInternalBySend ()

DROP FUNCTION IF EXISTS gpReport_Check_OrderInternalBySend (TDateTime,TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_OrderInternalBySend (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inFromId            Integer   ,
    IN inToId              Integer   , --
    IN inGoodsGroupId      Integer   , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureName TVarChar
             , OrderAmount TFloat, SendAmount TFloat
             , AmountDiff TFloat
             , isUnder Boolean
             , isOver Boolean
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Ограничения по товарам
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;


    -- Результат
    RETURN QUERY
      WITH 
      tmpMovOrder  AS  (SELECT Movement.Id
                             , MovementLinkObject_From.ObjectId AS FromId
                             , MovementLinkObject_To.ObjectId   AS ToId
                        FROM Movement 
                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = Movement.Id 
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                          AND MovementLinkObject_To.ObjectId = inFromId
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id 
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                         --AND MovementLinkObject_From.ObjectId = inToId
                            
                        WHERE Movement.DescId   = zc_Movement_OrderInternal()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                       )
   , tmpMI_Order AS  (SELECT MI_Master.ObjectId                           AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId,0) AS GoodsKindId
                           , SUM (MI_Master.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0))  AS Amount
                      FROM tmpMovOrder
                           INNER JOIN MovementItem AS MI_Master 
                                                   ON MI_Master.MovementId = tmpMovOrder.Id
                                                  AND MI_Master.DescId     = zc_MI_Master()
                                                  AND MI_Master.isErased   = FALSE
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MI_Master.ObjectId

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MI_Master.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                       ON MIFloat_AmountSecond.MovementItemId = MI_Master.Id
                                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                ON ObjectLink_Goods_InfoMoney.ObjectId = MI_Master.ObjectId
                                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = CASE WHEN Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                                                                                                                        , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные  + Прочие материалы
                                                                                                                                         )
                                                                                    THEN 8455 -- Склад специй
                                                                                    ELSE tmpMovOrder.FromId
                                                                               END
                      WHERE Object_Unit.Id = inToId
                      GROUP BY MI_Master.ObjectId  
                           , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                      HAVING SUM (MI_Master.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) <> 0
                     )

     , tmpMovSend AS (SELECT Movement.Id
                      FROM Movement 
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id 
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                        AND MovementLinkObject_From.ObjectId = inFromId
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id 
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                        AND MovementLinkObject_To.ObjectId = inToId
                      WHERE Movement.DescId   = zc_Movement_Send()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                     )

   , tmpMI_Send AS  (SELECT MI_Master.ObjectId AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId,0)   AS GoodsKindId
                          , SUM (COALESCE (MI_Master.Amount, 0))           AS Amount
                      FROM tmpMovSend
                           INNER JOIN MovementItem AS MI_Master 
                                                   ON MI_Master.MovementId = tmpMovSend.Id
                                                  AND MI_Master.DescId     = zc_MI_Master()
                                                  AND MI_Master.isErased   = FALSE
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MI_Master.ObjectId
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MI_Master.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      WHERE COALESCE (MI_Master.Amount, 0) <> 0
                      GROUP BY MI_Master.ObjectId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                     )

   , tmpData AS (SELECT tmp.GoodsId
                      , tmp.GoodsKindId
                      , SUM (tmp.OrderAmount) AS OrderAmount
                      , SUM (tmp.SendAmount)  AS SendAmount
                 FROM (SELECT tmpMI_Order.GoodsId
                            , tmpMI_Order.GoodsKindId
                            , (tmpMI_Order.Amount)  AS OrderAmount
                            , 0            ::TFloat AS SendAmount
                       FROM tmpMI_Order
                       WHERE tmpMI_Order.Amount <> 0
                     UNION 
                       SELECT tmpMI_Send.GoodsId
                            , tmpMI_Send.GoodsKindId
                            , 0           ::TFloat AS OrderAmount
                            , (tmpMI_Send.Amount)  AS SendAmount
                       FROM tmpMI_Send
                       WHERE tmpMI_Send.Amount <> 0
                       ) AS tmp
                  GROUP BY tmp.GoodsId
                      , tmp.GoodsKindId
                 )

   
             -- результат
             SELECT Object_Goods.ObjectCode     AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_GoodsKind.ValueData  AS GoodsKindName
                  , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                  , Object_Measure.ValueData                    AS MeasureName
                  , tmpData.OrderAmount  :: Tfloat
                  , tmpData.SendAmount   :: Tfloat
                  , (tmpData.OrderAmount - tmpData.SendAmount) :: Tfloat AS AmountDiff
                  , CASE WHEN tmpData.SendAmount < tmpData.OrderAmount THEN TRUE ELSE FALSE END AS isUnder
                  , CASE WHEN tmpData.SendAmount > tmpData.OrderAmount THEN TRUE ELSE FALSE END AS isOver
              FROM tmpData
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
                
                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
 
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.17         *
*/

-- тест
-- select * from gpReport_Check_OrderInternalBySend(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('30.12.2016')::TDateTime , inFromId := 8455 , inToId := 8447 , inGoodsGroupId := 1917 ,  inSession := '5');
