 -- Function: gpSelect_MovementItem_ConvertRemains_Print()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ConvertRemains_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ConvertRemains_Print(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , Number        Integer
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , Amount        TFloat  

             , PriceWithVAT  TFloat  
             , Summa         TFloat  
             , VAT           TFloat  

             , Measure       TVarChar
             , UKTZED        TVarChar

             , Color_UKTZED  Integer

             , isErased      Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ConvertRemains());
    vbUserId:= lpGetUserBySession (inSession);

    
    RETURN QUERY
       SELECT MovementItem.Id
            , MIFloat_Number.ValueData::Integer                     AS Number
            , MovementItem.ObjectId
            , Object_Goods_Main.ObjectCode
            , COALESCE(Object_Goods_Main.NameUkr, 
                       Object_Goods_Main.Name, 
                       MIString_GoodsName.ValueData)                AS GoodsName
            , MovementItem.Amount

            , MIFloat_PriceWithVAT.ValueData                        AS PriceWithVAT
            , Round(MIFloat_PriceWithVAT.ValueData * MovementItem.Amount, 2)::TFloat AS Summa
            , MIFloat_VAT.ValueData                                 AS VAT

            , MIString_Measure.ValueData                            AS Measure
            
            , Object_Goods_Main.CodeUKTZED                          AS UKTZED
            
            , zc_Color_White()                                      AS Color_UKTZED

            , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased
       FROM MovementItem
                         
            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id  = MovementItem.ObjectId
            LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

            LEFT JOIN MovementItemFloat AS MIFloat_Number
                                        ON MIFloat_Number.MovementItemId = MovementItem.Id
                                       AND MIFloat_Number.DescId = zc_MIFloat_Number()  
            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                        ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()  
            LEFT JOIN MovementItemFloat AS MIFloat_VAT
                                        ON MIFloat_VAT.MovementItemId = MovementItem.Id
                                       AND MIFloat_VAT.DescId = zc_MIFloat_VAT()

            LEFT JOIN MovementItemString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
            LEFT JOIN MovementItemString AS MIString_Measure
                                         ON MIString_Measure.MovementItemId = MovementItem.Id
                                        AND MIString_Measure.DescId = zc_MIString_Measure()

       WHERE MovementItem.DescId = zc_MI_Master()
         AND MovementItem.MovementId = inMovementId
         AND MovementItem.isErased = FALSE
       ORDER BY MIFloat_Number.ValueData
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.10.2023                                                     *
*/

--ТЕСТ
-- 
SELECT * FROM gpSelect_MovementItem_ConvertRemains_Print (inMovementId:= 33817411, inSession:= '3')