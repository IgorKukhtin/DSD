-- Function: gpGet_Object_Discount()

DROP FUNCTION IF EXISTS gpGet_Object_Discount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Discount(
    IN inId          Integer,       -- Ключь <Названия накопительных скидок>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DiscountKindId Integer, DiscountKindName TVarChar) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                              AS Id
           , NEXTVAL ('Object_Discount_seq') :: Integer AS Code
           , '' :: TVarChar                             AS Name
           ,  0 :: Integer                              AS DiscountKindId
           , '' :: TVarChar                             AS DiscountKindName
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_Discount.Id              AS Id
           , Object_Discount.ObjectCode      AS Code
           , Object_Discount.ValueData       AS Name
           , Object_DiscountKind.Id          AS DiscountKindId
           , Object_DiscountKind.ValueData   AS DiscountKindName

       FROM Object as Object_Discount
            LEFT JOIN ObjectLink AS ObjectLink_Discount_DiscountKind
                                 ON ObjectLink_Discount_DiscountKind.ObjectId = Object_Discount.Id
                                AND ObjectLink_Discount_DiscountKind.DescId = zc_ObjectLink_Discount_DiscountKind()
            LEFT JOIN Object AS Object_DiscountKind ON Object_DiscountKind.Id = ObjectLink_Discount_DiscountKind.ChildObjectId

       WHERE Object_Discount.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.03.17                                                          *
22.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Discount (1,'2')
