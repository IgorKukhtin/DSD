-- View: TT

DROP VIEW IF EXISTS TT;

CREATE OR REPLACE VIEW TT
AS 
  WITH _tmpresult AS (SELECT extId
                           , Name
                           , legalAddress
                           , streetAddress
                           , latitude
                           , longitude
                           , recurrence
                           , channelSaleId    
                           , salePointDistributorName
                           , salePointDistributorExtId
                           , customer
                           , customerIsis
                           , banner
                           , address2
                           , address3
                           , address4
                           , segment
                           , recDays
                           , recTimeBeg
                           , recTimeEnd
                           , timeInTT
                           , retailerName 
                           , retailerExtId
                           , territorialFeatureExtId
                           , salePointDistrictExtId
                           , salePointDistrictName
                           , salePointFormatExtId
                           , salePointFormatName
                           , salePointRegionExtId
                           , salePointRegionName
                           , defaultOrderPaymentFormExtId
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_TT_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId           TVarChar   -- Идентификатор канала продаж
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
                                                )
                     )
 --
 SELECT extId
      , Name
      , legalAddress
      , streetAddress
      , latitude
      , longitude
      , recurrence
      , channelSaleId    
      , salePointDistributorName
      , salePointDistributorExtId
      , customer
      , customerIsis
      , banner
      , address2
      , address3
      , address4
      , segment
      , recDays
      , recTimeBeg
      , recTimeEnd
      , timeInTT
      , retailerName 
      , retailerExtId
      , territorialFeatureExtId
      , salePointDistrictExtId
      , salePointDistrictName
      , salePointFormatExtId
      , salePointFormatName
      , salePointRegionExtId
      , salePointRegionName
      , defaultOrderPaymentFormExtId
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE TT  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.TT TO admin;
GRANT ALL ON TABLE PUBLIC.TT TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26         *
*/

-- тест
-- SELECT * FROM TT ORDER BY 1
