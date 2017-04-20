-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MovementItem_Income (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_MovementItem_Income(
    IN inId             Integer  , -- ключ 
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , CompositionGroupId Integer, CompositionGroupName TVarChar
             , CompositionId Integer, CompositionName TVarChar
             , GoodsInfoId Integer, GoodsInfoName TVarChar
             , LineFabricaId Integer, LineFabricaName TVarChar
             , LabelId Integer, LabelName TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , Amount TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Income());
     vbUserId := inSession;

     IF COALESCE (inId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
              0 :: Integer                             AS Id
           ,  0 :: Integer                             AS GoodsId        
           , '' :: TVarChar                            AS GoodsName
           ,  0 :: Integer                             AS GoodsGroupId        
           , '' :: TVarChar                            AS GoodsGroupName      
           ,  0 :: Integer                             AS MeasureId           
           , '' :: TVarChar                            AS MeasureName  
           ,  0 :: Integer                             AS CompositionGroupId       
           , '' :: TVarChar                            AS CompositionGroupName         
           ,  0 :: Integer                             AS CompositionId       
           , '' :: TVarChar                            AS CompositionName     
           ,  0 :: Integer                             AS GoodsInfoId         
           , '' :: TVarChar                            AS GoodsInfoName       
           ,  0 :: Integer                             AS LineFabricaId       
           , '' :: TVarChar                            AS LineFabricaName     
           ,  0 :: Integer                             AS LabelId           
           , '' :: TVarChar                            AS LabelName   
           ,  0 :: Integer                             AS GoodsSizeId             
           , '' :: TVarChar                            AS GoodsSizeName   
        
           , CAST (0 AS TFloat)                        AS Amount
           , CAST (0 AS TFloat)                        AS OperPrice
           , CAST (1 AS TFloat)                        AS CountForPrice
           , CAST (0 AS TFloat)                        AS OperPriceList

        ;

     ELSE

     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice 
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                           , MovementItem.isErased
                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()    
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                       WHERE MovementItem.Id = inId
                         AND MovementItem.DescId     = zc_MI_Master()
                       )

       SELECT 
             tmpMI.Id
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ValueData         AS GoodsName
           , Object_GoodsGroup.Id           AS GoodsGroupId
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.Id              AS MeasureId
           , Object_Measure.ValueData       AS MeasureName  
           , Object_CompositionGroup.Id          AS CompositionGroupId
           , Object_CompositionGroup.ValueData   AS CompositionGroupName  
           , Object_Composition.Id          AS CompositionId
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.Id            AS GoodsInfoId
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.Id          AS LineFabricaId
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.Id                AS LabelId
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.Id            AS GoodsSizeId
           , Object_GoodsSize.ValueData     AS GoodsSizeName

           , tmpMI.Amount         ::TFloat
           , tmpMI.OperPrice      ::TFloat
           , tmpMI.CountForPrice  ::TFloat
           , tmpMI.OperPriceList  ::TFloat

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId

            LEFT JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                 ON ObjectLink_Composition_CompositionGroup.ObjectId = Object_Composition.Id 
                                AND ObjectLink_Composition_CompositionGroup.DescId = zc_ObjectLink_Composition_CompositionGroup()
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = ObjectLink_Composition_CompositionGroup.ChildObjectId

            LEFT JOIN Object AS Object_GoodsInfo ON Object_GoodsInfo.Id = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label ON Object_Label.Id = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = Object_PartionGoods.GoodsSizeId

    /*        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Composition
                                 ON ObjectLink_Goods_Composition.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Composition.DescId = zc_ObjectLink_Goods_Composition()
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = ObjectLink_Goods_Composition.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsInfo
                                 ON ObjectLink_Goods_GoodsInfo.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsInfo.DescId = zc_ObjectLink_Goods_GoodsInfo()
            LEFT JOIN Object AS Object_GoodsInfo ON Object_GoodsInfo.Id = ObjectLink_Goods_GoodsInfo.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_LineFabrica
                                 ON ObjectLink_Goods_LineFabrica.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_LineFabrica.DescId = zc_ObjectLink_Goods_LineFabrica()
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = ObjectLink_Goods_LineFabrica.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Label
                                 ON ObjectLink_Goods_Label.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Label.DescId = zc_ObjectLink_Goods_Label()
            LEFT JOIN Object AS Object_Label ON Object_Label.Id = ObjectLink_Goods_Label.ChildObjectId

      --      LEFT JOIN Object_GoodsItem ON Object_GoodsItem.GoodsId = Object_Goods.Id
      --                                AND Object_PartionGoods.GoodsItem
            LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = Object_PartionGoods.GoodsSizeId --Object_GoodsItem.GoodsSizeId
      */
;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_Income (inId:= 1, inSession:= '9818')