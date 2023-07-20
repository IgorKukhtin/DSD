-- Function: gpSelect_Object_DiscountExternalJuridical()

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountExternalJuridical (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountExternalJuridical(
    IN inIsErased      Boolean   ,    -- Показать все
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , DiscountExternalId Integer, DiscountExternalCode Integer, DiscountExternalName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , ExternalJuridical TVarChar  
             , isErased Boolean
              ) AS
$BODY$
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternalJuridical());

      RETURN QUERY 
        SELECT Object_DiscountExternalJuridical.Id         AS Id
             , Object_DiscountExternalJuridical.ObjectCode AS Code

             , Object_DiscountExternal.Id         AS DiscountExternalId
             , Object_DiscountExternal.ObjectCode AS DiscountExternalCode
             , Object_DiscountExternal.ValueData  AS DiscountExternalName

             , Object_Juridical.Id             AS JuridicalId
             , Object_Juridical.ObjectCode     AS JuridicalCode
             , Object_Juridical.ValueData      AS JuridicalName

             , ObjectString_ExternalJuridical.ValueData AS ExternalJuridical

             , Object_DiscountExternalJuridical.isErased

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

        WHERE Object_DiscountExternalJuridical.DescId = zc_Object_DiscountExternalJuridical()
          AND (Object_DiscountExternalJuridical.isErased = False OR inIsErased = True);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 16.05.17                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DiscountExternalJuridical (False, '2')