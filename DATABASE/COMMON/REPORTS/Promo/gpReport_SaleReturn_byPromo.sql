
DROP FUNCTION IF EXISTS gpReport_SaleReturn_byPromo(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleReturn_byPromo(
    IN inMovementId     Integer,   --
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(MovementId           Integer   --
            , ItemName             TVarChar
            , OperDate             TDateTime
            , OperDatePartner      TDateTime
            , InvNumber            Integer   --
            , InvNumberPartner     TVarChar
            , FromName             TVarChar  
            , ToName               TVarChar
            , OperDate_ord         TDateTime
            , OperDatePartner_ord  TDateTime
            , Invnumber_ord        TVarChar--Integer
            , InvNumberPartner_ord TVarChar
            , GoodsName            TVarChar  --Позиция
            , GoodsCode            Integer   --Код позиции
            , GoodsKindName        TVarChar  --Вид упаковки
                 
            , AmountOut            TFloat    --Кол-во реализация (факт)
            , AmountOutWeight      TFloat    --Кол-во реализация (факт) Вес
            , AmountIn             TFloat    --Кол-во возврат (факт)
            , AmountInWeight       TFloat    --Кол-во возврат (факт) Вес
            , AmountOrder          TFloat    --Кол-во заявка (факт)
            , AmountOrderWeight    TFloat    --Кол-во заявка (факт) Вес

            , Summ_diff   TFloat
            , Price_pl TFloat
            , Price    TFloat
            )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN

    -- Результат
    RETURN QUERY
    
    WITH
          -- выбираем все док продажи и возврата по док. Акция
          tmpMovement AS (SELECT Movement.Id
                               , Movement.OperDate
                               , Movement.Invnumber
                               , Movement.DescId
                               , MovementItem.Id AS MovementItemId
                               , MovementItem.ObjectId                         AS GoodsId
                               , MIFloat_PromoMovement.ValueData
                               , MovementItem.Amount
                          FROM MovementItemFloat AS MIFloat_PromoMovement
                               INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_PromoMovement.MovementItemId
                                                      AND MovementItem.isErased = FALSE
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.DescId IN ( zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal())
                          WHERE MIFloat_PromoMovement.ValueData = inMovementId
                            AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                        )

        , tmpOperDatePartner AS (SELECT MovementDate.*
                                 FROM MovementDate
                                 WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                                 )

        , tmpMovementLinkObject_To AS (SELECT MovementLinkObject.*
                                       FROM MovementLinkObject
                                       WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                         AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                                       )

        , tmpMovementLinkObject_From AS (SELECT MovementLinkObject.*
                                         FROM MovementLinkObject
                                         WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                           AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                       )
        , tmpInvNumberPartner AS (SELECT MovementString.*
                                  FROM MovementString
                                  WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                    AND MovementString.DescId = zc_MovementString_InvNumberPartner()
                                 )
        , tmpMLM_Order AS (SELECT MovementLinkMovement.*
                           FROM MovementLinkMovement
                           WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                           )

        , tmpInvNumberPartner_ord AS (SELECT MovementString.*
                                      FROM MovementString
                                      WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMLM_Order.MovementChildId FROM tmpMLM_Order)
                                        AND MovementString.DescId = zc_MovementString_InvNumberPartner()
                                      )
        , tmpOperDatePartner_ord AS (SELECT MovementDate.*
                                     FROM MovementDate
                                     WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMLM_Order.MovementChildId FROM tmpMLM_Order)
                                       AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                                     )

        , tmpMI_GoodsKind AS (SELECT *
                              FROM MovementItemLinkObject 
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovement.MovementItemId FROM tmpMovement)
                                AND MovementItemLinkObject.DescId         = zc_MILinkObject_GoodsKind()
                              )

        , tmpMovementItemFloat AS (SELECT *
                                   FROM MovementItemFloat 
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovement.MovementItemId FROM tmpMovement)
                                     AND MovementItemFloat.DescId   IN (zc_MIFloat_AmountPartner()
                                                                      , zc_MIFloat_AmountSecond()
                                                                      , zc_MIFloat_ChangePercent()
                                                                      , zc_MIFloat_Price())
                                   )

        -- определяем прайсы и цены
        , tmp2 AS (SELECT Movement.*
                        , MovementLinkObject_Contract.ObjectId AS ContractId
                        , MovementLinkObject_Partner.ObjectId  AS PartnerId
                        , tmpOperDatePartner.ValueData         AS OperDatePartner
                   FROM tmpMovementSale_1 AS Movement
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                     ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                    AND MovementLinkObject_Partner.DescId = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END          
                        LEFT JOIN tmpOperDatePartner ON tmpOperDatePartner.MovementId = Movement.Id
                   )

        , tmpPriceListAll AS (SELECT Movement.ContractId
                                   , Movement.PartnerId
                                   , Movement.OperDate
                                   , tmp.PriceListId
                              FROM (SELECT DISTINCT tmp.OperDate, tmp.OperDatePartner, tmp.ContractId, tmp.PartnerId  FROM tmp2 AS tmp) AS Movement
                                  LEFT JOIN lfGet_Object_Partner_PriceList_onDate (inContractId     := Movement.ContractId
                                                                                 , inPartnerId      := Movement.PartnerId
                                                                                 , inMovementDescId := zc_Movement_Sale() -- !!!не ошибка!!!
                                                                                 , inOperDate_order := Movement.OperDate
                                                                                 , inOperDatePartner:= NULL
                                                                                 , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                                                                 , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                                                                 , inOperDatePartner_order:= Movement.OperDatePartner
                                                                                  ) AS tmp ON 1=1

                              )

        , tmpMovementFact AS (SELECT Movement.*
                                   , tmpPriceListAll.PriceListId
                              FROM tmp2 AS Movement
                                   LEFT JOIN tmpPriceListAll ON tmpPriceListAll.OperDate = Movement.OperDate
                                                            AND tmpPriceListAll.ContractId = Movement.ContractId
                                                            AND tmpPriceListAll.PartnerId = Movement.PartnerId
                              )

          -- Цены из прайса
        , tmpPriceList AS (SELECT tmp.PriceListId
                                , tmp.OperDate
                                , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                                , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                                , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                           FROM (SELECT DISTINCT tmpMovementSale.PriceListId, tmpMovementSale.OperDate FROM tmpMovementSale) AS tmp
                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                     ON ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                                                    AND ObjectLink_PriceListItem_PriceList.ChildObjectId = tmp.PriceListId
                                                    
                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                     ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                    AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                                LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                     ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                    AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()
                    
                                LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                        ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                       AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                       AND tmp.OperDate >= ObjectHistory_PriceListItem.StartDate AND tmp.OperDate < ObjectHistory_PriceListItem.EndDate
                                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                             ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                            AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                           WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
                           )




        SELECT tmpMovement.Id                               AS MovementId
             , MovementDesc.ItemName                        AS ItemName
             , tmpMovement.OperDate                         AS OperDate
             , tmpOperDatePartner.ValueData                 AS OperDatePartner
             , tmpMovement.Invnumber             ::Integer  AS Invnumber
             , tmpInvNumberPartner.ValueData     ::TVarChar AS InvNumberPartner
             , Object_From.ValueData             ::TVarChar AS FromName
             , Object_To.ValueData               ::TVarChar AS ToName
             , Movement_order.OperDate                      AS OperDate_ord
             , tmpOperDatePartner_ord.ValueData             AS OperDatePartner_ord
             , Movement_order.Invnumber          ::TVarChar AS Invnumber_ord
             , tmpInvNumberPartner_ord.ValueData ::TVarChar AS InvNumberPartner_ord
             , Object_Goods.ValueData                       AS GoodsName
             , Object_Goods.ObjectCode                      AS GoodsCode
             , Object_GoodsKind.ValueData                   AS GoodsKindName
        
             , (CASE WHEN tmpMovement.DescId = zc_Movement_Sale()  THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)         :: TFloat AS AmountOut
             , ( CASE WHEN tmpMovement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END ) :: TFloat AS AmountOutWeight

             , (CASE WHEN tmpMovement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)      :: TFloat AS AmountIn
             , (CASE WHEN tmpMovement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END ) :: TFloat AS AmountInWeight

             , (CASE WHEN tmpMovement.DescId = zc_Movement_OrderExternal() THEN COALESCE (tmpMovement.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) :: TFloat AS AmountOrder
             , (CASE WHEN tmpMovement.DescId = zc_Movement_OrderExternal() THEN COALESCE (tmpMovement.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END
                * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END ) :: TFloat AS AmountOrderWeight

             , ((CASE WHEN tmpMovement.DescId = zc_Movement_Sale()  THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END 
               - CASE WHEN tmpMovement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)
                     * (COALESCE (tmpPriceList.ValuePrice,tmpPriceListAll.ValuePrice,0) - COALESCE (MIFloat_Price.ValueData,0) ) )        :: TFloat AS Summ_diff

             , COALESCE (tmpPriceList.ValuePrice,tmpPriceListAll.ValuePrice,0) :: TFloat AS Price_pl
             , COALESCE (MIFloat_Price.ValueData,0) ELSE 0 END                 :: TFloat AS Price
                               
        FROM tmpMovementFact AS tmpMovement
        LEFT JOIN tmpMovementLinkObject_From ON tmpMovementLinkObject_From.MovementId = tmpMovement.Id
        LEFT JOIN tmpMovementLinkObject_To ON tmpMovementLinkObject_To.MovementId = tmpMovement.Id
        LEFT JOIN tmpOperDatePartner ON tmpOperDatePartner.MovementId = tmpMovement.Id
        LEFT JOIN tmpInvNumberPartner ON tmpInvNumberPartner.MovementId = tmpMovement.Id
        LEFT JOIN tmpMLM_Order AS MovementLinkMovement_Order ON MovementLinkMovement_Order.MovementId = tmpMovement.Id
        
        LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId
        
        LEFT JOIN tmpOperDatePartner_ord ON tmpOperDatePartner_ord.MovementId = MovementLinkMovement_Order.MovementChildId
        LEFT JOIN tmpInvNumberPartner_ord ON tmpInvNumberPartner_ord.MovementId = MovementLinkMovement_Order.MovementChildId

        LEFT JOIN tmpMI_GoodsKind AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = tmpMovement.MovementItemId
 
        LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner
                                       ON MIFloat_AmountPartner.MovementItemId = tmpMovement.MovementItemId
                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
        LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountSecond
                                       ON MIFloat_AmountSecond.MovementItemId = tmpMovement.MovementItemId
                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
        LEFT JOIN tmpMovementItemFloat AS MIFloat_ChangePercent
                                       ON MIFloat_ChangePercent.MovementItemId = tmpMovement.MovementItemId
                                      AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

        LEFT JOIN tmpMovementItemFloat AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId = Movement.MovementItemId
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovement.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
        LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovementLinkObject_From.ObjectId
        LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovementLinkObject_To.ObjectId
        LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMovement.DescId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = tmpMovement.GoodsId
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                    ON ObjectFloat_Goods_Weight.ObjectId = tmpMovement.GoodsId
                                   AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

        LEFT JOIN tmpPriceList ON tmpPriceList.PriceListId = tmpMovement.PriceListId
                              AND tmpPriceList.OperDate = tmpMovement.OperDate
                              AND tmpPriceList.GoodsId = tmpMovement.GoodsId
                              AND COALESCE (tmpPriceList.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)
        LEFT JOIN tmpPriceList AS tmpPriceListAll
                               ON tmpPriceListAll.PriceListId = tmpMovement.PriceListId
                              AND tmpPriceListAll.OperDate = tmpMovement.OperDate
                              AND tmpPriceListAll.GoodsId = tmpMovement.GoodsId
                              AND COALESCE (tmpPriceListAll.GoodsKindId,0) = 0
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.20         *
*/

-- тест
--SELECT * FROM gpReport_SaleReturn_byPromo (inMovementId:= 16383392, inSession := '5' ::TVarChar)