-- Function: gpSelect_Object_Clients_effie

DROP FUNCTION IF EXISTS gpSelect_Object_Clients_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Clients_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId           TVarChar   -- Идентификатор канала продаж
             , Name            TVarChar   -- Название канала продаж
             , legalAddress    TVarChar   -- Юр. адрес клиента
             , streetAddress   TVarChar   -- Физ. адрес клиента
             , regNumb         TVarChar   -- Регистрационный номер
             , regDate         TVarChar   -- Дата регистрации
             , subjCode        TVarChar   -- Код клиента
             , bankInfo        TVarChar   -- Банковские реквизиты клиента
             , corporationCode TVarChar   -- Код корпорации
             , isDeleted       Boolean    -- Признак активности записи: 0 = активна / 1 = не активна
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
             WITH tmpPartner AS (-- если vbPersonalId - Сотрудник (торговый)
                                 SELECT OL.ObjectId AS PartnerId
                                 FROM ObjectLink AS OL
                                 WHERE OL.ChildObjectId > 0
                                   AND OL.DescId        = zc_ObjectLink_Partner_PersonalTrade()
                                UNION
                                 -- если vbPersonalId - Сотрудник (супервайзер)
                                 SELECT OL.ObjectId AS PartnerId
                                 FROM ObjectLink AS OL
                                 WHERE OL.ChildObjectId > 0
                                   AND OL.DescId        = zc_ObjectLink_Partner_Personal()
                                UNION
                                 -- если vbPersonalId - Сотрудник (мерчандайзер)
                                 SELECT OL.ObjectId AS PartnerId
                                 FROM ObjectLink AS OL
                                 WHERE OL.ChildObjectId > 0
                                   AND OL.DescId        = zc_ObjectLink_Partner_PersonalMerch()
                                )
     SELECT Object_Partner.Id                             ::TVarChar AS extId
          , TRIM (Object_Partner.ValueData)               ::TVarChar AS Name
          , ObjectHistoryString_JuridicalDetails_JuridicalAddress.ValueData  ::TVarChar AS legalAddress
          , ObjectString_Address.ValueData                                   ::TVarChar AS streetAddress 
          , ''                                            ::TVarChar AS regNumb
          , ''                                            ::TVarChar AS regDate
          , Object_Partner.ObjectCode                     ::TVarChar AS subjCode
          , ''                                            ::TVarChar AS bankInfo 
          , ''                                            ::TVarChar AS corporationCode
          , Object_Partner.isErased                       ::Boolean  AS isDeleted
     FROM Object AS Object_Partner
          INNER JOIN tmpPartner ON tmpPartner.PartnerId = Object_Partner.Id

          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = Object_Partner.Id
                                AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN ObjectHistory AS ObjectHistory_JuridicalDetails 
                                  ON ObjectHistory_JuridicalDetails.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails()
                                 AND CURRENT_DATE >= ObjectHistory_JuridicalDetails.StartDate AND CURRENT_DATE < ObjectHistory_JuridicalDetails.EndDate  
          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_JuridicalAddress
                                        ON ObjectHistoryString_JuridicalDetails_JuridicalAddress.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                       AND ObjectHistoryString_JuridicalDetails_JuridicalAddress.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()
     WHERE Object_Partner.DescId = zc_Object_Partner()
       AND Object_Partner.isErased = FALSE
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Clients_effie (zfCalc_UserAdmin()::TVarChar);
