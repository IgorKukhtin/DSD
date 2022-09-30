-- Function: gpSelect_ObjectHistory_JuridicalDetails ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_JuridicalDetails (Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_JuridicalDetails(
    IN inJuridicalId        Integer   , -- Юр.лицо
    IN inFullName           TVarChar  , -- Название
    IN inOKPO               TVarChar  , -- ОКПО
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, BankName TVarChar, BankId Integer,
               Name TVarChar, FullName TVarChar, JuridicalAddress TVarChar, OKPO TVarChar, INN TVarChar,
               NumberVAT TVarChar, AccounterName TVarChar, MainName TVarChar,
               BankAccount TVarChar, Phone TVarChar, InvNumberBranch TVarChar)
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY
       WITH ObjectHistory_JuridicalDetails AS
                        (SELECT * FROM ObjectHistory
                          WHERE ObjectHistory.ObjectId = inJuridicalId
                            AND ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails())
       SELECT
             ObjectHistory_JuridicalDetails.Id                                              AS Id
           , COALESCE(ObjectHistory_JuridicalDetails.StartDate, Empty.StartDate)            AS StartDate
           , Object_Bank.ValueData                                                          AS BankName
           , Object_Bank.Id                                                                 AS BankId
           , ObjectHistoryString_JuridicalDetails_Name.ValueData                            AS Name
           , COALESCE(ObjectHistoryString_JuridicalDetails_FullName.ValueData, CASE WHEN inJuridicalId = 0 THEN 'ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ Фізична особа-підприємець' ELSE inFullName END) :: TVarChar AS FullName
           , ObjectHistoryString_JuridicalDetails_JuridicalAddress.ValueData                AS JuridicalAddress
           , COALESCE(ObjectHistoryString_JuridicalDetails_OKPO.ValueData, inOKPO)          AS OKPO
           , ObjectHistoryString_JuridicalDetails_INN.ValueData                             AS INN
           , ObjectHistoryString_JuridicalDetails_NumberVAT.ValueData                       AS NumberVAT
           , ObjectHistoryString_JuridicalDetails_AccounterName.ValueData                   AS AccounterName
           , ObjectHistoryString_JuridicalDetails_MainName.ValueData                        AS MainName
           , ObjectHistoryString_JuridicalDetails_BankAccount.ValueData                     AS BankAccount
           , ObjectHistoryString_JuridicalDetails_Phone.ValueData                           AS Phone
           , ObjectHistoryString_JuridicalDetails_InvNumberBranch.ValueData                 AS InvNumberBranch

       FROM ObjectHistory_JuridicalDetails
  FULL JOIN (SELECT zc_DateStart() AS StartDate, inJuridicalId AS ObjectId ) AS Empty
         ON Empty.ObjectId = ObjectHistory_JuridicalDetails.ObjectID

  LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_JuridicalDetails_Bank
         ON ObjectHistoryLink_JuridicalDetails_Bank.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryLink_JuridicalDetails_Bank.DescId = zc_ObjectHistoryLink_JuridicalDetails_Bank()
  LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectHistoryLink_JuridicalDetails_Bank.ObjectId

  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Name
                                ON ObjectHistoryString_JuridicalDetails_Name.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                               AND ObjectHistoryString_JuridicalDetails_Name.DescId = zc_ObjectHistoryString_JuridicalDetails_Name()

  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_FullName
         ON ObjectHistoryString_JuridicalDetails_FullName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_FullName.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_JuridicalAddress
         ON ObjectHistoryString_JuridicalDetails_JuridicalAddress.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_JuridicalAddress.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
         ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_INN
         ON ObjectHistoryString_JuridicalDetails_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_NumberVAT
         ON ObjectHistoryString_JuridicalDetails_NumberVAT.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_NumberVAT.DescId = zc_ObjectHistoryString_JuridicalDetails_NumberVAT()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_AccounterName
         ON ObjectHistoryString_JuridicalDetails_AccounterName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_AccounterName.DescId = zc_ObjectHistoryString_JuridicalDetails_AccounterName()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_MainName
         ON ObjectHistoryString_JuridicalDetails_MainName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_MainName.DescId = zc_ObjectHistoryString_JuridicalDetails_MainName()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_BankAccount
         ON ObjectHistoryString_JuridicalDetails_BankAccount.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_BankAccount.DescId = zc_ObjectHistoryString_JuridicalDetails_BankAccount()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Phone
         ON ObjectHistoryString_JuridicalDetails_Phone.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_Phone.DescId = zc_ObjectHistoryString_JuridicalDetails_Phone()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_InvNumberBranch
         ON ObjectHistoryString_JuridicalDetails_InvNumberBranch.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_InvNumberBranch.DescId = zc_ObjectHistoryString_JuridicalDetails_InvNumberBranch()
;



END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_JuridicalDetails (Integer, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.09.22         *
 07.04.16         * add InvNumberBranch
 26.11.15         * add MainName
 12.02.14                                                       * add phone
 22.01.14                        *
 28.11.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_JuridicalDetails (zc_PriceList_ProductionSeparate(), '', '', zfCalc_UserAdmin())
