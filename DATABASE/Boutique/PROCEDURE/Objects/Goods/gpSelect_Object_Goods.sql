-- Function: gpSelect_Object_Goods (Bolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Goods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods(
    IN inIsShowAll   Boolean,       --  признак показать удаленные да/нет
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (
             Id                   Integer
           , Code                 Integer
           , Name                 TVarChar
           , GoodsGroupId         Integer
           , GoodsGroupName       TVarChar
           , MeasureId            Integer
           , MeasureName          TVarChar
           , CompositionGroupId   Integer
           , CompositionGroupName TVarChar
           , CompositionId        Integer
           , CompositionName      TVarChar
           , GoodsInfoId          Integer
           , GoodsInfoName        TVarChar
           , LineFabricaId        Integer
           , LineFabricaName      TVarChar
           , LabelId              Integer
           , LabelName            TVarChar
           , GroupNameFull        TVarChar
           , InfoMoneyId          Integer
           , InfoMoneyName        TVarChar
           , isErased             boolean
 ) 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Goods());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Goods.Id                AS Id
           , Object_Goods.ObjectCode        AS Code
           , Object_Goods.ValueData         AS Name
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
           , Object_GroupNameFull.ValueData AS GroupNameFull
           , Object_InfoMoney.Id            AS InfoMoneyId
           , Object_InfoMoney.ValueData     AS InfoMoneyName
           , Object_Goods.isErased          AS isErased
           
       FROM Object AS Object_Goods
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

            LEFT JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                 ON ObjectLink_Composition_CompositionGroup.ObjectId = Object_Composition.Id 
                                AND ObjectLink_Composition_CompositionGroup.DescId = zc_ObjectLink_Composition_CompositionGroup()
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = ObjectLink_Composition_CompositionGroup.ChildObjectId

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

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectString AS Object_GroupNameFull
                                   ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

     WHERE Object_Goods.DescId = zc_Object_Goods()
       AND (Object_Goods.isErased = FALSE OR inIsShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
07.06.17          * add InfoMoney
19.04.17          * add Object_CompositionGroup
09.03.17                                                           *
03.03.17                                                           *
24.02.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods (TRUE, zfCalc_UserAdmin())
