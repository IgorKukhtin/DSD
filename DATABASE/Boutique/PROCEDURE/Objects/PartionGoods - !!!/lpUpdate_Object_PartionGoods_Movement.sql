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
BEGIN

       -- изменили во Всех партиях Товара - ОДНОГО Документа
       UPDATE Object_PartionGoods SET PartnerId            = inPartnerId
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
