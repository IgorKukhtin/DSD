-- Function: gpGet_Object_GoodsItem(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsItem(
    IN inId          Integer,       -- Единица измерения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, GoodsItemGroupId Integer, GoodsItemGroupName TVarChar, MeasureId Integer, MeasureName TVarChar, CompositionId Integer, CompositionName TVarChar, GoodsItemInfoId Integer, GoodsItemInfoName TVarChar, LineFabricaId Integer, LineFabricaName TVarChar, LabalId Integer, LabelName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsItem());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                             AS Id
           , NEXTVAL ('Object_GoodsItem_seq') :: Integer   AS Code
           , '' :: TVarChar                            AS Name
           ,  0 :: Integer                             AS GoodsItemGroupId        
           , '' :: TVarChar                            AS GoodsItemGroupName      
           ,  0 :: Integer                             AS MeasureId           
           , '' :: TVarChar                            AS MeasureName         
           ,  0 :: Integer                             AS CompositionId       
           , '' :: TVarChar                            AS CompositionName     
           ,  0 :: Integer                             AS GoodsItemInfoId         
           , '' :: TVarChar                            AS GoodsItemInfoName       
           ,  0 :: Integer                             AS LineFabricaId       
           , '' :: TVarChar                            AS LineFabricaName     
           ,  0 :: Integer                             AS LabalId             
           , '' :: TVarChar                            AS LabelName           
        ;
   ELSE
       RETURN QUERY
      SELECT 
             Object_GoodsItem.Id               AS Id
           , Object_GoodsItem.ObjectCode       AS Code
           , Object_GoodsItem.ValueData        AS Name
           , Object_GoodsItemGroup.Id          AS GoodsItemGroupId
           , Object_GoodsItemGroup.ValueData   AS GoodsItemGroupName
           , Object_Measure.Id             AS MeasureId
           , Object_Measure.ValueData      AS MeasureName
           , Object_Composition.Id         AS CompositionId
           , Object_Composition.ValueData  AS CompositionName
           , Object_GoodsItemInfo.Id           AS GoodsItemInfoId
           , Object_GoodsItemInfo.ValueData    AS GoodsItemInfoName
           , Object_LineFabrica.Id         AS LineFabricaId
           , Object_LineFabrica.ValueData  AS LineFabricaName
           , Object_Label.Id               AS LabalId
           , Object_Label.ValueData        AS LabelName
           
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

      WHERE Object_GoodsItem.Id = inId;
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
-- SELECT * FROM gpSelect_GoodsItem (1,'2')
