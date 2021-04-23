-- Function: gpSelect_Object_PriceList (Boolean, TVarChar);

DROP FUNCTION IF EXISTS gpSelect_Object_PriceList (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceList(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , UnitId Integer, UnitName TVarChar
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());   
      PERFORM lpGetUserBySession (inSession);

   -- результат
   RETURN QUERY
       SELECT
             Object_PriceList.Id                      AS Id
           , Object_PriceList.ObjectCode              AS Code
           , Object_PriceList.ValueData               AS Name
           , Object_Currency.Id                       AS CurrencyId
           , Object_Currency.ValueData                AS CurrencyName
           , Object_Unit.Id                           AS UnitId
           , Object_Unit.ValueData                    AS UnitName
           , Object_PriceList.isErased                AS isErased
       FROM Object AS Object_PriceList

            LEFT JOIN ObjectLink AS Object_PriceList_Currency
                                 ON Object_PriceList_Currency.ObjectId = Object_PriceList.Id
                                AND Object_PriceList_Currency.DescId = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = Object_PriceList_Currency.ChildObjectId
      
            LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList
                                 ON ObjectLink_Unit_PriceList.ChildObjectId = Object_PriceList.Id
                                AND ObjectLink_Unit_PriceList.DescId = zc_ObjectLink_Unit_PriceList()
                                AND zc_Enum_GlobalConst_isTerry() = FALSE
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_PriceList.ObjectId

       WHERE Object_PriceList.DescId = zc_Object_PriceList()
         AND (Object_PriceList.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
28.04.17          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceList (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
