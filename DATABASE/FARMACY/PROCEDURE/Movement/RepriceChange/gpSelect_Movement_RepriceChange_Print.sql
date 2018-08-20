-- Function: gpSelect_Movement_RepriceChange_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_RepriceChange_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_RepriceChange_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_RepriceChange());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
        SELECT Movement_RepriceChange.Id
             , Movement_RepriceChange.InvNumber
             , Movement_RepriceChange.OperDate
             , Object_Retail.ValueData                                AS RetailName
             , COALESCE(MovementFloat_TotalSumm.ValueData, 0)::TFloat AS TotalSumm
        FROM Movement AS Movement_RepriceChange
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_RepriceChange.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                         ON MovementLinkObject_Retail.MovementId = Movement_RepriceChange.Id
                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId
        WHERE Movement_RepriceChange.DescId = zc_Movement_RepriceChange()
          AND Movement_RepriceChange.Id = inMovementId;

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    
    

    SELECT Object_Goods.ObjectCode::INTEGER                  AS GoodsCode
         , Object_Goods.ValueData                            AS GoodsName
         , COALESCE(MovementItem.Amount,0)::TFloat           AS Amount
         , MIFloat_Price.ValueData                           AS PriceOld
         , MIFloat_PriceSale.ValueData                       AS PriceNew
         , (MovementItem.Amount *
             (COALESCE(MIFloat_PriceSale.ValueData,0)
              -COALESCE(MIFloat_Price.ValueData,0)))::TFloat AS SummReprice
    FROM MovementItem
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                    ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
    WHERE MovementItem.DescId = zc_MI_Master()
      AND MovementItem.MovementId = inMovementId
    ORDER BY MovementItem.GoodsName;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.18         *
*/

-- SELECT * FROM gpSelect_Movement_RepriceChange_Print (inMovementId := 570596, inSession:= '5');
