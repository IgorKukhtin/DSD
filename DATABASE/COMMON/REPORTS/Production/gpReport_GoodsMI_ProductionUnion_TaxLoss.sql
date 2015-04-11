-- Function: gpReport_GoodsMI_ProductionUnion_TaxLoss () - <Производство ГП и процент потерь (итоги)>

DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionUnion_TaxLoss (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_ProductionUnion_TaxLoss (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inFromId       Integer   , 
    IN inToId         Integer   , 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , Amount_in TFloat
             , AmountReceipt_out TFloat
             , Amount_out TFloat
             , AmountSend_out TFloat
             , AmountSend_In TFloat
              )
AS
$BODY$
BEGIN

    -- Результат
    RETURN QUERY
         -- приходы ГП с inFromId на inToId, через производство
    WITH tmpMI_GP_in AS
                     (SELECT MIContainer.Id                          AS Id
                           , MIContainer.MovementItemId              AS MovementItemId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                           , CLO_GoodsKind.ObjectId                  AS GoodsKindId
                           , MIContainer.Amount                      AS Amount
                           , CASE WHEN ObjectFloat_Value_master.ValueData <> 0 THEN COALESCE (ObjectFloat_Value_child.ValueData, 0) * MIContainer.Amount / ObjectFloat_Value_master.ValueData ELSE 0 END AS AmountReceipt_out
                      FROM MovementItemContainer AS MIContainer
                           INNER JOIN MovementLinkObject AS MLO_From
                                                         ON MLO_From.MovementId = MIContainer.MovementId
                                                        AND MLO_From.DescId = zc_MovementLinkObject_From()
                                                        AND MLO_From.ObjectId = inFromId
                           INNER JOIN ContainerLinkObject AS CLO_GoodsKind
                                                          ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                                         AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                           LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                            ON MILO_Receipt.MovementItemId = MIContainer.MovementItemId
                                                           AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Value_master
                                                 ON ObjectFloat_Value_master.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = MILO_Receipt.ObjectId
                                               AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Value_child
                                                 ON ObjectFloat_Value_child.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                AND ObjectFloat_Value_child.DescId = zc_ObjectFloat_ReceiptChild_Value()
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.WhereObjectId_Analyzer = inToId
                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        AND MIContainer.IsActive = TRUE
                        AND MIContainer.Amount <> 0
                      )
         -- расход на производство ГП с inFromId на inToId
       , tmpMI_GP_out AS
                     (SELECT tmpMI_GP_in.GoodsId
                           , tmpMI_GP_in.GoodsKindId
                           , SUM (-1 * MIContainer.Amount) AS Amount
                      FROM tmpMI_GP_in
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ParentId = tmpMI_GP_in.Id
                                                           AND MIContainer.DescId = zc_MIContainer_Count()
                      GROUP BY tmpMI_GP_in.GoodsId
                             , tmpMI_GP_in.GoodsKindId
                      )
         -- перемещени ГП с inFromId на inToId + с inToId на inFromId, т.е. возврат в цех и приход из цеха по перемещению
       , tmpMI_GP_send AS
                     (SELECT MIContainer.ObjectId_Analyzer           AS GoodsId
                           , CLO_GoodsKind.ObjectId                  AS GoodsKindId
                           , SUM (CASE WHEN MIContainer.isActive = TRUE THEN -1 * MIContainer.Amount ELSE 0 END) AS Amount_out   -- !!!не ошибка, т.е. расход в цех по перемещению!!!
                           , SUM (CASE WHEN MIContainer.isActive = FALSE  THEN -1 * MIContainer.Amount ELSE 0 END) AS Amount_In  -- !!!не ошибка, т.е. расход из цеха по перемещению!!!
                      FROM MovementItemContainer AS MIContainer
                           INNER JOIN MovementLinkObject AS MLO_From
                                                         ON MLO_From.MovementId = MIContainer.MovementId
                                                        AND MLO_From.DescId = zc_MovementLinkObject_From()
                                                        AND MLO_From.ObjectId IN (inFromId, inToId)
                           INNER JOIN MovementLinkObject AS MLO_To
                                                         ON MLO_To.MovementId = MIContainer.MovementId
                                                        AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                        AND MLO_To.ObjectId IN (inFromId, inToId)
                           INNER JOIN ContainerLinkObject AS CLO_GoodsKind
                                                          ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                                         AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.WhereObjectId_Analyzer = inFromId
                        AND MIContainer.MovementDescId = zc_Movement_Send()
                        AND MIContainer.Amount <> 0
                      GROUP BY MIContainer.ObjectId_Analyzer
                             , CLO_GoodsKind.ObjectId
                      )
         -- результат - группируется
       , tmpResult AS
                     (SELECT tmp.GoodsId
                           , tmp.GoodsKindId
                           , SUM (tmp.Amount_in)             AS Amount_in
                           , SUM (tmp.AmountReceipt_out)     AS AmountReceipt_out
                           , SUM (tmp.Amount_out)            AS Amount_out
                           , SUM (tmp.AmountSend_out)        AS AmountSend_out
                           , SUM (tmp.AmountSend_In)         AS AmountSend_In
                      FROM
                     (SELECT tmpMI_GP_in.GoodsId
                           , tmpMI_GP_in.GoodsKindId
                           , SUM (tmpMI_GP_in.Amount)            AS Amount_in
                           , SUM (tmpMI_GP_in.AmountReceipt_out) AS AmountReceipt_out
                           , 0 AS Amount_out
                           , 0 AS AmountSend_out
                           , 0 AS AmountSend_In
                      FROM tmpMI_GP_in
                      GROUP BY tmpMI_GP_in.GoodsId
                             , tmpMI_GP_in.GoodsKindId
                     UNION ALL
                      SELECT tmpMI_GP_out.GoodsId
                           , tmpMI_GP_out.GoodsKindId
                           , 0 AS Amount_in
                           , 0 AS AmountReceipt_out
                           , tmpMI_GP_out.Amount AS Amount_out
                           , 0 AS AmountSend_out
                           , 0 AS AmountSend_In
                      FROM tmpMI_GP_out
                     UNION ALL
                      SELECT tmpMI_GP_send.GoodsId
                           , tmpMI_GP_send.GoodsKindId
                           , 0 AS Amount_in
                           , 0 AS AmountReceipt_out
                           , 0 AS Amount_out
                           , tmpMI_GP_send.Amount_out AS AmountSend_out
                           , tmpMI_GP_send.Amount_In  AS AmountSend_In
                      FROM tmpMI_GP_send
                     ) AS tmp
                      GROUP BY tmp.GoodsId
                             , tmp.GoodsKindId
                     )

    SELECT ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName

         , tmpResult.Amount_in         :: TFloat AS Amount_in
         , tmpResult.AmountReceipt_out :: TFloat AS AmountReceipt_out
         , tmpResult.Amount_out        :: TFloat AS Amount_out
         , tmpResult.AmountSend_out    :: TFloat AS AmountSend_out
         , tmpResult.AmountSend_In     :: TFloat AS AmountSend_In

     FROM tmpResult
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpResult.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_ProductionUnion_TaxLoss (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.15                                        *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_ProductionUnion_TaxLoss (inStartDate:= '01.06.2014', inEndDate:= '01.06.2014', inFromId:= 8447, inToId:= 8458, inSession:= zfCalc_UserAdmin()) ORDER BY 2;
