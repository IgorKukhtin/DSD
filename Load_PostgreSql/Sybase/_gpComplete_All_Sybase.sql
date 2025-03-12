-- Function: gpComplete_All_Sybase()

DROP FUNCTION IF EXISTS gpComplete_All_Sybase (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_All_Sybase(
    IN inMovementId        Integer              , -- ключ Документа
    IN inIsNoHistoryCost   Boolean              , --
    IN inSession           TVarChar               -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     --***vbOperDate_Begin1:= CLOCK_TIMESTAMP();

if inMovementId  = 30603865 AND 1=0
THEN RETURN; END IF;

     -- нашли
     SELECT DescId, StatusId, OperDate INTO vbMovementDescId, vbStatusId, vbOperDate FROM Movement WHERE Id = inMovementId;
     -- !!!выход!!!
     IF vbStatusId <> zc_Enum_Status_Complete() AND inSession <> '' THEN RETURN; END IF;
     
if CURRENT_TIMESTAMP between '10.02.2025 7:33' and '10.02.2025 7:35'
then
select * from gpComplete_All_Sybase( 30382239  ,False,'444873');
end if;

     -- Розподільчий комплекс + Склад Брак + Склад Возвратов + Склад УТИЛЬ + Склад Утиль-сроки
     /*IF    (EXISTS (SELECT 1  FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (8459, 8462, 8461, 256716, 1387416))
         OR EXISTS (SELECT 1  FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To()   AND MLO.ObjectId IN (8459, 8462, 8461, 256716, 1387416))
           )
        AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
      THEN RETURN; END IF;*/


   -- !!!ошщибка!!!
   -- IF inMovementId IN (30202848) AND inSession <> '' THEN RETURN; END IF;

/*   IF inMovementId IN (28363986, 28364016) THEN RETURN; END IF;
-- select * from gpComplete_All_Sybase(28363986,False,'444873')
-- select * from gpComplete_All_Sybase(28364016,False,'444873')
-- select * from gpComplete_All_Sybase(28364189,False,'444873')
     IF EXISTS (SELECT 1  FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (zc_Unit_RK()))
        AND vbMovementDescId IN (zc_Movement_Sale())
        THEN RETURN;
     END IF;
*/

   --IF vbMovementDescId IN (zc_Movement_SendOnPrice()) THEN RETURN; END IF;

   --IF vbMovementDescId NOT IN (zc_Movement_ReturnIn()) THEN RETURN; END IF;

   --IF vbMovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice(), zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()) 
   --   OR NOT EXISTS (SELECT 1  FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId IN (zc_Unit_RK()))
   --THEN RETURN; END IF;

   --IF vbMovementDescId IN (zc_Movement_Inventory()) THEN RETURN; END IF;
   --IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) > 18 AND vbMovementDescId IN (zc_Movement_Inventory()) THEN RETURN; END IF;
   

    --IF vbOperDate >= '01.11.2023' AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN RETURN; END IF;
     


     /*IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Inventory())
     THEN 
         -- !!!выход!!!
         IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.ObjectId IN (301309 -- Склад ГП ф.Запорожье
                                                                                                                   , 309599 -- Склад возвратов ф.Запорожье
                                                                                                                   , 8417   -- Склад ГП ф.Николаев (Херсон)
                                                                                                                   , 428364 -- Склад возвратов ф.Николаев (Херсон)
                                                                                                                   , 8415   -- Склад ГП ф.Черкассы (Кировоград)
                                                                                                                   , 428363 -- Склад возвратов ф.Черкассы (Кировоград)
                                                                                                                   , 8413   -- Склад ГП ф.Кривой Рог
                                                                                                                   , 428366 -- Склад возвратов ф.Кривой Рог
                                                                                                                   , 8425   -- Склад ГП ф.Харьков
                                                                                                                   , 409007 -- Склад возвратов ф.Харьков
                                                                                                                    ))
         THEN RETURN; END IF;
    
         IF inIsNoHistoryCost = FALSE
            AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId IN (zc_Movement_ReturnIn()
                                                                                                      , zc_Movement_ProductionUnion()
                                                                                                      , zc_Movement_ProductionSeparate()
                                                                                                      , zc_Movement_Send()
                                                                                                       ))
         THEN RETURN; END IF;
     END IF;*/

     -- !!!выход!!!
     -- IF vbMovementDescId IN (zc_Movement_Inventory()) THEN RETURN; END IF;
     -- IF vbMovementDescId IN (zc_Movement_Sale()) THEN RETURN; END IF;
     -- IF vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN RETURN; END IF;

     -- !!!проверка!!!
     IF COALESCE (vbMovementDescId, 0) = 0 OR inMovementId <= 1000000
     THEN
         RAISE EXCEPTION 'NOT FIND, inMovementId = %', inMovementId;
     END IF;


