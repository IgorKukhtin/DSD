-- Function: gpGet_Object_DiscountExternalJuridical()

DROP FUNCTION IF EXISTS gpGet_Object_DiscountExternalJuridical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountExternalJuridical(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , DiscountExternalId Integer, DiscountExternalName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ExternalJuridical TVarChar  
              )
AS
$BODY$
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternalJuridical());

      IF COALESCE (inId, 0) = 0
      THEN
           RETURN QUERY
             SELECT CAST (0 AS Integer)    AS Id
                  , lfGet_ObjectCode(0, zc_Object_DiscountExternalJuridical()) AS Code
                 
                  , NULL :: Integer        AS DiscountExternalId
                  , CAST ('' AS TVarChar)  AS DiscountExternalName
                  , NULL :: Integer        AS JuridicalId
                  , CAST ('' AS TVarChar)  AS JuridicalName
                  , ''::TVarChar           AS ExternalJuridical;
      ELSE
           RETURN QUERY
             SELECT Object_DiscountExternalJuridical.Id         AS Id
                  , Object_DiscountExternalJuridical.ObjectCode AS Code
                  , Object_DiscountExternal.Id               AS DiscountExternalId
                  , Object_DiscountExternal.ValueData        AS DiscountExternalName
                  , Object_Juridical.Id                      AS JuridicalId
                  , Object_Juridical.ValueData               AS JuridicalName
                  , ObjectString_ExternalJuridical.ValueData AS ExternalJuridical

             FROM Object AS Object_DiscountExternalJuridical
                  LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                       ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalJuridical.Id
                                      AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalJuridical_DiscountExternal()
                  LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId
                  LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                       ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalJuridical.Id
                                      AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalJuridical_Juridical()
                  LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId

                  LEFT JOIN ObjectString AS ObjectString_ExternalJuridical
                                         ON ObjectString_ExternalJuridical.ObjectId = Object_DiscountExternalJuridical.Id 
                                        AND ObjectString_ExternalJuridical.DescId = zc_ObjectString_DiscountExternalJuridical_ExternalJuridical()
                
             WHERE Object_DiscountExternalJuridical.Id = inId;
      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 16.05.17                                                        * 
*/

-- тест
-- SELECT * FROM gpGet_Object_DiscountExternalJuridical (0, zfCalc_UserAdmin())
