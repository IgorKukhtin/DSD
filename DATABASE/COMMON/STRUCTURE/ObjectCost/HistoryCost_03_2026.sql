/*
  Создание 
    - таблицы HistoryCost (История цен)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

-- delete from HistoryCost_03_2026 ;
-- insert into HistoryCost_03_2026 select * from HistoryCost where StartDate = '01.03.2026';
--
--  update HistoryCost_03_2026 set Price = Price_new
select HistoryCost_03_2026.Id, HistoryCost_03_2026.Price, HistoryCost.Price as Price_new -- , HistoryCost_03_2026.StartSumm, HistoryCost.StartSumm, HistoryCost.ContainerId, Container.ParentId , *
 from HistoryCost
      join Container ON Container.Id = HistoryCost.ContainerId
      join HistoryCost_03_2026 ON HistoryCost_03_2026.ContainerId = HistoryCost.ContainerId
                              AND HistoryCost_03_2026.Price <> HistoryCost.Price
                              AND HistoryCost_03_2026.StartSumm <> HistoryCost.StartSumm
where HistoryCost.StartDate = '01.03.2026'
--) as a 
--where HistoryCost_03_2026.Id = a.Id
;

-- delete from HistoryCost where StartDate = '01.03.2026';
-- insert into HistoryCost select * from HistoryCost_03_2026 where StartDate = '01.03.2026';


CREATE TABLE HistoryCost_03_2026(
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

-- insert into HistoryCost_03_2026_2 select * from HistoryCost_03_2026 where StartDate = '01.03.2026';
CREATE TABLE HistoryCost_03_2026_2(
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
