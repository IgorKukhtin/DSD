DROP FUNCTION IF EXISTS gpSelect_MovementItem_CheckDeferred (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CheckDeferred(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat 
             , NDS TFloat
             , PriceSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , AmountOrder TFloat
             , List_UID TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;   
    vbUnitId := vbUnitKey::Integer;

    RETURN QUERY
        WITH 
            tmpMov AS(SELECT Movement.Id
                      FROM 
                        Movement
                        INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                   ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                  AND MovementBoolean_Deferred.ValueData = TRUE 
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                      WHERE Movement.DescId = zc_Movement_Check()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                        AND (MovementLinkObject_Unit.ObjectId = vbUnitId 
                          OR vbUnitId = 0)
                     )
       -- Результат
       SELECT
             MovementItem.Id          AS Id,
             MovementItem.MovementId  AS MovementId 
           , MovementItem.ObjectId    AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , MovementItem.Amount      AS Amount
           , MIFloat_Price.ValueData  AS Price
           , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
           , ObjectFloat_NDSKind_NDS.ValueData AS NDS
           , MIFloat_PriceSale.ValueData         AS PriceSale
           , MIFloat_ChangePercent.ValueData     AS ChangePercent
           , MIFloat_SummChangePercent.ValueData AS SummChangePercent
           , MIFloat_AmountOrder.ValueData       AS AmountOrder
           , MIString_UID.ValueData              AS List_UID
           , MovementItem.isErased
       FROM tmpMov
          INNER JOIN MovementItem ON MovementItem.MovementId = tmpMov.Id
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 
          LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                      ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
          LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                      ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                     AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
          LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                      ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                      ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                               ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
          
          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
          LEFT JOIN MovementItemString AS MIString_UID
                                       ON MIString_UID.MovementItemId = MovementItem.Id
                                      AND MIString_UID.DescId = zc_MIString_UID()
     WHERE MovementItem.isErased = FALSE;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckDeferred (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А
 10.08.16                                                                     * MIString_UID.ValueData AS List_UID + оптимизация
 08.04.16         *
 03.07.15                                                                       * 
 25.05.15                         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_CheckDeferred ('3')
