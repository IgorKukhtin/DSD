--

DROP FUNCTION IF EXISTS gpGet_Object_MoneyPlace (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MoneyPlace(
    IN inMovementId  Integer,
    IN inId          Integer,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , IBAN TVarChar, Street TVarChar, Street_add TVarChar
             , TaxNumber TVarChar
             , PLZId Integer, PLZName TVarChar
             , CityName TVarChar, CountryId Integer, CountryName TVarChar   --город страна
             , TaxKindId Integer, TaxKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
              )
AS
$BODY$
 DECLARE vbDescId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Client());

   --определяем в какой справочник обновлять информацию
   vbDescId := (SELECT Object.DescId FROM Object WHERE Object.Id = inId);

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , 0   AS Code
           , MovementString_7.ValueData :: TVarChar AS Name
           , MovementString_8.ValueData :: TVarChar AS IBAN
           , '' :: TVarChar           AS Street
           , '' :: TVarChar           AS Street_add
           , '' :: TVarChar           AS TaxNumber
           , 0                        AS PLZId
           , '' :: TVarChar           AS PLZName
           , '' :: TVarChar           AS CityName
           , 0                        AS CountryId
           , '' :: TVarChar           AS CountryName
           , Object_TaxKind.Id         AS TaxKindId
           , Object_TaxKind.ValueData  AS TaxKindName

           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyName_all

        FROM Object_InfoMoney_View
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm()
             LEFT JOIN Object AS Object_TaxKind  ON Object_TaxKind.Id = zc_TaxKind_Basis()

             LEFT JOIN MovementString AS MovementString_7
                                      ON MovementString_7.MovementId = inMovementId
                                     AND MovementString_7.DescId = zc_MovementString_7()
             LEFT JOIN MovementString AS MovementString_8
                                      ON MovementString_8.MovementId = inMovementId
                                     AND MovementString_8.DescId = zc_MovementString_8()
        WHERE Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_10101()
       ;
   ELSE
   RETURN QUERY
       SELECT
             Object_Client.Id                AS Id
           , Object_Client.ObjectCode        AS Code
           , Object_Client.ValueData         AS Name
           , ObjectString_IBAN.ValueData     AS IBAN
           , ObjectString_Street.ValueData   AS Street
           , COALESCE (ObjectString_Street_add.ValueData,'')::TVarChar AS Street_add
           , ObjectString_TaxNumber.ValueData AS TaxNumber
           , Object_PLZ.Id                   AS PLZId
           , Object_PLZ.ValueData            AS PLZName
           , ObjectString_City.ValueData     AS CityName
           , Object_Country.Id               AS CountryId
           , Object_Country.ValueData        AS CountryName
           , Object_TaxKind.Id               AS TaxKindId
           , Object_TaxKind.ValueData        AS TaxKindName
           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyName_all

       FROM Object AS Object_Client
          LEFT JOIN ObjectString AS ObjectString_IBAN
                                 ON ObjectString_IBAN.ObjectId = Object_Client.Id
                                AND ObjectString_IBAN.DescId = zc_ObjectString_Client_IBAN()
          LEFT JOIN ObjectString AS ObjectString_Street
                                 ON ObjectString_Street.ObjectId = Object_Client.Id
                                AND ObjectString_Street.DescId = zc_ObjectString_Client_Street()
          LEFT JOIN ObjectString AS ObjectString_Street_add
                                 ON ObjectString_Street_add.ObjectId = Object_Client.Id
                                AND ObjectString_Street_add.DescId = zc_ObjectString_Client_Street_add()
          LEFT JOIN ObjectString AS ObjectString_TaxNumber
                                 ON ObjectString_TaxNumber.ObjectId = Object_Client.Id
                                AND ObjectString_TaxNumber.DescId = zc_ObjectString_Client_TaxNumber()
          LEFT JOIN ObjectLink AS ObjectLink_PLZ
                               ON ObjectLink_PLZ.ObjectId = Object_Client.Id
                              AND ObjectLink_PLZ.DescId = zc_ObjectLink_Client_PLZ()
          LEFT JOIN Object AS Object_PLZ ON Object_PLZ.Id = ObjectLink_PLZ.ChildObjectId
          LEFT JOIN ObjectString AS ObjectString_City
                                 ON ObjectString_City.ObjectId = Object_PLZ.Id
                                AND ObjectString_City.DescId = zc_ObjectString_PLZ_City()
          LEFT JOIN ObjectLink AS ObjectLink_Country
                               ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                              AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
          LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Country.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = Object_Client.Id
                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                               ON ObjectLink_InfoMoney.ObjectId = Object_Client.Id
                              AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Client_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_InfoMoney.ChildObjectId

       WHERE Object_Client.Id = inId
         AND vbDescId = zc_Object_Client()

      UNION
              SELECT
             Object_Partner.Id               AS Id
           , Object_Partner.ObjectCode       AS Code
           , Object_Partner.ValueData        AS Name
           , ObjectString_IBAN.ValueData     AS IBAN
           , ObjectString_Street.ValueData   AS Street
           , ObjectString_Street_add.ValueData   AS Street_add
           , ObjectString_TaxNumber.ValueData AS TaxNumber
           , Object_PLZ.Id                   AS PLZId
           , Object_PLZ.ValueData            AS PLZName
           , ObjectString_City.ValueData     AS CityName
           , Object_Country.Id               AS CountryId
           , Object_Country.ValueData        AS CountryName
           , Object_TaxKind.Id               AS TaxKindId
           , Object_TaxKind.ValueData        AS TaxKindName

           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyName_all

       FROM Object AS Object_Partner
          LEFT JOIN ObjectString AS ObjectString_IBAN
                                 ON ObjectString_IBAN.ObjectId = Object_Partner.Id
                                AND ObjectString_IBAN.DescId = zc_ObjectString_Partner_IBAN()
          LEFT JOIN ObjectString AS ObjectString_Street
                                 ON ObjectString_Street.ObjectId = Object_Partner.Id
                                AND ObjectString_Street.DescId = zc_ObjectString_Partner_Street()
          LEFT JOIN ObjectString AS ObjectString_Street_add
                                 ON ObjectString_Street_add.ObjectId = Object_Partner.Id
                                AND ObjectString_Street_add.DescId = zc_ObjectString_Partner_Street_add()
          LEFT JOIN ObjectString AS ObjectString_TaxNumber
                                 ON ObjectString_TaxNumber.ObjectId = Object_Partner.Id
                                AND ObjectString_TaxNumber.DescId = zc_ObjectString_Partner_TaxNumber()
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
          LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = Object_Partner.Id
                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Partner_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                               ON ObjectLink_InfoMoney.ObjectId = Object_Partner.Id
                              AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Partner_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_InfoMoney.ChildObjectId

       WHERE Object_Partner.Id = inId
         AND vbDescId = zc_Object_Partner()
         ;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.02.24         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MoneyPlace (2295 , 0  ::integer,'2'::TVarChar)
