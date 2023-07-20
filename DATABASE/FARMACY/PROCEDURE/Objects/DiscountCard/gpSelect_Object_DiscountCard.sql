-- Function: gpSelect_Object_DiscountCard()

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountCard (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountCard(
    IN inIsErased      Boolean   ,    -- Показать все
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ObjectId Integer, ObjectName TVarChar
             , isErased Boolean
              ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountCard());

   RETURN QUERY 
   SELECT Object_DiscountCard.Id             AS Id
        , Object_DiscountCard.ObjectCode     AS Code
        , Object_DiscountCard.ValueData      AS Name
        , Object_Object.Id                   AS ObjectId
        , Object_Object.ValueData            AS ObjectName

        , Object_DiscountCard.isErased

   FROM Object AS Object_DiscountCard
      LEFT JOIN ObjectLink AS ObjectLink_Object
                           ON ObjectLink_Object.ObjectId = Object_DiscountCard.Id
                          AND ObjectLink_Object.DescId = zc_ObjectLink_DiscountCard_Object()
      LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId

   WHERE Object_DiscountCard.DescId = zc_Object_DiscountCard()
     AND (Object_DiscountCard.isErased = False OR inIsErased = True)
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DiscountCard (False, '2')