/*
  Создание 
    - таблицы UkraineAlarm (Повітряна тривога)
    - связей
    - индексов
*/


-- DROP TABLE UkraineAlarm;

/*-------------------------------------------------------------------------------*/
CREATE TABLE UkraineAlarm
(
  Id             serial NOT NULL,
  regionId       Integer,    -- Регион 
  startDate      TDateTime,  -- Дата начала
  endDate        TDateTime,  -- Дата конца
  alertType      TVarChar,   -- Тип тревоги

  CONSTRAINT pk_UkraineAlarm PRIMARY KEY (Id)
);

ALTER TABLE UkraineAlarm
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Фелонюк И.В.   Шаблий О.В.
22.08.2022                                                        *
*/
