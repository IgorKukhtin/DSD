-- Function: gpSelect_Object_GoodsGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , ParentId Integer, ParentName TVarChar
             , GroupStatId Integer, GroupStatName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , GoodsTagId Integer, GoodsTagName TVarChar
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
           Object_GoodsGroup.Id                AS Id 
         , Object_GoodsGroup.ObjectCode        AS Code
         , Object_GoodsGroup.ValueData         AS Name
         , Object_GoodsGroup.isErased          AS isErased
         
         , GoodsGroup.Id            AS ParentId
         , GoodsGroup.ValueData     AS ParentName
         , GoodsGroupStat.Id        AS GroupStatId
         , GoodsGroupStat.ValueData AS GroupStatName

         , Object_TradeMark.Id            AS TradeMarkId
         , Object_TradeMark.ValueData     AS TradeMarkName

         , Object_GoodsTag.Id            AS GoodsTagId
         , Object_GoodsTag.ValueData     AS GoodsTagName         
         
     FROM Object AS Object_GoodsGroup
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                ON ObjectLink_GoodsGroup.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
           LEFT JOIN Object AS GoodsGroup ON GoodsGroup.Id = ObjectLink_GoodsGroup.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupStat
                                ON ObjectLink_GoodsGroupStat.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroupStat.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupStat()
           LEFT JOIN Object AS GoodsGroupStat ON GoodsGroupStat.Id = ObjectLink_GoodsGroupStat.ChildObjectId   

           LEFT JOIN ObjectLink AS ObjectLink_TradeMark
                                ON ObjectLink_TradeMark.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_TradeMark.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
           LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_TradeMark.ChildObjectId          
           
           LEFT JOIN ObjectLink AS ObjectLink_GoodsTag
                                ON ObjectLink_GoodsTag.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsTag.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
           LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_GoodsTag.ChildObjectId
                  
    WHERE Object_GoodsGroup.DescId = zc_Object_GoodsGroup();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsGroup(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.14         * add GoodsTag
 11.09.14         * add TradeMark
 04.09.14         *              
 12.06.13         *
 00.06.13          
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsGroup('2')