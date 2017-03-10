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
           , GoodsItemGroupId         Integer
           , GoodsItemGroupName       TVarChar
           , MeasureName          TVarChar
           , CompositionName      TVarChar
           , GoodsItemInfoName        TVarChar
           , LineFabricaName      TVarChar
           , LabelName            TVarChar
           , GroupNameFull        TVarChar
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

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_GoodsItem.Id                AS Id
           , Object_GoodsItem.ObjectCode        AS Code
           , Object_GoodsItem.ValueData         AS Name
           , Object_GoodsItemGroup.Id           AS GoodsItemGroupId
           , Object_GoodsItemGroup.ValueData    AS GoodsItemGroupName
           , Object_Measure.ValueData       AS MeasureName    
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsItemInfo.ValueData     AS GoodsItemInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GroupNameFull.ValueData As GroupNameFull
           , Object_GoodsItem.isErased          AS isErased
           
       FROM Object AS Object_GoodsItem
            LEFT JOIN ObjectLink AS ObjectLink_GoodsItem_GoodsItemGroup
                                 ON ObjectLink_GoodsItem_GoodsItemGroup.ObjectId = Object_GoodsItem.Id
                                AND ObjectLink_GoodsItem_GoodsItemGroup.DescId = zc_ObjectLink_GoodsItem_GoodsItemGroup()
            LEFT JOIN Object AS Object_GoodsItemGroup ON Object_GoodsItemGroup.Id = ObjectLink_GoodsItem_GoodsItemGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsItem_Measure
                                 ON ObjectLink_GoodsItem_Measure.ObjectId = Object_GoodsItem.Id
                                AND ObjectLink_GoodsItem_Measure.DescId = zc_ObjectLink_GoodsItem_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_GoodsItem_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsItem_Composition
                                 ON ObjectLink_GoodsItem_Composition.ObjectId = Object_GoodsItem.Id
                                AND ObjectLink_GoodsItem_Composition.DescId = zc_ObjectLink_GoodsItem_Composition()
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = ObjectLink_GoodsItem_Composition.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsItem_GoodsItemInfo
                                 ON ObjectLink_GoodsItem_GoodsItemInfo.ObjectId = Object_GoodsItem.Id
                                AND ObjectLink_GoodsItem_GoodsItemInfo.DescId = zc_ObjectLink_GoodsItem_GoodsItemInfo()
            LEFT JOIN Object AS Object_GoodsItemInfo ON Object_GoodsItemInfo.Id = ObjectLink_GoodsItem_GoodsItemInfo.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsItem_LineFabrica
                                 ON ObjectLink_GoodsItem_LineFabrica.ObjectId = Object_GoodsItem.Id
                                AND ObjectLink_GoodsItem_LineFabrica.DescId = zc_ObjectLink_GoodsItem_LineFabrica()
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = ObjectLink_GoodsItem_LineFabrica.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsItem_Label
                                 ON ObjectLink_GoodsItem_Label.ObjectId = Object_GoodsItem.Id
                                AND ObjectLink_GoodsItem_Label.DescId = zc_ObjectLink_GoodsItem_Label()
            LEFT JOIN Object AS Object_Label ON Object_Label.Id = ObjectLink_GoodsItem_Label.ChildObjectId

           LEFT JOIN ObjectString AS Object_GroupNameFull
                                  ON Object_GroupNameFull.ObjectId = Object_GoodsItem.Id
                                 AND Object_GroupNameFull.DescId = zc_ObjectString_GoodsItem_GroupNameFull()

     WHERE Object_GoodsItem.DescId = zc_Object_GoodsItem()
              AND (Object_GoodsItem.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
09.03.17                                                           *
03.03.17                                                           *
24.02.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsItem (TRUE, zfCalc_UserAdmin())