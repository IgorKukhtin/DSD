-- Function: gpSelect_Object_GlobalConst_user()


DROP FUNCTION IF EXISTS gpSelect_Object_GlobalConst_user(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalConst_user(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , EnumName TVarChar
             , ActualBankStatementDate TDateTime
             , SiteDiscount TFloat
             , isSiteDiscount  Boolean
             , isErased   Boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GlobalConst());

     RETURN QUERY  
       SELECT 
             Object_GlobalConst.Id            AS Id
           , Object_GlobalConst.ObjectCode    AS Code
           , Object_GlobalConst.ValueData     AS Name
           
           , ObjectString_Enum.ValueData      AS EnumName

           , COALESCE (ObjectDate_ActualBankStatement.ValueData, NULL) :: TDateTime AS ActualBankStatementDate
           , COALESCE (ObjectFloat_SiteDiscount.ValueData, 0)          :: TFloat    AS SiteDiscount
           , COALESCE (ObjectBoolean_SiteDiscount.ValueData, FALSE)    :: Boolean   AS isSiteDiscount

           , Object_GlobalConst.isErased      AS isErased
           
       FROM Object AS Object_GlobalConst
   
           LEFT JOIN ObjectDate AS ObjectDate_ActualBankStatement
                                ON ObjectDate_ActualBankStatement.ObjectId = Object_GlobalConst.Id
                               AND ObjectDate_ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_SiteDiscount
                                   ON ObjectBoolean_SiteDiscount.ObjectId = Object_GlobalConst.Id
                                  AND ObjectBoolean_SiteDiscount.DescId = zc_ObjectBoolean_GlobalConst_SiteDiscount()

           LEFT JOIN ObjectString AS ObjectString_Enum
                                  ON ObjectString_Enum.ObjectId = Object_GlobalConst.Id 
                                 AND ObjectString_Enum.DescId = zc_ObjectString_Enum()

           LEFT JOIN ObjectFloat AS ObjectFloat_SiteDiscount
                                 ON ObjectFloat_SiteDiscount.ObjectId = Object_GlobalConst.Id
                                AND ObjectFloat_SiteDiscount.DescId = zc_ObjectFloat_GlobalConst_SiteDiscount()

     WHERE Object_GlobalConst.DescId = zc_Object_GlobalConst()
       AND (Object_GlobalConst.Id = zc_Enum_GlobalConst_SiteDiscount()
         OR Object_GlobalConst.Id =zc_Enum_GlobalConst_CostCredit()) ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GlobalConst_user('2')