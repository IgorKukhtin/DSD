-- Function: gpGet_Object_DiscountExternalSupplier()

DROP FUNCTION IF EXISTS gpGet_Object_DiscountExternalSupplier (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountExternalSupplier(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , DiscountExternalId Integer, DiscountExternalName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , SupplierID Integer
              )
AS
$BODY$
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternalSupplier());

      IF COALESCE (inId, 0) = 0
      THEN
           RETURN QUERY
             SELECT CAST (0 AS Integer)    AS Id
                  , lfGet_ObjectCode(0, zc_Object_DiscountExternalSupplier()) AS Code
                 
                  , NULL :: Integer        AS DiscountExternalId
                  , CAST ('' AS TVarChar)  AS DiscountExternalName
                  , NULL :: Integer        AS JuridicalId
                  , CAST ('' AS TVarChar)  AS JuridicalName
                  , 0                      AS SupplierID;
      ELSE
           RETURN QUERY
             SELECT Object_DiscountExternalSupplier.Id         AS Id
                  , Object_DiscountExternalSupplier.ObjectCode AS Code
                  , Object_DiscountExternal.Id              AS DiscountExternalId
                  , Object_DiscountExternal.ValueData       AS DiscountExternalName
                  , Object_Juridical.Id                          AS JuridicalId
                  , Object_Juridical.ValueData                   AS JuridicalName
                  , ObjectFloat_SupplierID.ValueData::Integer    AS SupplierID

             FROM Object AS Object_DiscountExternalSupplier
                  LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                       ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalSupplier.Id
                                      AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalSupplier_DiscountExternal()
                  LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId

                  LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                       ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalSupplier.Id
                                      AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalSupplier_Juridical()
                  LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId

                  LEFT JOIN ObjectFloat AS ObjectFloat_SupplierID
                                        ON ObjectFloat_SupplierID.ObjectId = Object_DiscountExternalSupplier.Id 
                                       AND ObjectFloat_SupplierID.DescId = zc_ObjectFloat_DiscountExternalSupplier_SupplierID()

             WHERE Object_DiscountExternalSupplier.Id = inId;
      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_DiscountExternalSupplier (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 11.03.21                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_DiscountExternalSupplier (2915395, zfCalc_UserAdmin())