-- Function: gpSelect_Object_TT_effie

DROP FUNCTION IF EXISTS gpSelect_Object_TT_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TT_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId           TVarChar   -- Идентификатор канала продаж
             , Name            TVarChar   -- Название канала продаж
             , legalAddress    TVarChar   -- Юр. адрес клиента
             , streetAddress   TVarChar   -- Физ. адрес клиента
             , latitude        TVarChar   -- Широта
             , longitude       TVarChar   -- Довгота 
             , recurrence      Integer    -- Частота посещения торговой точки	
             , channelSaleId   TVarChar   -- Идентификатор канала продаж
             , salePointDistributorName  TVarChar -- Название дистрибьютера	
             , salePointDistributorExtId TVarChar -- Код дистрибьютера	
             , customer        TVarChar   -- Название корпорации          
             , customerIsis    TVarChar   -- Код корпорации	
             , banner          TVarChar   -- Торговая сеть	
             , address2        TVarChar   -- Город	
             , address3        TVarChar   -- Улица
             , address4        TVarChar   -- Дом/корпус	
             , segment         TFloat     -- Средняя продажа в месяц в MSU
             , recDays         Integer    -- Рекомендуемые дни посещения (битовая маска: пн - 1, вт - 2, ср - 4, чт - 8, пт - 16, сб - 32, вс - 64)
             , recTimeBeg      TVarChar   -- Рекомендуемое время начала визита
             , recTimeEnd	   TVarChar   -- Рекомендуемое время окончания визита
             , timeInTT        Integer    -- Время проведенное в торговой точке в минутах
             , retailerName    TVarChar   -- "Название торговой сети
             , retailerExtId   TVarChar   -- "Внешний ид торговой сети
             , territorialFeatureExtId TVarChar -- Внешний идентификатор территориального признака
             , salePointDistrictExtId  TVarChar -- Внешний идентификатор области 
             , salePointDistrictName   TVarChar -- Название области
             , salePointFormatExtId	   TVarChar -- Внешний идентификатор формата магазина	
             , salePointFormatName     TVarChar -- Название формата магазина
             , salePointRegionExtId    TVarChar -- Внешний идентификатор региона
             , salePointRegionName     TVarChar -- Название региона
             , defaultOrderPaymentFormExtId  TVarChar -- Внешний идентификатор формы оплаты по умолчанию
             , isDeleted       Integer    -- Признак активности записи: 0 = активна / 1 = не активна
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     SELECT Object_Partner.Id                             ::TVarChar AS extId
          , TRIM (Object_Partner.ValueData)               ::TVarChar AS Name
          , TRIM (ObjectHistoryString_JuridicalDetails_JuridicalAddress.ValueData)  ::TVarChar AS legalAddress
          , TRIM (ObjectString_Address.ValueData)         ::TVarChar AS streetAddress
          , ''                                            ::TVarChar AS latitude
          , ''                                            ::TVarChar AS longitude
          , 0                                             ::Integer  AS recurrence
          ,  COALESCE (ObjectLink_Partner_PartnerTag.ChildObjectId ::TVarChar, zfCalc_UserAdmin() ::TVarChar)  ::TVarChar AS channelSaleId    
          , ''                                            ::TVarChar AS salePointDistributorName
          , ''                                            ::TVarChar AS salePointDistributorExtId
          , ''                                            ::TVarChar AS customer
          , ''                                            ::TVarChar AS customerIsis
          , Object_Retail.ValueData                       ::TVarChar AS banner
          , Object_City.ValueData                         ::TVarChar AS address2
          , Object_Street.ValueData                       ::TVarChar AS address3
          , ObjectString_HouseNumber.ValueData            ::TVarChar AS address4
          , 0                                             ::TFloat   AS segment
          , 1                                             ::Integer  AS recDays
          , ''                                            ::TVarChar AS recTimeBeg
          , ''                                            ::TVarChar AS recTimeEnd
          , NULL                                          ::Integer  AS timeInTT
          , '' /*COALESCE (Object_Retail.ValueData, 'нет')*/     ::TVarChar AS retailerName 
          , '' /*COALESCE (Object_Retail.Id ::TVarChar, zfCalc_UserAdmin() ::TVarChar)*/ ::TVarChar AS retailerExtId
          , ''                                            ::TVarChar AS territorialFeatureExtId
          , Object_Region.Id                              ::TVarChar AS salePointDistrictExtId
          , Object_Region.ValueData                       ::TVarChar AS salePointDistrictName
          , ''                                            ::TVarChar AS salePointFormatExtId
          , ''                                            ::TVarChar AS salePointFormatName
          , Object_Area.Id                                ::TVarChar AS salePointRegionExtId
          , Object_Area.ValueData                         ::TVarChar AS salePointRegionName
          , ''                                            ::TVarChar AS defaultOrderPaymentFormExtId
          , CASE WHEN Object_Partner.isErased = FALSE THEN 0 ELSE 1 END  ::Integer  AS isDeleted
     FROM Object AS Object_Partner

          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = Object_Partner.Id
                                AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

          LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                               ON ObjectLink_Partner_PartnerTag.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                               ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

          LEFT JOIN ObjectHistory AS ObjectHistory_JuridicalDetails 
                                  ON ObjectHistory_JuridicalDetails.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails()
                                 AND CURRENT_DATE >= ObjectHistory_JuridicalDetails.StartDate AND CURRENT_DATE < ObjectHistory_JuridicalDetails.EndDate  
          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_JuridicalAddress
                                        ON ObjectHistoryString_JuridicalDetails_JuridicalAddress.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                       AND ObjectHistoryString_JuridicalDetails_JuridicalAddress.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                               ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
          LEFT JOIN Object AS Object_Street ON Object_Street.Id = ObjectLink_Partner_Street.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Street_City 
                               ON ObjectLink_Street_City.ObjectId = ObjectLink_Partner_Street.ChildObjectId
                              AND ObjectLink_Street_City.DescId = zc_ObjectLink_Street_City()
          LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Street_City.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_City_Region
                               ON ObjectLink_City_Region.ObjectId = Object_City.Id
                              AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
          LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_City_Region.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_HouseNumber
                                 ON ObjectString_HouseNumber.ObjectId = Object_Partner.Id
                                AND ObjectString_HouseNumber.DescId = zc_ObjectString_Partner_HouseNumber()

     WHERE Object_Partner.DescId   = zc_Object_Partner()
       AND Object_Partner.isErased = FALSE
--limit 200
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
-- SELECT * FROM gpSelect_Object_TT_effie (zfCalc_UserAdmin()::TVarChar);
