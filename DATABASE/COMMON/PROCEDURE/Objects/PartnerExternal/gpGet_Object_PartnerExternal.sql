-- Function: gpGet_Object_PartnerExternal (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_PartnerExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PartnerExternal(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , ObjectCode TVarChar
             , PartnerId Integer, PartnerName TVarChar
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_PartnerExternal());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PartnerExternal()) AS Code
           , CAST ('' as TVarChar)  AS Name
           
           , CAST ('' as TVarChar)  AS ObjectCode

           , CAST (0 as Integer)    AS PartnerId
           , CAST ('' as TVarChar)  AS PartnerName 
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_PartnerExternal.Id          AS Id
           , Object_PartnerExternal.ObjectCode  AS Code
           , Object_PartnerExternal.ValueData   AS Name
           
           , ObjectString_ObjectCode.ValueData  AS ObjectCode
           
           , Object_Partner.Id                  AS PartnerId
           , Object_Partner.ValueData           AS PartnerName 

       FROM Object AS Object_PartnerExternal
       
            LEFT JOIN ObjectString AS ObjectString_ObjectCode
                                   ON ObjectString_ObjectCode.ObjectId = Object_PartnerExternal.Id 
                                  AND ObjectString_ObjectCode.DescId = zc_ObjectString_PartnerExternal_ObjectCode()

            LEFT JOIN ObjectLink AS ObjectLink_Partner
                                 ON ObjectLink_Partner.ObjectId = Object_PartnerExternal.Id 
                                AND ObjectLink_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner.ChildObjectId                               

       WHERE Object_PartnerExternal.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.10.20         *       
*/

-- тест
-- SELECT * FROM gpGet_Object_PartnerExternal (0,  inPartnerId:= 83665 , inPartnerExternalKindId := 153273 ,  inSession := '5')
