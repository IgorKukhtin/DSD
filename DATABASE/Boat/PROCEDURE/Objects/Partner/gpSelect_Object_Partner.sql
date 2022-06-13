-- Торговая марка

DROP FUNCTION IF EXISTS gpSelect_Object_Partner (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner(
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
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , DiscountTax TFloat
             , DayCalendar TFloat
             , DayBank     TFloat
             , DatePriceList TDateTime
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       -- результат
       SELECT
             Object_Partner.Id               AS Id
           , Object_Partner.ObjectCode       AS Code
           , COALESCE (Object_Partner.ValueData,'')::TVarChar        AS Name
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
           --, Object_PLZ.ValueData            AS PLZName
           , TRIM (COALESCE (Object_PLZ.ValueData,'')||' '||ObjectString_City.ValueData||' '||Object_Country.ValueData) ::TVarChar AS PLZName

           , Object_TaxKind.Id               AS TaxKindId
           , Object_TaxKind.ValueData        AS TaxKindName
           , ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value

           , Object_PaidKind.Id              AS PaidKindId
           , Object_PaidKind.ValueData       AS PaidKindName

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

           , ObjectFloat_DiscountTax.ValueData ::TFloat AS DiscountTax
           , ObjectFloat_DayCalendar.ValueData ::TFloat AS DayCalendar
           , ObjectFloat_Bank.ValueData        ::TFloat AS DayBank

           , ObjectDate_PriceList.ValueData ::TDateTime AS DatePriceList

           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_Partner.isErased         AS isErased
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
          LEFT JOIN ObjectString AS ObjectString_TaxNumber
                                 ON ObjectString_TaxNumber.ObjectId = Object_Partner.Id
                                AND ObjectString_TaxNumber.DescId = zc_ObjectString_Partner_TaxNumber()
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
          LEFT JOIN ObjectString AS ObjectString_City
                                 ON ObjectString_City.ObjectId = Object_PLZ.Id
                                AND ObjectString_City.DescId = zc_ObjectString_PLZ_City()
          LEFT JOIN ObjectLink AS ObjectLink_Country
                               ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                              AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
          LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Country.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Bank
                               ON ObjectLink_Bank.ObjectId = Object_Partner.Id
                              AND ObjectLink_Bank.DescId = zc_ObjectLink_Partner_Bank()
          LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Bank.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                               ON ObjectLink_InfoMoney.ObjectId = Object_Partner.Id
                              AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Partner_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_InfoMoney.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = Object_Partner.Id
                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Partner_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PaidKind
                               ON ObjectLink_PaidKind.ObjectId = Object_Partner.Id
                              AND ObjectLink_PaidKind.DescId = zc_ObjectLink_Partner_PaidKind()
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_PaidKind.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id 
                               AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value() 

          LEFT JOIN ObjectDate AS ObjectDate_PriceList
                               ON ObjectDate_PriceList.ObjectId = Object_Partner.Id
                              AND ObjectDate_PriceList.DescId = zc_ObjectDate_Partner_PriceList()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_Partner.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_Partner.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_Partner.DescId = zc_Object_Partner()
         AND (Object_Partner.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.21         *
 02.02.21         *
 09.11.20         *
 22.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Partner (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())