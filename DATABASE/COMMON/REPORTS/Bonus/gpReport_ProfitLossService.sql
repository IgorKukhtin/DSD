-- Function: gpReport_ProfitLossService ()

DROP FUNCTION IF EXISTS gpReport_ProfitLossService (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLossService (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, MovementDescName TVarChar
             , MovementId_doc Integer, OperDate_Doc TDateTime, InvNumber_doc TVarChar, InvNumber_full_doc TVarChar, MovementDescName_doc TVarChar
             , TradeMarkName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , AmountMarket TFloat
             , SummInMarket Tfloat
             , SummOutMarket  Tfloat
             , AmountMarket_calc  Tfloat
             , SummInMarket_calc  Tfloat
             , SummOutMarket_calc Tfloat
                 
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
      WITH 
      tmpMovementFull AS (SELECT Movement.*
                          FROM Movement
                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.DescId = zc_Movement_ProfitLossService()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          )

    , tmpMLM_doc AS (SELECT MLM.*
                     FROM MovementLinkMovement AS MLM
                     WHERE MLM.DescId = zc_MovementLinkMovement_Doc()
                       AND MLM.MovementId IN (SELECT DISTINCT tmpMovementFull.Id FROM tmpMovementFull)
                     )

    , tmpML0 AS (SELECT MovementLinkObject.*
                     FROM MovementLinkObject
                     WHERE MovementLinkObject.DescId = zc_MovementLinkObject_TradeMark()
                       AND MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovementFull.Id FROM tmpMovementFull)
                     )

    --сумма начислений
    , tmpMI AS (SELECT MovementItem.MovementId
                     , CASE WHEN MovementItem.Amount > 0
                                 THEN MovementItem.Amount
                            ELSE 0
                       END::TFloat                                    AS AmountIn
                     , CASE WHEN MovementItem.Amount < 0
                                 THEN -1 * MovementItem.Amount
                            ELSE 0
                       END::TFloat                                    AS AmountOut
                FROM MovementItem
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementFull.Id FROM tmpMovementFull) 
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
                  AND COALESCE (MovementItem.Amount,0) <> 0
                )

    , tmpMovement AS (SELECT Movement.Id              AS MovementId
                           , Movement.DescId          AS MovementDescId
                           , Movement.OperDate
                           , Movement.InvNumber
                           , MLM_Doc.MovementChildId  AS MovementId_doc     
                           , MovementLinkObject_TradeMark.ObjectId AS TradeMarkId
                           , MovementItem.AmountIn
                           , MovementItem.AmountOut
                      FROM tmpMovementFull AS Movement
                          INNER JOIN tmpMLM_doc AS MLM_Doc
                                                ON MLM_Doc.MovementId = Movement.Id
                                               AND MLM_Doc.DescId = zc_MovementLinkMovement_Doc() 

                          LEFT JOIN tmpML0 AS MovementLinkObject_TradeMark
                                           ON MovementLinkObject_TradeMark.MovementId = Movement.Id
                                          AND MovementLinkObject_TradeMark.DescId = zc_MovementLinkObject_TradeMark()


                          LEFT JOIN tmpMI AS MovementItem 
                                          ON MovementItem.MovementId = Movement.Id 
                      )

    , tmpMI_doc AS (SELECT MovementItem.*
                    FROM MovementItem
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMLM_doc.MovementChildId FROM tmpMLM_doc) 
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                    )

    , tmpMIFloat_doc AS (SELECT MovementItemFloat.*
                         FROM MovementItemFloat
                         WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_doc.Id FROM tmpMI_doc)
                           AND MovementItemFloat.DescId IN (zc_MIFloat_AmountMarket()
                                                          , zc_MIFloat_SummOutMarket()
                                                          , zc_MIFloat_SummInMarket()
                                                           )
                           AND COALESCE (MovementItemFloat.ValueData,0) <> 0
                        )

    , tmpMILO_doc AS (SELECT MovementItemLinkObject.*
                      FROM MovementItemLinkObject
                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_doc.Id FROM tmpMI_doc)
                        AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                     )

    , tmpData AS (SELECT tmpMovement.MovementId
                       , tmpMovement.MovementDescId
                       , tmpMovement.OperDate
                       , tmpMovement.InvNumber
                       , tmpMovement.MovementId_doc
                       , tmpMovement.TradeMarkId
                       , MovementItem.ObjectId AS GoodsId  
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 

                       , tmpMovement.AmountIn
                       , tmpMovement.AmountOut
                       , MIFloat_AmountMarket.ValueData  ::TFloat AS AmountMarket
                       , MIFloat_SummOutMarket.ValueData ::TFloat AS SummOutMarket
                       , MIFloat_SummInMarket.ValueData  ::TFloat AS SummInMarket
             
                  FROM tmpMovement
                   LEFT JOIN tmpMI_doc AS MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_doc

                   LEFT JOIN tmpMILO_doc AS MILinkObject_GoodsKind
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN tmpMIFloat_doc AS MIFloat_AmountMarket
                                            ON MIFloat_AmountMarket.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountMarket.DescId = zc_MIFloat_AmountMarket()
                   LEFT JOIN tmpMIFloat_doc AS MIFloat_SummOutMarket
                                            ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                           AND MIFloat_SummOutMarket.DescId = zc_MIFloat_SummOutMarket()
                   LEFT JOIN tmpMIFloat_doc AS MIFloat_SummInMarket
                                            ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                           AND MIFloat_SummInMarket.DescId = zc_MIFloat_SummInMarket()
             )
 


             SELECT tmpData.MovementId
                  , tmpData.OperDate
                  , tmpData.InvNumber
                  , MovementDesc.ItemName       AS MovementDescName
                  , CASE WHEN COALESCE (Movement_Doc.Id,0) <> 0 THEN Movement_Doc.Id ELSE -1 END ::Integer AS MovementId_doc
                  , Movement_Doc.OperDate       AS OperDate_Doc
                  , Movement_Doc.InvNumber      AS InvNumber_doc
                  , zfCalc_PartionMovementName (Movement_Doc.DescId, MovementDesc_Doc.ItemName, Movement_Doc.InvNumber, Movement_Doc.OperDate) :: TVarChar AS InvNumber_full_doc
                  , MovementDesc_Doc.ItemName   AS MovementDescName_doc   
                  , Object_TradeMark.ValueData  AS TradeMarkName

                  , Object_Goods.Id             AS GoodsId
                  , Object_Goods.ObjectCode     AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_GoodsKind.ValueData  AS GoodsKindName
                  , tmpData.AmountIn  :: Tfloat
                  , tmpData.AmountOut :: Tfloat
                  , tmpData.AmountMarket  :: Tfloat
                  , tmpData.SummInMarket  :: Tfloat
                  , tmpData.SummOutMarket :: Tfloat
                  

                  , 0 :: Tfloat  AS AmountMarket_calc 
                  , 0 :: Tfloat  AS SummInMarket_calc 
                  , 0 :: Tfloat  AS SummOutMarket_calc

             FROM tmpData 
                LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
                LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
                
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
                
                LEFT JOIN Movement AS Movement_Doc ON Movement_Doc.Id = tmpData.MovementId_doc
                LEFT JOIN MovementDesc AS MovementDesc_Doc ON MovementDesc_Doc.Id = Movement_Doc.DescId
       ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.08.24         *
*/

-- тест
--  SELECT * FROM gpReport_ProfitLossService (inStartDate:= '01.04.2024', inEndDate:= '15.04.2025', inSession:= zfCalc_UserAdmin());
