/*
  Создание 
    - таблицы _replica.HistoryCost_Rewiring (Данные для изменения HistoryCost)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.HistoryCost_Rewiring(
    RewiringUUId          TVarChar,        -- UUId Для переносы данных
   
    Id                    SERIAL NOT NULL PRIMARY KEY,
    StartDate             TDateTime NOT NULL,
    EndDate               TDateTime NOT NULL,
    Price                 TFloat NOT NULL,
    StartCount            TFloat NOT NULL,
    StartSumm             TFloat NOT NULL,
    IncomeCount           TFloat NOT NULL,
    IncomeSumm            TFloat NOT NULL,
    CalcCount             TFloat NOT NULL,
    CalcSumm              TFloat NOT NULL,
    OutCount              TFloat NOT NULL,
    OutSumm               TFloat NOT NULL,

    ContainerId           Integer  NOT NULL,
    Price_external        TFloat   NOT NULL,
    CalcCount_external    TFloat   NOT NULL,
    CalcSumm_external     TFloat   NOT NULL,
    MovementItemId_diff   Integer          ,
    Summ_diff             TFloat   
   );

/*-------------------------------------------------------------------------------*/

-- Добавление полей


/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Шаблий О.В.
 19.09.23                                          * 
*/