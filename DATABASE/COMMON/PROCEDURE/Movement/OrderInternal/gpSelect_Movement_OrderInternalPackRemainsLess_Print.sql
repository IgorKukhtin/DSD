-- Function: gpSelect_Movement_OrderInternalPackRemainsLess_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemainsLess_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPackRemainsLess_Print(
    IN inMovementId    Integer  , -- ключ Документа
    IN inSession       TVarChar   -- сессия пользователя
)
RETURNS TABLE (FromId               Integer
             , FromName             TVarChar
             , GoodsId              Integer
             , GoodsCode            Integer
             , GoodsName            TVarChar
             , GoodsKindId          Integer
             , GoodsKindName        TVarChar
             , MeasureName          TVarChar
             , GoodsGroupNameFull   TVarChar
                
             , Amount_result_pack      TFloat
             , Amount_result_pack_pack TFloat
             , AmountPartnerPriorTotal TFloat
             , AmountPartnerTotal      TFloat
             , Income_PACK_from        TFloat
             , Remains                 TFloat
             , Remains_pack            TFloat
             , AmountPackAllTotal      TFloat

             , Amount_result_pack_sh      TFloat
             , AmountPartnerPriorTotal_sh TFloat
             , Remains_pack_sh            TFloat

             , Amount_result_pack_       TFloat
             , AmountPartnerPriorTotal_  TFloat
             , Remains_pack_             TFloat
                
             , AmountPartner              TFloat
             , AmountPartner_w            TFloat
             , AmountPartner_sh           TFloat
             
             , AmountPartnerPromo         TFloat
             , AmountPartnerPromo_w       TFloat
             , AmountPartnerPromo_sh      TFloat

             , AmountPartnerPrior         TFloat
             , AmountPartnerPrior_w      TFloat
             , AmountPartnerPrior_sh      TFloat
             
             , AmountPartnerPriorPromo    TFloat
             , AmountPartnerPriorPromo_w TFloat
             , AmountPartnerPriorPromo_sh TFloat
             
              )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbFromId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , MovementLinkObject_From.ObjectId
      INTO vbDescId, vbStatusId, vbOperDate, vbFromId
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

     -- очень важная проверка
     /*IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND vbUserId <> 5 -- !!!кроме Админа!!!
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;*/


      -- формируются данные в _Result_Master, _Result_Child, _Result_ChildTotal
      PERFORM lpSelect_MI_OrderInternalPackRemains (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inUserId:= vbUserId) ;

      -- Результат
      RETURN QUERY
           WITH 
                tmpUnit AS (SELECT tmp.UnitId
                            FROM lfSelect_Object_Unit_byGroup (vbFromId) AS tmp
                            )
              -- данные по недостающим товарам из _Result_Child
              , tmpGoods_Less AS (SELECT _Result_Child.GoodsId         
                                       , _Result_Child.GoodsCode
                                       , _Result_Child.GoodsName    
                                       , _Result_Child.GoodsKindId  
                                       , _Result_Child.GoodsKindName
                                       , _Result_Child.MeasureId  
                                       , _Result_Child.MeasureName       
                                       , _Result_Child.GoodsGroupNameFull
                                       
                                       , SUM (_Result_Child.Amount_result_pack)      AS Amount_result_pack
                                       , SUM (_Result_Child.Amount_result_pack_pack) AS Amount_result_pack_pack
                                       , SUM (_Result_Child.AmountPartnerPriorTotal) AS AmountPartnerPriorTotal
                                       , SUM (_Result_Child.AmountPartnerTotal)      AS AmountPartnerTotal
                                       , SUM (_Result_Child.Income_PACK_from)        AS Income_PACK_from
                                       , SUM (_Result_Child.Remains)                 AS Remains
                                       , SUM (_Result_Child.Remains_pack)            AS Remains_pack
                                       , SUM (_Result_Child.AmountPackAllTotal)      AS AmountPackAllTotal
                                   FROM _Result_Child
                                   WHERE (_Result_Child.Amount_result_pack_pack < 0
                                      OR _Result_Child.Amount_result_pack < 0)
                                      AND _Result_Child.GoodsKindId <> zc_GoodsKind_Basis()
                                   GROUP BY _Result_Child.GoodsId         
                                          , _Result_Child.GoodsCode
                                          , _Result_Child.GoodsName    
                                          , _Result_Child.GoodsKindId  
                                          , _Result_Child.GoodsKindName
                                          , _Result_Child.MeasureId  
                                          , _Result_Child.MeasureName       
                                          , _Result_Child.GoodsGroupNameFull
                                  )
              -- выбираем заявки
              , tmpMovementOrder AS (SELECT Movement.Id
                                          , Movement.InvNumber
                                          , Movement.OperDate
                                          , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                                          , MovementLinkObject_From.ObjectId       AS FromId           -- контрагент
                  
                                      FROM Movement
                                          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId

                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From() -- ограничить

                                      WHERE Movement.OperDate BETWEEN (vbOperDate - INTERVAL '3 DAY') AND (vbOperDate - INTERVAL '0 DAY')
                                        AND MovementDate_OperDatePartner.ValueData >= vbOperDate
                                        AND Movement.DescId = zc_Movement_OrderExternal()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                      )

              , tmpMIOrder AS (SELECT Movement.FromId
                                    , MovementItem.ObjectId                                             AS GoodsId
                                    , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())  AS GoodsKindId
                                                                              
                                    , SUM (CASE WHEN Movement.OperDate = vbOperDate 
                                                THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) 
                                                ELSE 0 END)                                             AS Amount1
                                    , SUM (CASE WHEN Movement.OperDate <> Movement.OperDatePartner 
                                                       AND Movement.OperDatePartner = vbOperDate 
                                                      THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                      ELSE 0 END)                                       AS Amount2
                                                      
                                      -- заказ покупателя БЕЗ акций, сегодня + завтра
                                    , SUM (CASE WHEN Movement.OperDate >= vbOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartner
                                      -- заказ покупателя ТОЛЬКО Акции, сегодня + завтра
                                    , SUM (CASE WHEN Movement.OperDate >= vbOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartnerPromo
 
                                      -- "информативно" заказ покупателя БЕЗ акций, завтра
                                    , SUM (CASE WHEN Movement.OperDate >= vbOperDate AND Movement.OperDatePartner > vbOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartnerNext
                                      -- "информативно" заказ покупателя ТОЛЬКО Акции, завтра
                                    , SUM (CASE WHEN Movement.OperDate >= vbOperDate AND Movement.OperDatePartner > vbOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartnerNextPromo
                                    
                                      -- заказ покупателя БЕЗ акций, неотгруж - вчера
                                    , SUM (CASE WHEN Movement.OperDate < vbOperDate
                                                 AND Movement.OperDatePartner >= vbOperDate
                                                 AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0
                                                     THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                ELSE 0
                                           END) AS AmountPartnerPrior
                                      -- заказ покупателя ТОЛЬКО Акции, неотгруж - вчера
                                    , SUM (CASE WHEN Movement.OperDate < vbOperDate
                                                 AND Movement.OperDatePartner >= vbOperDate
                                                 AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0
                                                     THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                ELSE 0
                                           END) AS AmountPartnerPriorPromo
                               FROM tmpMovementOrder AS Movement
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE

                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                    INNER JOIN tmpGoods_Less ON tmpGoods_Less.GoodsId = MovementItem.ObjectId
                                                            AND tmpGoods_Less.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())

                                    LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                               AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                                    LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                                ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_PromoMovementId.DescId = zc_MIFloat_PromoMovementId()

                               GROUP BY Movement.FromId
                                      , MovementItem.ObjectId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())
                               )


              
           -- Результат
           SELECT Object_From.Id        AS FromId
                , Object_From.ValueData AS FromName
               
                , tmpGoods_Less.GoodsId         
                , tmpGoods_Less.GoodsCode
                , tmpGoods_Less.GoodsName    
                , tmpGoods_Less.GoodsKindId  
                , tmpGoods_Less.GoodsKindName

                , tmpGoods_Less.MeasureName       
                , tmpGoods_Less.GoodsGroupNameFull
                
                , tmpGoods_Less.Amount_result_pack      :: TFloat
                , tmpGoods_Less.Amount_result_pack_pack :: TFloat
                , tmpGoods_Less.AmountPartnerPriorTotal :: TFloat
                , tmpGoods_Less.AmountPartnerTotal      :: TFloat
                , tmpGoods_Less.Income_PACK_from        :: TFloat
                , tmpGoods_Less.Remains                 :: TFloat
                , tmpGoods_Less.Remains_pack            :: TFloat
                , tmpGoods_Less.AmountPackAllTotal      :: TFloat
                

                , (tmpGoods_Less.Amount_result_pack      * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END ))                         :: TFloat AS Amount_result_pack_sh
                , (tmpGoods_Less.AmountPartnerPriorTotal * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END ))                         :: TFloat AS AmountPartnerPriorTotal_sh
                , (tmpGoods_Less.Remains_pack            * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END ))                         :: TFloat AS Remains_pack_sh

                , (tmpGoods_Less.Amount_result_pack      / (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) :: TFloat AS Amount_result_pack_
                , (tmpGoods_Less.AmountPartnerPriorTotal / (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) :: TFloat AS AmountPartnerPriorTotal_
                , (tmpGoods_Less.Remains_pack            / (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) :: TFloat AS Remains_pack_


                  -- заказ покупателя БЕЗ акций, сегодня + завтра
                , tmpMIOrder.AmountPartner                                                                                                                  :: TFloat AS AmountPartner
                , (tmpMIOrder.AmountPartner * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ))          :: TFloat AS AmountPartner_w
                , (tmpMIOrder.AmountPartner * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END ))                                     :: TFloat AS AmountPartner_sh
                  -- заказ покупателя ТОЛЬКО Акции, сегодня + завтра
                , tmpMIOrder.AmountPartnerPromo                                                                                                             :: TFloat AS AmountPartnerPromo
                , (tmpMIOrder.AmountPartnerPromo * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ))     :: TFloat AS AmountPartnerPromo_w
                , (tmpMIOrder.AmountPartnerPromo * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END ))                                :: TFloat AS AmountPartnerPromo_sh
                  -- заказ покупателя БЕЗ акций, неотгруж - вчера
                , tmpMIOrder.AmountPartnerPrior                                                                                                             :: TFloat AS AmountPartnerPrior
                , (tmpMIOrder.AmountPartnerPrior * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ))     :: TFloat AS AmountPartnerPrior_w
                , (tmpMIOrder.AmountPartnerPrior * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END ))                                :: TFloat AS AmountPartnerPrior_sh
                  -- заказ покупателя ТОЛЬКО Акции, неотгруж - вчера
                , tmpMIOrder.AmountPartnerPriorPromo                                                                                                        :: TFloat AS AmountPartnerPriorPromo
                , (tmpMIOrder.AmountPartnerPriorPromo * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )):: TFloat AS AmountPartnerPriorPromo_w
                , (tmpMIOrder.AmountPartnerPriorPromo * (CASE WHEN tmpGoods_Less.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END ))                           :: TFloat AS AmountPartnerPriorPromo_sh

           FROM tmpMIOrder
                 JOIN tmpGoods_Less ON tmpGoods_Less.GoodsId     = tmpMIOrder.GoodsId
                                        AND tmpGoods_Less.GoodsKindId = tmpMIOrder.GoodsKindId
                INNER JOIN Object AS Object_From ON Object_From.Id = tmpMIOrder.FromId

                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = tmpMIOrder.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE tmpMIOrder.AmountPartner <> 0
              OR tmpMIOrder.AmountPartnerPromo <> 0
              OR tmpMIOrder.AmountPartnerPrior <> 0
              OR tmpMIOrder.AmountPartnerPriorPromo <> 0
           ORDER BY tmpGoods_Less.GoodsName, Object_From.ValueData

          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternalPackRemainsLess_Print (inMovementId:= 9492049 , inSession:= zfCalc_UserAdmin())
--where GoodsCode = 777