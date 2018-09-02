-- Function: lpUpdate_Object_PartionGoods_Movement

DROP FUNCTION IF EXISTS lpUpdate_Object_PartionGoods_Movement (Integer, Integer, Integer, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_PartionGoods_Movement(
    IN inMovementId             Integer,       -- Ключ Документа
    IN inPartnerId              Integer,       -- Поcтавщик
    IN inUnitId                 Integer,       -- Подразделение(прихода)
    IN inOperDate               TDateTime,     -- Дата прихода
    IN inCurrencyId             Integer,       -- Валюта для цены прихода
    IN inUserId                 Integer        --
)
RETURNS VOID
AS
$BODY$
  DECLARE vbBrandId    Integer;
  DECLARE vbFabrikaId  Integer;
  DECLARE vbPeriodId   Integer;
  DECLARE vbPeriodYear Integer;
BEGIN

       SELECT 
             ObjectLink_Partner_Brand.ChildObjectId   AS BrandId
           , ObjectLink_Partner_Fabrika.ChildObjectId AS FabrikaId
           , ObjectLink_Partner_Period.ChildObjectId  AS PeriodId
           , ObjectFloat_PeriodYear.ValueData         AS PeriodYear
           
             INTO vbBrandId
                , vbFabrikaId
                , vbPeriodId
                , vbPeriodYear
       FROM Object AS Object_Partner
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Brand
                                 ON ObjectLink_Partner_Brand.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Brand.DescId = zc_ObjectLink_Partner_Brand()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Fabrika
                                 ON ObjectLink_Partner_Fabrika.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Fabrika.DescId = zc_ObjectLink_Partner_Fabrika()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                 ON ObjectLink_Partner_Period.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()
            LEFT JOIN ObjectFloat AS ObjectFloat_PeriodYear 
                                  ON ObjectFloat_PeriodYear.ObjectId = Object_Partner.Id 
                                 AND ObjectFloat_PeriodYear.DescId = zc_ObjectFloat_Partner_PeriodYear()
       WHERE Object_Partner.Id = inPartnerId;
       
       -- изменили во Всех партиях Товара - ОДНОГО Документа
       UPDATE Object_PartionGoods SET PartnerId            = inPartnerId
                                    , BrandId              = vbBrandId
                                    , FabrikaId            = vbFabrikaId
                                    , PeriodId             = vbPeriodId
                                    , PeriodYear           = vbPeriodYear
                                    , UnitId               = inUnitId
                                    , OperDate             = inOperDate
                                    , CurrencyId           = inCurrencyId
       WHERE Object_PartionGoods.MovementId = inMovementId;
                                     
END;                                 
$BODY$                               
  LANGUAGE plpgsql VOLATILE;           
                                     
/*------------------------------     -------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.06.17                                         *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_PartionGoods_Movement()
