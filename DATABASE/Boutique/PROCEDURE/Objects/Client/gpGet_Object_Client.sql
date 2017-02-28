-- Function: gpGet_Object_Client (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Client (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Client(
    IN inId          Integer,       -- Покупатели
    IN inSession     TVarChar       -- Cессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DiscountCard TVarChar, DiscountTax TFloat, DiscountTaxTwo TFloat, Address TVarChar, HappyDate TDateTime, PhoneMobile TVarChar, Phone TVarChar, Mail TVarChar, Comment TVarChar, CityId Integer,  CityName TVarChar, DiscountKindId Integer, DiscountKindName TVarChar) 
AS
$BODY$
DECLARE vbCode_max Integer;
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Client());
  PERFORM lpGetUserBySession (inSession);

 -- пытаемся найти код
   IF inId <> 0 AND COALESCE (vbCode_max, 0) = 0 THEN vbCode_max := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = inId); END IF;


  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS DiscountCard             
           , CAST (0 as TFloat)     AS DiscountTax              
           , CAST (0 as TFloat)     AS DiscountTaxTwo                                   
           , CAST ('' as TVarChar)  AS Address                  
           , CAST (now() as TDateTime) AS HappyDate                
           , CAST ('' as TVarChar)  AS PhoneMobile              
           , CAST ('' as TVarChar)  AS Phone                    
           , CAST ('' as TVarChar)  AS Mail                     
           , CAST ('' as TVarChar)  AS Comment                  
           , CAST (0 as Integer)    AS CityId                   
           , CAST ('' as TVarChar)  AS CityName                 
           , CAST (0 as Integer)    AS DiscountKindId           
           , CAST ('' as TVarChar)  AS DiscountKindName         
           

       FROM Object
       WHERE Object.DescId = zc_Object_Client();
   ELSE
       RETURN QUERY
       SELECT 
             Object_Client.Id                        AS Id
           , Object_Client.ObjectCode                AS Code
           , Object_Client.ValueData                 AS Name
           , ObjectString_DiscountCard.ValueData     AS DiscountCard
           , ObjectFloat_DiscountTax.ValueData       AS DiscountTax
           , ObjectFloat_DiscountTaxTwo.ValueData    AS DiscountTaxTwo
           , ObjectString_Address.ValueData          AS Address
           , ObjectDate_HappyDate.ValueData          AS HappyDate
           , ObjectString_PhoneMobile.ValueData      AS PhoneMobile
           , ObjectString_Phone.ValueData            AS Phone
           , ObjectString_Mail.ValueData             AS Mail
           , ObjectString_Comment.ValueData          AS Comment
           , Object_City.Id                          AS CityId
           , Object_City.ValueData                   AS CityName
           , Object_DiscountKind.Id                  AS DiscountKindId
           , Object_DiscountKind.ValueData           AS DiscountKindName
           
           
       FROM Object AS Object_Client

            LEFT JOIN ObjectLink AS ObjectLink_Client_City
                                 ON ObjectLink_Client_City.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_City.DescId = zc_ObjectLink_Client_City()
            LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Client_City.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Client_DiscountKind
                                 ON ObjectLink_Client_DiscountKind.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_DiscountKind.DescId = zc_ObjectLink_Client_DiscountKind()
            LEFT JOIN Object AS Object_DiscountKind ON Object_DiscountKind.Id = ObjectLink_Client_DiscountKind.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_DiscountCard 
                                   ON ObjectString_DiscountCard.ObjectId = Object_Client.Id 
                                  AND ObjectString_DiscountCard.DescId = zc_ObjectString_Client_DiscountCard()

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax 
                                  ON ObjectFloat_DiscountTax.ObjectId = Object_Client.Id 
                                 AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTaxTwo 
                                  ON ObjectFloat_DiscountTaxTwo.ObjectId = Object_Client.Id 
                                 AND ObjectFloat_DiscountTaxTwo.DescId = zc_ObjectFloat_Client_DiscountTaxTwo()

            LEFT JOIN ObjectString AS  ObjectString_Address 
                                   ON  ObjectString_Address.ObjectId = Object_Client.Id 
                                  AND  ObjectString_Address.DescId = zc_ObjectString_Client_Address()

            LEFT JOIN ObjectDate AS  ObjectDate_HappyDate 
                                  ON ObjectDate_HappyDate.ObjectId = Object_Client.Id 
                                 AND ObjectDate_HappyDate.DescId = zc_ObjectDate_Client_HappyDate()

            LEFT JOIN ObjectString AS  ObjectString_PhoneMobile 
                                   ON  ObjectString_PhoneMobile.ObjectId = Object_Client.Id 
                                  AND  ObjectString_PhoneMobile.DescId = zc_ObjectString_Client_PhoneMobile()

            LEFT JOIN ObjectString AS  ObjectString_Phone 
                                   ON  ObjectString_Phone.ObjectId = Object_Client.Id 
                                  AND  ObjectString_Phone.DescId = zc_ObjectString_Client_Phone()

            LEFT JOIN ObjectString AS  ObjectString_Mail 
                                   ON  ObjectString_Mail.ObjectId = Object_Client.Id 
                                  AND  ObjectString_Mail.DescId = zc_ObjectString_Client_Mail()

            LEFT JOIN ObjectString AS  ObjectString_Comment 
                                   ON  ObjectString_Comment.ObjectId = Object_Client.Id 
                                  AND  ObjectString_Comment.DescId = zc_ObjectString_Client_Comment()

       WHERE Object_Client.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
28.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Client(1,'2')
