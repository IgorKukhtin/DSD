-- Function: gpGet_Object_GoodsItem(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsItem(
    IN inId          Integer,       -- Товары с размерами
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupId Integer, GoodsGroupName TVarChar, MeasureId Integer, MeasureName TVarChar, CompositionId Integer, CompositionName TVarChar, GoodsInfoId Integer, GoodsInfoName TVarChar, LineFabricaId Integer, LineFabricaName TVarChar, LabalId Integer, LabelName TVarChar, GoodsSizeId Integer, GoodsSizeName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                             AS Id
           ,  0 :: Integer                             AS GoodsId        
           , NEXTVAL ('Object_Goods_seq') :: Integer   AS GoodsCode
           , '' :: TVarChar                            AS GoodsName
           ,  0 :: Integer                             AS GoodsGroupId        
           , '' :: TVarChar                            AS GoodsGroupName      
           ,  0 :: Integer                             AS MeasureId           
           , '' :: TVarChar                            AS MeasureName         
           ,  0 :: Integer                             AS CompositionId       
           , '' :: TVarChar                            AS CompositionName     
           ,  0 :: Integer                             AS GoodsInfoId         
           , '' :: TVarChar                            AS GoodsInfoName       
           ,  0 :: Integer                             AS LineFabricaId       
           , '' :: TVarChar                            AS LineFabricaName     
           ,  0 :: Integer                             AS LabalId             
           , '' :: TVarChar                            AS LabelName   
           ,  0 :: Integer                             AS GoodsSizeId             
           , '' :: TVarChar                            AS GoodsSizeName          
        ;
   ELSE
       RETURN QUERY
      SELECT 
             Object_GoodsItem.Id            as Id
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , Object_GoodsGroup.Id           AS GoodsGroupId
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.Id              AS MeasureId
           , Object_Measure.ValueData       AS MeasureName    
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
           
       FROM Object_GoodsItem

            LEFT JOIN left join  Object AS Object_Goods on Object_Goods.Id = Object_GoodsItem.GoodsId 
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
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

           LEFT JOIN ObjectString AS Object_GroupNameFull
                                  ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                                 AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

           left join  Object AS Object_GoodsSize on GoodsSize.Id = Object_GoodsItem.GoodsSizeId



     WHERE  Object_GoodsItem.Id = inId; 
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
03.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Goods (1,'2')
