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
   DECLARE cursMovement refcursor;
   DECLARE cursMovementItem refcursor;
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
--     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount_From_BankS());

     -- Проверка что все для переноса установлено
     SELECT COUNT(*) INTO vbSaleCount 
      FROM Sale1C  
     WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate;

     SELECT COUNT(*) INTO vbCount
      FROM Sale1C
      JOIN Object AS Object_DeliveryPoint ON Sale1C.ClientCode = Object_DeliveryPoint.ObjectCode
       AND Object_DeliveryPoint.DescId =  zc_Object_Partner1CLink()
      JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
        ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_DeliveryPoint.Id
       AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
       AND ObjectLink_Partner1CLink_Branch.ChildObjectId = zfGetBranchFromUnitId(Sale1C.UnitId)
      JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
        ON ObjectLink_Partner1CLink_Partner.ObjectId = ObjectLink_Partner1CLink_Branch.ObjectId
       AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
      JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId


      JOIN Object AS Object_GoodsByGoodsKind1CLink ON Sale1C.GoodsCode = Object_GoodsByGoodsKind1CLink.ObjectCode
       AND Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
       
      JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
        ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
       AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
       AND ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId = zfGetUnitId(Sale1C.UnitId)
      JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind
        ON ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId
       AND ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind()
      JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.ChildObjectId
     WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate;

     IF vbSaleCount > vbCount THEN 
        RAISE EXCEPTION 'Не все записи засинхронизированы. Перенос не возможен'; 
     END IF;

     -- Помечаем на удаление загруженных Sale

    PERFORM gpSetErased_Movement(Movement.Id, inSession) 
       FROM Movement  
       JOIN MovementLinkObject AS MIO_From ON MIO_From.movementid = Movement.id
        AND MIO_From.descid = zc_MovementLinkObject_From() 
        AND MIO_From.objectid IN (SELECT zfGetUnitFromUnitId(UnitId) FROM Sale1C GROUP BY zfGetUnitFromUnitId(UnitId))
       JOIN movementboolean AS movementboolean_isLoad 
         ON movementboolean_isLoad.movementid = Movement.id
        AND movementboolean_isLoad.descid = zc_movementBoolean_isLoad()
        AND movementboolean_isLoad.valuedata = true 
      WHERE Movement.descid = zc_movement_sale()
        AND Movement.OperDate BETWEEN inStartDate AND inEndDate; 


     OPEN cursMovement FOR 
        SELECT DISTINCT InvNumber, OperDate, zfGetUnitFromUnitId(UnitId), ObjectLink_Partner1CLink_Partner.ChildObjectId 
          FROM Sale1C 
          JOIN Object AS Object_DeliveryPoint ON Sale1C.ClientCode = Object_DeliveryPoint.ObjectCode
           AND Object_DeliveryPoint.DescId =  zc_Object_Partner1CLink()
          JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
            ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_DeliveryPoint.Id
           AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
           AND ObjectLink_Partner1CLink_Branch.ChildObjectId = zfGetBranchFromUnitId(Sale1C.UnitId)
          JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
            ON ObjectLink_Partner1CLink_Partner.ObjectId = ObjectLink_Partner1CLink_Branch.ObjectId
           AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
         WHERE OperDate BETWEEN inStartDate AND inEndDate; --открываем курсор
     LOOP --начинаем цикл по курсору
          --извлекаем данные из строки и записываем их в переменные
        FETCH cursMovement INTO vbInvNumber, vbOperDate, vbUnitId, vbPartnerId;
        --если такого периода и не возникнет, то мы выходим
        IF NOT FOUND THEN 
           EXIT;
        END IF;
        vbMovementId := lpInsertUpdate_Movement_Sale(ioId := 0, inInvNumber := vbInvNumber, inInvNumberPartner := '', inInvNumberOrder := '', 
                          inOperDate := vbOperDate, inOperDatePartner := vbOperDate, inChecked := false, inPriceWithVAT := true, inVATPercent := 20, 
                          inChangePercent := 0, inFromId := vbUnitId, inToId := vbPartnerId, inPaidKindId := zc_Enum_PaidKind_FirstForm(), inContractId := 0, inRouteSortingId := 0, inUserId := vbUserId);
        -- сохранили свойство <Проверен>
        PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), vbMovementId, true);

        OPEN cursMovementItem FOR 
        SELECT OperCount, OperPrice, Object_GoodsByGoodsKind_View.GoodsId, Object_GoodsByGoodsKind_View.GoodsKindId

          FROM Sale1C 
          JOIN Object AS Object_GoodsByGoodsKind1CLink ON Sale1C.GoodsCode = Object_GoodsByGoodsKind1CLink.ObjectCode
           AND Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
          JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
            ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
           AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
           AND ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId = zfGetBranchFromUnitId(Sale1C.UnitId)
          JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind
            ON ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId
           AND ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind()
          JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.ChildObjectId

         WHERE InvNumber = vbInvNumber AND OperDate = vbOperDate; --открываем курсор;
        LOOP
          FETCH cursMovementItem INTO vbOperCount, vbOperPrice, vbGoodsId, vbGoodsKindId;
          --если такого периода и не возникнет, то мы выходим
          IF NOT FOUND THEN 
             EXIT;
          END IF;

          PERFORM lpInsertUpdate_MovementItem_Sale(ioId := 0, inMovementId := vbMovementId, inGoodsId := vbGoodsId, 
              inAmount := vbOperCount, inAmountPartner := vbOperCount, inAmountChangePercent := vbOperCount, 
              inChangePercentAmount := 0, inPrice := vbOperPrice, inCountForPrice := 1 , inHeadCount := 0, 
              inPartionGoods := '', inGoodsKindId := vbGoodsKindId, inAssetId := 0, inUserId := vbUserId);

        END LOOP;--заканчиваем цикл по курсору
        CLOSE cursMovementItem; --закрываем курсор
     END LOOP;--заканчиваем цикл по курсору
     CLOSE cursMovement; --закрываем курсор
    
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 03.02.14                        *  
*/

-- тест
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')