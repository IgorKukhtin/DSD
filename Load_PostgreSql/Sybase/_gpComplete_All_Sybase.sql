-- Function: gpComplete_All_Sybase()

DROP FUNCTION IF EXISTS gpComplete_All_Sybase (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_All_Sybase(
    IN inMovementId        Integer              , -- ���� ���������
    IN inIsNoHistoryCost   Boolean              , --
    IN inSession           TVarChar               -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN

     -- �����
     SELECT DescId, StatusId, OperDate INTO vbMovementDescId, vbStatusId, vbOperDate FROM Movement WHERE Id = inMovementId;
     -- !!!�����!!!
     IF vbStatusId <> zc_Enum_Status_Complete() THEN RETURN; END IF;


     -- !!!�����!!!
     -- IF vbMovementDescId IN (zc_Movement_Inventory()) THEN RETURN; END IF;
     -- IF vbMovementDescId IN (zc_Movement_Sale()) THEN RETURN; END IF;

     -- !!!��������!!!
     IF COALESCE (vbMovementDescId, 0) = 0
     THEN
         RAISE EXCEPTION 'NOT FIND, inMovementId = %', inMovementId;
     END IF;

/*
     -- !!!����� - ��������������!!!
     IF vbMovementDescId = zc_Movement_Inventory() AND EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) BETWEEN 20 AND 23 AND EXTRACT ('MONTH' FROM vbOperDate) <> EXTRACT ('MONTH' FROM CURRENT_DATE) THEN RETURN; END IF;
     IF vbMovementDescId = zc_Movement_Inventory() AND EXTRACT ('HOUR' FROM CURRENT_TIMESTAMP) BETWEEN 0  AND 4  AND EXTRACT ('MONTH' FROM vbOperDate) <> EXTRACT ('MONTH' FROM CURRENT_DATE) THEN RETURN; END IF;

     -- !!!����� - ��������������!!!
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


     -- !!! �������������!!!
     PERFORM lpUnComplete_Movement (inMovementId:= inMovementId, inUserId:= zc_Enum_Process_Auto_PrimeCost() :: Integer);


     -- !!!0 - PriceCorrective!!!
     IF vbMovementDescId = zc_Movement_PriceCorrective() AND 1=0
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             PERFORM lpComplete_Movement_PriceCorrective_CreateTemp();
             -- !!! �������� - Loss !!!
             PERFORM lpComplete_Movement_PriceCorrective (inMovementId     := inMovementId
                                                        , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer);

     ELSE
     -- !!!1 - Loss!!!
     IF vbMovementDescId = zc_Movement_Loss()
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             PERFORM lpComplete_Movement_Loss_CreateTemp();
             -- !!! �������� - Loss !!!
             PERFORM lpComplete_Movement_Loss (inMovementId     := inMovementId
                                             , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer);

     ELSE
     -- !!!2 - SendOnPrice!!!
     IF vbMovementDescId = zc_Movement_SendOnPrice()
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             PERFORM lpComplete_Movement_SendOnPrice_CreateTemp();
             -- !!! �������� - SendOnPrice !!!
             -- PERFORM lpComplete_Movement_SendOnPrice_Price (inMovementId     := inMovementId
             PERFORM lpComplete_Movement_SendOnPrice (inMovementId     := inMovementId
                                                    , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer);

     ELSE
     -- !!!3 - ReturnIn!!!
     IF vbMovementDescId = zc_Movement_ReturnIn()
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             PERFORM lpComplete_Movement_ReturnIn_CreateTemp();
             -- !!! �������� - ReturnIn !!!
             PERFORM lpComplete_Movement_ReturnIn (inMovementId     := inMovementId
                                                 , inStartDateSale  := NULL
                                                 , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer
                                                 , inIsLastComplete := FALSE); -- inIsNoHistoryCost);

     ELSE
     -- !!!4 - Sale!!!
     IF vbMovementDescId = zc_Movement_Sale()
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             PERFORM lpComplete_Movement_Sale_CreateTemp();
             -- !!! �������� - Sale !!!
             PERFORM lpComplete_Movement_Sale (inMovementId     := inMovementId
                                             , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer
                                             , inIsLastComplete := FALSE); -- inIsNoHistoryCost);
     ELSE
     -- !!!5 - ReturnOut!!!
     IF vbMovementDescId = zc_Movement_ReturnOut()
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             PERFORM lpComplete_Movement_ReturnOut_CreateTemp();
             -- !!! �������� - ReturnOut !!!
             PERFORM lpComplete_Movement_ReturnOut (inMovementId     := inMovementId
                                                  , inUserId         := zc_Enum_Process_Auto_PrimeCost() :: Integer
                                                  , inIsLastComplete := NULL); -- inIsNoHistoryCost);

     ELSE
     -- !!!6.1. - Send!!!
     IF vbMovementDescId = zc_Movement_Send()
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             -- PERFORM lpComplete_Movement_Send_CreateTemp();
             -- !!! �������� - Send !!!
             PERFORM gpComplete_Movement_Send (inMovementId     := inMovementId
                                             , inIsLastComplete := TRUE
                                             , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
     ELSE
     -- !!!6.2. - ProductionUnion!!!
     IF vbMovementDescId = zc_Movement_ProductionUnion()
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             -- PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
             -- !!! �������� - ProductionUnion !!!
             PERFORM gpComplete_Movement_ProductionUnion (inMovementId     := inMovementId
                                                        , inIsLastComplete := TRUE
                                                        , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
     ELSE
     -- !!!6.3. - ProductionSeparate!!!
     IF vbMovementDescId = zc_Movement_ProductionSeparate()
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             -- PERFORM lpComplete_Movement_ProductionSeparate_CreateTemp();
             -- !!! �������� - ProductionSeparate !!!
             PERFORM gpComplete_Movement_ProductionSeparate (inMovementId     := inMovementId
                                                           , inIsLastComplete := TRUE
                                                           , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
     ELSE
     -- !!!10.1 - Cash!!!
     IF vbMovementDescId = zc_Movement_Cash() AND 1=0
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! �������� - Cash !!!
             PERFORM gpComplete_Movement_Cash (inMovementId     := inMovementId
                                             , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!10.2 - BankAccount!!!
     IF vbMovementDescId = zc_Movement_BankAccount() AND 1=0
     THEN
             -- !!! �������� - BankAccount !!!
             PERFORM gpComplete_Movement_BankAccount (inMovementId     := inMovementId
                                                    , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!11. - SendDebt!!!
     IF vbMovementDescId = zc_Movement_SendDebt() AND 1=0
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! �������� - SendDebt !!!
             PERFORM gpComplete_Movement_SendDebt (inMovementId     := inMovementId
                                                 , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!12.1. - PersonalReport!!!
     IF vbMovementDescId = zc_Movement_PersonalReport() AND 1=0
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! �������� - Service !!!
             PERFORM gpComplete_Movement_PersonalReport (inMovementId     := inMovementId
                                                       , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
     ELSE
     -- !!!12.2. - Service!!!
     IF vbMovementDescId = zc_Movement_Service() AND 1=0
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! �������� - Service !!!
             PERFORM gpComplete_Movement_Service (inMovementId     := inMovementId
                                                , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!13. - PersonalAccount!!!
     IF vbMovementDescId = zc_Movement_PersonalAccount() AND 1=0
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! �������� - PersonalAccount !!!
             PERFORM gpComplete_Movement_PersonalAccount (inMovementId     := inMovementId
                                                        , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!14.1. - ProfitLossService!!!
     IF vbMovementDescId = zc_Movement_ProfitLossService() AND 1=0
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             -- PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- !!! �������� - ProfitLossService !!!
             PERFORM gpComplete_Movement_ProfitLossService (inMovementId     := inMovementId
                                                          , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!14.2. - zc_Movement_PersonalSendCash!!!
     IF vbMovementDescId = zc_Movement_PersonalSendCash() AND 1=0
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             PERFORM lpComplete_Movement_PersonalSendCash_CreateTemp();
             -- �������� ��������
             PERFORM lpComplete_Movement_PersonalSendCash (inMovementId := inMovementId
                                                         , inUserId     := zc_Enum_Process_Auto_PrimeCost());
     ELSE
     -- !!!14.3. - zc_Movement_TransportService!!!
     IF vbMovementDescId = zc_Movement_TransportService() AND 1=0
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             PERFORM lpComplete_Movement_Finance_CreateTemp();
             -- �������� ��������
             PERFORM lpComplete_Movement_TransportService (inMovementId := inMovementId
                                                         , inUserId     := zc_Enum_Process_Auto_PrimeCost());
     ELSE


     -- !!!14. - Income!!!
     IF vbMovementDescId = zc_Movement_Income() AND 1=0
     THEN
             -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
             PERFORM lpComplete_Movement_Income_CreateTemp();
             -- !!! �������� - Income !!!
             PERFORM lpComplete_Movement_Income (inMovementId     := inMovementId
                                               , inUserId         := zc_Enum_Process_Auto_PrimeCost()
                                               , inIsLastComplete := TRUE);
     ELSE

     -- !!!15.1 - TransferDebtIn!!!
     IF vbMovementDescId = zc_Movement_TransferDebtIn() AND 1=0
     THEN
             -- !!! �������� - TransferDebtIn !!!
             PERFORM gpComplete_Movement_TransferDebtIn (inMovementId     := inMovementId
                                                       , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!15.2. - TransferDebtOut!!!
     IF vbMovementDescId = zc_Movement_TransferDebtOut() AND 1=0
     THEN
             -- !!! �������� - TransferDebtOut !!!
             PERFORM gpComplete_Movement_TransferDebtOut (inMovementId     := inMovementId
                                                        , inSession        := zfCalc_UserAdmin());
     ELSE

     -- !!!16 - Inventory!!!
     IF vbMovementDescId = zc_Movement_Inventory() AND 1=1 -- !!!ADD!!!
     THEN
             -- !!! �������� - Inventory !!!
             PERFORM gpComplete_Movement_Inventory (inMovementId     := inMovementId
                                                  , inIsLastComplete := NULL
                                                  , inSession        := zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
     ELSE

     -- !!!17 - IncomeCost!!!
     IF vbMovementDescId = zc_Movement_IncomeCost() AND 1=1 -- !!!ADD!!!
     THEN
             -- !!! �������� - IncomeCost !!!
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


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.11.14                                        *
*/

-- ����
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