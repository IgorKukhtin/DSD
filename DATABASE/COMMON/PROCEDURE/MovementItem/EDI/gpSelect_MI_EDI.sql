-- Function: gpSelect_MI_EDI()

DROP FUNCTION IF EXISTS gpSelect_MI_EDI (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_EDI (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_EDI(
    IN inMovementId  Integer, --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, MovementItemId Integer, GLNCode TVarChar, GoodsNameEDI TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName  TVarChar
             , Price TFloat, Price_EDI TFloat
             , AmountOrderEDI TFloat, AmountOrder TFloat
             , AmountNoticeEDI TFloat, AmountNotice TFloat
             , AmountPartnerEDI TFloat, AmountPartner TFloat
             , SummPartnerEDI TFloat, SummPartner TFloat
             , OperDate_Insert TDateTime
             , isCheck Boolean, isErased Boolean
              )
AS
$BODY$
  DECLARE vbMovementId_Sale Integer;
  DECLARE vbMovementId_Order Integer;
  DECLARE vbMovementId_Order_Sale Integer;
  DECLARE vbGoodsPropertyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_EDI());


     -- Параметры
     SELECT Movement_Sale.Id  AS MovementId_Sale
          , Movement_Order.Id AS MovementId_Order
          , MovementLinkMovement_Order_Sale.MovementChildId AS MovementId_Order_Sale
          , MovementLinkObject_GoodsProperty.ObjectId       AS GoodsPropertyId
            INTO vbMovementId_Sale, vbMovementId_Order, vbMovementId_Order_Sale, vbGoodsPropertyId
     FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                                              ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                                             AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                ON MovementLinkMovement_Order.MovementChildId = Movement.Id 
                                                               AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                                                ON MovementLinkMovement_Sale.MovementChildId = Movement.Id 
                                                               AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_MasterEDI
                                                                ON MovementLinkMovement_MasterEDI.MovementChildId = Movement.Id 
                                                               AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()
                                 LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = COALESCE (MovementLinkMovement_Sale.MovementId, MovementLinkMovement_MasterEDI.MovementId)
                                                                    --*** AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                                 LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementId
                                                                    --*** AND Movement_Order.StatusId = zc_Enum_Status_Complete()
                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order_Sale
                                                                ON MovementLinkMovement_Order_Sale.MovementId = Movement_Sale.Id
                                                               AND MovementLinkMovement_Order_Sale.DescId = zc_MovementLinkMovement_Order()
     WHERE Movement.Id = inMovementId
       AND COALESCE (Movement_Sale.StatusId, 0) <> zc_Enum_Status_Erased()
       AND COALESCE (Movement_Order.StatusId, 0) <> zc_Enum_Status_Erased()
     ;


     RETURN QUERY
       WITH tmpMI_Order AS (SELECT inMovementId   AS MovementId
                              , vbGoodsPropertyId AS GoodsPropertyId
                              -- , 0                                                   AS MovementItemId
                              , MovementItem.ObjectId                               AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                              , COALESCE (MIFloat_Price.ValueData, 0) * (1 + COALESCE (MIFloat_ChangePercent.ValueData, 0) / 100) AS Price
                              , MAX (COALESCE (MIFloat_PriceEDI.ValueData, 0))      AS PriceEDI
                              , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE MIFloat_CountForPrice.ValueData END AS CountForPrice
                              , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS AmountOrder
                         FROM MovementItem
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                          ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceEDI
                                                          ON MIFloat_PriceEDI.MovementItemId = MovementItem.Id
                                                         AND MIFloat_PriceEDI.DescId = zc_MIFloat_PriceEDI()
                              LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                          ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                         AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                         AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                         WHERE MovementItem.MovementId = vbMovementId_Order
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.isErased = FALSE
                           AND MovementItem.ObjectId > 0
                         GROUP BY MovementItem.ObjectId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                , COALESCE (MIFloat_Price.ValueData, 0)
                                , COALESCE (MIFloat_ChangePercent.ValueData, 0)
                                , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE MIFloat_CountForPrice.ValueData END
                        )
       , tmpMI_OrderPrice AS (SELECT tmpMI_Order.MovementId
                                   -- , tmpMI_Order.GoodsPropertyId
                                   , tmpMI_Order.GoodsId
                                   , tmpMI_Order.GoodsKindId
                                   , MAX (tmpMI_Order.Price) AS Price
                              FROM tmpMI_Order
                              GROUP BY tmpMI_Order.MovementId
                                     --  , tmpMI_Order.GoodsPropertyId
                                     , tmpMI_Order.GoodsId
                                     , tmpMI_Order.GoodsKindId
                             )
       , tmpMI_OrderPrice_two AS (SELECT tmpMI_OrderPrice.MovementId
                                       , tmpMI_OrderPrice.GoodsId
                                       , MAX (tmpMI_OrderPrice.Price) AS Price
                                  FROM tmpMI_OrderPrice
                                  GROUP BY tmpMI_OrderPrice.MovementId
                                         , tmpMI_OrderPrice.GoodsId
                                 )
         -- строчная часть EDI - inMovementId
       , tmpMI_find AS (SELECT MovementItem.Id
                        FROM MovementItem
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     =  zc_MI_Master()
                          AND MovementItem.isErased   =  FALSE
                       )
       , tmpMI_Protocol AS (SELECT MovementItemProtocol.MovementItemId, MIN (MovementItemProtocol.OperDate) AS OperDate_Insert
                            FROM MovementItemProtocol
                            WHERE MovementItemProtocol.MovementItemId IN (SELECT DISTINCT tmpMI_find.Id FROM tmpMI_find)
                            GROUP BY MovementItemProtocol.MovementItemId
                           )
       -- РЕЗУЛЬТАТ
       SELECT
             tmpMI.MovementId
           , tmpMI.MovementItemId :: Integer AS MovementItemId
           , tmpMI.GLNCode :: TVarChar       AS GLNCode
           , MIString_GoodsName.ValueData    AS GoodsNameEDI

           , Object_Goods.ObjectCode         AS GoodsCode
           , Object_Goods.ValueData          AS GoodsName
           , Object_GoodsKind.ValueData      AS GoodsKindName

           , tmpMI.Price   :: TFloat AS Price
           , COALESCE (MIFloat_Price.ValueData, tmpMI.PriceEDI) :: TFloat AS Price_EDI

           , tmpMI.AmountOrderEDI :: TFloat AS AmountOrderEDI
           , tmpMI.AmountOrder :: TFloat AS AmountOrder

           , tmpMI.AmountNoticeEDI :: TFloat AS AmountNoticeEDI
           , tmpMI.AmountNotice :: TFloat AS AmountNotice

           , tmpMI.AmountPartnerEDI :: TFloat AS AmountPartnerEDI
           , tmpMI.AmountPartner :: TFloat AS AmountPartner

           , tmpMI.SummPartnerEDI :: TFloat AS SummPartnerEDI
           , tmpMI.SummPartner :: TFloat AS SummPartner

           , CASE WHEN tmpMI.OperDate_Insert = zc_DateStart() THEN NULL ELSE tmpMI.OperDate_Insert END :: TDateTime AS OperDate_Insert

           , CASE WHEN tmpMI.AmountOrderEDI <> tmpMI.AmountOrder
                    OR tmpMI.AmountNoticeEDI <> tmpMI.AmountNotice
                    OR tmpMI.AmountPartnerEDI <> tmpMI.AmountPartner
                    OR tmpMI.SummPartnerEDI <> tmpMI.SummPartner
                  THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isCheck
         
           , FALSE AS isErased

       FROM (SELECT tmpMI.MovementId
                  , MAX (tmpMI.MovementItemId) AS MovementItemId
                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.GLNCode
                  , tmpMI.Price
                  , MAX (tmpMI.PriceEDI) AS PriceEDI
                  , SUM (tmpMI.AmountOrderEDI) AS AmountOrderEDI
                  , SUM (tmpMI.AmountNoticeEDI) AS AmountNoticeEDI
                  , SUM (tmpMI.AmountPartnerEDI) AS AmountPartnerEDI
                  , SUM (tmpMI.SummPartnerEDI) AS SummPartnerEDI

                  , SUM (tmpMI.AmountOrder) AS AmountOrder
                  , SUM (tmpMI.AmountNotice) AS AmountNotice
                  , SUM (tmpMI.AmountPartner) AS AmountPartner
                  , SUM (tmpMI.SummPartner) AS SummPartner
                  , MAX (tmpMI.OperDate_Insert) AS OperDate_Insert
             FROM (-- строчная часть EDI - inMovementId
                   SELECT inMovementId AS MovementId
                        , MAX (MovementItem.Id)                               AS MovementItemId
                        , MovementItem.ObjectId                               AS GoodsId
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                        , COALESCE (MIString_GLNCode.ValueData, '')           AS GLNCode
                        -- , COALESCE (MIFloat_Price.ValueData, COALESCE (tmpMI_OrderPrice.Price, 0)) AS Price
                        , COALESCE (tmpMI_OrderPrice.Price, tmpMI_OrderPrice_two.Price) AS Price
                        , 0 AS PriceEDI

                        , SUM (COALESCE (MovementItem.Amount, 0))             AS AmountOrderEDI
                        , SUM (COALESCE (MIFloat_AmountNotice.ValueData, 0))  AS AmountNoticeEDI
                        , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartnerEDI
                        , SUM (COALESCE (MIFloat_SummPartner.ValueData, 0))   AS SummPartnerEDI
                        , 0 AS AmountOrder
                        , 0 AS AmountNotice
                        , 0 AS AmountPartner
                        , 0 AS SummPartner
                        , tmpMI_Protocol.OperDate_Insert
                   FROM MovementItem
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                        LEFT JOIN MovementItemFloat AS MIFloat_AmountNotice
                                                    ON MIFloat_AmountNotice.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountNotice.DescId = zc_MIFloat_AmountNotice()
                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                        /*LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                   AND MIFloat_Price.ValueData <> 0*/
                        LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                                    ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_SummPartner.DescId = zc_MIFloat_Summ()
                        LEFT JOIN MovementItemString AS MIString_GLNCode
                                                     ON MIString_GLNCode.MovementItemId = MovementItem.Id
                                                    AND MIString_GLNCode.DescId = zc_MIString_GLNCode()
                        LEFT JOIN tmpMI_OrderPrice ON tmpMI_OrderPrice.MovementId = inMovementId
                                                  AND tmpMI_OrderPrice.GoodsId = MovementItem.ObjectId
                                                  AND tmpMI_OrderPrice.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                        LEFT JOIN tmpMI_OrderPrice_two ON tmpMI_OrderPrice_two.MovementId = inMovementId
                                                      AND tmpMI_OrderPrice_two.GoodsId = MovementItem.ObjectId
                        LEFT JOIN tmpMI_Protocol ON tmpMI_Protocol.MovementItemId = MovementItem.Id
                                                      
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId =  zc_MI_Master()
                     AND MovementItem.isErased =  FALSE
                   GROUP BY MovementItem.ObjectId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          , COALESCE (MIString_GLNCode.ValueData, '')
                          -- , COALESCE (MIFloat_Price.ValueData, COALESCE (tmpMI_OrderPrice.Price, 0))
                          , COALESCE (tmpMI_OrderPrice.Price, tmpMI_OrderPrice_two.Price)
                          , tmpMI_Protocol.OperDate_Insert
                  UNION ALL
                   -- строчная часть Sale + Order
                   SELECT tmpMI_Sale_Order.MovementId
                        , tmpMI_Sale_Order.MovementItemId
                        , tmpMI_Sale_Order.GoodsId
                        , tmpMI_Sale_Order.GoodsKindId
                        , COALESCE (View_GoodsPropertyValue.ArticleGLN, '') AS GLNCode
                        , tmpMI_Sale_Order.Price
                        , tmpMI_Sale_Order.PriceEDI
                        , 0 AS AmountOrderEDI
                        , 0 AS AmountNoticeEDI
                        , 0 AS AmountPartnerEDI
                        , 0 AS SummPartnerEDI
                        , tmpMI_Sale_Order.AmountOrder
                        , tmpMI_Sale_Order.AmountNotice
                        , tmpMI_Sale_Order.AmountPartner
                        , CASE WHEN tmpMI_Sale_Order.CountForPrice > 0
                                    THEN CAST (tmpMI_Sale_Order.AmountPartner * tmpMI_Sale_Order.Price / tmpMI_Sale_Order.CountForPrice AS NUMERIC (16, 2))
                               ELSE CAST (tmpMI_Sale_Order.AmountPartner * tmpMI_Sale_Order.Price AS NUMERIC (16, 2))
                          END AS SummPartner
                        , zc_DateStart() AS OperDate_Insert
                   FROM (-- строчная часть Sale - vbMovementId_Sale
                         SELECT inMovementId      AS MovementId
                              , vbGoodsPropertyId AS GoodsPropertyId
                              , 0                                                   AS MovementItemId
                              , MovementItem.ObjectId                               AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                              , COALESCE (MIFloat_Price.ValueData, 0) * (1 + COALESCE (MIFloat_ChangePercent.ValueData, 0) / 100) AS Price
                              , 0 AS PriceEDI
                              , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE MIFloat_CountForPrice.ValueData END AS CountForPrice
                              , 0                                                                                AS AmountOrder
                              , SUM (CASE WHEN vbMovementId_Order_Sale <> 0 THEN MovementItem.Amount ELSE 0 END) AS AmountNotice
                              , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))                              AS AmountPartner
                         FROM MovementItem
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                          ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                          ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                         AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                         AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                         WHERE MovementItem.MovementId = vbMovementId_Sale
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.isErased = FALSE
                         GROUP BY MovementItem.ObjectId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                , COALESCE (MIFloat_Price.ValueData, 0)
                                , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) = 0 THEN 1 ELSE MIFloat_CountForPrice.ValueData END
                                , COALESCE (MIFloat_ChangePercent.ValueData, 0)
                        UNION ALL
                         -- строчная часть Order
                         SELECT tmpMI_Order.MovementId
                              , tmpMI_Order.GoodsPropertyId
                              , 0 AS MovementItemId -- tmpMI_Order.MovementItemId
                              , tmpMI_Order.GoodsId
                              , tmpMI_Order.GoodsKindId
                              , tmpMI_Order.Price
                              , tmpMI_Order.PriceEDI
                              , tmpMI_Order.CountForPrice
                              , tmpMI_Order.AmountOrder
                              , 0 AS AmountNotice
                              , 0 AS AmountPartner
                         FROM tmpMI_Order
                        ) AS tmpMI_Sale_Order
                        LEFT JOIN Object_GoodsPropertyValue_View AS View_GoodsPropertyValue
                                                                 ON View_GoodsPropertyValue.GoodsId = tmpMI_Sale_Order.GoodsId
                                                                AND View_GoodsPropertyValue.GoodsKindId = tmpMI_Sale_Order.GoodsKindId
                                                                AND View_GoodsPropertyValue.GoodsPropertyId = tmpMI_Sale_Order.GoodsPropertyId
                  ) AS tmpMI
             GROUP BY tmpMI.MovementId
                    , tmpMI.GoodsId
                    , tmpMI.GoodsKindId
                    , tmpMI.GLNCode
                    , tmpMI.Price
            ) AS tmpMI

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = tmpMI.MovementItemId
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
            LEFT JOIN MovementItemString AS MIString_GLNCode
                                         ON MIString_GLNCode.MovementItemId = tmpMI.MovementItemId
                                        AND MIString_GLNCode.DescId = zc_MIString_GLNCode()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
      ;
 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MI_EDI (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.08.15                        * add inMovementId
 09.10.14                                        * rem --***
 31.07.14                                        * add zc_MovementLinkMovement_MasterEDI
 19.07.14                                        * ALL
 15.05.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_EDI (inMovementId:= 1, inSession:= zfCalc_UserAdmin())
