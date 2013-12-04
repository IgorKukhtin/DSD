-- Function: gpGet_Object_TicketFuel (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_TicketFuel (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_TicketFuel(
    IN inId             Integer,       -- ключ объекта <Топливные карты>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_TicketFuel());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_TicketFuel()) AS Code
           , CAST ('' as TVarChar)  AS Name
                      
           , CAST (0 as Integer)    AS GoodsId 
           , CAST (0 as Integer)    AS GoodsCode
           , CAST ('' as TVarChar)  AS GoodsName                      
            
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT
             Object_TicketFuel.Id         AS Id
           , Object_TicketFuel.ObjectCode AS Code
           , Object_TicketFuel.ValueData  AS NAME
                      
           , Object_Goods.Id         AS GoodsId 
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName            
            
           , Object_TicketFuel.isErased   AS isErased
           
       FROM Object AS Object_TicketFuel
            LEFT JOIN ObjectLink AS ObjectLink_TicketFuel_Goods ON ObjectLink_TicketFuel_Goods.ObjectId = Object_TicketFuel.Id
                                                               AND ObjectLink_TicketFuel_Goods.DescId = zc_ObjectLink_TicketFuel_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_TicketFuel_Goods.ChildObjectId
            
       WHERE Object_TicketFuel.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_TicketFuel (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.10.13          *         

*/

-- тест
-- SELECT * FROM gpGet_Object_TicketFuel (2, '')
