-- Function: gpSelect_Object_Unit_ExportPriceForLiki24()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_ExportPriceForLiki24(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_ExportPriceForLiki24(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Name TVarChar
             , Address TVarChar
             , Phones TVarChar
             , WorkingTime TVarChar
             , AllDay TVarChar
             , Latitude TVarChar
             , Longitude TVarChar
             , CompanyId TVarChar
             , CompanyName TVarChar
             , Email TVarChar
             , City TVarChar) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

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
           Object_Unit_View.ID
         , REPLACE(Object_Unit_View.Name, ',', ';')::TVarChar
         , REPLACE(ObjectString_Unit_Address.ValueData, ',', ';')::TVarChar
         , REPLACE(ObjectString_Unit_Phone.ValueData, ',', ';')::TVarChar                    AS Phone
         , REPLACE((CASE WHEN COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00'
                THEN 'Пн-Пт '||LEFT ((ObjectDate_MondayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_MondayEnd.ValueData::Time)::TVarChar,5)||'; '
                ELSE ''
           END||'' ||
           CASE WHEN COALESCE(ObjectDate_SaturdayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SaturdayEnd.ValueData ::Time,'00:00') <> '00:00'
                THEN 'Сб '||LEFT ((ObjectDate_SaturdayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SaturdayEnd.ValueData::Time)::TVarChar,5)||'; '
                ELSE ''
           END||''||
           CASE WHEN COALESCE(ObjectDate_SundayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SundayEnd.ValueData ::Time,'00:00') <> '00:00'
                THEN 'Вс '||LEFT ((ObjectDate_SundayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SundayEnd.ValueData::Time)::TVarChar,5)
                ELSE ''
           END), ',', ';')::TVarChar AS TimeWork
         , '':: TVarChar AS AllDay
         , REPLACE(ObjectString_Latitude.ValueData, ',', ';')::TVarChar        AS Latitude
         , REPLACE(ObjectString_Longitude.ValueData, ',', ';')::TVarChar       AS Longitude
         , REPLACE(tmpJuridicalDetails.OKPO, ',', ';')::TVarChar
         , REPLACE(Object_Juridical.ValueData, ',', ';')::TVarChar
         , REPLACE(ObjectString_EMail.ValueData, ',', ';')::TVarChar                         AS EMail_Member
         , REPLACE(Object_Area.ValueData, ',', ';')::TVarChar                                AS AreaName
     FROM Object_Unit_View AS Object_Unit_View

          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit_View.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
          INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                               AND ObjectLink_Juridical_Retail.ChildObjectId = 4
          INNER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

          INNER JOIN ObjectString AS ObjectString_Unit_Address
                                  ON ObjectString_Unit_Address.ObjectId  = Object_Unit_View.Id
                                 AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

          LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                                 ON ObjectString_Unit_Phone.ObjectId = Object_Unit_View.Id
                                AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()

          LEFT JOIN ObjectDate AS ObjectDate_MondayStart
                               ON ObjectDate_MondayStart.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_MondayStart.DescId = zc_ObjectDate_Unit_MondayStart()
          LEFT JOIN ObjectDate AS ObjectDate_MondayEnd
                               ON ObjectDate_MondayEnd.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_MondayEnd.DescId = zc_ObjectDate_Unit_MondayEnd()
          LEFT JOIN ObjectDate AS ObjectDate_SaturdayStart
                               ON ObjectDate_SaturdayStart.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_SaturdayStart.DescId = zc_ObjectDate_Unit_SaturdayStart()
          LEFT JOIN ObjectDate AS ObjectDate_SaturdayEnd
                               ON ObjectDate_SaturdayEnd.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_SaturdayEnd.DescId = zc_ObjectDate_Unit_SaturdayEnd()
          LEFT JOIN ObjectDate AS ObjectDate_SundayStart
                               ON ObjectDate_SundayStart.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_SundayStart.DescId = zc_ObjectDate_Unit_SundayStart()
          LEFT JOIN ObjectDate AS ObjectDate_SundayEnd
                               ON ObjectDate_SundayEnd.ObjectId = Object_Unit_View.Id
                              AND ObjectDate_SundayEnd.DescId = zc_ObjectDate_Unit_SundayEnd()

          LEFT JOIN ObjectString AS ObjectString_Latitude
                                 ON ObjectString_Latitude.ObjectId = Object_Unit_View.Id
                                AND ObjectString_Latitude.DescId = zc_ObjectString_Unit_Latitude()
          LEFT JOIN ObjectString AS ObjectString_Longitude
                                 ON ObjectString_Longitude.ObjectId = Object_Unit_View.Id
                                AND ObjectString_Longitude.DescId = zc_ObjectString_Unit_Longitude()
          LEFT JOIN ObjectString AS ObjectString_EMail
                                 ON ObjectString_EMail.ObjectId = Object_Unit_View.Id
                                AND ObjectString_EMail.DescId = zc_ObjectString_Member_EMail()

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                               ON ObjectLink_Unit_Area.ObjectId = Object_Unit_View.Id
                              AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

          LEFT JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalId = Object_Juridical.Id

     WHERE Object_Unit_View.isErased = False
       AND Object_Unit_View.Name NOT ILIKE '%закрыта%'
       AND COALESCE (ObjectString_Unit_Address.ValueData, '') <> ''
       AND Object_Unit_View.Id <> 11460971
     ORDER BY Object_Unit_View.Id;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В
 25.03.20                                                                     *

*/

-- тест
-- SELECT * FROM Object WHERE DescId = zc_Object_Unit();
-- SELECT * FROM gpSelect_Object_Unit_ExportPriceForLiki24 ('3')