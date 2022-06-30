-- Function: gpSelect_Object_Juridical()

--DROP FUNCTION IF EXISTS gpSelect_Object_Juridical(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Juridical(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical(
    IN inisShowErased  Boolean ,     -- 
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, --OKPO TVarChar,
               RetailId Integer, RetailName TVarChar,
               isCorporate boolean,
               Percent TFloat, PayOrder TFloat,
               isLoadBarcode Boolean,
               isDeferred Boolean,
               isUseReprice Boolean, isPriorityReprice Boolean,
               CBName TVarChar, CBMFO TVarChar, CBAccount TVarChar, CBPurposePayment TVarChar,
               ExpirationDateMonth Integer,
               isChangeExpirationDate Boolean, 
               isErased boolean,
               
               StartDate TDateTime, 
               FullName TVarChar, JuridicalAddress TVarChar, OKPO TVarChar, INN TVarChar,
               NumberVAT TVarChar, AccounterName TVarChar, BankAccount TVarChar, Phone TVarChar,
               MainName TVarChar, MainName_Cut TVarChar,
               Reestr TVarChar, Decision TVarChar, License TVarChar, 
               DecisionDate TDateTime) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

   RETURN QUERY

   WITH tmpObjectHistory AS (SELECT *
                             FROM ObjectHistory
                             WHERE ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
                               AND ObjectHistory.enddate::timestamp with time zone = zc_dateend()::timestamp with time zone
                             )
      , tmpJuridicalDetails AS (SELECT ObjectHistory_JuridicalDetails.ObjectId                                        AS JuridicalId
                                  , COALESCE(ObjectHistory_JuridicalDetails.StartDate, zc_DateStart())             AS StartDate
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
                       
                             FROM tmpObjectHistory AS ObjectHistory_JuridicalDetails
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
                             )
        
        
       SELECT 
             Object_Juridical.Id                 AS Id
           , Object_Juridical.ObjectCode         AS Code
           , Object_Juridical.ValueData          AS Name
           --, ObjectHistory_JuridicalDetails_View.OKPO

           , Object_Retail.Id                    AS RetailId
           , Object_Retail.ValueData             AS RetailName 

           , ObjectBoolean_isCorporate.ValueData AS isCorporate
           , ObjectFloat_Percent.ValueData       AS Percent
           , ObjectFloat_PayOrder.ValueData      AS PayOrder
           
           , COALESCE (ObjectBoolean_LoadBarcode.ValueData, FALSE)     AS isLoadBarcode
           , COALESCE (ObjectBoolean_Deferred.ValueData, FALSE)        AS isDeferred
           , COALESCE (ObjectBoolean_UseReprice.ValueData, FALSE)      AS isUseReprice
           , COALESCE (ObjectBoolean_PriorityReprice.ValueData, FALSE) AS isPriorityReprice
           
           , ObjectString_CBName.ValueData             AS CBName 
           , ObjectString_CBMFO.ValueData              AS CBMFO
           , ObjectString_CBAccount.ValueData          AS CBAccount
           , ObjectString_CBPurposePayment.ValueData   AS CBPurposePayment
           , ObjectFloat_ExpirationDateMonth.ValueData::Integer AS ExpirationDateMonth
           , COALESCE (ObjectBoolean_ChangeExpirationDate.ValueData, FALSE)          AS isChangeExpirationDate

           , Object_Juridical.isErased           AS isErased
           
           , tmpJuridicalDetails.StartDate
           , tmpJuridicalDetails.FullName
           , tmpJuridicalDetails.JuridicalAddress
           , tmpJuridicalDetails.OKPO
           , tmpJuridicalDetails.INN
           , tmpJuridicalDetails.NumberVAT
           , tmpJuridicalDetails.AccounterName
           , tmpJuridicalDetails.BankAccount
           , tmpJuridicalDetails.Phone
 
           , tmpJuridicalDetails.MainName    ::TVarChar
           , tmpJuridicalDetails.MainName_Cut
           , tmpJuridicalDetails.Reestr
           , tmpJuridicalDetails.Decision
           , tmpJuridicalDetails.License
           , tmpJuridicalDetails.DecisionDate
           
       FROM Object AS Object_Juridical

           LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                 ON ObjectFloat_Percent.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

           LEFT JOIN ObjectFloat AS ObjectFloat_ExpirationDateMonth
                                 ON ObjectFloat_ExpirationDateMonth.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_ExpirationDateMonth.DescId = zc_ObjectFloat_Juridical_ExpirationDateMonth()

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                   ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
           LEFT JOIN ObjectFloat AS ObjectFloat_PayOrder
                                 ON ObjectFloat_PayOrder.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_PayOrder.DescId = zc_ObjectFloat_Juridical_PayOrder()
           --LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

           LEFT JOIN ObjectBoolean AS ObjectBoolean_LoadBarcode 
                                   ON ObjectBoolean_LoadBarcode.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_LoadBarcode.DescId = zc_ObjectBoolean_Juridical_LoadBarcode()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Deferred
                                   ON ObjectBoolean_Deferred.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_Deferred.DescId = zc_ObjectBoolean_Juridical_Deferred()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_UseReprice
                                   ON ObjectBoolean_UseReprice.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_UseReprice.DescId = zc_ObjectBoolean_Juridical_UseReprice()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PriorityReprice
                                   ON ObjectBoolean_PriorityReprice.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_PriorityReprice.DescId = zc_ObjectBoolean_Juridical_PriorityReprice()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_ChangeExpirationDate
                                   ON ObjectBoolean_ChangeExpirationDate.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_ChangeExpirationDate.DescId = zc_ObjectBoolean_Juridical_ChangeExpirationDate()

           LEFT JOIN ObjectString AS ObjectString_CBName
                                  ON ObjectString_CBName.ObjectId = Object_Juridical.Id
                                 AND ObjectString_CBName.DescId = zc_ObjectString_Juridical_CBName()

           LEFT JOIN ObjectString AS ObjectString_CBMFO
                                  ON ObjectString_CBMFO.ObjectId = Object_Juridical.Id
                                 AND ObjectString_CBMFO.DescId = zc_ObjectString_Juridical_CBMFO()

           LEFT JOIN ObjectString AS ObjectString_CBAccount
                                  ON ObjectString_CBAccount.ObjectId = Object_Juridical.Id
                                 AND ObjectString_CBAccount.DescId = zc_ObjectString_Juridical_CBAccount()

           LEFT JOIN ObjectString AS ObjectString_CBPurposePayment
                                  ON ObjectString_CBPurposePayment.ObjectId = Object_Juridical.Id
                                 AND ObjectString_CBPurposePayment.DescId = zc_ObjectString_Juridical_CBPurposePayment()

           LEFT JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalId = Object_Juridical.Id

       WHERE Object_Juridical.DescId = zc_Object_Juridical()
         AND (Object_Juridical.isErased = FALSE OR inisShowErased = TRUE);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.  Ярошенко Р.Ф.  Шаблий О.В.
 06.09.19                                                                                      * 
 20.03.19         * add JuridicalDetails
 22.02.18         * dell OrderSumm, OrderSummComment, OrderTime
 17.08.17         * add isDeferred
 27.06.17                                                                        * isLoadBarcode
 14.01.17         * 
 02.12.15                                                         * PayOrder
 01.07.14         *

*/

-- тест
-- 
SELECT * FROM gpSelect_Object_Juridical(False, '2')