/*
  Создание 
    - таблицы MovementSiteBonus (Бонусы по мобильному приложеним)
    - связей
    - индексов
*/


-- DROP TABLE MovementSiteBonus;

/*-------------------------------------------------------------------------------*/
CREATE TABLE MovementSiteBonus
(
  MovementId        Integer,  -- Заказ
  BuyerForSiteCode  Integer,  -- Покупателя сайта "Не болей"
  Bonus             TFloat,   -- Начислено бонусов
  Bonus_Used        TFloat,   -- Использовано бонусов

  CONSTRAINT pk_MovementSiteBonus PRIMARY KEY (MovementId)
);

ALTER TABLE MovementSiteBonus
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Фелонюк И.В.   Шаблий О.В.
05.09.2022                                                        *
*/