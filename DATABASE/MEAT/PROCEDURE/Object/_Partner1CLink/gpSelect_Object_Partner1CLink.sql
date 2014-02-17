-- Function: gpSelect_Object_Partner1CLink(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Partner1CLink (TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_Partner1CLink(
    IN inSession     TVarChar       -- сессия пользователя
)                                                                	
RETURNS TABLE (PartnerId integer, PartnerCode Integer, PartnerName TVarChar, Id Integer, Code Integer, Name TVarChar, BranchId Integer, BranchName TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner1CLink());
   
     RETURN QUERY 
       SELECT
             Object_Partner.Id                     AS PartnerId
           , Object_Partner.ObjectCode             AS PartnerCode
           , Object_Partner.ValueData              AS PartnerName
           , Object_Partner1CLink.Id               AS Id
           , Object_Partner1CLink.ObjectCode       AS Code
           , Object_Partner1CLink.ValueData        AS Name
           , Object_Branch.Id
           , Object_Branch.ValueData
       FROM Object AS Object_Partner
            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                   ON ObjectLink_Partner1CLink_Partner.ChildObjectId = Object_Partner.Id
                  AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
            LEFT JOIN Object AS Object_Partner1CLink
                   ON Object_Partner1CLink.Id = ObjectLink_Partner1CLink_Partner.ObjectId
           LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                   ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                  AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Partner1CLink_Branch.ChildObjectId   

       WHERE Object_Partner.DescId = zc_Object_Partner();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner1CLink (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.14                        * 
 28.01.14                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_Partner1CLink (zfCalc_UserAdmin()) WHERE Code = 