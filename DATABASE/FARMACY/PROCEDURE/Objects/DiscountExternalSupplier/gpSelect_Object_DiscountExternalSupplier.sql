-- Function: gpSelect_Object_DiscountExternalSupplier()

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountExternalSupplier (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountExternalSupplier(
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , DiscountExternalId Integer, DiscountExternalCode Integer, DiscountExternalName TVarChar, Service TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , SupplierID Integer
             , isErased Boolean
              ) AS
$BODY$
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternalSupplier());

      RETURN QUERY 
        SELECT Object_DiscountExternalSupplier.Id         AS Id
             , Object_DiscountExternalSupplier.ObjectCode AS Code

             , Object_DiscountExternal.Id         AS DiscountExternalId
             , Object_DiscountExternal.ObjectCode AS DiscountExternalCode
             , Object_DiscountExternal.ValueData  AS DiscountExternalName
             , ObjectString_Service.ValueData     AS Service
             
             , Object_Juridical.Id                AS JuridicalId
             , Object_Juridical.ObjectCode        AS JuridicalCode
             , Object_Juridical.ValueData         AS JuridicalName

             , ObjectFloat_SupplierID.ValueData::Integer   AS SupplierID

             , Object_DiscountExternalSupplier.isErased

        FROM Object AS Object_DiscountExternalSupplier
             LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalSupplier.Id
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalSupplier_DiscountExternal()
             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Service
                                    ON ObjectString_Service.ObjectId = Object_DiscountExternal.Id 
                                   AND ObjectString_Service.DescId = zc_ObjectString_DiscountExternal_Service()

             LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                  ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalSupplier.Id
                                 AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalSupplier_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId


             LEFT JOIN ObjectFloat AS ObjectFloat_SupplierID
                                   ON ObjectFloat_SupplierID.ObjectId = Object_DiscountExternalSupplier.Id 
                                  AND ObjectFloat_SupplierID.DescId = zc_ObjectFloat_DiscountExternalSupplier_SupplierID()

        WHERE Object_DiscountExternalSupplier.DescId = zc_Object_DiscountExternalSupplier();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 11.03.21                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DiscountExternalSupplier ('3')
