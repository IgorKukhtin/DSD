-- Function: gpSelect_Object_TicketFuel (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_TicketFuel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TicketFuel(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_TicketFuel());

   RETURN QUERY 
       SELECT
             Object_TicketFuel.Id         AS Id
           , Object_TicketFuel.ObjectCode AS Code
           , Object_TicketFuel.ValueData  AS Name
                      
           , Object_Goods.Id         AS GoodsId 
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName            
            
           , Object_TicketFuel.isErased   AS isErased
           
       FROM Object AS Object_TicketFuel
            LEFT JOIN ObjectLink AS ObjectLink_TicketFuel_Goods ON ObjectLink_TicketFuel_Goods.ObjectId = Object_TicketFuel.Id
                                                               AND ObjectLink_TicketFuel_Goods.DescId = zc_ObjectLink_TicketFuel_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_TicketFuel_Goods.ChildObjectId
   
   WHERE Object_TicketFuel.DescId = zc_Object_TicketFuel();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_TicketFuel (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.10.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_TicketFuel('2')
