/*
  Создание 
    - таблицы HistoryCost (История цен)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE HistoryCost(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   -- ObjectCostId          Integer NOT NULL,
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

/*                                  Индексы                                      */

CREATE UNIQUE INDEX idx_HistoryCost_ObjectCostId_StartDate_EndDate ON HistoryCost(ObjectCostId, StartDate, EndDate);

/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 11.08.13             * add OutCount and OutSumm
 03.08.13             * StratSumm
 11.07.13                             *
*/
