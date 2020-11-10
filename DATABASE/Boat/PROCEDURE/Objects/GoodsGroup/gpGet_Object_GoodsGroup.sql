-- Function: gpGet_Object_GoodsGroup()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsGroup(
    IN inId          Integer,       -- Состав товара
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ModelEtiketenId Integer, ModelEtiketenName TVarChar
) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             0  :: Integer                      AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsGroup())   AS Code
           , '' :: TVarChar                     AS Name
           , 0  :: Integer                      AS GoodsGroupId
           , '' :: TVarChar                     AS GoodsGroupName
           , 0  :: Integer                      AS InfoMoneyId
           , '' :: TVarChar                     AS InfoMoneyName
           , 0  :: Integer                      AS ModelEtiketenId
           , '' :: TVarChar                     AS ModelEtiketenName
       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_GoodsGroup.Id               AS Id
           , Object_GoodsGroup.ObjectCode       AS Code
           , Object_GoodsGroup.ValueData        AS Name    
           , Object_Parent.Id                   AS GoodsGroupId
           , Object_Parent.ValueData            AS GoodsGroupName
           , Object_InfoMoney.Id                AS InfoMoneyId
           , Object_InfoMoney.ValueData         AS InfoMoneyName
           , Object_ModelEtiketen.Id            AS ModelEtiketenId
           , Object_ModelEtiketen.ValueData     AS ModelEtiketenName
       FROM Object AS Object_GoodsGroup
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                 ON ObjectLink_GoodsGroup_Parent.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup_Parent.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_InfoMoney
                                 ON ObjectLink_GoodsGroup_InfoMoney.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_InfoMoney.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_GoodsGroup_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_ModelEtiketen
                                 ON ObjectLink_GoodsGroup_ModelEtiketen.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_ModelEtiketen.DescId = zc_ObjectLink_GoodsGroup_ModelEtiketen()
            LEFT JOIN Object AS Object_ModelEtiketen ON Object_ModelEtiketen.Id = ObjectLink_GoodsGroup_ModelEtiketen.ChildObjectId

       WHERE Object_GoodsGroup.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
09.11.20          *
07.06.17          *
06.03.17                                                          *
20.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsGroup(1,'2'::TVarChar)