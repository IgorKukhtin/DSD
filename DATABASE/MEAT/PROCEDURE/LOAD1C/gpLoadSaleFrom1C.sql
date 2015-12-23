-- Function: gpLoadSaleFrom1C()

DROP FUNCTION IF EXISTS gpLoadSaleFrom1C (TDateTime, TDateTime, TDateTime, TVarChar, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadSaleFrom1C(
    IN inStartDate           TDateTime  , -- Начальная дата переноса
    IN inEndDate             TDateTime  , -- Конечная дата переноса
    IN inOperDate            TDateTime  ,
    IN inInvNumber           TVarChar   ,
    IN inClientCode          Integer    ,
    IN inBranchId            Integer    , -- Филиал
    IN inVidDoc              TVarChar   ,
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
   DECLARE vbSumma TFloat;
   DECLARE vbGoodsId Integer; 
   DECLARE vbGoodsKindId Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbDiscount_min TFloat;
   DECLARE vbDiscount_max TFloat;
   DECLARE vbDiscount TFloat;
   DECLARE vbSumaPDV TFloat;
   DECLARE vbMovementDescId Integer;
   DECLARE vbMovementDescId_find Integer;
   DECLARE vbArticleLossId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);


     -- таблица - <Проводки>
     CREATE TEMP TABLE _tmpMIContainer_insert (MovementItemId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMIReport_insert (MovementItemId Integer) ON COMMIT DROP;
     -- !!!tmp!!! таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer) ON COMMIT DROP;
     -- !!!tmp!!! таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer) ON COMMIT DROP;

                  

     -- !!!Продажи + Списание!!!

     -- Создание Документов                                   

     -- открыли курсор c учетом существующих документов
     OPEN curMovement FOR 
                   SELECT Sale1C.InvNumber
                        , Sale1C.OperDate
                        , zfGetUnitFromUnitId (Sale1C.UnitId) AS UnitId
                        , Sale1C.UnitId AS UnitId_1C
                        , ObjectLink_Partner1CLink_Partner.ChildObjectId AS PartnerId
                        , tmpPartner1CLink.ContractId
                        , CASE WHEN Object_To.DescId = zc_Object_ArticleLoss()
                                    THEN Object_To.Id
                          END AS ArticleLossId
                        , 0 AS MovementId -- Sale.Id AS MovementId
                        , CASE WHEN Object_To.DescId = zc_Object_Partner() THEN zc_Movement_Sale() ELSE zc_Movement_Loss() END AS MovementDescId
                        -- , COALESCE (Sale.DescId, CASE WHEN Object_To.DescId = zc_Object_Partner() THEN zc_Movement_Sale() ELSE zc_Movement_Loss() END) AS MovementDescId_find
                        , CASE WHEN Object_To.DescId = zc_Object_Partner() THEN zc_Movement_Sale() ELSE zc_Movement_Loss() END AS MovementDescId_find
                        , zfGetPaidKindFrom1CType (Sale1C.VidDoc) AS PaidKindId
                        , MAX (round (COALESCE (Sale1C.Tax * 100, 0)) / 100) AS Discount_min
                        , MIN (round (COALESCE (Sale1C.Tax * 100, 0)) / 100) AS Discount_max
                        , CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                                    THEN MAX (round (COALESCE (Sale1C.Tax, 0)))
                               ELSE MAX (round (COALESCE (Sale1C.Tax * 10, 0))) / 10
                          END AS Discount
                        , MAX (SumaPDV) AS SumaPDV
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
               /*LEFT JOIN (SELECT Movement.Id, Movement.DescId, Movement.InvNumber, Movement.OperDate
                               , CASE WHEN Movement.DescId = zc_Movement_Sale()
                                           THEN MLO_To.ObjectId
                                      WHEN Object_To.DescId = zc_Object_Personal()
                                           THEN MLO_To.ObjectId
                                      WHEN Object_To.DescId = zc_Object_Unit()
                                           THEN MLO_To.ObjectId
                                      WHEN Movement.DescId = zc_Movement_Loss() AND MLO_ArticleLoss.ObjectId > 0
                                           THEN MLO_ArticleLoss.ObjectId
                                      ELSE MLO_To.ObjectId
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
                           AND ObjectLink_Partner1CLink_Partner.ChildObjectId = Sale.PartnerId*/
            
          WHERE Sale1C.InvNumber = inInvNumber AND Sale1C.OperDate = inOperDate AND Sale1C.ClientCode = inClientCode
            AND ((Sale1C.VIDDOC = '1') OR (Sale1C.VIDDOC = '2')) AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId)
            AND Sale1C.VIDDOC = inVidDoc
            AND COALESCE (ObjectLink_Partner1CLink_Partner.ChildObjectId, 0) <> zc_Enum_InfoMoney_40801() -- Внутренний оборот
                 GROUP BY Sale1C.InvNumber
                        , Sale1C.OperDate
                        , zfGetUnitFromUnitId (Sale1C.UnitId)
                        , Sale1C.UnitId
                        , ObjectLink_Partner1CLink_Partner.ChildObjectId
                        , tmpPartner1CLink.ContractId
                        , CASE WHEN Object_To.DescId = zc_Object_ArticleLoss()
                                    THEN Object_To.Id
                          END
                        -- , Sale.Id
                        , CASE WHEN Object_To.DescId = zc_Object_Partner() THEN zc_Movement_Sale() ELSE zc_Movement_Loss() END
                        -- , COALESCE (Sale.DescId, CASE WHEN Object_To.DescId = zc_Object_Partner() THEN zc_Movement_Sale() ELSE zc_Movement_Loss() END)
                        , zfGetPaidKindFrom1CType (Sale1C.VidDoc)
                        -- , round (Sale1C.Tax)
         ;

     -- начало цикла по курсору
     LOOP
          -- данные для Документа
          FETCH curMovement INTO vbInvNumber, vbOperDate, vbUnitId, vbUnitId_1C, vbPartnerId, vbContractId, vbArticleLossId, vbMovementId, vbMovementDescId, vbMovementDescId_find, vbPaidKindId, vbDiscount_min, vbDiscount_max, vbDiscount, vbSumaPDV;

          -- если такого периода и не возникнет, то мы выходим
          IF NOT FOUND THEN 
             EXIT;
          END IF;

          -- Распровели существующий документ
          /*IF COALESCE (vbMovementId, 0) <> 0 AND vbMovementDescId_find = vbMovementDescId
          THEN
              PERFORM lpUnComplete_Movement (inMovementId := vbMovementId
                                           , inUserId     := vbUserId);
          ELSE
              IF vbMovementDescId_find <> vbMovementDescId --  AND COALESCE (vbMovementId, 0) <> 0
              THEN
                  -- Удалили документ
                  PERFORM lpSetErased_Movement (inMovementId     := vbMovementId
                                              , inUserId         := vbUserId);
          END IF;
          END IF;*/

          IF vbMovementDescId = zc_Movement_Sale() AND vbMovementDescId = vbMovementDescId_find
          THEN
          -- сохранили Документ - Sale
          SELECT tmp.ioId INTO vbMovementId
          FROM lpInsertUpdate_Movement_Sale (ioId := vbMovementId, inInvNumber := vbInvNumber, inInvNumberPartner := vbInvNumber, inInvNumberOrder := ''
                                           , inOperDate := vbOperDate, inOperDatePartner := vbOperDate, inChecked := FALSE --, inPriceWithVAT := FALSE, inVATPercent := 20
                                           , inChangePercent := -1 * CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscount_min = vbDiscount_max THEN vbDiscount
                                                                          WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() THEN vbDiscount
                                                                          ELSE 0
                                                                     END
                                           , inFromId := vbUnitId, inToId := vbPartnerId, inPaidKindId:= vbPaidKindId
                                           , inContractId:= vbContractId, inRouteSortingId:= 0
                                           , inCurrencyDocumentId:= NULL
                                           , inCurrencyPartnerId:= NULL
                                           , inMovementId_Order := NULL
                                           , ioPriceListId:= CASE WHEN COALESCE (vbSumaPDV, 0) = 0 THEN (SELECT MAX (ObjectBoolean.ObjectId) FROM ObjectBoolean INNER JOIN ObjectFloat ON ObjectFloat.ObjectId = ObjectBoolean.ObjectId AND ObjectFloat.ValueData = 0 AND ObjectFloat.DescId = zc_ObjectFloat_PriceList_VATPercent() WHERE ObjectBoolean.ValueData = TRUE AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()) ELSE 0 END
                                           , ioCurrencyPartnerValue := NULL
                                           , ioParPartnerValue      := NULL
                                           , inUserId := vbUserId
                                            ) AS tmp;
          -- сохранили Property если продажа от Контрагента -> Контрагенту
          IF EXISTS (SELECT Id FROM Object WHERE Id = vbUnitId AND DescId = zc_Object_Partner())
          THEN
              PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), vbMovementId, Object_Contract_View.PaidKindId)
                    , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), vbMovementId, Object_Contract_View.ContractId)
              FROM ObjectLink AS ObjectLink_Partner_Juridical
                   INNER JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                  AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
              WHERE ObjectLink_Partner_Juridical.ObjectId = vbUnitId
                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical();
          END IF;

          ELSE

          IF vbMovementDescId = zc_Movement_Loss() AND vbMovementDescId_find = vbMovementDescId
          THEN
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
          END IF;

          -- сохранили свойство <Загружен из 1С>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), vbMovementId, TRUE);

          -- IF vbMovementDescId_find <> vbMovementDescId
          -- THEN
               -- пометим записи на удаление ПОКА
               -- PERFORM gpSetErased_MovementItem (MovementItem.Id, inSession) FROM MovementItem WHERE MovementItem.MovementId = vbMovementId;
          -- END IF;
         
         
          -- открыли курсор
          OPEN curMovementItem FOR 
               SELECT OperCount, OperPrice, SUMA, ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId AS GoodsId, ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId AS GoodsKindId
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
                 AND ((Sale1C.VIDDOC = '1') OR (Sale1C.VIDDOC = '2'))
                 AND Sale1C.VIDDOC = inVidDoc;
          -- начало цикла по курсору
          LOOP
               -- данные для Элемента документа
               FETCH curMovementItem INTO vbOperCount, vbOperPrice, vbSumma, vbGoodsId, vbGoodsKindId;
               -- если такого периода и не возникнет, то мы выходим
               IF NOT FOUND THEN 
                  EXIT;
               END IF;

               IF vbMovementDescId = zc_Movement_Sale() AND vbMovementDescId = vbMovementDescId_find
               THEN
               -- сохранили Элемент документа - Sale
               PERFORM lpInsertUpdate_MovementItem_Sale_BBB (ioId := 0, inMovementId := vbMovementId, inGoodsId := vbGoodsId
                                                       , inAmount := vbOperCount, inAmountPartner := vbOperCount, inAmountChangePercent := vbOperCount
                                                       , inChangePercentAmount := 0
                                                       , ioPrice := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscount_min = vbDiscount_max THEN vbOperPrice
                                                                         WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() THEN vbOperPrice
                                                                         WHEN vbOperCount <> 0 THEN vbSumma / vbOperCount
                                                                         ELSE 0
                                                                    END
                                                       , ioCountForPrice := 1 , inHeadCount := 0, inBoxCount:= 0
                                                       , inPartionGoods := '', inGoodsKindId := vbGoodsKindId, inAssetId := 0, inBoxId:= 0
                                                       , inCountPack    := 0
                                                       , inWeightTotal  := 0
                                                       , inWeightPack   := 0
                                                       , inIsBarCode    := FALSE
                                                       , inUserId := vbUserId);

               ELSE
               IF vbMovementDescId = zc_Movement_Loss() AND vbMovementDescId = vbMovementDescId_find
               THEN
               -- сохранили Элемент документа - Loss
               PERFORM lpInsertUpdate_MovementItem_Loss (ioId := 0, inMovementId := vbMovementId, inGoodsId := vbGoodsId
                                                       , inAmount := vbOperCount, inCount := 0
                                                       , inHeadCount := 0
                                                       , inPartionGoodsDate:= NULL, inPartionGoods := '', inGoodsKindId := vbGoodsKindId, inAssetId := 0, inPartionGoodsId:= 0, inUserId := vbUserId);
               END IF;
               END IF;

          END LOOP; -- финиш цикла по курсору
          CLOSE curMovementItem; -- закрыли курсор


          IF vbMovementDescId = zc_Movement_Sale() AND vbMovementDescId = vbMovementDescId_find
          THEN
              -- !!!удаление!!!
              DROP TABLE _tmpMIContainer_insert;
              DROP TABLE _tmpMIReport_insert;
              DROP TABLE _tmpItemSumm;
              DROP TABLE _tmpItem;
             -- создаются временные таблицы - для формирование данных для проводок
              PERFORM lpComplete_Movement_Sale_CreateTemp();
              -- Провели существующий документ - Sale
              PERFORM lpComplete_Movement_Sale (inMovementId     := vbMovementId
                                              , inUserId         := vbUserId
                                              , inIsLastComplete := FALSE);
          ELSE
          IF vbMovementDescId = zc_Movement_Loss() AND vbMovementDescId = vbMovementDescId_find
          THEN
              -- !!!удаление!!!
              DROP TABLE _tmpMIContainer_insert;
              DROP TABLE _tmpMIReport_insert;
              DROP TABLE _tmpItemSumm;
              DROP TABLE _tmpItem;
             -- создаются временные таблицы - для формирование данных для проводок
              PERFORM lpComplete_Movement_Loss_CreateTemp();
              -- Провели существующий документ - Loss
              PERFORM lpComplete_Movement_Loss (inMovementId     := vbMovementId
                                              , inUserId         := vbUserId);
          END IF;
          END IF;

     END LOOP; -- финиш цикла по курсору
     CLOSE curMovement; -- закрыли курсор


     -- !!!удаление!!!
     DROP TABLE _tmpMIContainer_insert;
     DROP TABLE _tmpMIReport_insert;
     DROP TABLE _tmpItemSumm;
     DROP TABLE _tmpItem;
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_ReturnIn_CreateTemp();

     -- !!!Возвраты!!!

     -- Создание Документов

     -- открыли курсор
     OPEN curMovement FOR 
                   SELECT Sale1C.InvNumber
                        , Sale1C.OperDate
                        , CASE WHEN zfGetUnitFromUnitId (Sale1C.UnitId) = 346093 THEN 346094 -- Склад ГП ф.Одесса -> Склад возвратов ф.Одесса 
                               ELSE zfGetUnitFromUnitId (Sale1C.UnitId)
                          END AS UnitId
                        , Sale1C.UnitId AS UnitId_1C
                        , ObjectLink_Partner1CLink_Partner.ChildObjectId AS PartnerId
                        , tmpPartner1CLink.ContractId
                        , 0 AS MovementId -- MovementReturn.Id AS MovementId
                        , zfGetPaidKindFrom1CType(Sale1C.VidDoc) AS PaidKindId
                        , MAX (round (COALESCE (Sale1C.Tax * 100, 0)) / 100) AS Discount_min
                        , MIN (round (COALESCE (Sale1C.Tax * 100, 0)) / 100) AS Discount_max
                        , CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                                    THEN MAX (round (COALESCE (Sale1C.Tax, 0)))
                               ELSE MAX (round (COALESCE (Sale1C.Tax * 10, 0))) / 10
                          END AS Discount
                        , MAX (SumaPDV) AS SumaPDV
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
               /*LEFT JOIN  (SELECT Movement.Id, Movement.InvNumber, Movement.OperDate, MLO_From.ObjectId AS PartnerId 
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
                         AND MovementReturn.PartnerId = ObjectLink_Partner1CLink_Partner.ChildObjectId*/

          WHERE  Sale1C.InvNumber = inInvNumber AND Sale1C.OperDate = inOperDate AND Sale1C.ClientCode = inClientCode
            AND ((Sale1C.VIDDOC = '4') OR (Sale1C.VIDDOC = '3')) AND inBranchId = zfGetBranchFromUnitId (Sale1C.UnitId)
            AND Sale1C.VIDDOC = inVidDoc
            AND COALESCE (ObjectLink_Partner1CLink_Partner.ChildObjectId, 0) <> zc_Enum_InfoMoney_40801() -- Внутренний оборот

                 GROUP BY Sale1C.InvNumber
                        , Sale1C.OperDate
                        , CASE WHEN zfGetUnitFromUnitId (Sale1C.UnitId) = 346093 THEN 346094 -- Склад ГП ф.Одесса -> Склад возвратов ф.Одесса 
                               ELSE zfGetUnitFromUnitId (Sale1C.UnitId)
                          END
                        , Sale1C.UnitId
                        , ObjectLink_Partner1CLink_Partner.ChildObjectId
                        , tmpPartner1CLink.ContractId
                        -- , MovementReturn.Id
                        , zfGetPaidKindFrom1CType(Sale1C.VidDoc)
                        -- , round(Sale1C.Tax)
      ;

     -- начало цикла по курсору
     LOOP
          -- данные для создания Документа
          FETCH curMovement INTO vbInvNumber, vbOperDate, vbUnitId, vbUnitId_1C, vbPartnerId, vbContractId, vbMovementId, vbPaidKindId, vbDiscount_min, vbDiscount_max, vbDiscount, vbSumaPDV;
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
          FROM lpInsertUpdate_Movement_ReturnIn (ioId := vbMovementId, inInvNumber := vbInvNumber, inInvNumberPartner := vbInvNumber
                                                          , inInvNumberMark := (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId AND DescId = zc_MovementString_InvNumberMark())
                                                          , inParentId          := NULL
                                                          , inOperDate := vbOperDate, inOperDatePartner := vbOperDate
                                                          , inChecked  := FALSE
                                                          , inIsPartner:= FALSE
                                                          , inPriceWithVAT := CASE WHEN COALESCE (vbSumaPDV, 0) = 0 THEN TRUE ELSE FALSE END
                                                          , inVATPercent := CASE WHEN COALESCE (vbSumaPDV, 0) = 0 THEN 0 ELSE 20 END
                                                          , inChangePercent := -1 * CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscount_min = vbDiscount_max THEN vbDiscount
                                                                                         WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() THEN vbDiscount
                                                                                         ELSE 0
                                                                                    END
                                                          , inFromId := vbPartnerId, inToId := vbUnitId, inPaidKindId := vbPaidKindId
                                                          , inContractId := vbContractId
                                                          , inCurrencyDocumentId:= 14461 -- грн
                                                          , inCurrencyPartnerId := NULL
                                                          , inCurrencyValue     := NULL
                                                          , inComment           := ''
                                                          , inUserId := vbUserId) AS tmp;

          -- сохранили свойство <Загружен из 1С>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), vbMovementId, TRUE);

          -- сохранили Property если продажа от Контрагента -> Контрагенту
          IF EXISTS (SELECT Id FROM Object WHERE Id = vbUnitId AND DescId = zc_Object_Partner())
          THEN
              PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), vbMovementId, Object_Contract_View.PaidKindId)
                    , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), vbMovementId, Object_Contract_View.ContractId)
              FROM ObjectLink AS ObjectLink_Partner_Juridical
                   INNER JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                  AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
              WHERE ObjectLink_Partner_Juridical.ObjectId = vbUnitId
                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical();
          END IF;


          -- пометим записи на удаление ПОКА
          -- PERFORM gpSetErased_MovementItem (MovementItem.Id, inSession) FROM MovementItem WHERE MovementItem.MovementId = vbMovementId;

          -- открыли курсор
          OPEN curMovementItem FOR 
               SELECT OperCount, OperPrice, SUMA, ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId AS GoodsId, ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId AS GoodsKindId
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
                 AND ((Sale1C.VIDDOC = '3') OR (Sale1C.VIDDOC = '4'))
                 AND Sale1C.VIDDOC = inVidDoc;

          -- начало цикла по курсору
          LOOP
               -- данные для Элемента документа
               FETCH curMovementItem INTO vbOperCount, vbOperPrice, vbSumma, vbGoodsId, vbGoodsKindId;
               -- если такого периода и не возникнет, то мы выходим
               IF NOT FOUND THEN 
                  EXIT;
               END IF;

               -- сохранили Элемент документа
              PERFORM lpInsertUpdate_MovementItem_ReturnIn (ioId := 0, inMovementId := vbMovementId, inGoodsId := vbGoodsId
                                                          , inAmount := vbOperCount, inAmountPartner := vbOperCount
                                                          , inPrice := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscount_min = vbDiscount_max THEN vbOperPrice
                                                                            WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() THEN vbOperPrice
                                                                            WHEN vbOperCount <> 0 THEN vbSumma / vbOperCount
                                                                            ELSE 0
                                                                       END
                                                          , ioCountForPrice := 1 , inHeadCount := 0
                                                          , inMovementId_Partion := 0
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
 08.11.14                                        * add _tmpList_Alternative
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
-- SELECT * FROM gpLoadSaleFrom1C ('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
