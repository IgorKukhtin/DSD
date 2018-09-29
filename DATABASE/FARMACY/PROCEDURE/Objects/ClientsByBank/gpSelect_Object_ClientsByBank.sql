-- Function: gpSelect_Object_ClientsByBank (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ClientsByBank (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ClientsByBank(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Phone TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ClientsByBank());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_ClientsByBank.Id          AS Id
           , Object_ClientsByBank.ObjectCode  AS Code
           , Object_ClientsByBank.ValueData   AS Name
           
           , ObjectString_Phone.ValueData     AS Phone
           
           , Object_ClientsByBank.isErased           AS isErased
       FROM Object AS Object_ClientsByBank
       
            LEFT JOIN ObjectString AS ObjectString_Phone
                                   ON ObjectString_Phone.ObjectId = Object_ClientsByBank.Id 
                                  AND ObjectString_Phone.DescId = zc_ObjectString_ClientsByBank_Phone()
                 
     WHERE Object_ClientsByBank.DescId = zc_Object_ClientsByBank();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ClientsByBank(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 28.09.18         * 
       
*/

-- тест
-- SELECT * FROM gpSelect_Object_ClientsByBank (zfCalc_UserAdmin())
