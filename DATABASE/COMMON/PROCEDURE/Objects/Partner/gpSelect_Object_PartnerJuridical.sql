-- Function: gpSelect_Object_Partner()

--DROP FUNCTION IF EXISTS gpSelect_Object_PartnerJuridical (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PartnerJuridical (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartnerJuridical(
    IN inJuridicalId       Integer,
    IN inisErased          Boolean,            --
    IN inSession           TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Address TVarChar, isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());

   RETURN QUERY 
     SELECT 
           Object_Partner.Id               AS Id
         , Object_Partner.ObjectCode       AS Code
         , Object_Partner.ValueData        AS Name
         , COALESCE (ObjectString_Address.ValueData, '' /*Object_Partner.ValueData*/) :: TVarChar AS Address
         , Object_Partner.isErased         AS isErased
         
     FROM Object AS Object_Partner
          JOIN ObjectLink AS ObjectLink_Partner_Juridical
                          ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id 
                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                         AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId
          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = Object_Partner.Id
                                AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
                                AND ObjectString_Address.ValueData <> ''
    WHERE Object_Partner.DescId = zc_Object_Partner()
      AND (Object_Partner.isErased = FALSE OR inisErased = TRUE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_PartnerJuridical (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.08.23         * inisErased
 05.04.14                                        * add COALESCE (ObjectString_Address.ValueData, Object_Partner.ValueData)
 06.01.14                                        * add zc_ObjectString_Partner_Address
 27.11.13                          *  
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartnerJuridical (1, false, '2')