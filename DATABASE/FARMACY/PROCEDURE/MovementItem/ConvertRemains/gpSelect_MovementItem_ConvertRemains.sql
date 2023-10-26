 -- Function: gpSelect_MovementItem_ConvertRemains()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ConvertRemains (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ConvertRemains(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer
             , GoodsCode     Integer
             , Amount        TFloat  

             , PriceWithVAT  TFloat  
             , Summa         TFloat  
             , VAT           TFloat  

             , GoodsName     TVarChar
             , Measure       TVarChar
             , UKTZED        TVarChar

             , Color_Count   Integer

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
            , MovementItem.ObjectId
            , Object_Goods_Main.ObjectCode
            , MovementItem.Amount

            , MIFloat_PriceWithVAT.ValueData                        AS PriceWithVAT
            , Round(MIFloat_PriceWithVAT.ValueData * MIFloat_VAT.ValueData, 2)::TFloat AS Summa
            , MIFloat_VAT.ValueData                                 AS VAT

            , MIString_Name.ValueData                               AS Name
            , MIString_Measure.ValueData                            AS Measure
            
            , Object_Goods_Main.CodeUKTZED                          AS UKTZED
            
            , zc_Color_White()                                      AS Color_Count

            , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased
       FROM MovementItem
                         
            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id  = MovementItem.ObjectId
            LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                        ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()  
            LEFT JOIN MovementItemFloat AS MIFloat_VAT
                                        ON MIFloat_VAT.MovementItemId = MovementItem.Id
                                       AND MIFloat_VAT.DescId = zc_MIFloat_VAT()

            LEFT JOIN MovementItemString AS MIString_Name
                                         ON MIString_Name.MovementItemId = MovementItem.Id
                                        AND MIString_Name.DescId = zc_MIString_Name()
            LEFT JOIN MovementItemString AS MIString_Measure
                                         ON MIString_Measure.MovementItemId = MovementItem.Id
                                        AND MIString_Measure.DescId = zc_MIString_Measure()

       WHERE MovementItem.DescId = zc_MI_Master()
         AND MovementItem.MovementId = inMovementId
         AND (MovementItem.isErased = FALSE  OR inIsErased = TRUE)
       ORDER BY MovementItem.Id

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
SELECT * FROM gpSelect_MovementItem_ConvertRemains (inMovementId:= 28341113 , inShowAll:= False, inIsErased:= FALSE, inSession:= '3')