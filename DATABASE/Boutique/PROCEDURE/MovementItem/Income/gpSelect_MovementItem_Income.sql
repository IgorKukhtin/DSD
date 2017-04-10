-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat
             , AmountSumm TFloat, AmountPriceListSumm TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbPriceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат такой
     RETURN QUERY 
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice 
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                           , MovementItem.isErased
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()    
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                       )

       -- результат
       SELECT
             tmpMI.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData AS MeasureName
         
           , tmpMI.Amount

           , tmpMI.OperPrice      ::TFloat
           , tmpMI.CountForPrice  ::TFloat
           , tmpMI.OperPriceList  ::TFloat

           , CAST (CASE WHEN tmpMI.CountForPrice <> 0
                           THEN CAST (COALESCE (tmpMI.Amount, 0) * tmpMI.OperPrice / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.OperPrice AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm

           , CAST (CASE WHEN tmpMI.CountForPrice <> 0
                           THEN CAST (COALESCE (tmpMI.Amount, 0) * tmpMI.OperPriceList / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.OperPriceList AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountPriceListSumm

           , tmpMI.isErased

       FROM tmpMI
            
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
           
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId  --Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.04.17         *
*/

-- тест
 --SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 25173, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())