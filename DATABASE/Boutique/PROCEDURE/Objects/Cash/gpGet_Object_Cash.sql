-- Function: gpGet_Object_Cash()

DROP FUNCTION IF EXISTS gpGet_Object_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Cash(
    IN inId          Integer,       -- Cash
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, CurrencyId Integer, CurrencyName TVarChar, UnitId Integer, UnitName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Cash());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                             AS Id
           , lfGet_ObjectCode(0, zc_Object_Cash())     AS Code
           , '' :: TVarChar                            AS Name
           ,  0 :: Integer                             AS CurrencyId
           , '' :: TVarChar                            AS CurrencyName
           ,  0 :: Integer                             AS UnitId
           , '' :: TVarChar                            AS UnitName

       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_Cash.Id               AS Id
           , Object_Cash.ObjectCode       AS Code
           , Object_Cash.ValueData        AS Name
           , Object_Currency.Id           AS CurrencyId
           , Object_Currency.ValueData    AS CurrencyName
           , Object_Unit.Id               AS UnitId
           , Object_Unit.ValueData        AS UnitName
       FROM Object As Object_Cash
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                                 ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                                AND ObjectLink_Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Cash_Currency.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                 ON ObjectLink_Cash_Unit.ObjectId = Object_Cash.Id
                                AND ObjectLink_Cash_Unit.DescId = zc_ObjectLink_Cash_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Cash_Unit.ChildObjectId

       WHERE Object_Cash.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
09.05.17                                                          *
08.05.17                                                          *
06.03.17                                                          *
20.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Cash (1,'2')
