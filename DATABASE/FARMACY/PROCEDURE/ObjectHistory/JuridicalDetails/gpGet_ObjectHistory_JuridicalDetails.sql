-- Function: gpGet_ObjectHistory_JuridicalDetails ()

DROP FUNCTION IF EXISTS gpGet_ObjectHistory_JuridicalDetails (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_JuridicalDetails(
    IN inJuridicalId        Integer   , -- Юр.лицо
    IN inOperDate           TDateTime , -- Дата Истории
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, 
               FullName TVarChar, JuridicalAddress TVarChar, OKPO TVarChar, INN TVarChar,
               NumberVAT TVarChar, AccounterName TVarChar, BankAccount TVarChar, Phone TVarChar,
               MainName TVarChar, MainName_Cut TVarChar,
               Reestr TVarChar, Decision TVarChar, License TVarChar, 
               DecisionDate TDateTime
               )
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY
       WITH ObjectHistory_JuridicalDetails AS
                        (SELECT * FROM ObjectHistory
                          WHERE ObjectHistory.ObjectId = inJuridicalId
                            AND ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
                            AND inOperDate >= ObjectHistory.StartDate AND inOperDate < ObjectHistory.EndDate)
       SELECT
             ObjectHistory_JuridicalDetails.Id                                              AS Id
           , COALESCE(ObjectHistory_JuridicalDetails.StartDate, Empty.StartDate)            AS StartDate

           , ObjectHistoryString_JuridicalDetails_FullName.ValueData                        AS FullName
           , ObjectHistoryString_JuridicalDetails_JuridicalAddress.ValueData                AS JuridicalAddress
           , ObjectHistoryString_JuridicalDetails_OKPO.ValueData                            AS OKPO
           , ObjectHistoryString_JuridicalDetails_INN.ValueData                             AS INN
           , ObjectHistoryString_JuridicalDetails_NumberVAT.ValueData                       AS NumberVAT
           , ObjectHistoryString_JuridicalDetails_AccounterName.ValueData                   AS AccounterName
           , ObjectHistoryString_JuridicalDetails_BankAccount.ValueData                     AS BankAccount
           , ObjectHistoryString_JuridicalDetails_Phone.ValueData                           AS Phone

           , ObjectHistoryString_JuridicalDetails_MainName.ValueData                        AS MainName
           , ObjectHistoryString_JuridicalDetails_MainName_Cut.ValueData                    AS MainName_Cut
           , ObjectHistoryString_JuridicalDetails_Reestr.ValueData                          AS Reestr
           , ObjectHistoryString_JuridicalDetails_Decision.ValueData                        AS Decision
           , ObjectHistoryString_JuridicalDetails_License.ValueData                         AS License
           , ObjectHistoryDate_JuridicalDetails_Decision.ValueData                          AS DecisionDate

       FROM ObjectHistory_JuridicalDetails
  FULL JOIN (SELECT zc_DateStart() AS StartDate, inJuridicalId AS ObjectId ) AS Empty
         ON Empty.ObjectId = ObjectHistory_JuridicalDetails.ObjectID
 
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
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_BankAccount
         ON ObjectHistoryString_JuridicalDetails_BankAccount.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_BankAccount.DescId = zc_ObjectHistoryString_JuridicalDetails_BankAccount()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Phone
         ON ObjectHistoryString_JuridicalDetails_Phone.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_Phone.DescId = zc_ObjectHistoryString_JuridicalDetails_Phone()

  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_MainName
         ON ObjectHistoryString_JuridicalDetails_MainName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_MainName.DescId = zc_ObjectHistoryString_JuridicalDetails_MainName()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_MainName_Cut
         ON ObjectHistoryString_JuridicalDetails_MainName_Cut.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_MainName_Cut.DescId = zc_ObjectHistoryString_JuridicalDetails_MainName_Cut()

  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Reestr
         ON ObjectHistoryString_JuridicalDetails_Reestr.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_Reestr.DescId = zc_ObjectHistoryString_JuridicalDetails_Reestr()
  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Decision
         ON ObjectHistoryString_JuridicalDetails_Decision.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_Decision.DescId = zc_ObjectHistoryString_JuridicalDetails_Decision()

  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_License
         ON ObjectHistoryString_JuridicalDetails_License.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryString_JuridicalDetails_License.DescId = zc_ObjectHistoryString_JuridicalDetails_License()

  LEFT JOIN ObjectHistoryDate AS ObjectHistoryDate_JuridicalDetails_Decision
         ON ObjectHistoryDate_JuridicalDetails_Decision.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
        AND ObjectHistoryDate_JuridicalDetails_Decision.DescId = zc_ObjectHistoryDate_JuridicalDetails_Decision()
;


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_ObjectHistory_JuridicalDetails (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.03.17         *
 04.07.14         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_JuridicalDetails (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP)
