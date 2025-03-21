-- Function:  gpReport_Upload_YuriFarm_Unit()

DROP FUNCTION IF EXISTS gpReport_Upload_YuriFarm_Unit (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Upload_YuriFarm_Unit(
    IN inDate         TDateTime,  -- Операционный день
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (ID            Integer
             , JuridicalName TVarChar  -- Наименование юридического лица
             , UnitCode      Integer   -- Код аптеки
             , UnitName      TVarChar  -- Наименование склада - наименование аптеки в учетной системе компании Клиента
             , OKPO          TVarChar  -- ЕДРПОУ юр.лица, к которому принадлежит аптека
             , UnitAddress   TVarChar  -- Адрес аптеки
             , MorionCode    Integer   -- Код мориона
             , AccessKeyYF   TVarChar  -- Ключ ХО для отправки данных Юрия-Фарм
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
      vbUserId:= lpGetUserBySession (inSession);

      -- список аптек
      RETURN QUERY
      SELECT Object_Unit.ID
           , Object_Juridical.ValueData                          AS JuridicalName
           , Object_Unit.ObjectCode                              AS UnitCode
           , Object_Unit.ValueData                               AS UnitName
           , ObjectHistoryString_JuridicalDetails_OKPO.ValueData AS OKPO
           , ObjectString_Unit_Address.ValueData                 AS UnitAddress
           , ObjectFloat_MorionCode.ValueData::Integer          AS MorionCode
           , ObjectString_AccessKeyYF.ValueData                 AS AccessKeyYF
      FROM ObjectLink AS ObjectLink_Unit_Juridical
           JOIN ObjectLink AS ObjectLink_Juridical_Retail
                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           JOIN ObjectLink AS ObjectLink_Unit_Parent
                           ON ObjectLink_Unit_Parent.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                          AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                          AND ObjectLink_Unit_Parent.ChildObjectId IS NOT NULL
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Juridical.ObjectId
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
           LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                  ON ObjectString_Unit_Address.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                 AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
           LEFT JOIN ObjectHistory AS ObjectHistory_JuridicalDetails
                                   ON ObjectHistory_JuridicalDetails.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                  AND ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails()
                                  AND ObjectHistory_JuridicalDetails.StartDate <= inDate
                                  AND ObjectHistory_JuridicalDetails.EndDate > inDate
           LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                         ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
           LEFT JOIN ObjectFloat AS ObjectFloat_MorionCode
                                 ON ObjectFloat_MorionCode.ObjectId = Object_Unit.Id
                                AND ObjectFloat_MorionCode.DescId = zc_ObjectFloat_Unit_MorionCode()
           LEFT JOIN ObjectString AS ObjectString_AccessKeyYF
                                  ON ObjectString_AccessKeyYF.ObjectId = Object_Unit.Id 
                                 AND ObjectString_AccessKeyYF.DescId = zc_ObjectString_Unit_AccessKeyYF()
      WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        AND COALESCE (ObjectString_AccessKeyYF.ValueData, '') <> ''
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.11.19                                                       *

*/

-- тест
-- SELECT * FROM gpReport_Upload_YuriFarm_Unit (inDate:= '01.10.2019'::TDateTime, inSession:= zfCalc_UserAdmin())
