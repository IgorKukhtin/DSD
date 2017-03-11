-- Function: gpSelect_Object_GoodsItem (Bolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsItem (Bolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsItem(
    IN inIsShowAll   Boolean,       --  признак показать удаленные да/нет
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (
             Id                   Integer
           , Code                 Integer
           , Name                 TVarChar
           , GoodsGroupName       TVarChar
           , MeasureName          TVarChar
           , CompositionName      TVarChar
           , GoodsInfoName        TVarChar
           , LineFabricaName      TVarChar
           , LabelName            TVarChar
           , GroupNameFull        TVarChar
           , GoodsSizeName        TVarChar
           , isErased             boolean
 ) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsItem());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);
/*
select *
from Object_GoodsItem
left join  Object AS Object_Goods on Object_Goods.Id = GoodsId
left join  Object AS Object_GoodsSize on GoodsSize.Id = GoodsSizeId
*/
     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Goods.Id                AS Id
           , Object_Goods.ObjectCode        AS Code
           , Object_Goods.ValueData         AS Name
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName    
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GroupNameFull.ValueData As GroupNameFull
           , Object_GoodsSize.ValueData     AS GoodsSizeName
           , Object_Goods.isErased          AS isErased
           
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



     WHERE  (Object_GoodsItem.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
10.03.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods (TRUE, zfCalc_UserAdmin())