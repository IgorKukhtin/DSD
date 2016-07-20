-- Function: gpGet_Object_DiscountCard()

DROP FUNCTION IF EXISTS gpGet_Object_DiscountCard (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountCard(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ObjectId Integer, ObjectName TVarChar
)
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountCard());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 AS Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_DiscountCard()) AS Code
           , CAST ('' AS TVarChar)  AS Name
          
           , CAST (0 AS Integer)    AS ObjectId
           , CAST ('' AS TVarChar)  AS ObjectName
;
   ELSE
       RETURN QUERY
       SELECT
             Object_DiscountCard.Id         AS Id
           , Object_DiscountCard.ObjectCode AS Code
           , Object_DiscountCard.ValueData  AS Name

           , Object_Object.Id         AS ObjectId
           , Object_Object.ValueData  AS ObjectName

       FROM Object AS Object_DiscountCard
           LEFT JOIN ObjectLink AS ObjectLink_DiscountCard_Object
                                ON ObjectLink_DiscountCard_Object.ObjectId = Object_DiscountCard.Id
                               AND ObjectLink_DiscountCard_Object.DescId = zc_ObjectLink_DiscountCard_Object()
           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_DiscountCard_Object.ChildObjectId

       WHERE Object_DiscountCard.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_DiscountCard (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.07.16         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_DiscountCard (0, '2')
