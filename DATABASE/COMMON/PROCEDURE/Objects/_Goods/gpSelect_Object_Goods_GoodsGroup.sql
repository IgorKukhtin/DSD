-- Function: gpSelect_Object_Goods_GoodsGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_GoodsGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_GoodsGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , DescName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
       SELECT 
             Object_Goods.Id              AS Id
           , Object_Goods.ObjectCode      AS Code
           , Object_Goods.ValueData       AS Name

         
           , Object_GoodsGroup.Id         AS GoodsGroupId
           , Object_GoodsGroup.ValueData  AS GoodsGroupName 

           , ObjectDesc.ItemName as DescName

           , Object_Goods.isErased   AS isErased
          

       FROM Object AS Object_Goods
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectDesc on ObjectDesc.Id = Object_Goods.DescId 
                          
       WHERE Object_Goods.DescId =  zc_Object_Goods() 


     UNION 


       SELECT 
           Object_GoodsGroup.Id         AS Id 
         , Object_GoodsGroup.ObjectCode AS Code
         , Object_GoodsGroup.ValueData  AS Name
    
         , ObjectLink_GoodsGroup.ChildObjectId AS GoodsGroupId
         , Object_GoodsGroup_Parent.valuedata as  GoodsGroupName

         , ObjectDesc.ItemName as DescName
         
         , Object_GoodsGroup.isErased   AS isErased

       FROM Object as Object_GoodsGroup
            LEFT JOIN ObjectLink as ObjectLink_GoodsGroup ON ObjectLink_GoodsGroup.ObjectId = Object_GoodsGroup.Id
                                                         AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_GoodsGroup_Parent ON Object_GoodsGroup_Parent.Id = ObjectLink_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectDesc on ObjectDesc.Id = Object_GoodsGroup.DescId                                  
       WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup()
;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpSelect_Object_Goods_GoodsGroup(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.12.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods_GoodsGroup('2')