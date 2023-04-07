-- Function: gpSelect_MovementItem_Income_Pfizer()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income_Pfizer (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income_Pfizer(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementItemId Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, BarCode TVarChar
             , Amount TFloat, Price TFloat
             , isRegistered Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
      SELECT
                Min(MovementItem.Id)                 AS MovementItemId
              , MovementItem.ObjectId                AS GoodsId
              , Object_Goods.ObjectCode              AS GoodsCode
              , Object_Goods.ValueData               AS GoodsName
              , Object_BarCode.ValueData             AS BarCode
              , SUM(MovementItem.Amount)::TFloat     AS Amount
              , MAX(MIFloat_Price.ValueData)::TFloat AS Price
              , COALESCE (MovementBoolean.ValueData, TRUE) AS isRegistered
          FROM MovementItem
               INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                     ON ObjectLink_BarCode_Goods.ChildObjectId = MovementItem.ObjectId
                                    AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
               INNER JOIN Object AS Object_BarCode ON Object_BarCode.Id = ObjectLink_BarCode_Goods.ObjectId
                                                  AND Object_BarCode.isErased = FALSE
                                                  AND Object_BarCode.ValueData <> ''
               INNER JOIN ObjectLink AS ObjectLink_BarCode_Object
                                     ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                    AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                    AND ObjectLink_BarCode_Object.ChildObjectId IN (SELECT Id FROM gpSelect_Object_DiscountExternal(inSession := inSession) AS D WHERE D.service = 'CardService')
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()

               -- Еще раз определим, что б не отправлять повторно
               LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = inMovementId
                                        AND MovementBoolean.DescId = zc_MovementBoolean_Registered()

          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE
            AND MovementItem.Amount     <> 0
          GROUP BY MovementItem.ObjectId
                 , Object_Goods.ObjectCode
                 , Object_Goods.ValueData
                 , Object_BarCode.ValueData
                 , MovementBoolean.ValueData
         ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 09.07.20                                                                     *
 06.12.16                                        *
*/

-- тест
-- 
SELECT * FROM gpSelect_MovementItem_Income_Pfizer (inMovementId:= 22244129, inSession:= '3')