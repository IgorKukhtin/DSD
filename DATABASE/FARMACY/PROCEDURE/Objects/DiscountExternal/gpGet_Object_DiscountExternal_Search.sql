-- Function: gpGet_Object_DiscountExternal_Search()

DROP FUNCTION IF EXISTS gpGet_Object_DiscountExternal_Search (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountExternal_Search(
    IN inCode                   Integer,       -- 
   OUT outDiscountExternalId    Integer,       -- 
   OUT outDiscountExternalName  TVarChar,      -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternal());
     vbUserId := lpGetUserBySession (inSession);

       SELECT
             Object_DiscountExternal.Id         AS Id
           , Object_DiscountExternal.ValueData  AS Name
       INTO outDiscountExternalId, outDiscountExternalName
       FROM Object AS Object_DiscountExternal
       WHERE Object_DiscountExternal.DescId = zc_Object_DiscountExternal()
         AND Object_DiscountExternal.ObjectCode = inCode
         AND Object_DiscountExternal.isErased = False;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_DiscountExternal_Search (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.11.20                                                       * 
*/

-- тест
-- 
SELECT * FROM gpGet_Object_DiscountExternal_Search (16, zfCalc_UserAdmin())
