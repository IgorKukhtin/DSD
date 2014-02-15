-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpLoadSaleFrom1C (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadSaleFrom1C(
    IN inStartDate           TDateTime  , -- Начальная дата переноса
    IN inEndDate             TDateTime  , -- Конечная дата переноса
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
   DECLARE vbPartnerId Integer;
   DECLARE vbOperCount TFloat;
   DECLARE vbOperPrice TFloat;
   DECLARE vbGoodsId Integer; 
   DECLARE vbGoodsKindId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadSaleFrom1C());
     vbUserId := lpGetUserBySession (inSession);


     -- Определяем итого записей (для проверка что все для переноса установлено)
     SELECT COUNT(*) INTO vbSaleCount FROM Sale1C WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate;

     -- Определяем итого связанных записей (для проверка что все для переноса установлено)
     SELECT COUNT(*) INTO vbCount
     FROM Sale1C
          JOIN (SELECT Object_Partner1CLink.ObjectCode
                     , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                FROM Object AS Object_Partner1CLink
                     LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                          ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                         AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
               ) AS tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Sale1C.ClientCode
                                    AND tmpPartner1CLink.BranchId = zfGetBranchFromUnitId (Sale1C.UnitId)

          JOIN (SELECT Object_GoodsByGoodsKind1CLink.ObjectCode
                     , ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId AS BranchId
                FROM Object AS Object_GoodsByGoodsKind1CLink
                     LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                          ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                         AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                WHERE Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
               ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode
                                             AND tmpGoodsByGoodsKind1CLink.BranchId = zfGetBranchFromUnitId (Sale1C.UnitId)

    WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate;


     -- Проверка
     IF vbSaleCount <> vbCount THEN 
        RAISE EXCEPTION 'Ошибка.Не все записи засинхронизированы. Перенос не возможен. <%> <%>', vbSaleCount, vbCount; 
     END IF;


     -- !!!Продажи!!!

     -- Удаление Документов
     PERFORM gpSetErased_Movement (Movement.Id, inSession) 
     FROM Movement  
          JOIN MovementLinkObject AS MLO_From
                                  ON MLO_From.MovementId = Movement.Id
                                 AND MLO_From.DescId = zc_MovementLinkObject_From() 
                                 AND MIO_From.ObjectId IN (SELECT zfGetUnitFromUnitId (UnitId) FROM Sale1C GROUP BY zfGetUnitFromUnitId (UnitId))
          JOIN MovementBoolean AS MovementBoolean_isLoad 
                               ON MovementBoolean_isLoad.MovementId = Movement.Id
                              AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                              AND MovementBoolean_isLoad.ValueData = TRUE
     WHERE Movement.DescId = zc_Movement_Sale()
       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId <> zc_Enum_Status_Erased();


     -- Создание Документов

     -- открыли курсор
     OPEN curMovement FOR 
          SELECT DISTINCT InvNumber, OperDate, zfGetUnitFromUnitId(UnitId), ObjectLink_Partner1CLink_Partner.ChildObjectId AS PartnerId
          FROM Sale1C
               JOIN (SELECT Object_Partner1CLink.Id AS ObjectId
                          , Object_Partner1CLink.ObjectCode
                          , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                     FROM Object AS Object_Partner1CLink
                          LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                               ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                              AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                     WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                    ) AS tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Sale1C.ClientCode
                                         AND tmpPartner1CLink.BranchId = zfGetBranchFromUnitId (Sale1C.UnitId)
               LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                    ON ObjectLink_Partner1CLink_Partner.ObjectId = tmpPartner1CLink.ObjectId
                                   AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
          WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate
            AND Sale1C.VIDDOC = 1;

     -- начало цикла по курсору
     LOOP
          -- данные для Документа
          FETCH curMovement INTO vbInvNumber, vbOperDate, vbUnitId, vbPartnerId;
          -- если такого периода и не возникнет, то мы выходим
          IF NOT FOUND THEN 
             EXIT;
          END IF;
          -- сохранили Документ
          vbMovementId := lpInsertUpdate_Movement_Sale (ioId := 0, inInvNumber := vbInvNumber, inInvNumberPartner := '', inInvNumberOrder := ''
                                                      , inOperDate := vbOperDate, inOperDatePartner := vbOperDate, inChecked := FALSE, inPriceWithVAT := TRUE, inVATPercent := 20
                                                      , inChangePercent := 0, inFromId := vbUnitId, inToId := vbPartnerId, inPaidKindId := zc_Enum_PaidKind_FirstForm()
                                                      , inContractId := 0, inRouteSortingId := 0, inUserId := vbUserId);
          -- сохранили свойство <Загружен из 1С>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), vbMovementId, TRUE);

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
                         ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.BranchId = zfGetBranchFromUnitId (Sale1C.UnitId)
                                                       AND tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode

                    LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                         ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                                        AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()

                    LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                         ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                                        AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()
               WHERE InvNumber = vbInvNumber AND OperDate = vbOperDate
                 AND VIDDOC = 1;
          -- начало цикла по курсору
          LOOP
               -- данные для Элемента документа
               FETCH curMovementItem INTO vbOperCount, vbOperPrice, vbGoodsId, vbGoodsKindId;
               -- если такого периода и не возникнет, то мы выходим
               IF NOT FOUND THEN 
                  EXIT;
               END IF;

               -- сохранили Элемент документа
               PERFORM lpInsertUpdate_MovementItem_Sale (ioId := 0, inMovementId := vbMovementId, inGoodsId := vbGoodsId
                                                       , inAmount := vbOperCount, inAmountPartner := vbOperCount, inAmountChangePercent := vbOperCount
                                                       , inChangePercentAmount := 0, inPrice := vbOperPrice, inCountForPrice := 1 , inHeadCount := 0
                                                       , inPartionGoods := '', inGoodsKindId := vbGoodsKindId, inAssetId := 0, inUserId := vbUserId);

          END LOOP; -- финиш цикла по курсору
          CLOSE curMovementItem; -- закрыли курсор
        
     END LOOP; -- финиш цикла по курсору
     CLOSE curMovement; -- закрыли курсор


     -- !!!Возвраты!!!

     -- Удаление Документов
     PERFORM gpSetErased_Movement(Movement.Id, inSession) 
     FROM Movement  
          JOIN MovementLinkObject AS MLO_To
                                  ON MLO_To.MovementId = Movement.Id
                                 AND MLO_To.DescId = zc_MovementLinkObject_To() 
                                 AND MLO_To.ObjectId IN (SELECT zfGetUnitFromUnitId (UnitId) FROM Sale1C GROUP BY zfGetUnitFromUnitId (UnitId))
          JOIN MovementBoolean AS MovementBoolean_isLoad 
                               ON MovementBoolean_isLoad.MovementId = Movement.Id
                              AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                              AND MovementBoolean_isLoad.valuedata = TRUE 
     WHERE Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId <> zc_Enum_Status_Erased();


     -- Создание Документов

     -- открыли курсор
     OPEN curMovement FOR 
          SELECT DISTINCT InvNumber, OperDate, zfGetUnitFromUnitId (UnitId), ObjectLink_Partner1CLink_Partner.ChildObjectId AS PartnerId
          FROM Sale1C
               JOIN (SELECT Object_Partner1CLink.Id AS ObjectId
                          , Object_Partner1CLink.ObjectCode
                          , ObjectLink_Partner1CLink_Branch.ChildObjectId  AS BranchId
                     FROM Object AS Object_Partner1CLink
                          LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                               ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                              AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
                     WHERE Object_Partner1CLink.DescId =  zc_Object_Partner1CLink()
                    ) AS tmpPartner1CLink ON tmpPartner1CLink.ObjectCode = Sale1C.ClientCode
                                         AND tmpPartner1CLink.BranchId = zfGetBranchFromUnitId (Sale1C.UnitId)
               LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                    ON ObjectLink_Partner1CLink_Partner.ObjectId = tmpPartner1CLink.ObjectId
                                   AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
          WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate
            AND Sale1C.VIDDOC = 4;

     -- начало цикла по курсору
     LOOP
          -- данные для создания Документа
          FETCH curMovement INTO vbInvNumber, vbOperDate, vbUnitId, vbPartnerId;
          -- если такого периода и не возникнет, то мы выходим
          IF NOT FOUND THEN 
             EXIT;
          END IF;

          -- сохранили Документ
          vbMovementId := lpInsertUpdate_Movement_ReturnIn (ioId := 0, inInvNumber := vbInvNumber
                                                          , inOperDate := vbOperDate, inOperDatePartner := vbOperDate, inChecked := FALSE, inPriceWithVAT := TRUE, inVATPercent := 20
                                                          , inChangePercent := 0, inFromId := vbPartnerId, inToId := vbUnitId, inPaidKindId := zc_Enum_PaidKind_FirstForm()
                                                          , inContractId := 0, inDocumentTaxKindId := 0, inUserId := vbUserId);
          -- сохранили свойство <Загружен из 1С>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), vbMovementId, TRUE);

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
                         ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.BranchId = zfGetBranchFromUnitId (Sale1C.UnitId)
                                                       AND tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode

                    LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                         ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                                        AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()

                    LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                         ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = tmpGoodsByGoodsKind1CLink.ObjectId
                                        AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()
               WHERE InvNumber = vbInvNumber AND OperDate = vbOperDate
                 AND VIDDOC = 4;

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
                                                          , inPrice := vbOperPrice, inCountForPrice := 1 , inHeadCount := 0
                                                          , inPartionGoods := '', inGoodsKindId := vbGoodsKindId, inAssetId := 0, inUserId := vbUserId);

          END LOOP; -- финиш цикла по курсору
          CLOSE curMovementItem; -- закрыли курсор
        
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
 15.02.14                                        * исправил на "<>" там где Не все записи засинхронизированы
 15.02.14                                        * zfGetUnitFromUnitId
 13.02.14                        *  
 03.02.14                        *  
*/

-- тест
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')
