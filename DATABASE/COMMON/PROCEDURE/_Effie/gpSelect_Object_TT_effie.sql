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

     -- временная таблица PriceListItem
     CREATE TEMP TABLE _tmpPartner (PartnerId            Integer,
                                    StreetId             Integer,
                                    PartnerTagId         Integer,
                                    AreaId               Integer,
                                    HouseNumber          TVarChar,
                                    CaseNumber           TVarChar,
                                    RoomNumber           TVarChar,
                                    isErased             Boolean)  ON COMMIT DROP;
     
     INSERT INTO _tmpPartner (PartnerId,
                              StreetId,
                              PartnerTagId,
                              AreaId,
                              HouseNumber,
                              CaseNumber,
                              RoomNumber,
                              isErased) 
     
     WITH 
     tmpPartner AS (-- если vbPersonalId - Сотрудник (торговый)
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
      --
     SELECT Object_Partner.Id                                           AS PartnerId
          , ObjectLink_Partner_Street.ChildObjectId                     AS StreetId
          , ObjectLink_Partner_PartnerTag.ChildObjectId                 AS PartnerTagId
          , COALESCE (ObjectLink_Partner_Area.ChildObjectId,0)::Integer AS AreaId
          , COALESCE (ObjectString_HouseNumber.ValueData,'') ::TVarChar AS HouseNumber
          , COALESCE (ObjectString_CaseNumber.ValueData,'')  ::TVarChar AS CaseNumber
          , COALESCE (ObjectString_RoomNumber.ValueData,'')  ::TVarChar AS RoomNumber
          , Object_Partner.isErased                          ::Boolean  AS isErased
     FROM Object AS Object_Partner
         INNER JOIN tmpPartner ON tmpPartner.PartnerId = Object_Partner.Id

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                              ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                              ON ObjectLink_Partner_PartnerTag.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                              ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id
                             AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
         
         LEFT JOIN ObjectString AS ObjectString_HouseNumber
                                ON ObjectString_HouseNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_HouseNumber.DescId = zc_ObjectString_Partner_HouseNumber()          

         LEFT JOIN ObjectString AS ObjectString_CaseNumber
                                ON ObjectString_CaseNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_CaseNumber.DescId = zc_ObjectString_Partner_CaseNumber()

         LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                ON ObjectString_RoomNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()
                
     WHERE Object_Partner.DescId   = zc_Object_Partner()
      AND Object_Partner.isErased = FALSE
      AND COALESCE (ObjectLink_Partner_Street.ChildObjectId,0) > 0
    ;                               
     
     --нужно записать в таблица Object_TT_effie.Id - ключ StreetId, HouseNumber, CaseNumber, RoomNumber  те элементы , которых нет
     INSERT INTO Object_TT_effie (StreetId, PartnerTagId, AreaId, HouseNumber, CaseNumber, RoomNumber, InsertDate, isErased)
     SELECT DISTINCT
            tmpPartner.StreetId
          , COALESCE (tmpPartner.PartnerTagId,0) AS PartnerTagId
          , COALESCE (tmpPartner.AreaId,0)  AS AreaId
          , tmpPartner.HouseNumber
          , tmpPartner.CaseNumber
          , tmpPartner.RoomNumber
          , CURRENT_TIMESTAMP AS InsertDate
          , FALSE             AS isErased
      FROM (SELECT DISTINCT 
                  _tmpPartner.StreetId, _tmpPartner.HouseNumber, _tmpPartner.CaseNumber, _tmpPartner.RoomNumber
                , MAX (_tmpPartner.PartnerTagId) AS PartnerTagId, MAX (_tmpPartner.AreaId) AS AreaId
            FROM _tmpPartner
            GROUP BY _tmpPartner.StreetId, _tmpPartner.HouseNumber, _tmpPartner.CaseNumber, _tmpPartner.RoomNumber
          -- limit 150
           ) AS tmpPartner
        LEFT JOIN Object_TT_effie ON Object_TT_effie.StreetId   = tmpPartner.StreetId
                                   AND Object_TT_effie.HouseNumber= tmpPartner.HouseNumber
                                   AND Object_TT_effie.CaseNumber = tmpPartner.CaseNumber 
                                   AND Object_TT_effie.RoomNumber = tmpPartner.RoomNumber
     WHERE Object_TT_effie.Id IS NULL;


     -- Результат
     RETURN QUERY
     --
     SELECT Object_TT_effie.Id                            ::TVarChar AS extId
          , (Object_TT_effie.StreetId 
            || ' ' ||COALESCE (Object_TT_effie.HouseNumber,'')
            || ' ' ||COALESCE (Object_TT_effie.CaseNumber,'') 
            || ' ' ||COALESCE (Object_TT_effie.RoomNumber,''))          ::TVarChar AS Name       --StreetId + HouseNumber + CaseNumber + RoomNumber
          , ''                         ::TVarChar AS legalAddress
          , (Object_TT_effie.StreetId 
            || ' ' ||Object_TT_effie.HouseNumber
            || ' ' ||Object_TT_effie.CaseNumber 
            || ' ' ||Object_TT_effie.RoomNumber)          ::TVarChar AS streetAddress
          , ''                                            ::TVarChar AS latitude
          , ''                                            ::TVarChar AS longitude
          , 0                                             ::Integer  AS recurrence
          ,  COALESCE (Object_TT_effie.PartnerTagId ::TVarChar, zfCalc_UserAdmin() ::TVarChar)  ::TVarChar AS channelSaleId    
          , ''                                            ::TVarChar AS salePointDistributorName
          , ''                                            ::TVarChar AS salePointDistributorExtId
          , ''                                            ::TVarChar AS customer
          , ''                                            ::TVarChar AS customerIsis
          , ''                                            ::TVarChar AS banner
          , Object_City.ValueData                         ::TVarChar AS address2
          , Object_Street.ValueData                       ::TVarChar AS address3
          , COALESCE (Object_TT_effie.HouseNumber,'')     ::TVarChar AS address4
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
          , CASE WHEN Object_TT_effie.isErased = FALSE THEN 0 ELSE 1 END  ::Integer  AS isDeleted
     FROM Object_TT_effie
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = Object_TT_effie.AreaId

          LEFT JOIN Object AS Object_Street ON Object_Street.Id = Object_TT_effie.StreetId

          LEFT JOIN ObjectLink AS ObjectLink_Street_City 
                               ON ObjectLink_Street_City.ObjectId = Object_TT_effie.StreetId
                              AND ObjectLink_Street_City.DescId = zc_ObjectLink_Street_City()
          LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Street_City.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_City_Region
                               ON ObjectLink_City_Region.ObjectId = Object_City.Id
                              AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
          LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_City_Region.ChildObjectId

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