/*
     -- !!!выход - Инвентаризация!!!
     IF vbMovementDescId = zc_Movement_Inventory() AND EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) BETWEEN 20 AND 23 AND EXTRACT ('MONTH' FROM vbOperDate) <> EXTRACT ('MONTH' FROM CURRENT_DATE) THEN RETURN; END IF;
     IF vbMovementDescId = zc_Movement_Inventory() AND EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) BETWEEN 0  AND 4  AND EXTRACT ('MONTH' FROM vbOperDate) <> EXTRACT ('MONTH' FROM CURRENT_DATE) THEN RETURN; END IF;

     -- !!!выход - Инвентаризация!!!
     IF vbMovementDescId = zc_Movement_Inventory() AND EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) BETWEEN 8 AND 15
     -- IF vbMovementDescId = zc_Movement_Inventory() AND EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) BETWEEN 10 AND 15
     THEN 
         IF EXTRACT ('MINUTES' FROM CURRENT_TIMESTAMP) BETWEEN 50 AND 59 OR EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) > 8
         -- IF EXTRACT ('MINUTES' FROM CURRENT_TIMESTAMP) BETWEEN 25 AND 59 OR EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) > 10
         THEN 
             RETURN; 
         END IF;
     END IF;
*/


     -- !!! распроведение!!!
     PERFORM lpUnComplete_Movement (inMovementId:= inMovementId, inUserId:= zc_Enum_Process_Auto_PrimeCost() :: Integer);


     -- !!!0 - PriceCorrective!!!
     IF vbMovementDescId = zc_Movement_PriceCorrective() AND 1=0
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_PriceCorrective_CreateTemp();
             -- !!! проводим - Loss !!!
             PERFORM lpComplete_Movement_PriceCorrective (inMovementId     := inMovementId
                                                        , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer);

     ELSE
     -- !!!1 - Loss!!!
     IF vbMovementDescId IN (zc_Movement_Loss(), zc_Movement_LossAsset())
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_Loss_CreateTemp();
             -- !!! проводим - Loss !!!
             PERFORM lpComplete_Movement_Loss (inMovementId     := inMovementId
                                             , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer);

     ELSE
     -- !!!2 - SendOnPrice!!!
     IF vbMovementDescId = zc_Movement_SendOnPrice()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_SendOnPrice_CreateTemp();
             -- !!! проводим - SendOnPrice !!!
             -- PERFORM lpComplete_Movement_SendOnPrice_Price (inMovementId     := inMovementId
             PERFORM lpComplete_Movement_SendOnPrice (inMovementId     := inMovementId
                                                    , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer);

     ELSE
     -- !!!3 - ReturnIn!!!
     IF vbMovementDescId = zc_Movement_ReturnIn()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_ReturnIn_CreateTemp();
             -- !!! проводим - ReturnIn !!!
             PERFORM lpComplete_Movement_ReturnIn (inMovementId     := inMovementId
                                                 , inStartDateSale  := NULL
                                                 , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer
                                                 , inIsLastComplete := FALSE); -- inIsNoHistoryCost);

     ELSE
     -- !!!4 - Sale!!!
     IF vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_Sale_CreateTemp();
             -- !!! проводим - Sale !!!
             PERFORM lpComplete_Movement_Sale (inMovementId     := inMovementId
                                             , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer
                                             , inIsLastComplete := FALSE); -- inIsNoHistoryCost);
     ELSE
     -- !!!5 - ReturnOut!!!
     IF vbMovementDescId = zc_Movement_ReturnOut()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_ReturnOut_CreateTemp();
             -- !!! проводим - ReturnOut !!!
             PERFORM lpComplete_Movement_ReturnOut (inMovementId     := inMovementId
                                                  , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer
                                                  , inIsLastComplete := NULL); -- inIsNoHistoryCost);

     ELSE
     -- !!!6.1. - Send!!!
     IF vbMovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             -- PERFORM lpComplete_Movement_Send_CreateTemp();
             -- !!! проводим - Send !!!
             PERFORM gpComplete_Movement_Send (inMovementId     := inMovementId
                                             , inIsLastComplete := TRUE
                                             , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
     ELSE
     -- !!!6.2. - ProductionUnion!!!
     IF vbMovementDescId = zc_Movement_ProductionUnion()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             -- PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
             -- !!! проводим - ProductionUnion !!!
             PERFORM gpComplete_Movement_ProductionUnion (inMovementId     := inMovementId
                                                        , inIsLastComplete := TRUE
                                                        , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
     ELSE
     -- !!!6.3. - ProductionSeparate!!!
     IF vbMovementDescId = zc_Movement_ProductionSeparate()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             -- PERFORM lpComplete_Movement_ProductionSeparate_CreateTemp();
             -- !!! проводим - ProductionSeparate !!!
             PERFORM gpComplete_Movement_ProductionSeparate (inMovementId     := inMovementId
                                                           , inIsLastComplete := TRUE
                                                           , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
     ELSE
     -- !!!10.1 - Cash!!!
     IF vbMovementDescId = zc_Movement_Cash() AND 1=0
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! проводим - Cash !!!
             PERFORM gpComplete_Movement_Cash (inMovementId     := inMovementId
                                             , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!10.2 - BankAccount!!!
     IF vbMovementDescId = zc_Movement_BankAccount() AND 1=0
     THEN
             -- !!! проводим - BankAccount !!!
             PERFORM gpComplete_Movement_BankAccount (inMovementId     := inMovementId
                                                    , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!11. - SendDebt!!!
     IF vbMovementDescId = zc_Movement_SendDebt() AND 1=0
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! проводим - SendDebt !!!
             PERFORM gpComplete_Movement_SendDebt (inMovementId     := inMovementId
                                                 , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!12.1. - PersonalReport!!!
     IF vbMovementDescId = zc_Movement_PersonalReport() AND 1=0
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! проводим - Service !!!
             PERFORM gpComplete_Movement_PersonalReport (inMovementId     := inMovementId
                                                       , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
     ELSE
     -- !!!12.2. - Service!!!
     IF vbMovementDescId = zc_Movement_Service() AND 1=0
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! проводим - Service !!!
             PERFORM gpComplete_Movement_Service (inMovementId     := inMovementId
                                                , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!13. - PersonalAccount!!!
     IF vbMovementDescId = zc_Movement_PersonalAccount() AND 1=0
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! проводим - PersonalAccount !!!
             PERFORM gpComplete_Movement_PersonalAccount (inMovementId     := inMovementId
                                                        , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!14.1. - ProfitLossService!!!
     IF vbMovementDescId = zc_Movement_ProfitLossService() AND 1=0
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! проводим - ProfitLossService !!!
             PERFORM gpComplete_Movement_ProfitLossService (inMovementId     := inMovementId
                                                          , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!14.2. - zc_Movement_PersonalSendCash!!!
     IF vbMovementDescId = zc_Movement_PersonalSendCash() AND 1=0
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_PersonalSendCash_CreateTemp();
             -- проводим Документ
             PERFORM lpComplete_Movement_PersonalSendCash (inMovementId := inMovementId
                                                         , inUserId     := zc_Enum_Process_Auto_PrimeCost());
     ELSE
     -- !!!14.3. - zc_Movement_TransportService!!!
     IF vbMovementDescId = zc_Movement_TransportService() AND 1=0
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- проводим Документ
             PERFORM lpComplete_Movement_TransportService (inMovementId := inMovementId
                                                         , inUserId     := zc_Enum_Process_Auto_PrimeCost());
     ELSE


     -- !!!14. - Income!!!
     IF vbMovementDescId = zc_Movement_Income() AND 1=1
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_Income_CreateTemp();
             -- !!! проводим - Income !!!
             PERFORM lpComplete_Movement_Income (inMovementId     := inMovementId
                                               , inUserId         := zc_Enum_Process_Auto_PrimeCost()
                                               , inIsLastComplete := TRUE);
     ELSE

     -- !!!15.1 - TransferDebtIn!!!
     IF vbMovementDescId = zc_Movement_TransferDebtIn() AND 1=0
     THEN
             -- !!! проводим - TransferDebtIn !!!
             PERFORM gpComplete_Movement_TransferDebtIn (inMovementId     := inMovementId
                                                       , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!15.2. - TransferDebtOut!!!
     IF vbMovementDescId = zc_Movement_TransferDebtOut() AND 1=0
     THEN
             -- !!! проводим - TransferDebtOut !!!
             PERFORM gpComplete_Movement_TransferDebtOut (inMovementId     := inMovementId
                                                        , inSession        := zfCalc_UserAdmin());
     ELSE

     -- !!!16 - Inventory!!!
     IF vbMovementDescId = zc_Movement_Inventory() AND 1=1 -- !!!ADD!!!
     THEN
             -- !!! проводим - Inventory !!!
             PERFORM gpComplete_Movement_Inventory (inMovementId     := inMovementId
                                                  , inIsLastComplete := NULL
                                                  , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
     ELSE

     -- !!!17 - IncomeCost!!!
     IF vbMovementDescId = zc_Movement_IncomeCost() AND 1=1 -- !!!ADD!!!
     THEN
             -- !!! проводим - IncomeCost !!!
             PERFORM gpComplete_Movement_IncomeCost (inMovementId     := inMovementId
                                                   , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);

     ELSE
         RAISE EXCEPTION 'NOT FIND inMovementId = %, MovementDescId = %(%)', inMovementId, vbMovementDescId, (SELECT ItemName FROM MovementDesc WHERE Id = vbMovementDescId);
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;


     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     --***
     /*INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT zc_Enum_Process_Auto_PrimeCost() :: Integer
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum' in query) = 1)         AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id =  vbMovementDescId)

               -- ProtocolData
             , inMovementId :: TVarChar
        || ' ' || COALESCE ((SELECT Object.ValueData FROM MovementLinkObject AS MLO JOIN Object ON Object.Id = MLO.ObjectId WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From()), '')
     || ' => ' || COALESCE ((SELECT Object.ValueData FROM MovementLinkObject AS MLO JOIN Object ON Object.Id = MLO.ObjectId WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To()), '')
              ;*/

-- SELECT OperDate AS T_start, Time5 AS T_end, Time1 AS diff, Value1 AS ProcessCount, Value2 AS ProcessVAC, ProcName, ProtocolData FROM ResourseProtocol WHERE OperDate >= '26.11.2023' AND UserId = zc_Enum_Process_Auto_PrimeCost() :: Integer ORDER BY OperDate

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.11.14                                        *
*/

-- тест
-- SELECT * FROM gpComplete_All_Sybase (inMovementId:= 3581, inIsBefoHistoryCost:= FALSE, inIsNoHistoryCost = FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())

/*
update MovementItemContainer set AnalyzerId = zc_Enum_ProfitLossDirection_10400()
-- select *
-- from MovementItemContainer 
-- , 
from Movement
where Movement.Id = MovementItemContainer.MovementId
and AnalyzerId is null
and Movement.DescId = zc_Movement_Sale()
and MovementItemContainer.DescId = zc_MIContainer_Count()
and MovementItemContainer.OperDAte < '01.06.2014'
;


update MovementItemContainer set AnalyzerId = zc_Enum_ProfitLossDirection_10800()
from Movement
where Movement.Id = MovementItemContainer.MovementId
and AnalyzerId is null
and Movement.DescId = zc_Movement_ReturnIn()
and MovementItemContainer.DescId = zc_MIContainer_Count()
and MovementItemContainer.OperDAte < '01.06.2014'
;


update MovementItemContainer set AnalyzerId = zc_Enum_ProfitLossDirection_10400()
from Movement, (select Container.Id from Object_Account_View JOIN Container ON Container.ObjectId = Object_Account_View.AccountId where AccountGroupId IN (zc_Enum_AccountGroup_20000(), zc_Enum_AccountGroup_60000())) AS Container
where Movement.Id = MovementItemContainer.MovementId
and AnalyzerId is null
and Movement.DescId = zc_Movement_Sale()
and MovementItemContainer.DescId = zc_MIContainer_Summ()
and MovementItemContainer.ContainerId = Container.Id
and MovementItemContainer.OperDAte < '01.06.2014'
;


update MovementItemContainer set AnalyzerId = zc_Enum_ProfitLossDirection_10800()
from Movement, (select Container.Id from Object_Account_View JOIN Container ON Container.ObjectId = Object_Account_View.AccountId where AccountGroupId IN (zc_Enum_AccountGroup_20000(), zc_Enum_AccountGroup_60000())) AS Container
where Movement.Id = MovementItemContainer.MovementId
and AnalyzerId is null
and Movement.DescId = zc_Movement_ReturnIn()
and MovementItemContainer.DescId = zc_MIContainer_Summ()
and MovementItemContainer.ContainerId = Container.Id
and MovementItemContainer.OperDAte < '01.06.2014'
;

	
update MovementItemContainer set AnalyzerId = zc_Enum_ProfitLossDirection_10100()
from Movement, Container
where Movement.Id = MovementItemContainer.MovementId
and AnalyzerId is null
and Movement.DescId = zc_Movement_Sale()
and MovementItemContainer.DescId = zc_MIContainer_Summ()
and MovementItemContainer.ContainerId = Container.Id
and Container.ObjectId not in (zc_Enum_Account_100301(), zc_Enum_Account_110101())
and MovementItemContainer.OperDAte < '01.06.2014'
;
update MovementItemContainer set AnalyzerId = zc_Enum_ProfitLossDirection_10700()
from Movement, Container
where Movement.Id = MovementItemContainer.MovementId
and AnalyzerId is null
and Movement.DescId = zc_Movement_ReturnIn()
and MovementItemContainer.DescId = zc_MIContainer_Summ()
and MovementItemContainer.ContainerId = Container.Id
and Container.ObjectId not in (zc_Enum_Account_100301(), zc_Enum_Account_110101())
and MovementItemContainer.OperDAte < '01.06.2014'
;


-- SELECT lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= Movement.Id) from Movement where DescId in (zc_Movement_Sale(), zc_Movement_ReturnIn()) and OperDate between ('01.09.2014')::TDateTime and  ('31.10.2014')::TDateTime
*/
