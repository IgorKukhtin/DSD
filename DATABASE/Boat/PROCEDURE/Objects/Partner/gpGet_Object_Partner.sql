-- Торговая марка

DROP FUNCTION IF EXISTS gpGet_Object_Partner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Fax TVarChar, Phone TVarChar, Mobile TVarChar
             , IBAN TVarChar, Street TVarChar, Member TVarChar
             , WWW TVarChar, Email TVarChar, CodeDB TVarChar
             , Comment TVarChar
             , BankId Integer, BankName TVarChar
             , PLZId Integer, PLZName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , DiscountTax TFloat
             , DayCalendar TFloat
             , DayBank     TFloat
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_Partner())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Fax
           , '' :: TVarChar           AS Phone
           , '' :: TVarChar           AS Mobile
           , '' :: TVarChar           AS IBAN
           , '' :: TVarChar           AS Street
           , '' :: TVarChar           AS Member
           , '' :: TVarChar           AS WWW
           , '' :: TVarChar           AS Email
           , '' :: TVarChar           AS CodeDB
           , '' :: TVarChar           AS Comment
           , 0                        AS BankId
           , '' :: TVarChar           AS BankName
           , 0                        AS PLZId
           , '' :: TVarChar           AS PLZName

           , 0                        AS TaxKindId
           , '' :: TVarChar           AS TaxKindName
           , 0                        AS InfoMoneyId
           , '' :: TVarChar           AS InfoMoneyName
           , 0 ::TFloat               AS DiscountTax
           , 0 ::TFloat               AS DayCalendar
           , 0 ::TFloat               AS DayBank
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_Partner.Id               AS Id
           , Object_Partner.ObjectCode       AS Code
           , Object_Partner.ValueData        AS Name
           , ObjectString_Fax.ValueData      AS Fax
           , ObjectString_Phone.ValueData    AS Phone
           , ObjectString_Mobile.ValueData   AS Mobile
           , ObjectString_IBAN.ValueData     AS IBAN
           , ObjectString_Street.ValueData   AS Street
           , ObjectString_Member.ValueData   AS Member
           , ObjectString_WWW.ValueData      AS WWW
           , ObjectString_Email.ValueData    AS Email
           , ObjectString_CodeDB.ValueData   AS CodeDB
           , ObjectString_Comment.ValueData  AS Comment

           , Object_Bank.Id                  AS BankId
           , Object_Bank.ValueData           AS BankName
           , Object_PLZ.Id                   AS PLZId
           , Object_PLZ.ValueData            AS PLZName

           , Object_TaxKind.Id               AS TaxKindId
           , Object_TaxKind.ValueData        AS TaxKindName
           , Object_InfoMoney.Id             AS InfoMoneyId
           , Object_InfoMoney.ValueData      AS InfoMoneyName
           , ObjectFloat_DiscountTax.ValueData ::TFloat AS DiscountTax
           , ObjectFloat_DayCalendar.ValueData ::TFloat AS DayCalendar
           , ObjectFloat_Bank.ValueData        ::TFloat AS DayBank
       FROM Object AS Object_Partner
          LEFT JOIN ObjectString AS ObjectString_Fax
                                 ON ObjectString_Fax.ObjectId = Object_Partner.Id
                                AND ObjectString_Fax.DescId = zc_ObjectString_Partner_Fax()  

          LEFT JOIN ObjectString AS ObjectString_Phone
                                 ON ObjectString_Phone.ObjectId = Object_Partner.Id
                                AND ObjectString_Phone.DescId = zc_ObjectString_Partner_Phone()
          LEFT JOIN ObjectString AS ObjectString_Mobile
                                 ON ObjectString_Mobile.ObjectId = Object_Partner.Id
                                AND ObjectString_Mobile.DescId = zc_ObjectString_Partner_Mobile()
          LEFT JOIN ObjectString AS ObjectString_IBAN
                                 ON ObjectString_IBAN.ObjectId = Object_Partner.Id
                                AND ObjectString_IBAN.DescId = zc_ObjectString_Partner_IBAN()
          LEFT JOIN ObjectString AS ObjectString_Street
                                 ON ObjectString_Street.ObjectId = Object_Partner.Id
                                AND ObjectString_Street.DescId = zc_ObjectString_Partner_Street()
          LEFT JOIN ObjectString AS ObjectString_Member
                                 ON ObjectString_Member.ObjectId = Object_Partner.Id
                                AND ObjectString_Member.DescId = zc_ObjectString_Partner_Member()
          LEFT JOIN ObjectString AS ObjectString_WWW
                                 ON ObjectString_WWW.ObjectId = Object_Partner.Id
                                AND ObjectString_WWW.DescId = zc_ObjectString_Partner_WWW()
          LEFT JOIN ObjectString AS ObjectString_Email
                                 ON ObjectString_Email.ObjectId = Object_Partner.Id
                                AND ObjectString_Email.DescId = zc_ObjectString_Partner_Email()
          LEFT JOIN ObjectString AS ObjectString_CodeDB
                                 ON ObjectString_CodeDB.ObjectId = Object_Partner.Id
                                AND ObjectString_CodeDB.DescId = zc_ObjectString_Partner_CodeDB()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Partner.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Partner_Comment()

          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                ON ObjectFloat_DiscountTax.ObjectId = Object_Partner.Id
                               AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Partner_DiscountTax()  
          LEFT JOIN ObjectFloat AS ObjectFloat_DayCalendar
                                ON ObjectFloat_DayCalendar.ObjectId = Object_Partner.Id
                               AND ObjectFloat_DayCalendar.DescId = zc_ObjectFloat_Partner_DayCalendar() 
          LEFT JOIN ObjectFloat AS ObjectFloat_Bank
                                ON ObjectFloat_Bank.ObjectId = Object_Partner.Id
                               AND ObjectFloat_Bank.DescId = zc_ObjectFloat_Partner_Bank()

          LEFT JOIN ObjectLink AS ObjectLink_PLZ
                               ON ObjectLink_PLZ.ObjectId = Object_Partner.Id
                              AND ObjectLink_PLZ.DescId = zc_ObjectLink_Partner_PLZ()
          LEFT JOIN Object AS Object_PLZ ON Object_PLZ.Id = ObjectLink_PLZ.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Bank
                               ON ObjectLink_Bank.ObjectId = Object_Partner.Id
                              AND ObjectLink_Bank.DescId = zc_ObjectLink_Partner_Bank()
          LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Bank.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                               ON ObjectLink_InfoMoney.ObjectId = Object_Partner.Id
                              AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Partner_InfoMoney()
          LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_InfoMoney.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = Object_Partner.Id
                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Partner_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId
       WHERE Object_Partner.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.21         *
 09.11.20         *
 22.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Partner (1 ::integer,'2'::TVarChar)
