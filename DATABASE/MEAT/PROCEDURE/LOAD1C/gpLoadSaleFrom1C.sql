-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpLoadSaleFrom1C (TDateTime, TDateTime, TDateTime, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadSaleFrom1C(
    IN inStartDate           TDateTime  , -- Начальная дата переноса
    IN inEndDate             TDateTime  , -- Конечная дата переноса
    IN inOperDate            TDateTime  ,
    IN inInvNumber           TVarChar   ,
    IN inClientCode          Integer   ,
    IN inBranchId            Integer    , -- Филиал
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSaleCount Integer;
   DECLARE vbCount Integer;
   DECLARE curMovement refcursor;
   DECLARE curMovementItem refcursor;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;  
   DECLARE vbMovementId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitId_1C Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbOperCount TFloat;
   DECLARE vbOperPrice TFloat;
   DECLARE vbGoodsId Integer; 
   DECLARE vbGoodsKindId Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbDiscount TFloat;
   DECLARE vbMovementDescId Integer;
   DECLARE vbArticleLossId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);


     -- таблица - <Проводки>
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMIReport_insert (Id Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;

     -- !!!продажи!!! таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10500 Integer, ContainerId_ProfitLoss_10400 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_ChangePercent TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;

     -- !!!продажи!!! таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_GoodsPartner Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_ChangePercent TFloat, OperCount_Partner TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat
                               , ContainerId_ProfitLoss_10100 Integer, ContainerId_ProfitLoss_10200 Integer, ContainerId_ProfitLoss_10300 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean, isLossMaterials Boolean
                               , PartionGoodsId Integer
                               , PriceListPrice TFloat, Price TFloat, CountForPrice TFloat) ON COMMIT DROP;
                  

     -- !!!Продажи + Списание!!!

     -- Создание Документов                                   

     -- открыли курсор c учетом существующих документов
     OPEN curMovement FOR 
          SELECT DISTINCT Sale1C.InvNumber
                        , Sale1C.OperDate
                        , zfGetUnitFromUnitId (Sale1C.UnitId) AS UnitId
                        , Sale1C.UnitId AS UnitId_1C
                        , ObjectLink_Partner1CLink_Partner.ChildObjectId AS PartnerId
                        , tmpPartner1CLink.ContractId
                        , CASE WHEN Object_To.DescId = zc_Object_ArticleLoss()
                                    THEN Object_To.Id
                          END AS ArticleLossId
                        , Sale.Id AS MovementId
                        , CASE WHEN Object_To.DescId = zc_Object_Partner() THEN zc_Movement_Sale() ELSE zc_Movement_Loss() END AS MovementDescId
                        , zfGetPaidKindFrom1CType (Sale1C.VidDoc) AS PaidKindId
                        , round (Sale1C.Tax)
          FROM Sale1C
               JOIN (SELECT Object_Partner1CLink.Id          AS Partner1CLinkId
                          , Object_Partner1CLink.ObjectCode  AS ClientCode
                          , ObjectLink_Partner1CLink_Branch.ChildObjectId                 AS BranchId
                          , COALESCE (ObjectLink_Partner1CLink_Contract.ChildObjectId, 0) AS ContractId
                     FROM Object AS Object_Partner1CLink
                          INNER JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                                ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                               AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                          LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                               ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                              AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()                                 
                     WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                    ) AS tmpPartner1CLink ON tmpPartner1CLink.ClientCode = Sale1C.ClientCode
                                         AND tmpPartner1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))
               LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                    ON ObjectLink_Partner1CLink_Partner.ObjectId = tmpPartner1CLink.Partner1CLinkId
                                   AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               LEFT JOIN Object AS Object_To ON Object_To.Id= ObjectLink_Partner1CLink_Partner.ChildObjectId
               LEFT JOIN (SELECT Movement.Id, Movement.InvNumber, Movement.OperDate
                               , CASE WHEN Movement.DescId = zc_Movement_Sale()
                                           THEN MLO_To.ObjectId
                                      WHEN Object_To.DescId = zc_Object_Personal()
                                           THEN MLO_To.ObjectId
                                      WHEN Object_To.DescId = zc_Object_Unit()
                                           THEN MLO_To.ObjectId
                                      WHEN Movement.DescId = zc_Movement_Loss()
                                           THEN MLO_ArticleLoss.ObjectId
                                 END AS PartnerId
                          FROM Movement  
                               INNER JOIN MovementLinkObject AS MLO_From
                                                             ON MLO_From.MovementId = Movement.Id
                                                            AND MLO_From.DescId = zc_MovementLinkObject_From() 
                               LEFT JOIN MovementLinkObject AS MLO_To
                                                            ON MLO_To.MovementId = Movement.Id
                                                           AND MLO_To.DescId = zc_MovementLinkObject_To() 
                               LEFT JOIN Object AS Object_To ON Object_To.Id= MLO_To.ObjectId
                               LEFT JOIN MovementLinkObject AS MLO_ArticleLoss
                                                            ON MLO_ArticleLoss.MovementId = Movement.Id
                                                           AND MLO_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
                               INNER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                     ON ObjectLink_Unit_Branch.ObjectId = MLO_From.ObjectId
                                                    AND ObjectLink_Unit_Branch.ChildObjectId = inBranchId
                                                    AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                               INNER JOIN MovementBoolean AS MovementBoolean_isLoad 
                                                          ON MovementBoolean_isLoad.MovementId = Movement.Id
                                                         AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                                                         AND MovementBoolean_isLoad.ValueData = TRUE
                           WHERE Movement.DescId IN (zc_Movement_Sale(), zc_Movement_Loss())
                             AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                          ) AS Sale
                            ON Sale.InvNumber = Sale1C.InvNumber
                           AND Sale.OperDate = Sale1C.OperDate
                           AND ObjectLink_Partner1CLink_Partner.ChildObjectId = Sale.PartnerId
            
          WHERE Sale1C.InvNumber = inInvNumber AND Sale1C.OperDate = inOperDate AND Sale1C.ClientCode = inClientCode
            AND ((Sale1C.VIDDOC = '1') OR (Sale1C.VIDDOC = '2')) AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId)
            AND COALESCE (ObjectLink_Partner1CLink_Partner.ChildObjectId, 0) <> zc_Enum_InfoMoney_40801() -- Внутренний оборот
         ;

     -- начало цикла по курсору
     LOOP
          -- данные для Документа
          FETCH curMovement INTO vbInvNumber, vbOperDate, vbUnitId, vbUnitId_1C, vbPartnerId, vbContractId, vbArticleLossId, vbMovementId, vbMovementDescId, vbPaidKindId, vbDiscount;
          -- если такого периода и не возникнет, то мы выходим
          IF NOT FOUND THEN 
             EXIT;
          END IF;
          -- Распровели существующий документ
          IF COALESCE(vbMovementId, 0) <> 0 THEN
             PERFORM lpUnComplete_Movement (inMovementId := vbMovementId
                                          , inUserId     := vbUserId);
          END IF;

          IF vbMovementDescId = zc_Movement_Sale()
          THEN
          -- сохранили Документ - Sale
          SELECT tmp.ioId INTO vbMovementId
          FROM lpInsertUpdate_Movement_Sale (ioId := vbMovementId, inInvNumber := vbInvNumber, inInvNumberPartner := vbInvNumber, inInvNumberOrder := ''
                                           , inOperDate := vbOperDate, inOperDatePartner := vbOperDate, inChecked := FALSE, inPriceWithVAT := FALSE, inVATPercent := 20
                                           , inChangePercent := - vbDiscount, inFromId := vbUnitId, inToId := vbPartnerId, inPaidKindId:= vbPaidKindId
                                           , inContractId:= vbContractId, ioPriceListId:= 0, inRouteSortingId:= 0
                                           , inCurrencyDocumentId:= 14461 -- грн
                                           , inCurrencyPartnerId:= NULL
                                           , inUserId := vbUserId
                                            ) AS tmp;
          ELSE
          -- сохранили Документ - Loss
          SELECT tmp.ioId INTO vbMovementId
          FROM lpInsertUpdate_Movement_Loss (ioId := vbMovementId, inInvNumber := vbInvNumber
                                           , inOperDate := vbOperDate
                                           , inFromId := vbUnitId, inToId := vbPartnerId
                                           , inArticleLossId:= CASE WHEN vbArticleLossId <> 0
                                                                         THEN vbArticleLossId
                                                                    WHEN zc_Object_Personal() = (SELECT DescId FROM Object WHERE Id = vbPartnerId)
                                                                         THEN (SELECT Id FROM Object WHERE ObjectCode = 102 AND DescId = zc_Object_ArticleLoss()) -- ОТОВАРКА
                                                               END
                                           , inUserId := vbUserId
                                            ) AS tmp;
          END IF;

          -- сохранили свойство <Загружен из 1С>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), vbMovementId, TRUE);
          -- пометим записи на удаление ПОКА
          PERFORM gpSetErased_MovementItem(MovementItem.Id, inSession) FROM MovementItem WHERE MovementItem.MovementId = vbMovementId;
         
         
          -- открыли курсор
          OPEN curMovementItem FOR 
               SELECT OperCount, OperPrice, ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId AS GoodsId, ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId AS GoodsKindId
               FROM Sale1C 
                    JOIN (SELECT Object_GoodsByGoodsKind1CLink.Id AS ObjectId
                               , Object_GoodsByGoodsKind1CLink.ObjectCode
                               , ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId AS BranchId
                          FROM Object AS Object_GoodsByGoodsKind1CLink
                               LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                                    ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                                   AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                          WHERE Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
                         ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))
                                                       AND tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode

                    LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                         ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                                        AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()

                    LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                         ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                                        AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()
               WHERE Sale1C.InvNumber = vbInvNumber
                 AND Sale1C.OperDate = vbOperDate
                 AND Sale1C.UnitId = vbUnitId_1C
                 AND Sale1C.ClientCode = inClientCode
                 AND ((Sale1C.VIDDOC = '1') OR (Sale1C.VIDDOC = '2'));
          -- начало цикла по курсору
          LOOP
               -- данные для Элемента документа
               FETCH curMovementItem INTO vbOperCount, vbOperPrice, vbGoodsId, vbGoodsKindId;
               -- если такого периода и не возникнет, то мы выходим
               IF NOT FOUND THEN 
                  EXIT;
               END IF;

               IF vbMovementDescId = zc_Movement_Sale()
               THEN
               -- сохранили Элемент документа - Sale
               PERFORM lpInsertUpdate_MovementItem_Sale (ioId := 0, inMovementId := vbMovementId, inGoodsId := vbGoodsId
                                                       , inAmount := vbOperCount, inAmountPartner := vbOperCount, inAmountChangePercent := vbOperCount
                                                       , inChangePercentAmount := 0, inPrice := vbOperPrice, ioCountForPrice := 1 , inHeadCount := 0
                                                       , inPartionGoods := '', inGoodsKindId := vbGoodsKindId, inAssetId := 0, inUserId := vbUserId);

               ELSE
               -- сохранили Элемент документа - Loss
               PERFORM lpInsertUpdate_MovementItem_Loss (ioId := 0, inMovementId := vbMovementId, inGoodsId := vbGoodsId
                                                       , inAmount := vbOperCount, inCount := 0
                                                       , inHeadCount := 0
                                                       , inPartionGoodsDate:= NULL, inPartionGoods := '', inGoodsKindId := vbGoodsKindId, inAssetId := 0, inUserId := vbUserId);
               END IF;

          END LOOP; -- финиш цикла по курсору
          CLOSE curMovementItem; -- закрыли курсор


          IF vbMovementDescId = zc_Movement_Sale()
          THEN
               -- Провели существующий документ - Sale
               PERFORM lpComplete_Movement_Sale (inMovementId     := vbMovementId
                                               , inUserId         := vbUserId
                                               , inIsLastComplete := FALSE);
          ELSE
               -- Провели существующий документ - Loss
               PERFORM lpComplete_Movement_Loss (inMovementId     := vbMovementId
                                               , inUserId         := vbUserId
                                               , inIsLastComplete := FALSE);
        
          END IF;

     END LOOP; -- финиш цикла по курсору
     CLOSE curMovement; -- закрыли курсор


     -- !!!удаление!!!
     DROP TABLE _tmpItemSumm;
     DROP TABLE _tmpItem;
     -- !!!возвраты!!! таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10800 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- !!!возвраты!!!таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_GoodsPartner Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_Partner TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat
                               , ContainerId_ProfitLoss_10700 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_To Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean
                               , PartionGoodsId Integer
                               , Price TFloat, CountForPrice TFloat) ON COMMIT DROP;



     -- !!!Возвраты!!!

     -- Создание Документов

     -- открыли курсор
     OPEN curMovement FOR 
          SELECT DISTINCT Sale1C.InvNumber
                        , Sale1C.OperDate
                        , zfGetUnitFromUnitId (Sale1C.UnitId) AS vbUnitId
                        , Sale1C.UnitId AS vbUnitId
                        , ObjectLink_Partner1CLink_Partner.ChildObjectId AS PartnerId
                        , tmpPartner1CLink.ContractId
                        , MovementReturn.Id
                        , zfGetPaidKindFrom1CType(Sale1C.VidDoc) AS PaidKindId
                        , round(Sale1C.Tax)
          FROM Sale1C
               JOIN (SELECT Object_Partner1CLink.Id AS ObjectId
                          , Object_Partner1CLink.ObjectCode
                          , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                          , ObjectLink_Partner1CLink_Contract.ChildObjectId AS ContractId
                     FROM Object AS Object_Partner1CLink
                          LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                               ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                              AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                           JOIN ObjectLink AS ObjectLink_Partner1CLink_Contract
                                           ON ObjectLink_Partner1CLink_Contract.ObjectId = Object_Partner1CLink.Id
                                          AND ObjectLink_Partner1CLink_Contract.DescId = zc_ObjectLink_Partner1CLink_Contract()                                 
                     WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                    ) AS tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Sale1C.ClientCode
                                         AND tmpPartner1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))
               LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                    ON ObjectLink_Partner1CLink_Partner.ObjectId = tmpPartner1CLink.ObjectId
                                   AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner1CLink_Partner.ChildObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               LEFT JOIN  (SELECT Movement.Id, Movement.InvNumber, Movement.OperDate, MLO_From.ObjectId AS PartnerId 
                                FROM Movement  
          JOIN MovementLinkObject AS MLO_From
                                  ON MLO_From.MovementId = Movement.Id
                                 AND MLO_From.DescId = zc_MovementLinkObject_From() 
          JOIN MovementLinkObject AS MLO_To
                                  ON MLO_To.MovementId = Movement.Id
                                 AND MLO_To.DescId = zc_MovementLinkObject_To() 
          JOIN ObjectLink AS ObjectLink_Unit_Branch 
                          ON ObjectLink_Unit_Branch.ObjectId = MLO_To.ObjectId 
                         AND ObjectLink_Unit_Branch.ChildObjectId = inBranchId
                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          JOIN MovementBoolean AS MovementBoolean_isLoad 
                               ON MovementBoolean_isLoad.MovementId = Movement.Id
                              AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                              AND MovementBoolean_isLoad.valuedata = TRUE 
     WHERE Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId <> zc_Enum_Status_Erased()) AS MovementReturn
                          ON MovementReturn.InvNumber = Sale1C.InvNumber AND MovementReturn.OperDate = Sale1C.OperDate
                         AND MovementReturn.PartnerId = ObjectLink_Partner1CLink_Partner.ChildObjectId

          WHERE  Sale1C.InvNumber = inInvNumber AND Sale1C.OperDate = inOperDate AND Sale1C.ClientCode = inClientCode
            AND ((Sale1C.VIDDOC = '4') OR (Sale1C.VIDDOC = '3')) AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId);

     -- начало цикла по курсору
     LOOP
          -- данные для создания Документа
          FETCH curMovement INTO vbInvNumber, vbOperDate, vbUnitId, vbUnitId_1C, vbPartnerId, vbContractId, vbMovementId, vbPaidKindId, vbDiscount;
          -- если такого периода и не возникнет, то мы выходим
          IF NOT FOUND THEN 
             EXIT;
          END IF;

          -- Распровели существующий документ
          IF COALESCE(vbMovementId, 0) <> 0 THEN
             PERFORM lpUnComplete_Movement (inMovementId := vbMovementId
                                          , inUserId     := vbUserId);
          END IF;

          -- сохранили Документ

          SELECT tmp.ioId INTO vbMovementId
          FROM lpInsertUpdate_Movement_ReturnIn (ioId := vbMovementId, inInvNumber := vbInvNumber, inInvNumberPartner := vbInvNumber, inInvNumberMark := (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId AND DescId = zc_MovementString_InvNumberMark())
                                                          , inOperDate := vbOperDate, inOperDatePartner := vbOperDate, inChecked := FALSE, inPriceWithVAT := FALSE, inVATPercent := 20
                                                          , inChangePercent := - vbDiscount, inFromId := vbPartnerId, inToId := vbUnitId, inPaidKindId := vbPaidKindId
                                                          , inContractId := vbContractId
                                                          , inCurrencyDocumentId:= 14461 -- грн
                                                          , inCurrencyPartnerId := NULL
                                                          , inCurrencyValue     := NULL
                                                          , inUserId := vbUserId) AS tmp;

          -- сохранили свойство <Загружен из 1С>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), vbMovementId, TRUE);

          -- пометим записи на удаление ПОКА
          PERFORM gpSetErased_MovementItem(MovementItem.Id, inSession) FROM MovementItem WHERE MovementItem.MovementId = vbMovementId;

          -- открыли курсор
          OPEN curMovementItem FOR 
               SELECT OperCount, OperPrice, ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId AS GoodsId, ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId AS GoodsKindId
               FROM Sale1C
                    JOIN (SELECT Object_GoodsByGoodsKind1CLink.Id AS ObjectId
                               , Object_GoodsByGoodsKind1CLink.ObjectCode
                               , ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId AS BranchId
                          FROM Object AS Object_GoodsByGoodsKind1CLink
                               LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                                    ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                                   AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                          WHERE Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
                         ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.BranchId = zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))
                                                       AND tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode

                    LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                         ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                                        AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()

                    LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                         ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                                        AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()
               WHERE Sale1C.InvNumber = vbInvNumber
                 AND Sale1C.OperDate = vbOperDate
                 AND Sale1C.UnitId = vbUnitId_1C
                 AND Sale1C.ClientCode = inClientCode
                 AND ((Sale1C.VIDDOC = '3') OR (Sale1C.VIDDOC = '4'));

          -- начало цикла по курсору
          LOOP
               -- данные для Элемента документа
               FETCH curMovementItem INTO vbOperCount, vbOperPrice, vbGoodsId, vbGoodsKindId;
               -- если такого периода и не возникнет, то мы выходим
               IF NOT FOUND THEN 
                  EXIT;
               END IF;

               -- сохранили Элемент документа
              PERFORM lpInsertUpdate_MovementItem_ReturnIn (ioId := 0, inMovementId := vbMovementId, inGoodsId := vbGoodsId
                                                          , inAmount := vbOperCount, inAmountPartner := vbOperCount
                                                          , inPrice := vbOperPrice, ioCountForPrice := 1 , inHeadCount := 0
                                                          , inPartionGoods := '', inGoodsKindId := vbGoodsKindId, inAssetId := 0, inUserId := vbUserId);

          END LOOP; -- финиш цикла по курсору
          CLOSE curMovementItem; -- закрыли курсор

          -- Провели существующий документ
          PERFORM lpComplete_Movement_ReturnIn (inMovementId     := vbMovementId
                                              , inUserId         := vbUserId
                                              , inIsLastComplete := FALSE);
        
     END LOOP; -- финиш цикла по курсору
     CLOSE curMovement; -- закрыли курсор
    
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 07.09.14                                        * add Loss...
 17.08.14                                        * add MovementDescId
 14.08.14                        * новая связь с филиалами
 22.07.14                                        * add ...Price
 30.04.14                                        * lpComplete_Movement_ReturnIn
 28.04.14                                        * err 
 24.04.14                        * по одной записи
 24.04.14                                        * add inInvNumberMark
 18.04.14                        *  	Задваивал возвраты
 07.04.14                        * 
 31.03.14                        * 
 18.02.14                        * add inBranchId
 15.02.14                                        * исправил на "<>" там где Не все записи засинхронизированы
 15.02.14                                        * zfGetUnitFromUnitId
 13.02.14                        *  
 03.02.14                        *  
*/

-- тест
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
