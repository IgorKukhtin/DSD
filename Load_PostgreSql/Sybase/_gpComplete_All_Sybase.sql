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
BEGIN
/*
 -- 1.1.
 IF '' <> lpUpdate_Movement_ReturnIn_Auto (inMovementId    := inMovementId
                                         , inStartDateSale := (SELECT OperDate - INTERVAL '6 MONTH' FROM Movement WHERE Id = inMovementId)
                                         , inEndDateSale   := (SELECT OperDate - INTERVAL '1 DAY' FROM Movement WHERE Id = inMovementId)
                                         , inUserId        := zfCalc_UserAdmin() :: Integer
                                          )
 THEN
     -- 1.3. сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inMovementId, '?????' || COALESCE (' ' || MovementString.ValueData, ''))
     FROM Movement
          LEFT JOIN MovementString ON MovementString.MovementId = Movement.Id AND MovementString.DescId = zc_MovementString_Comment()
     WHERE Movement.Id = inMovementId;
END IF;

RETURN;
*/
/*
if exists (select 1
     FROM Movement
     where Movement.Id = inMovementId
       AND Movement.OperDate = '21.04.2016'
       AND Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.StatusId = zc_Enum_Status_Complete()
)

then
RAISE EXCEPTION '0k';
end if;
*/
/*
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--- !!!!!!!!!!!!!!!START - _gpComplete_SelectAll_Sybase__ReturnIn!!!!!!!!!!!!!!!
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if exists (select 1
     FROM Movement
          INNER JOIN MovementLinkObject AS MLO_PaidKind ON MLO_PaidKind.MovementId = Movement.Id
                                                       AND MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                       AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()

          INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                          ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                         AND MovementLinkMovement_Master.DescId          = zc_MovementLinkMovement_Master()
          -- только проведенные корр.
          INNER JOIN Movement AS Movement2 ON Movement2.Id       = MovementLinkMovement_Master.MovementId
                                          AND Movement2.DescId   = zc_Movement_TaxCorrective()
                                          AND Movement2.StatusId = zc_Enum_Status_Complete()
     WHERE Movement.Id = inMovementId
       AND Movement.OperDate BETWEEN '01.01.2016' AND '30.04.2016'
       AND Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.StatusId = zc_Enum_Status_Complete()
)

then

 -- 1.1.
 PERFORM lpUpdate_Movement_ReturnIn_fromTax_tmp (inMovementId:= inMovementId
                                               , inUserId    := zfCalc_UserAdmin() :: Integer
                                                );

 -- 1.2.
 IF '' <> lpCheck_Movement_ReturnIn_Auto (inMovementId    := inMovementId
                                        , inUserId        := zfCalc_UserAdmin() :: Integer
                                         )
 THEN
     -- 1.3. сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inMovementId, '***' || COALESCE (' ' || MovementString.ValueData, ''))
     FROM Movement
          LEFT JOIN MovementString ON MovementString.MovementId = Movement.Id AND MovementString.DescId = zc_MovementString_Comment()
     WHERE Movement.Id = inMovementId;
END IF;

RETURN;

--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--- !!!!!!!!!!!!!!!END - _gpComplete_SelectAll_Sybase__ReturnIn!!!!!!!!!!!!!!!
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


else 

 if   exists (SELECT 1
     FROM Movement
          INNER JOIN MovementLinkObject AS MLO_PaidKind ON MLO_PaidKind.MovementId = Movement.Id
                                                       AND MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                       AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()

          INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                        ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                       AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                                       AND MovementLinkObject_DocumentTaxKind.ObjectId  IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()
                                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()
                                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                                                                           )

     WHERE Movement.Id = inMovementId
       AND Movement.OperDate BETWEEN '01.12.2015' AND '30.05.2016'
       AND Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.StatusId = zc_Enum_Status_Complete()
)

then 

--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--- !!!!!!!!!!!!!!!START - lpUpdate_Movement_ReturnIn_Auto_OLD!!!!!!!!!!!!!!!
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


 -- 2.1.
 IF '' <> (SELECT lpUpdate_Movement_ReturnIn_Auto_OLD (inMovementId:= Movement.Id
                                                     , inStartDateSale:= Movement.OperDate - INTERVAL '2 MONTH'
                                                     , inEndDateSale:= Movement.OperDate
                                                     , inUserId    := zfCalc_UserAdmin() :: Integer
                                                      ) AS tmp
           FROM Movement WHERE Id = inMovementId)
 THEN
     -- 2.2. сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inMovementId, '***' || COALESCE (' ' || MovementString.ValueData, ''))
     FROM Movement
          LEFT JOIN MovementString ON MovementString.MovementId = Movement.Id AND MovementString.DescId = zc_MovementString_Comment()
     WHERE Movement.Id = inMovementId;
END IF;

RETURN;

--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--- !!!!!!!!!!!!!!!END - lpUpdate_Movement_ReturnIn_Auto_OLD!!!!!!!!!!!!!!!
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


else 

 if   exists (SELECT 1
     FROM Movement
          INNER JOIN MovementLinkObject AS MLO_PaidKind ON MLO_PaidKind.MovementId = Movement.Id
                                                       AND MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                       AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                        ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                       AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
     WHERE Movement.Id = inMovementId
       AND Movement.OperDate BETWEEN '01.05.2016' AND '30.05.2016'
       AND Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND MovementLinkObject_DocumentTaxKind.ObjectId  IS NULL
)

then 

--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--- !!!!!!!!!!!!!!!START - 33333333333333333333333333333333333!!!!!!!!!!!!!!!
--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 -- 3.1.
 PERFORM lpUpdate_Movement_ReturnIn_Auto (inMovementId:= inMovementId
                                               , inStartDateSale       := Movement.OperDate - INTERVAL '2 MONTH'
                                               , inEndDateSale         := Movement.OperDate - INTERVAL '1 DAY'
                                               , inUserId    := zfCalc_UserAdmin() :: Integer
                                                )
 from MOvement where Id = inMovementId;

 -- 3.2.
 IF '' <> lpCheck_Movement_ReturnIn_Auto (inMovementId    := inMovementId
                                        , inUserId        := zfCalc_UserAdmin() :: Integer
                                         )
 THEN
     -- 3.3. сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inMovementId, '***' || COALESCE (' ' || MovementString.ValueData, ''))
     FROM Movement
          LEFT JOIN MovementString ON MovementString.MovementId = Movement.Id AND MovementString.DescId = zc_MovementString_Comment()
     WHERE Movement.Id = inMovementId;
END IF;

RETURN;

END IF;
END IF;
END IF;


if exists (select 1
     FROM Movement
     WHERE Movement.Id = inMovementId
       AND Movement.OperDate < '01.05.2016'
        )

then
         RAISE EXCEPTION 'OperDate < 01.05.2016';
end if;
*/


     -- нашли
     SELECT DescId, StatusId INTO vbMovementDescId, vbStatusId FROM Movement WHERE Id = inMovementId;
     -- !!!выход!!!
     IF vbStatusId <> zc_Enum_Status_Complete() THEN RETURN; END IF;


     -- !!!выход!!!
     -- IF vbMovementDescId IN (zc_Movement_Sale()) THEN RETURN; END IF;

     -- !!!проверка!!!
     IF COALESCE (vbMovementDescId, 0) = 0
     THEN
         RAISE EXCEPTION 'NOT FIND, inMovementId = %', inMovementId;
     END IF;


     -- !!!выход - Инвентаризация!!!
     IF vbMovementDescId = zc_Movement_Inventory() AND EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) BETWEEN 8 AND 15
     -- IF vbMovementDescId = zc_Movement_Inventory() AND EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) BETWEEN 10 AND 15
     THEN 
         IF EXTRACT ('MINUTES' FROM CURRENT_TIMESTAMP) BETWEEN 40 AND 59 OR EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) > 8
         -- IF EXTRACT ('MINUTES' FROM CURRENT_TIMESTAMP) BETWEEN 25 AND 59 OR EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) > 10
         THEN 
             RETURN; 
         END IF;
     END IF;



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
     IF vbMovementDescId = zc_Movement_Loss()
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
                                                 , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer
                                                 , inIsLastComplete := FALSE); -- inIsNoHistoryCost);

     ELSE
     -- !!!4 - Sale!!!
     IF vbMovementDescId = zc_Movement_Sale()
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
     IF vbMovementDescId = zc_Movement_Send()
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
     IF vbMovementDescId = zc_Movement_Income() AND 1=0
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


END;$BODY$
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