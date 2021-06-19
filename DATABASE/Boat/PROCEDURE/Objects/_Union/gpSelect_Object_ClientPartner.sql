-- Function: gpSelect_Object_ClientPartner()

DROP FUNCTION IF EXISTS gpSelect_Object_ClientPartner (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ClientPartner(
    IN inisShowAll         Boolean,     -- показать все
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DescId Integer, DescName TVarChar
             , DayCalendar TFloat
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , TaxKind_Value TFloat
             , PaidKindId Integer, PaidKindName TVarChar
             , isErased Boolean
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
       
        SELECT 
            Object_ClientPartner.Id
          , Object_ClientPartner.ObjectCode AS Code
          , Object_ClientPartner.ValueData  AS Name
          , Object_ClientPartner.DescId     AS DescId
          , ObjectDesc.ItemName             AS DescName
          , ObjectFloat_DayCalendar.ValueData ::TFloat AS DayCalendar
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
          , ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value
          , Object_PaidKind.Id              AS PaidKindId
          , Object_PaidKind.ValueData       AS PaidKindName
          , Object_ClientPartner.isErased
        FROM Object AS Object_ClientPartner
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_ClientPartner.DescId

            LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                 ON ObjectLink_InfoMoney.ObjectId = Object_ClientPartner.Id
                                AND ObjectLink_InfoMoney.DescId IN (zc_ObjectLink_Partner_InfoMoney(), zc_ObjectLink_Client_InfoMoney())
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_InfoMoney.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_DayCalendar
                                  ON ObjectFloat_DayCalendar.ObjectId = Object_ClientPartner.Id
                                 AND ObjectFloat_DayCalendar.DescId IN (zc_ObjectFloat_Partner_DayCalendar(),zc_ObjectFloat_Client_DayCalendar())

            LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                 ON ObjectLink_TaxKind.ObjectId = Object_ClientPartner.Id
                                AND ObjectLink_TaxKind.DescId IN (zc_ObjectLink_Client_TaxKind(),zc_ObjectLink_Partner_TaxKind())
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId 
  
            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                  ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                 AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

          LEFT JOIN ObjectLink AS ObjectLink_PaidKind
                               ON ObjectLink_PaidKind.ObjectId = Object_ClientPartner.Id
                              AND ObjectLink_PaidKind.DescId IN (zc_ObjectLink_Client_PaidKind(),zc_ObjectLink_Partner_PaidKind())
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_PaidKind.ChildObjectId

        WHERE Object_ClientPartner.DescId in (zc_Object_Partner(),zc_Object_Client())
          AND (Object_ClientPartner.isErased = FALSE OR inisShowAll = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.21         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_ClientPartner (inisShowAll := FALSE, inSession := zfCalc_UserAdmin())
