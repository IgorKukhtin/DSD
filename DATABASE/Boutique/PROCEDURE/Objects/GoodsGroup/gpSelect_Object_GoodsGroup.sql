-- Function: gpSelect_Object_GoodsGroup (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroup (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroup(
    IN inIsShowAll   Boolean,       --  признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ParentId Integer, GoodsGroupName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , isErased boolean) 
  AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsGroup());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_GoodsGroup.Id               AS Id
           , Object_GoodsGroup.ObjectCode       AS Code
           , Object_GoodsGroup.ValueData        AS Name
           , Object_Parent.Id                   AS ParentId
           , Object_Parent.ValueData            AS GoodsGroupName
           , Object_InfoMoney.Id                AS InfoMoneyId
           , Object_InfoMoney.ValueData         AS InfoMoneyName
           , Object_GoodsGroup.isErased         AS isErased
           
       FROM Object AS Object_GoodsGroup
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                 ON ObjectLink_GoodsGroup_Parent.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup_Parent.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_InfoMoney
                                 ON ObjectLink_GoodsGroup_InfoMoney.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup_InfoMoney.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_GoodsGroup_InfoMoney.ChildObjectId

     WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup()
       AND (Object_GoodsGroup.isErased = FALSE OR inIsShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
07.06.17          * add InfoMoney
07.03.17                                                            *
20.02.17                                                            *

        
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsGroup (TRUE, zfCalc_UserAdmin())
