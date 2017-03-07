-- Function: gpGet_Object_GoodsGroup()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsGroup(
    IN inId          Integer,       -- Состав товара
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, GoodsGroupId Integer, GoodsGroupName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             0 :: Integer                       AS Id
           ,  NEXTVAL ('Object_GoodsGroup_seq') :: Integer AS Code
           ,'' :: TVarChar                      AS Name
           , 0 :: Integer                       AS GoodsGroupId
           ,'' :: TVarChar                      AS GoodsGroupName
       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_GoodsGroup.Id               AS Id
           , Object_GoodsGroup.ObjectCode       AS Code
           , Object_GoodsGroup.ValueData        AS Name    
           , Object_Parent.Id                   AS GoodsGroupId
           , Object_Parent.ValueData            AS GoodsGroupName
       FROM Object AS Object_GoodsGroup
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                 ON ObjectLink_GoodsGroup_Parent.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup_Parent.ChildObjectId

       WHERE Object_GoodsGroup.Id = inId;


 

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.03.17                                                          *
20.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpSelect_GoodsGroup(1,'2')
