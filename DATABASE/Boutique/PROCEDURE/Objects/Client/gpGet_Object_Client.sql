-- Покупатели

DROP FUNCTION IF EXISTS gpGet_Object_Client (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Client(
    IN inId          Integer,       -- Покупатели
    IN inSession     TVarChar       -- Cессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DiscountCard TVarChar, DiscountTax TFloat, DiscountTaxTwo TFloat
             , Address TVarChar
             , HappyDate TDateTime
             , PhoneMobile TVarChar, Phone TVarChar
             , Mail TVarChar, Comment TVarChar
             , CityId Integer,  CityName TVarChar
             , DiscountKindId Integer, DiscountKindName TVarChar
             , CurrencyId Integer,  CurrencyName TVarChar
             ) 
AS
$BODY$
DECLARE vbCode_max Integer;
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Client());
  PERFORM lpGetUserBySession (inSession);


  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer    AS Id
           , lfGet_ObjectCode (0, zc_Object_Client())   AS Code
           , '' :: TVarChar   AS Name
           , '' :: TVarChar   AS DiscountCard             
           ,  0 :: TFloat     AS DiscountTax              
           ,  0 :: TFloat     AS DiscountTaxTwo                                   
           , '' :: TVarChar   AS Address                  
           , NOW() :: TDateTime AS HappyDate                
           , '' :: TVarChar   AS PhoneMobile              
           , '' :: TVarChar   AS Phone                    
           , '' :: TVarChar   AS Mail                     
           , '' :: TVarChar   AS Comment                  
           ,  0 :: Integer    AS CityId                   
           , '' :: TVarChar   AS CityName                 
           ,  0 :: Integer    AS DiscountKindId           
           , '' :: TVarChar   AS DiscountKindName         
           , Object_Currency.Id         AS CurrencyId           
           , Object_Currency.ValueData  AS CurrencyName
       FROM Object AS Object_Currency
       WHERE Object_Currency.Id = zc_Currency_EUR()
       ;
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
           
           , Object_Currency.Id                      AS CurrencyId
           , Object_Currency.ValueData               AS CurrencyName
           
       FROM Object AS Object_Client

            LEFT JOIN ObjectLink AS ObjectLink_Client_City
                                 ON ObjectLink_Client_City.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_City.DescId = zc_ObjectLink_Client_City()
            LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Client_City.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Client_DiscountKind
                                 ON ObjectLink_Client_DiscountKind.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_DiscountKind.DescId = zc_ObjectLink_Client_DiscountKind()
            LEFT JOIN Object AS Object_DiscountKind ON Object_DiscountKind.Id = ObjectLink_Client_DiscountKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Client_Currency
                                 ON ObjectLink_Client_Currency.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_Currency.DescId = zc_ObjectLink_Client_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Client_Currency.ChildObjectId

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
07.02.20          * add CurrencyName
02.03.17                                                          *
28.02.17                                                          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Client(1,'2')
