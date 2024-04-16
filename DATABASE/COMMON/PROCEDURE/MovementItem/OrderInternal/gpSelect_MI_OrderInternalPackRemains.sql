     -- Результат - master
-- Function: gpSelect_MI_OrderInternalPackRemains()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPackRemains (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPackRemains(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF REFCURSOR
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbSessionId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE Cursor3 refcursor;
   DECLARE Cursor4 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


-- IF inSession <> '5' THEN inShowAll:= TRUE; END IF;


     -- получааем  _Result_Master, _Result_Child, _Result_ChildTotal
     PERFORM lpSelect_MI_OrderInternalPackRemains (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inUserId:= vbUserId) ;

     IF inShowAll = TRUE -- AND vbUserId = 5
     THEN

          -- Результат - ChildTotal
          INSERT INTO _Result_ChildTotal (Id, ContainerId
                                        , GoodsId
                                        , GoodsCode
                                        , GoodsName
                                        , GoodsKindId
                                        , GoodsKindName

                                        , GoodsId_complete
                                        , GoodsName_complete
                                        , GoodsKindId_complete
                                        , GoodsKindName_complete

                                        , MeasureId
                                        , MeasureName
                                        , GoodsGroupNameFull
                                        , isErased)
       SELECT DISTINCT
              -1 AS Id
            , 0 AS ContainerId
            , _Result_Master.GoodsId
            , _Result_Master.GoodsCode
            , _Result_Master.GoodsName
            , Object_GoodsKind.Id        AS GoodsKindId
            , Object_GoodsKind.ValueData AS GoodsKindName

            , _Result_Master.GoodsId         AS GoodsId_complete
            , _Result_Master.GoodsName       AS GoodsName_complete
          --, _Result_Master.GoodsKindId     AS GoodsKindId_complete
          --, _Result_Master.GoodsKindName   AS GoodsKindName_complete
            , Object_GoodsKind_basis.Id        AS GoodsKindId_complete
            , Object_GoodsKind_basis.ValueData AS GoodsKindName_complete
          --, Object_GoodsKind.Id              AS GoodsKindId_complete
          --, Object_GoodsKind.ValueData       AS GoodsKindName_complete

            , _Result_Master.MeasureId
            , _Result_Master.MeasureName
            , _Result_Master.GoodsGroupNameFull
            , FALSE

       FROM _Result_Master
            INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = _Result_Master.GoodsId
            INNER JOIN ObjectBoolean AS ObjectBoolean_Order
                                     ON ObjectBoolean_Order.ObjectId  = Object_GoodsByGoodsKind_View.Id
                                    AND ObjectBoolean_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                    AND ObjectBoolean_Order.ValueData = TRUE

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Object_GoodsByGoodsKind_View.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind_basis ON Object_GoodsKind_basis.Id = zc_GoodsKind_Basis()

            LEFT JOIN _Result_Child ON _Result_Child.KeyId       = _Result_Master.KeyId
                                   AND _Result_Child.GoodsId     = _Result_Master.GoodsId
                                   AND _Result_Child.GoodsKindId = Object_GoodsKind.Id

       WHERE _Result_Child.KeyId IS NULL
      ;

          -- Результат - Child
          INSERT INTO _Result_Child (Id, ContainerId
                                        , KeyId
                                        , GoodsId
                                        , GoodsCode
                                        , GoodsName
                                        , GoodsKindId
                                        , GoodsKindName

                                        , GoodsId_complete
                                        , GoodsKindId_complete

                                        , MeasureId
                                        , MeasureName
                                        , GoodsGroupNameFull
                                        , isErased)
       SELECT DISTINCT
              -1 AS Id
            , 0 AS ContainerId
            , _Result_Master.KeyId

            , _Result_Master.GoodsId
            , _Result_Master.GoodsCode
            , _Result_Master.GoodsName
            , Object_GoodsKind.Id        AS GoodsKindId
            , Object_GoodsKind.ValueData AS GoodsKindName

            , _Result_Master.GoodsId     AS GoodsId_complete
          --, _Result_Master.GoodsKindId AS GoodsKindId_complete
            , Object_GoodsKind_basis.Id  AS GoodsKindId_complete
          --, Object_GoodsKind.Id        AS GoodsKindId_complete

            , _Result_Master.MeasureId
            , _Result_Master.MeasureName
            , _Result_Master.GoodsGroupNameFull
            , FALSE

       FROM _Result_Master

            INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = _Result_Master.GoodsId
            INNER JOIN ObjectBoolean AS ObjectBoolean_Order
                                     ON ObjectBoolean_Order.ObjectId  = Object_GoodsByGoodsKind_View.Id
                                    AND ObjectBoolean_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                    AND ObjectBoolean_Order.ValueData = TRUE

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Object_GoodsByGoodsKind_View.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind_basis ON Object_GoodsKind_basis.Id = zc_GoodsKind_Basis()

            LEFT JOIN _Result_Child ON _Result_Child.KeyId       = _Result_Master.KeyId
                                   AND _Result_Child.GoodsId     = _Result_Master.GoodsId
                                   AND _Result_Child.GoodsKindId = Object_GoodsKind.Id

       WHERE _Result_Child.KeyId IS NULL
      ;

     END IF;

     --
     vbSessionId:= (SELECT MAX(MovementItem.Amount) :: Integer
                    FROM MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId    = zc_MI_Detail()
                       AND MovementItem.isErased  = FALSE
                   );

     --
     CREATE TEMP TABLE _tmpResult_Detail (ParentId                  Integer
                                        , AmountPack                TFloat
                                        , AmountPackSecond          TFloat

                                        , AmountPack_calc           TFloat
                                        , AmountSecondPack_calc     TFloat

                                        , AmountPackNext            TFloat
                                        , AmountPackNextSecond      TFloat

                                        , AmountPackNext_calc       TFloat
                                        , AmountPackNextSecond_calc TFloat
                                         ) ON COMMIT DROP;
     --
     INSERT INTO _tmpResult_Detail (ParentId
                                  , AmountPack, AmountPackSecond
                                  , AmountPack_calc, AmountSecondPack_calc
                                  , AmountPackNext, AmountPackNextSecond
                                  , AmountPackNext_calc, AmountPackNextSecond_calc
                                   )
        --
        SELECT MovementItem.ParentId
             , SUM (COALESCE (MIFloat_AmountPack.ValueData, 0))                AS AmountPack
             , SUM (COALESCE (MIFloat_AmountPackSecond.ValueData, 0))          AS AmountPackSecond
             , SUM (COALESCE (MIFloat_AmountPack_calc.ValueData, 0))           AS AmountPack_calc
             , SUM (COALESCE (MIFloat_AmountPackSecond_calc.ValueData, 0))     AS AmountSecondPack_calc

             , SUM (COALESCE (MIFloat_AmountPackNext.ValueData, 0))            AS AmountPackNext
             , SUM (COALESCE (MIFloat_AmountPackNextSecond.ValueData, 0))      AS AmountPackNextSecond
             , SUM (COALESCE (MIFloat_AmountPackNext_calc.ValueData, 0))       AS AmountPackNext_calc
             , SUM (COALESCE (MIFloat_AmountPackNextSecond_calc.ValueData, 0)) AS AmountPackNextSecond_calc
        FROM MovementItem
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPack
                                         ON MIFloat_AmountPack.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPack.DescId = zc_MIFloat_AmountPack()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond
                                         ON MIFloat_AmountPackSecond.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPackSecond.DescId = zc_MIFloat_AmountPackSecond()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPack_calc
                                         ON MIFloat_AmountPack_calc.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPack_calc.DescId = zc_MIFloat_AmountPack_calc()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond_calc
                                         ON MIFloat_AmountPackSecond_calc.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPackSecond_calc.DescId = zc_MIFloat_AmountPackSecond_calc()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext
                                         ON MIFloat_AmountPackNext.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPackNext.DescId = zc_MIFloat_AmountPackNext()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond
                                         ON MIFloat_AmountPackNextSecond.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPackNextSecond.DescId = zc_MIFloat_AmountPackNextSecond()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext_calc
                                         ON MIFloat_AmountPackNext_calc.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPackNext_calc.DescId = zc_MIFloat_AmountPackNext_calc()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond_calc
                                         ON MIFloat_AmountPackNextSecond_calc.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPackNextSecond_calc.DescId = zc_MIFloat_AmountPackNextSecond_calc()
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Detail()
          AND MovementItem.Amount     = vbSessionId
          AND MovementItem.isErased   = FALSE
        GROUP BY MovementItem.ParentId
       ;

     --
     CREATE TEMP TABLE _tmpGoodsByGoodsKind_NormPack (GoodsId Integer, GoodsKindId Integer, NormPack TFloat, NormInDays TFloat) ON COMMIT DROP;
     INSERT INTO _tmpGoodsByGoodsKind_NormPack (GoodsId, GoodsKindId, NormPack, NormInDays)
          SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId         AS GoodsId
               , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId     AS GoodsKindId
               , ObjectFloat_NormPack.ValueData                          AS NormPack
               , COALESCE (ObjectFloat_NormInDays.ValueData,0) ::TFloat  AS NormInDays
          FROM Object AS Object_GoodsByGoodsKind
               INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                     ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId          = Object_GoodsByGoodsKind.Id
                                    AND ObjectLink_GoodsByGoodsKind_Goods.DescId            = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                    AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     > 0
               INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = Object_GoodsByGoodsKind.Id
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId > 0

               LEFT JOIN ObjectFloat AS ObjectFloat_NormPack
                                     ON ObjectFloat_NormPack.ObjectId = Object_GoodsByGoodsKind.Id
                                    AND ObjectFloat_NormPack.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormPack()
                                    AND COALESCE (ObjectFloat_NormPack.ValueData,0) <> 0

               LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                     ON ObjectFloat_NormInDays.ObjectId = Object_GoodsByGoodsKind.Id
                                    AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
                                    AND COALESCE (ObjectFloat_NormInDays.ValueData,0) <> 0
          WHERE Object_GoodsByGoodsKind.DescId   = zc_Object_GoodsByGoodsKind()
            AND Object_GoodsByGoodsKind.isErased = FALSE
         ;

     --
     CREATE TEMP TABLE _tmpResult_Child (Id                        Integer
                                       , ContainerId               Integer
                                       , KeyId                     TVarChar
                                       , GoodsId                   Integer
                                       , GoodsCode                 Integer
                                       , GoodsName                 TVarChar
                                       , GoodsKindId               Integer
                                       , GoodsKindName             TVarChar
                                       , MeasureName               TVarChar
                                       , GoodsGroupNameFull        TVarChar

                                       , AmountPack                TFloat
                                       , AmountPackSecond          TFloat
                                       , AmountPackTotal           TFloat

                                       , AmountPack_calc           TFloat
                                       , AmountSecondPack_calc     TFloat
                                       , AmountPackTotal_calc      TFloat

                                       , AmountPackNext            TFloat
                                       , AmountPackNextSecond      TFloat
                                       , AmountPackNextTotal       TFloat

                                       , AmountPackNext_calc       TFloat
                                       , AmountPackNextSecond_calc TFloat
                                       , AmountPackNextTotal_calc  TFloat

                                       , AmountPackAllTotal        TFloat
                                       , AmountPackAllTotal_calc   TFloat
                                       , Amount_result_two         TFloat
                                       , Amount_result_pack        TFloat
                                       , Amount_result_pack_pack   TFloat
                                       , Income_PACK_to            TFloat
                                       , Income_PACK_from          TFloat
                                       , Remains                   TFloat
                                       , Remains_pack              TFloat
                                       , RemainsRK                   TFloat
                                       , AmountPartnerPrior        TFloat
                                       , AmountPartnerPriorPromo   TFloat
                                       , AmountPartnerPriorTotal   TFloat
                                       , AmountPartner             TFloat
                                       , AmountPartnerNext         TFloat
                                       , AmountPartnerPromo        TFloat
                                       , AmountPartnerNextPromo    TFloat
                                       , AmountPartnerTotal        TFloat
                                       , AmountForecast            TFloat
                                       , AmountForecastPromo       TFloat
                                       , AmountForecastOrder       TFloat
                                       , AmountForecastOrderPromo  TFloat
                                       , AmountPrIn                TFloat
                                       , AmountPartnerOld          TFloat
                                       , AmountPartnerPromoOld     TFloat
                                       , AmountPartnerOldTotal     TFloat
                                       , CountForecast             TFloat
                                       , CountForecastOrder        TFloat
                                       , Plan1                     TFloat
                                       , Plan2                     TFloat
                                       , Plan3                     TFloat
                                       , Plan4                     TFloat
                                       , Plan5                     TFloat
                                       , Plan6                     TFloat
                                       , Plan7                     TFloat
                                       , Promo1                    TFloat
                                       , Promo2                    TFloat
                                       , Promo3                    TFloat
                                       , Promo4                    TFloat
                                       , Promo5                    TFloat
                                       , Promo6                    TFloat
                                       , Promo7                    TFloat
                                       , DayCountForecast          TFloat
                                       , DayCountForecastOrder     TFloat
                                       , DayCountForecast_calc     TFloat
                                       , DayCountForecast_new      TVarChar
                                       , DayCountForecast_new_new  TVarChar
                                       , ReceiptId                 Integer
                                       , ReceiptCode               TVarChar
                                       , ReceiptName               TVarChar
                                       , ReceiptId_basis           Integer
                                       , ReceiptCode_basis         TVarChar
                                       , ReceiptName_basis         TVarChar
                                       , isErased                  Boolean
                                       , GoodsCode_packTo          Integer
                                       , GoodsName_packTo          TVarChar
                                       , GoodsKindName_packTo      TVarChar
                                       , GoodsId_complete Integer, GoodsKindId_complete Integer
                                       , NormPack TFloat, HourPack_calc TFloat
                                       , NormInDays TFloat
                                       , isNotPack Boolean
                                        ) ON COMMIT DROP;

    INSERT INTO _tmpResult_Child (Id, ContainerId, KeyId
                                , GoodsId, GoodsCode, GoodsName, GoodsKindId, GoodsKindName, MeasureName, GoodsGroupNameFull
                                , AmountPack, AmountPackSecond, AmountPackTotal
                                , AmountPack_calc, AmountSecondPack_calc, AmountPackTotal_calc
                                , AmountPackNext, AmountPackNextSecond, AmountPackNextTotal
                                , AmountPackNext_calc, AmountPackNextSecond_calc, AmountPackNextTotal_calc, AmountPackAllTotal, AmountPackAllTotal_calc
                                , Amount_result_two, Amount_result_pack, Amount_result_pack_pack
                                , Income_PACK_to, Income_PACK_from
                                , Remains, Remains_pack, RemainsRK
                                , AmountPartnerPrior, AmountPartnerPriorPromo, AmountPartnerPriorTotal
                                , AmountPartner, AmountPartnerNext, AmountPartnerPromo
                                , AmountPartnerNextPromo, AmountPartnerTotal
                                , AmountForecast, AmountForecastPromo, AmountForecastOrder, AmountForecastOrderPromo
                                , AmountPrIn, AmountPartnerOld, AmountPartnerPromoOld, AmountPartnerOldTotal
                                , CountForecast, CountForecastOrder
                                , Plan1, Plan2, Plan3, Plan4, Plan5, Plan6, Plan7
                                , Promo1, Promo2, Promo3, Promo4, Promo5, Promo6, Promo7
                                , DayCountForecast, DayCountForecastOrder, DayCountForecast_calc, DayCountForecast_new, DayCountForecast_new_new

                                , ReceiptId, ReceiptCode, ReceiptName, ReceiptId_basis, ReceiptCode_basis, ReceiptName_basis, isErased
                                , GoodsCode_packTo, GoodsName_packTo, GoodsKindName_packTo
                                , GoodsId_complete, GoodsKindId_complete
                                , NormPack, HourPack_calc, NormInDays
                                , isNotPack
                                 )

            WITH -- Не упаковывать
                 tmpGoodsByGoodsKind_not AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId          AS GoodsId
                                                  , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId      AS GoodsKindId
                                                  , ObjectBoolean_NotPack.ValueData                          AS isNotPack
                                             FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                  JOIN Object AS Object_GoodsByGoodsKind
                                                              ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                             AND Object_GoodsByGoodsKind.isErased = FALSE
                                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                  ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                  JOIN ObjectBoolean AS ObjectBoolean_NotPack
                                                                     ON ObjectBoolean_NotPack.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                    AND ObjectBoolean_NotPack.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotPack()
                                                                    AND ObjectBoolean_NotPack.ValueData = TRUE
                                             WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                            )
                 -- заменяем товары на "Главный Товар в планировании прихода с упаковки"
               , tmpGoodsByGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId         AS GoodsId
                                              , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId     AS GoodsKindId
                                              , ObjectLink_GoodsByGoodsKind_GoodsPack.ChildObjectId     AS GoodsId_pack
                                              , ObjectLink_GoodsByGoodsKind_GoodsKindPack.ChildObjectId AS GoodsKindId_pack
                                              , ObjectFloat_NormPack.ValueData                          AS NormPack
                                              , CASE WHEN ObjectBoolean_NotPack.ValueData = TRUE OR tmpGoodsByGoodsKind_not.isNotPack = TRUE THEN TRUE ELSE FALSE END AS isNotPack
                                         FROM Object AS Object_GoodsByGoodsKind
                                              INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                                    ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId          = Object_GoodsByGoodsKind.Id
                                                                   AND ObjectLink_GoodsByGoodsKind_Goods.DescId            = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                                   AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     > 0
                                              INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                    ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = Object_GoodsByGoodsKind.Id
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId > 0

                                              INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsPack
                                                                    ON ObjectLink_GoodsByGoodsKind_GoodsPack.ObjectId      = Object_GoodsByGoodsKind.Id
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsPack.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsPack()
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsPack.ChildObjectId > 0
                                              INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindPack
                                                                    ON ObjectLink_GoodsByGoodsKind_GoodsKindPack.ObjectId      = Object_GoodsByGoodsKind.Id
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKindPack.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack()
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKindPack.ChildObjectId > 0

                                              LEFT JOIN ObjectBoolean AS ObjectBoolean_NotPack
                                                                      ON ObjectBoolean_NotPack.ObjectId  = Object_GoodsByGoodsKind.Id
                                                                     AND ObjectBoolean_NotPack.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotPack()

                                              LEFT JOIN ObjectFloat AS ObjectFloat_NormPack
                                                                    ON ObjectFloat_NormPack.ObjectId = Object_GoodsByGoodsKind.Id
                                                                   AND ObjectFloat_NormPack.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormPack()

                                              LEFT JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = ObjectLink_GoodsByGoodsKind_GoodsPack.ChildObjectId
                                                                               AND tmpGoodsByGoodsKind_not.GoodsKindId = ObjectLink_GoodsByGoodsKind_GoodsKindPack.ChildObjectId

                                         WHERE Object_GoodsByGoodsKind.DescId   = zc_Object_GoodsByGoodsKind()
                                           AND Object_GoodsByGoodsKind.isErased = FALSE
                                         --AND 1=0
                                        )
       -- результат
       SELECT _Result_Child.Id
            , _Result_Child.ContainerId
            , _Result_Child.KeyId
            , _Result_Child.GoodsId
            , _Result_Child.GoodsCode
            , _Result_Child.GoodsName
            , _Result_Child.GoodsKindId
            , _Result_Child.GoodsKindName
            , _Result_Child.MeasureName
            , _Result_Child.GoodsGroupNameFull

            , _Result_Child.AmountPack
            , _Result_Child.AmountPackSecond
            , _Result_Child.AmountPackTotal

            , _Result_Child.AmountPack_calc
            , _Result_Child.AmountSecondPack_calc
            , _Result_Child.AmountPackTotal_calc

            , _Result_Child.AmountPackNext
            , _Result_Child.AmountPackNextSecond
            , _Result_Child.AmountPackNextTotal

            , _Result_Child.AmountPackNext_calc
            , _Result_Child.AmountPackNextSecond_calc
            , _Result_Child.AmountPackNextTotal_calc

            , _Result_Child.AmountPackAllTotal
            , _Result_Child.AmountPackAllTotal_calc

            , _Result_Child.Amount_result_two
            , _Result_Child.Amount_result_pack
            , _Result_Child.Amount_result_pack_pack

            , _Result_Child.Income_PACK_to
            , _Result_Child.Income_PACK_from

            , _Result_Child.Remains
            , _Result_Child.Remains_pack
            , _Result_Child.RemainsRK

              -- неотгуж. заявка
            , _Result_Child.AmountPartnerPrior
            , _Result_Child.AmountPartnerPriorPromo
            , _Result_Child.AmountPartnerPriorTotal
              -- сегодня заявка
            , _Result_Child.AmountPartner
            , _Result_Child.AmountPartnerNext
            , _Result_Child.AmountPartnerPromo
            , _Result_Child.AmountPartnerNextPromo
            , _Result_Child.AmountPartnerTotal
              -- Прогноз по прод.
            , _Result_Child.AmountForecast
            , _Result_Child.AmountForecastPromo
              -- Прогноз по заяв.
            , _Result_Child.AmountForecastOrder
            , _Result_Child.AmountForecastOrderPromo

            --
            , _Result_Child.AmountPrIn               -- ***Приход пр-во (ФАКТ)
            , _Result_Child.AmountPartnerOld         -- ***Факт заказ покупателя, сегодня
            , _Result_Child.AmountPartnerPromoOld    -- ***Факт заказ покупателя, сегодня
            , _Result_Child.AmountPartnerOldTotal

              -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
            , CAST (_Result_Child.CountForecast AS NUMERIC (16, 1)) :: TFloat AS CountForecast
              -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
            , CAST (_Result_Child.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- "средняя" за 1 день - продажа ИЛИ заявака
            , CAST (_Result_Child.Plan1 AS NUMERIC (16, 1)) :: TFloat AS Plan1
            , CAST (_Result_Child.Plan2 AS NUMERIC (16, 1)) :: TFloat AS Plan2
            , CAST (_Result_Child.Plan3 AS NUMERIC (16, 1)) :: TFloat AS Plan3
            , CAST (_Result_Child.Plan4 AS NUMERIC (16, 1)) :: TFloat AS Plan4
            , CAST (_Result_Child.Plan5 AS NUMERIC (16, 1)) :: TFloat AS Plan5
            , CAST (_Result_Child.Plan6 AS NUMERIC (16, 1)) :: TFloat AS Plan6
            , CAST (_Result_Child.Plan7 AS NUMERIC (16, 1)) :: TFloat AS Plan7
              -- "средняя" за 1 день - акции - прогноз
            , CAST (_Result_Child.Promo1 AS NUMERIC (16, 1)) :: TFloat AS Promo1
            , CAST (_Result_Child.Promo2 AS NUMERIC (16, 1)) :: TFloat AS Promo2
            , CAST (_Result_Child.Promo3 AS NUMERIC (16, 1)) :: TFloat AS Promo3
            , CAST (_Result_Child.Promo4 AS NUMERIC (16, 1)) :: TFloat AS Promo4
            , CAST (_Result_Child.Promo5 AS NUMERIC (16, 1)) :: TFloat AS Promo5
            , CAST (_Result_Child.Promo6 AS NUMERIC (16, 1)) :: TFloat AS Promo6
            , CAST (_Result_Child.Promo7 AS NUMERIC (16, 1)) :: TFloat AS Promo7

              -- Ост. в днях (по пр.) - без К
           , CAST (CASE WHEN _Result_Child.CountForecast > 0
                             THEN (_Result_Child.Remains + _Result_Child.Remains_pack - COALESCE (_Result_Child.Amount_master, 0) - COALESCE (_Result_Child.AmountNext_master, 0)) / _Result_Child.CountForecast
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast
              -- Ост. в днях (по зв.) - без К
           , CAST (CASE WHEN _Result_Child.CountForecastOrder > 0
                             THEN (_Result_Child.Remains + _Result_Child.Remains_pack - COALESCE (_Result_Child.Amount_master, 0) - COALESCE (_Result_Child.AmountNext_master, 0)) / _Result_Child.CountForecastOrder
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
           , CAST (CASE WHEN _Result_Child.CountForecast > 0
                             THEN (_Result_Child.Remains + _Result_Child.Remains_pack + _Result_Child.AmountPack + _Result_Child.AmountPackSecond + _Result_Child.AmountPackNext + _Result_Child.AmountPackNextSecond
                                 - COALESCE (_Result_Child.Amount_master, 0) - COALESCE (_Result_Child.AmountNext_master, 0)
                                 - _Result_Child.AmountPartnerPrior - _Result_Child.AmountPartnerPriorPromo
                                 - _Result_Child.AmountPartner      - _Result_Child.AmountPartnerPromo
                                  ) / _Result_Child.CountForecast
                        WHEN _Result_Child.CountForecastOrder > 0
                             THEN (_Result_Child.Remains + _Result_Child.Remains_pack + _Result_Child.AmountPack + _Result_Child.AmountPackSecond + _Result_Child.AmountPackNext + _Result_Child.AmountPackNextSecond
                                 - COALESCE (_Result_Child.Amount_master, 0) - COALESCE (_Result_Child.AmountNext_master, 0)
                                 - _Result_Child.AmountPartnerPrior - _Result_Child.AmountPartnerPriorPromo
                                 - _Result_Child.AmountPartner      - _Result_Child.AmountPartnerPromo
                                  ) / _Result_Child.CountForecastOrder
                        ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast_calc

              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , zfCalc_StatDayCount_Week (inAmount           := COALESCE (_Result_Child.Amount_result_pack, 0)
                                      , inAmountPartnerNext:= COALESCE (_Result_Child.AmountPartnerNext, 0) + COALESCE (_Result_Child.AmountPartnerNextPromo, 0)
                                      , inCountForecast    := CASE WHEN _Result_Child.CountForecast > 0 THEN COALESCE (_Result_Child.CountForecast, 0) ELSE COALESCE (_Result_Child.CountForecastOrder, 0) END
                                      , inPlan1            := COALESCE (_Result_Child.Plan1, 0) + COALESCE (_Result_Child.Promo1, 0)
                                      , inPlan2            := COALESCE (_Result_Child.Plan2, 0) + COALESCE (_Result_Child.Promo2, 0)
                                      , inPlan3            := COALESCE (_Result_Child.Plan3, 0) + COALESCE (_Result_Child.Promo3, 0)
                                      , inPlan4            := COALESCE (_Result_Child.Plan4, 0) + COALESCE (_Result_Child.Promo4, 0)
                                      , inPlan5            := COALESCE (_Result_Child.Plan5, 0) + COALESCE (_Result_Child.Promo5, 0)
                                      , inPlan6            := COALESCE (_Result_Child.Plan6, 0) + COALESCE (_Result_Child.Promo6, 0)
                                      , inPlan7            := COALESCE (_Result_Child.Plan7, 0) + COALESCE (_Result_Child.Promo7, 0)
                                       ) :: TFloat AS DayCountForecast_new
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , zfCalc_StatDayCount_Week (inAmount           := COALESCE (_Result_Child.Amount_result_pack_pack, 0)
                                      , inAmountPartnerNext:= COALESCE (_Result_Child.AmountPartnerNext, 0) + COALESCE (_Result_Child.AmountPartnerNextPromo, 0)
                                      , inCountForecast    := CASE WHEN _Result_Child.CountForecast > 0 THEN COALESCE (_Result_Child.CountForecast, 0) ELSE COALESCE (_Result_Child.CountForecastOrder, 0) END
                                      , inPlan1            := COALESCE (_Result_Child.Plan1, 0) + COALESCE (_Result_Child.Promo1, 0)
                                      , inPlan2            := COALESCE (_Result_Child.Plan2, 0) + COALESCE (_Result_Child.Promo2, 0)
                                      , inPlan3            := COALESCE (_Result_Child.Plan3, 0) + COALESCE (_Result_Child.Promo3, 0)
                                      , inPlan4            := COALESCE (_Result_Child.Plan4, 0) + COALESCE (_Result_Child.Promo4, 0)
                                      , inPlan5            := COALESCE (_Result_Child.Plan5, 0) + COALESCE (_Result_Child.Promo5, 0)
                                      , inPlan6            := COALESCE (_Result_Child.Plan6, 0) + COALESCE (_Result_Child.Promo6, 0)
                                      , inPlan7            := COALESCE (_Result_Child.Plan7, 0) + COALESCE (_Result_Child.Promo7, 0)
                                       ) :: TFloat AS DayCountForecast_new_new

            , _Result_Child.ReceiptId
            , _Result_Child.ReceiptCode
            , _Result_Child.ReceiptName
            , _Result_Child.ReceiptId_basis
            , _Result_Child.ReceiptCode_basis
            , _Result_Child.ReceiptName_basis
            , _Result_Child.isErased

            , Object_Goods_packTo.ObjectCode     AS GoodsCode_packTo
            , Object_Goods_packTo.ValueData      AS GoodsName_packTo
            , Object_GoodsKind_packTo.ValueData  AS GoodsKindName_packTo

            , _Result_Child.GoodsId_complete
            , _Result_Child.GoodsKindId_complete

            , _tmpGoodsByGoodsKind_NormPack.NormPack  ::TFloat
            , CAST (CASE WHEN COALESCE (_tmpGoodsByGoodsKind_NormPack.NormPack,0) <> 0
                         THEN (COALESCE (_Result_Child.AmountPack,0)
                             + COALESCE (_Result_Child.AmountPackSecond,0)
                             + COALESCE (_Result_Child.AmountPackNext,0)
                             + COALESCE (_Result_Child.AmountPackNextSecond,0)) / _tmpGoodsByGoodsKind_NormPack.NormPack
                         ELSE 0
                    END  AS NUMERIC (16,2))  ::TFloat AS HourPack_calc  -- расчет сколько врмени надо на весь план
            , _tmpGoodsByGoodsKind_NormPack.NormInDays ::TFloat

          , CASE WHEN tmpGoodsByGoodsKind_not.isNotPack = TRUE
                   OR tmpGoodsByGoodsKind.isNotPack = TRUE
                   OR _Result_Child.isNotPack = TRUE
                 THEN TRUE
                 ELSE FALSE
            END AS isNotPack

       FROM (SELECT _Result_Child.Id
                  , _Result_Child.ContainerId
                  , _Result_Child.KeyId
                  , COALESCE (Object_Goods.Id, _Result_Child.GoodsId)                  :: Integer  AS GoodsId
                  , COALESCE (Object_Goods.ObjectCode, _Result_Child.GoodsCode)        :: Integer  AS GoodsCode
                  , COALESCE (Object_Goods.ValueData, _Result_Child.GoodsName)         :: TVarChar AS GoodsName
                  , COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId)          :: Integer  AS GoodsKindId
                  , COALESCE (Object_GoodsKind.ValueData, _Result_Child.GoodsKindName) :: TVarChar AS GoodsKindName
                  , _Result_Child.MeasureName
                  , _Result_Child.GoodsGroupNameFull
                  , _Result_Child.GoodsId_complete
                  , _Result_Child.GoodsKindId_complete

                    -- ***План1 заказ факт (с Ост.) - Приход с УПАК
                  , SUM (_Result_Child.AmountPack)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPack
                    -- ***План1 заказ факт (с Цеха) - Приход с УПАК
                  , SUM (_Result_Child.AmountPackSecond)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackSecond
                    -- ***План1 ИТОГО заказ факт - Приход с УПАК
                  , SUM (_Result_Child.AmountPackTotal)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackTotal

                    -- ***План1 заказ расч. (с Ост.) - Приход с УПАК
                  , SUM (_Result_Child.AmountPack_calc)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPack_calc
                    -- ***План1 заказ расч. (с Цеха) - Приход с УПАК
                  , SUM (_Result_Child.AmountSecondPack_calc)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountSecondPack_calc
                    -- ***План1 ИТОГО заказ расч. - Приход с УПАК
                  , SUM (_Result_Child.AmountPackTotal_calc)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackTotal_calc

                    -- ***План2 выдали с Ост. на УПАК
                  , SUM (_Result_Child.AmountPackNext)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackNext
                    -- ***План2 выдали с Цеха на УПАК
                  , SUM (_Result_Child.AmountPackNextSecond)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackNextSecond
                    -- ***План2 ИТОГО выдали на УПАК
                  , SUM (_Result_Child.AmountPackNextTotal)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackNextTotal

                    --
                  , SUM (_Result_Child.AmountPackNext_calc)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackNext_calc
                    --
                  , SUM (_Result_Child.AmountPackNextSecond_calc)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackNextSecond_calc
                    --
                  , SUM (_Result_Child.AmountPackNextTotal_calc)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackNextTotal_calc

                    --
                  , SUM (_Result_Child.AmountPackAllTotal)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackAllTotal
                    --
                  , SUM (_Result_Child.AmountPackAllTotal_calc)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPackAllTotal_calc

                    --
                  , SUM (_Result_Child.Amount_result_two)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Amount_result_two
                    --
                  , SUM (_Result_Child.Amount_result_pack)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Amount_result_pack
                    --
                  , SUM (_Result_Child.Amount_result_pack_pack)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Amount_result_pack_pack

                    -- ФАКТ - Перемещение на Цех Упаковки
                  , SUM (_Result_Child.Income_PACK_to)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Income_PACK_to
                    -- ФАКТ - Перемещение с Цеха Упаковки
                  , SUM (_Result_Child.Income_PACK_from)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Income_PACK_from

                    -- Ост. начальн. - НЕ упакованный
                  , SUM (_Result_Child.Remains)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Remains
                    -- Ост. начальн. - упакованный
                  , SUM (_Result_Child.Remains_pack)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Remains_pack
                    -- Ост. начальн. - РК
                  , SUM (_Result_Child.RemainsRK)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS RemainsRK

                    -- неотгуж. заявка
                  , SUM (_Result_Child.AmountPartnerPrior)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartnerPrior
                    --
                  , SUM (_Result_Child.AmountPartnerPriorPromo)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartnerPriorPromo
                    --
                  , SUM (_Result_Child.AmountPartnerPriorTotal)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartnerPriorTotal

                    -- сегодня заявка
                  , SUM (_Result_Child.AmountPartner)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartner
                    --
                  , SUM (_Result_Child.AmountPartnerNext)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartnerNext
                    --
                  , SUM (_Result_Child.AmountPartnerPromo)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartnerPromo
                    --
                  , SUM (_Result_Child.AmountPartnerNextPromo)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartnerNextPromo
                    --
                  , SUM (_Result_Child.AmountPartnerTotal)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartnerTotal

                    -- Прогноз по прод.
                  , SUM (_Result_Child.AmountForecast)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountForecast
                    --
                  , SUM (_Result_Child.AmountForecastPromo)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountForecastPromo

                    -- Прогноз по заяв.
                  , SUM (_Result_Child.AmountForecastOrder)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountForecastOrder
                    --
                  , SUM (_Result_Child.AmountForecastOrderPromo)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountForecastOrderPromo

                   --
                  , SUM (_Result_Child.AmountPrIn)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPrIn
                  , SUM (_Result_Child.AmountPartnerOld)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartnerOld

                  , SUM (_Result_Child.AmountPartnerPromoOld)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartnerPromoOld

                  , SUM (_Result_Child.AmountPartnerOldTotal)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountPartnerOldTotal
                  --

                    -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
                  , SUM (_Result_Child.CountForecast)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS CountForecast
                    -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
                  , SUM (_Result_Child.CountForecastOrder)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS CountForecastOrder

                    -- "средняя" за 1 день - продажа ИЛИ заявака
                  , SUM (_Result_Child.Plan1)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Plan1
                    --
                  , SUM (_Result_Child.Plan2)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Plan2
                    --
                  , SUM (_Result_Child.Plan3)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Plan3
                    --
                  , SUM (_Result_Child.Plan4)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Plan4
                    --
                  , SUM (_Result_Child.Plan5)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Plan5
                    --
                  , SUM (_Result_Child.Plan6)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Plan6
                    --
                  , SUM (_Result_Child.Plan7)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Plan7

                    -- "средняя" за 1 день - акции - прогноз
                    --
                  , SUM (_Result_Child.Promo1)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Promo1
                    --
                  , SUM (_Result_Child.Promo2)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Promo2
                    --
                  , SUM (_Result_Child.Promo3)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Promo3
                    --
                  , SUM (_Result_Child.Promo4)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Promo4
                    --
                  , SUM (_Result_Child.Promo5)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Promo5
                    --
                  , SUM (_Result_Child.Promo6)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Promo6
                    --
                  , SUM (_Result_Child.Promo7)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Promo7

                    -- Ост. в днях (по пр.) - без К
                  -- , _Result_Child.DayCountForecast
                    -- Ост. в днях (по зв.) - без К
                  -- , _Result_Child.DayCountForecastOrder
                    -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
                  -- , _Result_Child.DayCountForecast_calc

                    -- из master - ра
                  , SUM (_Result_Child.Amount_master)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS Amount_master
                    --
                  , SUM (_Result_Child.AmountNext_master)
                        OVER (PARTITION BY CASE WHEN inShowAll = TRUE THEN _Result_Child.Id :: TVarChar
                                                ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                           END
                              ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END ASC
                                     , _Result_Child.Id ASC
                             ) AS AmountNext_master

                  , _Result_Child.ReceiptId
                  , _Result_Child.ReceiptCode
                  , _Result_Child.ReceiptName
                  , _Result_Child.ReceiptId_basis
                  , _Result_Child.ReceiptCode_basis
                  , _Result_Child.ReceiptName_basis
                  , _Result_Child.isErased
                  
                  , COALESCE (tmpGoodsByGoodsKind.isNotPack, FALSE) AS isNotPack

                    --  № п/п
                  , ROW_NUMBER() OVER (PARTITION BY CASE WHEN inShowAll = TRUE AND _Result_Child.Id > 0 THEN _Result_Child.Id :: TVarChar
                                                         ELSE _Result_Child.KeyId || '_' || COALESCE (Object_Goods.Id, _Result_Child.GoodsId) :: TVarChar  || '_' || COALESCE (Object_GoodsKind.Id, _Result_Child.GoodsKindId) :: TVarChar
                                                    END
                                       ORDER BY CASE WHEN Object_Goods.Id > 0 THEN 0 ELSE _Result_Child.Id END DESC
                                              , _Result_Child.Id DESC
                                      ) AS Ord
             FROM _Result_Child
                  LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = _Result_Child.GoodsId
                                               AND tmpGoodsByGoodsKind.GoodsKindId = _Result_Child.GoodsKindId
                                               AND inShowAll = FALSE
                  LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpGoodsByGoodsKind.GoodsId_pack
                  LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoodsByGoodsKind.GoodsKindId_pack
            ) AS _Result_Child
            LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = _Result_Child.GoodsId
                                         AND tmpGoodsByGoodsKind.GoodsKindId = _Result_Child.GoodsKindId
                                         AND inShowAll = TRUE

            LEFT JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = _Result_Child.GoodsId
                                             AND tmpGoodsByGoodsKind_not.GoodsKindId = _Result_Child.GoodsKindId

            LEFT JOIN Object AS Object_Goods_packTo     ON Object_Goods_packTo.Id     = tmpGoodsByGoodsKind.GoodsId_pack
            LEFT JOIN Object AS Object_GoodsKind_packTo ON Object_GoodsKind_packTo.Id = tmpGoodsByGoodsKind.GoodsKindId_pack

            LEFT JOIN _tmpGoodsByGoodsKind_NormPack ON _tmpGoodsByGoodsKind_NormPack.GoodsId     = _Result_Child.GoodsId
                                                   AND _tmpGoodsByGoodsKind_NormPack.GoodsKindId = _Result_Child.GoodsKindId
       WHERE _Result_Child.Ord = 1
        --OR vbUserId = 5
      ;


       --
       OPEN Cursor1 FOR

       -- Результат
       WITH -- Не упаковывать
            tmpGoodsByGoodsKind_not AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId          AS GoodsId
                                             , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId      AS GoodsKindId
                                             , ObjectBoolean_NotPack.ValueData                          AS isNotPack
                                        FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                             JOIN Object AS Object_GoodsByGoodsKind
                                                         ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND Object_GoodsByGoodsKind.isErased = FALSE
                                             JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                             JOIN ObjectBoolean AS ObjectBoolean_NotPack
                                                                ON ObjectBoolean_NotPack.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                               AND ObjectBoolean_NotPack.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotPack()
                                                               AND ObjectBoolean_NotPack.ValueData = TRUE
                                        WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                       )
       SELECT _Result_Master.Id
            , _Result_Master.KeyId
            , _Result_Master.GoodsId
            , _Result_Master.GoodsCode
            , (CASE WHEN _Result_Child.isNotPack = 0 AND vbUserId = 5 THEN '---не упаковывать ' ELSE '' END || _Result_Master.GoodsName) :: TVarChar AS GoodsName
            , _Result_Master.GoodsId_basis
            , _Result_Master.GoodsCode_basis
            , _Result_Master.GoodsName_basis
--            , _Result_Master.GoodsKindId
            , Object.Id AS GoodsKindId
            , _Result_Master.GoodsKindName
            , _Result_Master.MeasureName
            , _Result_Master.MeasureName_basis
            , _Result_Master.GoodsGroupNameFull
            , _Result_Master.isCheck_basis

            , _Result_Master.Amount
            , _Result_Master.AmountSecond
            , _Result_Master.AmountTotal

            , _Result_Master.AmountNext
            , _Result_Master.AmountNextSecond
            , _Result_Master.AmountNextTotal
            , _Result_Master.AmountAllTotal

            , _Result_Master.Amount_result
            , _Result_Master.Amount_result_two
            , _Result_Master.Amount_result_pack

            , _Result_Master.Num
            , _Result_Master.Income_CEH
            , _Result_Master.Income_PACK_to
            , _Result_Master.Income_PACK_from

            , _Result_Master.Remains
            , _Result_Master.Remains_pack
            , _Result_Master.RemainsRK
            , _Result_Master.Remains_CEH
            , _Result_Master.Remains_CEH_Next

              -- неотгуж. заявка
            , _Result_Master.AmountPartnerPrior
            , _Result_Master.AmountPartnerPriorPromo
            , _Result_Master.AmountPartnerPriorTotal
              -- сегодня заявка
            , _Result_Master.AmountPartner
            , _Result_Master.AmountPartnerNext
            , _Result_Master.AmountPartnerPromo
            , _Result_Master.AmountPartnerNextPromo
            , _Result_Master.AmountPartnerTotal
            -- Прогноз по прод.
            , _Result_Master.AmountForecast
            , _Result_Master.AmountForecastPromo
             -- Прогноз по заяв.
            , _Result_Master.AmountForecastOrder
            , _Result_Master.AmountForecastOrderPromo
             --
            , _Result_Master.AmountPrIn
            , _Result_Master.AmountPartnerOld
            , _Result_Master.AmountPartnerPromoOld
            , _Result_Master.AmountPartnerOldTotal

             -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
            , CAST (_Result_Master.CountForecast AS NUMERIC (16, 1)) :: TFloat AS CountForecast
             -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
            , CAST (_Result_Master.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- "средняя" за 1 день - продажа ИЛИ заявака
            , CAST (_Result_Master.Plan1 AS NUMERIC (16, 1)) :: TFloat AS Plan1
            , CAST (_Result_Master.Plan2 AS NUMERIC (16, 1)) :: TFloat AS Plan2
            , CAST (_Result_Master.Plan3 AS NUMERIC (16, 1)) :: TFloat AS Plan3
            , CAST (_Result_Master.Plan4 AS NUMERIC (16, 1)) :: TFloat AS Plan4
            , CAST (_Result_Master.Plan5 AS NUMERIC (16, 1)) :: TFloat AS Plan5
            , CAST (_Result_Master.Plan6 AS NUMERIC (16, 1)) :: TFloat AS Plan6
            , CAST (_Result_Master.Plan7 AS NUMERIC (16, 1)) :: TFloat AS Plan7
              -- "средняя" за 1 день - акции - прогноз
            , CAST (_Result_Master.Promo1 AS NUMERIC (16, 1)) :: TFloat AS Promo1
            , CAST (_Result_Master.Promo2 AS NUMERIC (16, 1)) :: TFloat AS Promo2
            , CAST (_Result_Master.Promo3 AS NUMERIC (16, 1)) :: TFloat AS Promo3
            , CAST (_Result_Master.Promo4 AS NUMERIC (16, 1)) :: TFloat AS Promo4
            , CAST (_Result_Master.Promo5 AS NUMERIC (16, 1)) :: TFloat AS Promo5
            , CAST (_Result_Master.Promo6 AS NUMERIC (16, 1)) :: TFloat AS Promo6
            , CAST (_Result_Master.Promo7 AS NUMERIC (16, 1)) :: TFloat AS Promo7

              -- Ост. в днях (по пр.) - без К
            , _Result_Master.DayCountForecast
              -- Ост. в днях (по зв.) - без К
            , _Result_Master.DayCountForecastOrder
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_Master.DayCountForecast_calc
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , zfCalc_StatDayCount_Week (inAmount           := COALESCE (_Result_Master.Amount_result_pack, 0)
                                      , inAmountPartnerNext:= COALESCE (_Result_Master.AmountPartnerNext, 0) + COALESCE (_Result_Master.AmountPartnerNextPromo, 0)
                                      , inCountForecast    := CASE WHEN _Result_Master.CountForecast > 0 THEN COALESCE (_Result_Master.CountForecast, 0) ELSE COALESCE (_Result_Master.CountForecastOrder, 0) END
                                      , inPlan1            := COALESCE (_Result_Master.Plan1, 0) + COALESCE (_Result_Master.Promo1, 0)
                                      , inPlan2            := COALESCE (_Result_Master.Plan2, 0) + COALESCE (_Result_Master.Promo2, 0)
                                      , inPlan3            := COALESCE (_Result_Master.Plan3, 0) + COALESCE (_Result_Master.Promo3, 0)
                                      , inPlan4            := COALESCE (_Result_Master.Plan4, 0) + COALESCE (_Result_Master.Promo4, 0)
                                      , inPlan5            := COALESCE (_Result_Master.Plan5, 0) + COALESCE (_Result_Master.Promo5, 0)
                                      , inPlan6            := COALESCE (_Result_Master.Plan6, 0) + COALESCE (_Result_Master.Promo6, 0)
                                      , inPlan7            := COALESCE (_Result_Master.Plan7, 0) + COALESCE (_Result_Master.Promo7, 0)
                                       ) AS DayCountForecast_new

            , _Result_Master.ReceiptId
            , _Result_Master.ReceiptCode
            , _Result_Master.ReceiptName
            , _Result_Master.ReceiptId_basis
            , _Result_Master.ReceiptCode_basis
            , _Result_Master.ReceiptName_basis
            , _Result_Master.UnitId
            , _Result_Master.UnitCode
            , _Result_Master.UnitName
            , _Result_Master.isErased
            , COALESCE (MIBoolean_Calculated.ValueData, TRUE) :: Boolean AS isCalculated

              -- разница да/нет AmountPartnerTotal и AmountPartnerOldTotal
            , CASE WHEN COALESCE (_Result_Master.AmountPartnerTotal,0) <> COALESCE (_Result_Master.AmountPartnerOldTotal,0) THEN TRUE ELSE FALSE END :: Boolean AS isDiff1
              -- разница да/нет zc_MIFloat_AmountPrIn и Income_CEH
            , CASE WHEN COALESCE (FLOOR (_Result_Master.Income_CEH),0) <> COALESCE (FLOOR (_Result_Master.AmountPrIn)   ,0) THEN TRUE ELSE FALSE END :: Boolean AS isDiff2

            , (COALESCE (_Result_Master.AmountPartnerTotal,0) - COALESCE (_Result_Master.AmountPartnerOldTotal,0)) :: TFloat AS AmountPartnerTotal_diff
            , (COALESCE (FLOOR (_Result_Master.Income_CEH),0) - COALESCE (FLOOR (_Result_Master.AmountPrIn)   ,0)) :: TFloat AS Income_CEH_diff

            , _Result_Child.AmountPack                :: TFloat AS AmountPack
            , _Result_Child.AmountPackSecond          :: TFloat AS AmountPackSecond

            , _Result_Child.AmountPack_calc           :: TFloat AS AmountPack_calc
            , _Result_Child.AmountSecondPack_calc     :: TFloat AS AmountSecondPack_calc

            , _Result_Child.AmountPackNext            :: TFloat AS AmountPackNext
            , _Result_Child.AmountPackNextSecond      :: TFloat AS AmountPackNextSecond

            , _Result_Child.AmountPackNext_calc       :: TFloat AS AmountPackNext_calc
            , _Result_Child.AmountPackNextSecond_calc :: TFloat AS AmountPackNextSecond_calc

            , _tmpResult_Detail.AmountPack                :: TFloat AS AmountPack_dt
            , _tmpResult_Detail.AmountPackSecond          :: TFloat AS AmountPackSecond_dt

            , _tmpResult_Detail.AmountPack_calc           :: TFloat AS AmountPack_calc_dt
            , _tmpResult_Detail.AmountSecondPack_calc     :: TFloat AS AmountSecondPack_calc_dt

            , _tmpResult_Detail.AmountPackNext            :: TFloat AS AmountPackNext_dt
            , _tmpResult_Detail.AmountPackNextSecond      :: TFloat AS AmountPackNextSecond_dt

            , _tmpResult_Detail.AmountPackNext_calc       :: TFloat AS AmountPackNext_calc_dt
            , _tmpResult_Detail.AmountPackNextSecond_calc :: TFloat AS AmountPackNextSecond_calc_dt

            , _tmpGoodsByGoodsKind_NormPack.NormInDays ::TFloat
       FROM _Result_Master
           LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                         ON MIBoolean_Calculated.MovementItemId = _Result_Master.Id
                                        AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
           LEFT JOIN Object ON Object.Id = COALESCE (_Result_Master.GoodsKindId, zc_GoodsKind_Basis())
           LEFT JOIN (SELECT _Result_Child.KeyId

                           , SUM (_Result_Child.AmountPack)                AS AmountPack
                           , SUM (_Result_Child.AmountPackSecond)          AS AmountPackSecond

                           , SUM (_Result_Child.AmountPack_calc)           AS AmountPack_calc
                           , SUM (_Result_Child.AmountSecondPack_calc)     AS AmountSecondPack_calc

                           , SUM (_Result_Child.AmountPackNext)            AS AmountPackNext
                           , SUM (_Result_Child.AmountPackNextSecond)      AS AmountPackNextSecond

                           , SUM (_Result_Child.AmountPackNext_calc)       AS AmountPackNext_calc
                           , SUM (_Result_Child.AmountPackNextSecond_calc) AS AmountPackNextSecond_calc
                           , MIN (CASE WHEN tmpGoodsByGoodsKind_not.isNotPack = TRUE THEN 0 ELSE 1 END) AS isNotPack
                      FROM _Result_Child
                           LEFT JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = _Result_Child.GoodsId
                                                            AND tmpGoodsByGoodsKind_not.GoodsKindId = _Result_Child.GoodsKindId
                      GROUP BY _Result_Child.KeyId
                     ) AS _Result_Child ON _Result_Child.KeyId = _Result_Master.KeyId

           LEFT JOIN (SELECT _Result_Child.KeyId

                           , SUM (_tmpResult_Detail.AmountPack)                AS AmountPack
                           , SUM (_tmpResult_Detail.AmountPackSecond)          AS AmountPackSecond

                           , SUM (_tmpResult_Detail.AmountPack_calc)           AS AmountPack_calc
                           , SUM (_tmpResult_Detail.AmountSecondPack_calc)     AS AmountSecondPack_calc

                           , SUM (_tmpResult_Detail.AmountPackNext)            AS AmountPackNext
                           , SUM (_tmpResult_Detail.AmountPackNextSecond)      AS AmountPackNextSecond

                           , SUM (_tmpResult_Detail.AmountPackNext_calc)       AS AmountPackNext_calc
                           , SUM (_tmpResult_Detail.AmountPackNextSecond_calc) AS AmountPackNextSecond_calc
                      FROM _Result_Child
                           JOIN _tmpResult_Detail ON _tmpResult_Detail.ParentId = _Result_Child.Id
                      GROUP BY _Result_Child.KeyId
                     ) AS _tmpResult_Detail ON _tmpResult_Detail.KeyId = _Result_Master.KeyId

           LEFT JOIN _tmpGoodsByGoodsKind_NormPack ON _tmpGoodsByGoodsKind_NormPack.GoodsId     = _Result_Master.GoodsId
                                                  AND _tmpGoodsByGoodsKind_NormPack.GoodsKindId = _Result_Master.GoodsKindId
       ;
       RETURN NEXT Cursor1;


       OPEN Cursor2 FOR

       SELECT _Result_Child.Id
            , _Result_Child.ContainerId
            , _Result_Child.KeyId
            , _Result_Child.GoodsId
            , _Result_Child.GoodsCode
            , (CASE WHEN _Result_Child.isNotPack = TRUE AND vbUserId = 5 THEN '---не упаковывать ' ELSE '' END || _Result_Child.GoodsName) :: TVarChar AS GoodsName
            , _Result_Child.GoodsKindId
            , _Result_Child.GoodsKindName
            , _Result_Child.MeasureName
            , _Result_Child.GoodsGroupNameFull

            , Object_Goods_complete.Id            AS GoodsId_complete
            , Object_Goods_complete.ObjectCode    AS GoodsCode_complete
            , Object_Goods_complete.ValueData     AS GoodsName_complete

            , Object_GoodsKind_complete.Id        AS GoodsKindId_complete
            , Object_GoodsKind_complete.ValueData AS GoodsKindName_complete

            , _Result_Child.AmountPack
            , _Result_Child.AmountPackSecond
            , _Result_Child.AmountPackTotal

            , _Result_Child.AmountPack_calc
            , _Result_Child.AmountSecondPack_calc
            , _Result_Child.AmountPackTotal_calc

            , _Result_Child.AmountPackNext
            , _Result_Child.AmountPackNextSecond
            , _Result_Child.AmountPackNextTotal

            , _Result_Child.AmountPackNext_calc
            , _Result_Child.AmountPackNextSecond_calc
            , _Result_Child.AmountPackNextTotal_calc

            , _tmpResult_Detail.AmountPack                :: TFloat AS AmountPack_dt
            , _tmpResult_Detail.AmountPackSecond          :: TFloat AS AmountPackSecond_dt

            , _tmpResult_Detail.AmountPack_calc           :: TFloat AS AmountPack_calc_dt
            , _tmpResult_Detail.AmountSecondPack_calc     :: TFloat AS AmountSecondPack_calc_dt

            , _tmpResult_Detail.AmountPackNext            :: TFloat AS AmountPackNext_dt
            , _tmpResult_Detail.AmountPackNextSecond      :: TFloat AS AmountPackNextSecond_dt

            , _tmpResult_Detail.AmountPackNext_calc       :: TFloat AS AmountPackNext_calc_dt
            , _tmpResult_Detail.AmountPackNextSecond_calc :: TFloat AS AmountPackNextSecond_calc_dt

            , _Result_Child.AmountPackAllTotal
            , _Result_Child.AmountPackAllTotal_calc

            , _Result_Child.Amount_result_two
            , _Result_Child.Amount_result_pack
            , _Result_Child.Amount_result_pack_pack

            , _Result_Child.Income_PACK_to
            , _Result_Child.Income_PACK_from

            , _Result_Child.Remains
            , _Result_Child.Remains_pack
            , _Result_Child.RemainsRK

              -- неотгуж. заявка
            , _Result_Child.AmountPartnerPrior
            , _Result_Child.AmountPartnerPriorPromo
            , _Result_Child.AmountPartnerPriorTotal
              -- сегодня заявка
            , _Result_Child.AmountPartner
            , _Result_Child.AmountPartnerNext
            , _Result_Child.AmountPartnerPromo
            , _Result_Child.AmountPartnerNextPromo
            , _Result_Child.AmountPartnerTotal
              -- Прогноз по прод.
            , _Result_Child.AmountForecast
            , _Result_Child.AmountForecastPromo
              -- Прогноз по заяв.
            , _Result_Child.AmountForecastOrder
            , _Result_Child.AmountForecastOrderPromo

             --
            , _Result_Child.AmountPartnerOld
            , _Result_Child.AmountPartnerPromoOld
            , _Result_Child.AmountPartnerOldTotal

              -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
            , _Result_Child.CountForecast
              -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
            , _Result_Child.CountForecastOrder

              -- "средняя" за 1 день - продажа ИЛИ заявака
            , _Result_Child.Plan1
            , _Result_Child.Plan2
            , _Result_Child.Plan3
            , _Result_Child.Plan4
            , _Result_Child.Plan5
            , _Result_Child.Plan6
            , _Result_Child.Plan7
              -- "средняя" за 1 день - акции - прогноз
            , _Result_Child.Promo1
            , _Result_Child.Promo2
            , _Result_Child.Promo3
            , _Result_Child.Promo4
            , _Result_Child.Promo5
            , _Result_Child.Promo6
            , _Result_Child.Promo7
              -- Ост. в днях (по пр.) - без К
            , _Result_Child.DayCountForecast
              -- Ост. в днях (по зв.) - без К
            , _Result_Child.DayCountForecastOrder
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_Child.DayCountForecast_calc
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_Child.DayCountForecast_new
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_Child.DayCountForecast_new_new

            , _Result_Child.ReceiptId
            , _Result_Child.ReceiptCode
            , _Result_Child.ReceiptName
            , _Result_Child.ReceiptId_basis
            , _Result_Child.ReceiptCode_basis
            , _Result_Child.ReceiptName_basis
            , _Result_Child.isErased

            , _Result_Child.GoodsCode_packTo
            , _Result_Child.GoodsName_packTo
            , _Result_Child.GoodsKindName_packTo

            , COALESCE (MIBoolean_Calculated.ValueData, TRUE) :: Boolean AS isCalculated

            , CASE WHEN _Result_Child.AmountPartnerTotal <> _Result_Child.AmountPartnerOldTotal THEN TRUE ELSE FALSE END :: Boolean AS isDiff1           -- разница да/нет AmountPartnerTotal и AmountPartnerOldTotal
            , (COALESCE (_Result_Child.AmountPartnerTotal,0) - COALESCE (_Result_Child.AmountPartnerOldTotal,0)) :: TFloat AS AmountPartnerTotal_diff

            , _Result_Child.NormPack      ::TFloat
            , _Result_Child.HourPack_calc ::TFloat
            , _Result_Child.NormInDays    ::TFloat

       FROM _tmpResult_Child AS _Result_Child
           LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                         ON MIBoolean_Calculated.MovementItemId = _Result_Child.Id
                                        AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()

           LEFT JOIN (SELECT _tmpResult_Detail.ParentId

                           , SUM (_tmpResult_Detail.AmountPack)                AS AmountPack
                           , SUM (_tmpResult_Detail.AmountPackSecond)          AS AmountPackSecond

                           , SUM (_tmpResult_Detail.AmountPack_calc)           AS AmountPack_calc
                           , SUM (_tmpResult_Detail.AmountSecondPack_calc)     AS AmountSecondPack_calc

                           , SUM (_tmpResult_Detail.AmountPackNext)            AS AmountPackNext
                           , SUM (_tmpResult_Detail.AmountPackNextSecond)      AS AmountPackNextSecond

                           , SUM (_tmpResult_Detail.AmountPackNext_calc)       AS AmountPackNext_calc
                           , SUM (_tmpResult_Detail.AmountPackNextSecond_calc) AS AmountPackNextSecond_calc
                      FROM _tmpResult_Detail
                      GROUP BY _tmpResult_Detail.ParentId
                     ) AS _tmpResult_Detail ON _tmpResult_Detail.ParentId = _Result_Child.Id

            LEFT JOIN Object AS Object_Goods_complete     ON Object_Goods_complete.Id = _Result_Child.GoodsId_complete
            LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = _Result_Child.GoodsKindId_complete

       WHERE _Result_Child.GoodsId_complete > 0 -- OR inShowAll = TRUE
       -- OR vbUserId = 5
      ;
       RETURN NEXT Cursor2;

       OPEN Cursor3 FOR
            WITH -- Не упаковывать
                 tmpGoodsByGoodsKind_not AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId          AS GoodsId
                                                  , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId      AS GoodsKindId
                                                  , ObjectBoolean_NotPack.ValueData                          AS isNotPack
                                             FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                  JOIN Object AS Object_GoodsByGoodsKind
                                                              ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                             AND Object_GoodsByGoodsKind.isErased = FALSE
                                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                  ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                  JOIN ObjectBoolean AS ObjectBoolean_NotPack
                                                                     ON ObjectBoolean_NotPack.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                    AND ObjectBoolean_NotPack.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotPack()
                                                                    AND ObjectBoolean_NotPack.ValueData = TRUE
                                             WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                            )
       SELECT _Result_ChildTotal.Id
            , _Result_ChildTotal.ContainerId
            , _Result_ChildTotal.GoodsId
            , _Result_ChildTotal.GoodsCode
            , (CASE WHEN tmpGoodsByGoodsKind_not.isNotPack = TRUE AND vbUserId = 5 THEN '---не упаковывать ' ELSE '' END || _Result_ChildTotal.GoodsName) :: TVarChar AS GoodsName
            , _Result_ChildTotal.GoodsId_complete
            , _Result_ChildTotal.GoodsCode_complete
            , _Result_ChildTotal.GoodsName_complete
            , _Result_ChildTotal.GoodsId_basis
            , _Result_ChildTotal.GoodsCode_basis
            , _Result_ChildTotal.GoodsName_basis
            , _Result_ChildTotal.GoodsKindId
            , _Result_ChildTotal.GoodsKindName
            , _Result_ChildTotal.GoodsKindId_complete
            , _Result_ChildTotal.GoodsKindName_complete
            , _Result_ChildTotal.MeasureName
            , _Result_ChildTotal.MeasureName_complete
            , _Result_ChildTotal.MeasureName_basis
            , _Result_ChildTotal.GoodsGroupNameFull
            , _Result_ChildTotal.isCheck_basis

              -- План1 + План2 ИТОГО выдали на УПАК
            , (_Result_ChildTotal.AmountTotal + _Result_ChildTotal.AmountNextTotal)                   :: TFloat AS AmountAllTotal
              -- План1 + План2 ИТОГО заказ факт - Приход с УПАК
            , (_Result_ChildTotal.AmountPackTotal + _Result_ChildTotal.AmountPackNextTotal)           :: TFloat AS AmountPackAllTotal
              -- План1 + План2 ИТОГО заказ расч. - Приход с УПАК
            , (_Result_ChildTotal.AmountPackTotal_calc + _Result_ChildTotal.AmountPackNextTotal_calc) :: TFloat AS AmountPackAllTotal_calc

              -- ***План1 выдали на УПАК ...
            , _Result_ChildTotal.Amount
            , _Result_ChildTotal.AmountSecond
            , _Result_ChildTotal.AmountTotal
              -- ***План1 заказ факт - Приход с УПАК
            , _Result_ChildTotal.AmountPack
            , _Result_ChildTotal.AmountPackSecond
            , _Result_ChildTotal.AmountPackTotal
              -- ***План1 заказ расч. - Приход с УПАК
            , _Result_ChildTotal.AmountPack_calc
            , _Result_ChildTotal.AmountSecondPack_calc
            , _Result_ChildTotal.AmountPackTotal_calc

              -- ***План2 выдали на УПАК ...
            , _Result_ChildTotal.AmountNext
            , _Result_ChildTotal.AmountNextSecond
            , _Result_ChildTotal.AmountNextTotal
              -- ***План2 заказ факт - Приход с УПАК
            , _Result_ChildTotal.AmountPackNext
            , _Result_ChildTotal.AmountPackNextSecond
            , _Result_ChildTotal.AmountPackNextTotal
              -- ***План2 заказ расч. - Приход с УПАК
            , _Result_ChildTotal.AmountPackNext_calc
            , _Result_ChildTotal.AmountPackNextSecond_calc
            , _Result_ChildTotal.AmountPackNextTotal_calc

              -- РЕЗУЛЬТАТ c пр-вом
            , _Result_ChildTotal.Amount_result
              -- РЕЗУЛЬТАТ без пр-ва
            , _Result_ChildTotal.Amount_result_two
              -- РЕЗУЛЬТАТ ***УПАК
            , _Result_ChildTotal.Amount_result_pack

            , _Result_ChildTotal.Income_CEH
            , _Result_ChildTotal.Income_PACK_to
            , _Result_ChildTotal.Income_PACK_from

            , _Result_ChildTotal.Remains_CEH
            , _Result_ChildTotal.Remains_CEH_Next
            , _Result_ChildTotal.Remains_CEH_err
            , _Result_ChildTotal.Remains
            , _Result_ChildTotal.Remains_pack
            , _Result_ChildTotal.Remains_err
            , _Result_ChildTotal.RemainsRK

              -- неотгуж. заявка
            , _Result_ChildTotal.AmountPartnerPrior
            , _Result_ChildTotal.AmountPartnerPriorPromo
            , _Result_ChildTotal.AmountPartnerPriorTotal
              -- сегодня заявка
            , _Result_ChildTotal.AmountPartner
            , _Result_ChildTotal.AmountPartnerNext
            , _Result_ChildTotal.AmountPartnerPromo
            , _Result_ChildTotal.AmountPartnerNextPromo
            , _Result_ChildTotal.AmountPartnerTotal
              -- Прогноз по прод.
            , _Result_ChildTotal.AmountForecast
            , _Result_ChildTotal.AmountForecastPromo
              -- Прогноз по заяв.
            , _Result_ChildTotal.AmountForecastOrder
            , _Result_ChildTotal.AmountForecastOrderPromo

             --
            , _Result_ChildTotal.AmountPrIn
            , _Result_ChildTotal.AmountPartnerOld
            , _Result_ChildTotal.AmountPartnerPromoOld
            , _Result_ChildTotal.AmountPartnerOldTotal

              -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
            , CAST (_Result_ChildTotal.CountForecast AS NUMERIC (16, 1)) :: TFloat AS CountForecast
              -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
            , CAST (_Result_ChildTotal.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- "средняя" за 1 день - продажа ИЛИ заявака
            , CAST (_Result_ChildTotal.Plan1 AS NUMERIC (16, 1)) :: TFloat AS Plan1
            , CAST (_Result_ChildTotal.Plan2 AS NUMERIC (16, 1)) :: TFloat AS Plan2
            , CAST (_Result_ChildTotal.Plan3 AS NUMERIC (16, 1)) :: TFloat AS Plan3
            , CAST (_Result_ChildTotal.Plan4 AS NUMERIC (16, 1)) :: TFloat AS Plan4
            , CAST (_Result_ChildTotal.Plan5 AS NUMERIC (16, 1)) :: TFloat AS Plan5
            , CAST (_Result_ChildTotal.Plan6 AS NUMERIC (16, 1)) :: TFloat AS Plan6
            , CAST (_Result_ChildTotal.Plan7 AS NUMERIC (16, 1)) :: TFloat AS Plan7
              -- "средняя" за 1 день - акции - прогноз
            , CAST (_Result_ChildTotal.Promo1 AS NUMERIC (16, 1)) :: TFloat AS Promo1
            , CAST (_Result_ChildTotal.Promo2 AS NUMERIC (16, 1)) :: TFloat AS Promo2
            , CAST (_Result_ChildTotal.Promo3 AS NUMERIC (16, 1)) :: TFloat AS Promo3
            , CAST (_Result_ChildTotal.Promo4 AS NUMERIC (16, 1)) :: TFloat AS Promo4
            , CAST (_Result_ChildTotal.Promo5 AS NUMERIC (16, 1)) :: TFloat AS Promo5
            , CAST (_Result_ChildTotal.Promo6 AS NUMERIC (16, 1)) :: TFloat AS Promo6
            , CAST (_Result_ChildTotal.Promo7 AS NUMERIC (16, 1)) :: TFloat AS Promo7

              -- Ост. в днях (по пр.) - без К
            , _Result_ChildTotal.DayCountForecast
              -- Ост. в днях (по зв.) - без К
            , _Result_ChildTotal.DayCountForecastOrder
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_ChildTotal.DayCountForecast_calc
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , zfCalc_StatDayCount_Week (inAmount           := COALESCE (_Result_ChildTotal.Amount_result_pack, 0)
                                      , inAmountPartnerNext:= COALESCE (_Result_ChildTotal.AmountPartnerNext, 0) + COALESCE (_Result_ChildTotal.AmountPartnerNextPromo, 0)
                                      , inCountForecast    := CASE WHEN _Result_ChildTotal.CountForecast > 0 THEN COALESCE (_Result_ChildTotal.CountForecast, 0) ELSE COALESCE (_Result_ChildTotal.CountForecastOrder, 0) END
                                      , inPlan1            := COALESCE (_Result_ChildTotal.Plan1, 0) + COALESCE (_Result_ChildTotal.Promo1, 0)
                                      , inPlan2            := COALESCE (_Result_ChildTotal.Plan2, 0) + COALESCE (_Result_ChildTotal.Promo2, 0)
                                      , inPlan3            := COALESCE (_Result_ChildTotal.Plan3, 0) + COALESCE (_Result_ChildTotal.Promo3, 0)
                                      , inPlan4            := COALESCE (_Result_ChildTotal.Plan4, 0) + COALESCE (_Result_ChildTotal.Promo4, 0)
                                      , inPlan5            := COALESCE (_Result_ChildTotal.Plan5, 0) + COALESCE (_Result_ChildTotal.Promo5, 0)
                                      , inPlan6            := COALESCE (_Result_ChildTotal.Plan6, 0) + COALESCE (_Result_ChildTotal.Promo6, 0)
                                      , inPlan7            := COALESCE (_Result_ChildTotal.Plan7, 0) + COALESCE (_Result_ChildTotal.Promo7, 0)
                                       ) AS DayCountForecast_new

            , _Result_ChildTotal.ReceiptId
            , _Result_ChildTotal.ReceiptCode
            , _Result_ChildTotal.ReceiptName
            , _Result_ChildTotal.ReceiptId_basis
            , _Result_ChildTotal.ReceiptCode_basis
            , _Result_ChildTotal.ReceiptName_basis
            , _Result_ChildTotal.UnitId
            , _Result_ChildTotal.UnitCode
            , _Result_ChildTotal.UnitName
            , _Result_ChildTotal.GoodsKindName_pf
            , _Result_ChildTotal.GoodsKindCompleteName_pf
            , _Result_ChildTotal.PartionDate_pf
            , _Result_ChildTotal.PartionGoods_start
            , _Result_ChildTotal.TermProduction
            , _Result_ChildTotal.isErased

            , _tmpGoodsByGoodsKind_NormPack.NormPack  ::TFloat

            , CAST (CASE WHEN COALESCE (_tmpGoodsByGoodsKind_NormPack.NormPack,0) <> 0
                         THEN (COALESCE (_Result_ChildTotal.AmountPack,0)
                             + COALESCE (_Result_ChildTotal.AmountPackSecond,0)
                             + COALESCE (_Result_ChildTotal.AmountPackNext,0)
                             + COALESCE (_Result_ChildTotal.AmountPackNextSecond,0)) / _tmpGoodsByGoodsKind_NormPack.NormPack
                         ELSE 0
                    END  AS NUMERIC (16,2)) ::TFloat AS HourPack_calc  -- расчет сколько врмени надо на весь план

            , _tmpGoodsByGoodsKind_NormPack.NormInDays ::TFloat
       FROM _Result_ChildTotal
            LEFT JOIN _tmpGoodsByGoodsKind_NormPack ON _tmpGoodsByGoodsKind_NormPack.GoodsId     = _Result_ChildTotal.GoodsId
                                                   AND _tmpGoodsByGoodsKind_NormPack.GoodsKindId = _Result_ChildTotal.GoodsKindId
            LEFT JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = _Result_ChildTotal.GoodsId
                                             AND tmpGoodsByGoodsKind_not.GoodsKindId = _Result_ChildTotal.GoodsKindId
       ;

       RETURN NEXT Cursor3;

      OPEN Cursor4 FOR

       -- Результат
       SELECT _Result_Master.Id         AS Id_Master
            , _Result_Master.KeyId
            , _Result_Master.GoodsId    AS GoodsId_Master
            , _Result_Master.GoodsCode  AS GoodsCode_Master
            , _Result_Master.GoodsName  AS GoodsName_Master

            , _Result_Master.GoodsId_basis
            , _Result_Master.GoodsCode_basis
            , _Result_Master.GoodsName_basis
            , _Result_Master.GoodsKindId          AS GoodsKindId_Master
            , _Result_Master.GoodsKindName        AS GoodsKindName_Master
            , _Result_Master.MeasureName          AS MeasureName_Master
            , _Result_Master.MeasureName_basis
            , _Result_Master.GoodsGroupNameFull   AS GoodsGroupNameFull_Master
            , _Result_Master.isCheck_basis

            , _Result_Master.UnitId
            , _Result_Master.UnitCode
            , _Result_Master.UnitName
            , _Result_Master.isErased

            , _Result_Master.Num

            , _Result_Child.Id
            , _Result_Child.ContainerId
            , _Result_Child.GoodsId
            , _Result_Child.GoodsCode
            , (CASE WHEN _Result_Child.isNotPack = TRUE AND vbUserId = 5 THEN '---не упаковывать ' ELSE '' END || _Result_Child.GoodsName) :: TVarChar AS GoodsName
            , _Result_Child.GoodsKindId
            , _Result_Child.GoodsKindName
            , _Result_Child.MeasureName
            , _Result_Child.GoodsGroupNameFull

            , _Result_Child.AmountPack
            , _Result_Child.AmountPackSecond
            , _Result_Child.AmountPackTotal

            , _Result_Child.AmountPack_calc
            , _Result_Child.AmountSecondPack_calc
            , _Result_Child.AmountPackTotal_calc

            , _Result_Child.AmountPackNext
            , _Result_Child.AmountPackNextSecond
            , _Result_Child.AmountPackNextTotal

            , _Result_Child.AmountPackNext_calc
            , _Result_Child.AmountPackNextSecond_calc
            , _Result_Child.AmountPackNextTotal_calc

            , _Result_Child.AmountPackAllTotal
            , _Result_Child.AmountPackAllTotal_calc

            , _Result_Child.Amount_result_two
            , _Result_Child.Amount_result_pack
            , _Result_Child.Amount_result_pack_pack

            , _Result_Child.Income_PACK_to
            , _Result_Child.Income_PACK_from

            , _Result_Child.Remains
            , _Result_Child.Remains_pack
            , _Result_Child.RemainsRK

              -- неотгуж. заявка
            , _Result_Child.AmountPartnerPrior
            , _Result_Child.AmountPartnerPriorPromo
            , _Result_Child.AmountPartnerPriorTotal
              -- сегодня заявка
            , _Result_Child.AmountPartner
            , _Result_Child.AmountPartnerNext
            , _Result_Child.AmountPartnerPromo
            , _Result_Child.AmountPartnerNextPromo
            , _Result_Child.AmountPartnerTotal
              -- Прогноз по прод.
            , _Result_Child.AmountForecast
            , _Result_Child.AmountForecastPromo
              -- Прогноз по заяв.
            , _Result_Child.AmountForecastOrder
            , _Result_Child.AmountForecastOrderPromo

             --
            , _Result_Child.AmountPrIn
            , _Result_Child.AmountPartnerOld
            , _Result_Child.AmountPartnerPromoOld
            , _Result_Child.AmountPartnerOldTotal

              -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
            , _Result_Child.CountForecast
              -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
            , _Result_Child.CountForecastOrder

              -- "средняя" за 1 день - продажа ИЛИ заявака
            , _Result_Child.Plan1
            , _Result_Child.Plan2
            , _Result_Child.Plan3
            , _Result_Child.Plan4
            , _Result_Child.Plan5
            , _Result_Child.Plan6
            , _Result_Child.Plan7
              -- "средняя" за 1 день - акции - прогноз
            , _Result_Child.Promo1
            , _Result_Child.Promo2
            , _Result_Child.Promo3
            , _Result_Child.Promo4
            , _Result_Child.Promo5
            , _Result_Child.Promo6
            , _Result_Child.Promo7
              -- Ост. в днях (по пр.) - без К
            , _Result_Child.DayCountForecast
              -- Ост. в днях (по зв.) - без К
            , _Result_Child.DayCountForecastOrder
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_Child.DayCountForecast_calc
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_Child.DayCountForecast_new :: TFloat AS DayCountForecast_new
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_Child.DayCountForecast_new_new :: TFloat AS DayCountForecast_new_new

            , _Result_Child.ReceiptId
            , _Result_Child.ReceiptCode
            , _Result_Child.ReceiptName
            , _Result_Child.ReceiptId_basis
            , _Result_Child.ReceiptCode_basis
            , _Result_Child.ReceiptName_basis
            , _Result_Child.isErased

            , _Result_Child.GoodsCode_packTo
            , _Result_Child.GoodsName_packTo
            , _Result_Child.GoodsKindName_packTo
            , _Result_Child.NormInDays          ::TFloat

            -- из мастера
            , 0  :: TFloat   AS Remains_Master
            , 0  :: TFloat   AS Remains_CEH_Master
            , 0  :: TFloat   AS Remains_CEH_Next_Master
            , 0  :: TFloat   AS Income_CEH_Master
       FROM _Result_Master
            LEFT JOIN _tmpResult_Child AS _Result_Child ON _Result_Child.KeyId = _Result_Master.KeyId
      UNION
       SELECT _Result_Master.Id         AS Id_Master
            , _Result_Master.KeyId
            , _Result_Master.GoodsId    AS GoodsId_Master
            , _Result_Master.GoodsCode  AS GoodsCode_Master
            , _Result_Master.GoodsName  AS GoodsName_Master

            , _Result_Master.GoodsId_basis
            , _Result_Master.GoodsCode_basis
            , _Result_Master.GoodsName_basis
            , _Result_Master.GoodsKindId          AS GoodsKindId_Master
            , _Result_Master.GoodsKindName        AS GoodsKindName_Master
            , _Result_Master.MeasureName          AS MeasureName_Master
            , _Result_Master.MeasureName_basis
            , _Result_Master.GoodsGroupNameFull   AS GoodsGroupNameFull_Master
            , _Result_Master.isCheck_basis

            , _Result_Master.UnitId
            , _Result_Master.UnitCode
            , _Result_Master.UnitName
            , _Result_Master.isErased

            , _Result_Master.Num

            , 0              AS Id
            , 0              AS ContainerId
            , 0              AS GoodsId
            , 0              AS GoodsCode
            , '' :: Tvarchar AS GoodsName
            , 0              AS GoodsKindId
            , '' :: Tvarchar AS GoodsKindName
            , '' :: Tvarchar AS MeasureName
            , '' :: Tvarchar AS GoodsGroupNameFull

            , 0  :: TFloat   AS AmountPack
            , 0  :: TFloat   AS AmountPackSecond
            , 0  :: TFloat   AS AmountPackTotal

            , 0  :: TFloat   AS AmountPack_calc
            , 0  :: TFloat   AS AmountSecondPack_calc
            , 0  :: TFloat   AS AmountPackTotal_calc

            , 0  :: TFloat   AS AmountPackNext
            , 0  :: TFloat   AS AmountPackNextSecond
            , 0  :: TFloat   AS AmountPackNextTotal

            , 0  :: TFloat   AS AmountPackNext_calc
            , 0  :: TFloat   AS AmountPackNextSecond_calc
            , 0  :: TFloat   AS AmountPackNextTotal_calc

            , 0  :: TFloat   AS AmountPackAllTotal
            , 0  :: TFloat   AS AmountPackAllTotal_calc

            , 0  :: TFloat   AS Amount_result_two
            , 0  :: TFloat   AS Amount_result_pack
            , 0  :: TFloat   AS Amount_result_pack_pack

            , 0  :: TFloat   AS Income_PACK_to
            , 0  :: TFloat   AS Income_PACK_from

            , 0  :: TFloat   AS Remains
            , 0  :: TFloat   AS Remains_pack
            , 0  :: TFloat   AS RemainsRK

              -- неотгуж. заявка
            , 0  :: TFloat   AS AmountPartnerPrior
            , 0  :: TFloat   AS AmountPartnerPriorPromo
            , 0  :: TFloat   AS AmountPartnerPriorTotal
              -- сегодня заявка
            , 0  :: TFloat   AS AmountPartner
            , 0  :: TFloat   AS AmountPartnerNext
            , 0  :: TFloat   AS AmountPartnerPromo
            , 0  :: TFloat   AS AmountPartnerNextPromo
            , 0  :: TFloat   AS AmountPartnerTotal
              -- Прогноз по прод.
            , 0  :: TFloat   AS AmountForecast
            , 0  :: TFloat   AS AmountForecastPromo
              -- Прогноз по заяв.
            , 0  :: TFloat   AS AmountForecastOrder
            , 0  :: TFloat   AS AmountForecastOrderPromo

             --
            , 0  :: TFloat   AS AmountPrIn
            , 0  :: TFloat   AS AmountPartnerOld
            , 0  :: TFloat   AS AmountPartnerPromoOld
            , 0  :: TFloat   AS AmountPartnerOldTotal

              -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
            , 0  :: TFloat   AS CountForecast
              -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
            , 0  :: TFloat   AS CountForecastOrder

              -- "средняя" за 1 день - продажа ИЛИ заявака
            , 0  :: TFloat   AS Plan1
            , 0  :: TFloat   AS Plan2
            , 0  :: TFloat   AS Plan3
            , 0  :: TFloat   AS Plan4
            , 0  :: TFloat   AS Plan5
            , 0  :: TFloat   AS Plan6
            , 0  :: TFloat   AS Plan7
              -- "средняя" за 1 день - акции - прогноз
            , 0  :: TFloat   AS Promo1
            , 0  :: TFloat   AS Promo2
            , 0  :: TFloat   AS Promo3
            , 0  :: TFloat   AS Promo4
            , 0  :: TFloat   AS Promo5
            , 0  :: TFloat   AS Promo6
            , 0  :: TFloat   AS Promo7
              -- Ост. в днях (по пр.) - без К
            , 0  :: TFloat   AS DayCountForecast
              -- Ост. в днях (по зв.) - без К
            , 0  :: TFloat   AS DayCountForecastOrder
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , 0  :: TFloat   AS DayCountForecast_calc
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , 0  :: TFloat   AS DayCountForecast_new
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , 0  :: TFloat   AS DayCountForecast_new_new

            , 0              AS ReceiptId
            , '' :: Tvarchar AS ReceiptCode
            , '' :: Tvarchar AS ReceiptName
            , 0              AS ReceiptId_basis
            , '' :: Tvarchar AS ReceiptCode_basis
            , '' :: Tvarchar AS ReceiptName_basis
            , FALSE          AS isErased

            , 0              AS GoodsCode_packTo
            , '' :: Tvarchar AS GoodsName_packTo
            , '' :: Tvarchar AS GoodsKindName_packTo
            , 0  ::TFloat    AS NormInDays

            , _Result_Master.Remains          AS Remains_Master
            , _Result_Master.Remains_CEH      AS Remains_CEH_Master
            , _Result_Master.Remains_CEH_Next AS Remains_CEH_Next_Master
            , _Result_Master.Income_CEH       AS Income_CEH_Master

       FROM _Result_Master
       WHERE COALESCE (_Result_Master.Remains, 0)          <> 0
          OR COALESCE (_Result_Master.Remains_CEH, 0)      <> 0
          OR COALESCE (_Result_Master.Remains_CEH_Next, 0) <> 0
          OR COALESCE (_Result_Master.Income_CEH, 0)       <> 0
       ;
       RETURN NEXT Cursor4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.07.23         *
 03.12.20         *
 29.05.18         * Cursor4
 17.11.17         *
 13.11.17         *
 29.10.17         *
 19.06.15                                        * all
 31.03.15         * add GoodsGroupNameFull
 02.03.14         * add AmountRemains, AmountPartner, AmountForecast, AmountForecastOrder
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2'); -- FETCH ALL "<unnamed portal 1>";
-- select * from gpSelect_MI_OrderInternalPackRemains(inMovementId := 18405749 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '5');
