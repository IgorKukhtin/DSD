-- Торговая марка

DROP FUNCTION IF EXISTS gpSelect_Object_Client (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Client(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Fax TVarChar, Phone TVarChar, Mobile TVarChar
             , IBAN TVarChar, Street TVarChar, Member TVarChar
             , WWW TVarChar, Email TVarChar, CodeDB TVarChar
             , TaxNumber TVarChar
             , Comment TVarChar
             , BankId Integer, BankName TVarChar
             , PLZId Integer, PLZName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar, TaxKind_Value TFloat
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , DiscountTax TFloat
             , DayCalendar TFloat
             , DayBank     TFloat
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Client());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       -- результат
       SELECT
             Object_Client.Id                AS Id
           , Object_Client.ObjectCode        AS Code
           , Object_Client.ValueData         AS Name

           , COALESCE (ObjectString_Fax.ValueData,'')::TVarChar      AS Fax
           , COALESCE (ObjectString_Phone.ValueData,'')::TVarChar    AS Phone
           , COALESCE (ObjectString_Mobile.ValueData,'')::TVarChar   AS Mobile
           , COALESCE (ObjectString_IBAN.ValueData,'')::TVarChar     AS IBAN
           , COALESCE (ObjectString_Street.ValueData,'')::TVarChar   AS Street
           , COALESCE (ObjectString_Member.ValueData,'')::TVarChar   AS Member
           , COALESCE (ObjectString_WWW.ValueData,'')::TVarChar      AS WWW
           , COALESCE (ObjectString_Email.ValueData,'')::TVarChar    AS Email
           , COALESCE (ObjectString_CodeDB.ValueData,'')::TVarChar   AS CodeDB
           , COALESCE (ObjectString_TaxNumber.ValueData,'')::TVarChar AS TaxNumber
           , COALESCE (ObjectString_Comment.ValueData,'')::TVarChar  AS Comment

           , Object_Bank.Id                  AS BankId
           , Object_Bank.ValueData           AS BankName
           , Object_PLZ.Id                   AS PLZId
           , Object_PLZ.ValueData            AS PLZName

           , Object_TaxKind.Id               AS TaxKindId
           , Object_TaxKind.ValueData        AS TaxKindName
           , ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value

           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all

           , Object_InfoMoney_View.InfoMoneyGroupId
           , Object_InfoMoney_View.InfoMoneyGroupCode
           , Object_InfoMoney_View.InfoMoneyGroupName

           , Object_InfoMoney_View.InfoMoneyDestinationId
           , Object_InfoMoney_View.InfoMoneyDestinationCode
           , Object_InfoMoney_View.InfoMoneyDestinationName

           , COALESCE (ObjectFloat_DiscountTax.ValueData,0) ::TFloat AS DiscountTax
           , COALESCE (ObjectFloat_DayCalendar.ValueData,0) ::TFloat AS DayCalendar
           , COALESCE (ObjectFloat_Bank.ValueData,0)        ::TFloat AS DayBank

           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_Client.isErased          AS isErased
       FROM Object AS Object_Client
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Client.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Client_Comment()  

          LEFT JOIN ObjectString AS ObjectString_Fax
                                 ON ObjectString_Fax.ObjectId = Object_Client.Id
                                AND ObjectString_Fax.DescId = zc_ObjectString_Client_Fax()  
          LEFT JOIN ObjectString AS ObjectString_Phone
                                 ON ObjectString_Phone.ObjectId = Object_Client.Id
                                AND ObjectString_Phone.DescId = zc_ObjectString_Client_Phone()
          LEFT JOIN ObjectString AS ObjectString_Mobile
                                 ON ObjectString_Mobile.ObjectId = Object_Client.Id
                                AND ObjectString_Mobile.DescId = zc_ObjectString_Client_Mobile()
          LEFT JOIN ObjectString AS ObjectString_IBAN
                                 ON ObjectString_IBAN.ObjectId = Object_Client.Id
                                AND ObjectString_IBAN.DescId = zc_ObjectString_Client_IBAN()
          LEFT JOIN ObjectString AS ObjectString_Street
                                 ON ObjectString_Street.ObjectId = Object_Client.Id
                                AND ObjectString_Street.DescId = zc_ObjectString_Client_Street()
          LEFT JOIN ObjectString AS ObjectString_Member
                                 ON ObjectString_Member.ObjectId = Object_Client.Id
                                AND ObjectString_Member.DescId = zc_ObjectString_Client_Member()
          LEFT JOIN ObjectString AS ObjectString_WWW
                                 ON ObjectString_WWW.ObjectId = Object_Client.Id
                                AND ObjectString_WWW.DescId = zc_ObjectString_Client_WWW()
          LEFT JOIN ObjectString AS ObjectString_Email
                                 ON ObjectString_Email.ObjectId = Object_Client.Id
                                AND ObjectString_Email.DescId = zc_ObjectString_Client_Email()
          LEFT JOIN ObjectString AS ObjectString_CodeDB
                                 ON ObjectString_CodeDB.ObjectId = Object_Client.Id
                                AND ObjectString_CodeDB.DescId = zc_ObjectString_Client_CodeDB()
          LEFT JOIN ObjectString AS ObjectString_TaxNumber
                                 ON ObjectString_TaxNumber.ObjectId = Object_Client.Id
                                AND ObjectString_TaxNumber.DescId = zc_ObjectString_Client_TaxNumber()

          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                ON ObjectFloat_DiscountTax.ObjectId = Object_Client.Id
                               AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()  
          LEFT JOIN ObjectFloat AS ObjectFloat_DayCalendar
                                ON ObjectFloat_DayCalendar.ObjectId = Object_Client.Id
                               AND ObjectFloat_DayCalendar.DescId = zc_ObjectFloat_Client_DayCalendar() 
          LEFT JOIN ObjectFloat AS ObjectFloat_Bank
                                ON ObjectFloat_Bank.ObjectId = Object_Client.Id
                               AND ObjectFloat_Bank.DescId = zc_ObjectFloat_Client_Bank() 

          LEFT JOIN ObjectLink AS ObjectLink_PLZ
                               ON ObjectLink_PLZ.ObjectId = Object_Client.Id
                              AND ObjectLink_PLZ.DescId = zc_ObjectLink_Client_PLZ()
          LEFT JOIN Object AS Object_PLZ ON Object_PLZ.Id = ObjectLink_PLZ.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Bank
                               ON ObjectLink_Bank.ObjectId = Object_Client.Id
                              AND ObjectLink_Bank.DescId = zc_ObjectLink_Client_Bank()
          LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Bank.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                               ON ObjectLink_InfoMoney.ObjectId = Object_Client.Id
                              AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Client_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_InfoMoney.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = Object_Client.Id
                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId 

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                               AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_Client.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_Client.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_Client.DescId = zc_Object_Client()
         AND (Object_Client.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
04.01.21          *
22.10.20          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Client (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())