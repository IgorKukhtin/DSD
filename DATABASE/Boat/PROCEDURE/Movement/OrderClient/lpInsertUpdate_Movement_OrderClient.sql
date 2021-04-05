-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderClient(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер документа (внешний)
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inDiscountNextTax     TFloat    , --
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inPaidKindId          Integer   , -- ФО
    IN inProductId           Integer   , -- Лодка
    IN inMovementId_Invoice  Integer, 
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumberPoint Integer;
   DECLARE vbMI_Id Integer;
   DECLARE vbMovementId_Invoice Integer;
   DECLARE vbisComplete_Invoice Boolean;
BEGIN

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderClient(), inInvNumber, inOperDate, NULL, inUserId);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <ФО>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- сохранили связь с <Лодка>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Product(), ioId, inProductId);

     -- сохранили значение <НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили значение <% скидки>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), ioId, inDiscountTax);
     -- сохранили значение <% скидки доп>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), ioId, inDiscountNextTax);     

     -- сохранили <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

  --------
 
 /*    --- находим сохраненный счет
     vbMovementId_Invoice := (SELECT MovementLinkMovement.MovementChildId
                              FROM MovementLinkMovement
                              WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                                AND MovementLinkMovement.MovementId = ioId
                              );
     --если счет меняется то нужно в старом удалить ссылку на тек документ 
     IF COALESCE (vbMovementId_Invoice,0) <> COALESCE (inMovementId_Invoice,0) AND COALESCE (vbMovementId_Invoice,0) <> 0
     THEN
         vbisComplete_Invoice := FALSE;
         -- Распроводим Документ
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_Invoice AND Movement.StatusId = zc_Enum_Status_Complete())
         THEN
             PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Invoice
                                          , inUserId     := inUserId);
             vbisComplete_Invoice := TRUE;
         END IF;

         PERFORM lpInsertUpdate_Movement (Movement.Id, zc_Movement_Invoice(), Movement.InvNumber, Movement.OperDate, NULL, inUserId)
         FROM Movement
         WHERE Movement.Id = vbMovementId_Invoice
           AND Movement.DescId = zc_Movement_Invoice();

         --если документ счет был проведен нужно его провести
         IF vbisComplete_Invoice = TRUE
         THEN
              -- 5.3. проводим Документ
              IF inUserId = lpCheckRight (inUserId ::TVarChar, zc_Enum_Process_Complete_Invoice())
              THEN
                   PERFORM lpComplete_Movement_Invoice (inMovementId := vbMovementId_Invoice
                                                      , inUserId     := inUserId);
              END IF;
         END IF;
     END IF;
  -----------
     -- сохранили связь с документом <Счет>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);

     --сохранили связь документа <Счет> с документом <Приход> сохраняем ParentId в счете
     IF COALESCE (inMovementId_Invoice,0) <> 0
     THEN
         vbisComplete_Invoice := FALSE;
          -- Распроводим Документ
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_Invoice AND Movement.StatusId = zc_Enum_Status_Complete())
         THEN
             PERFORM lpUnComplete_Movement (inMovementId := inMovementId_Invoice
                                          , inUserId     := inUserId);
             vbisComplete_Invoice := TRUE;
         END IF;

         PERFORM lpInsertUpdate_Movement (Movement.Id, zc_Movement_Invoice(), Movement.InvNumber, Movement.OperDate, ioId, inUserId)
         FROM Movement
         WHERE Movement.Id = inMovementId_Invoice
           AND Movement.DescId = zc_Movement_Invoice();

         --если документ счет был проведен нужно его провести
         IF vbisComplete_Invoice = TRUE
         THEN
              -- 5.3. проводим Документ
              IF inUserId = lpCheckRight (inUserId ::TVarChar, zc_Enum_Process_Complete_Invoice())
              THEN
                   PERFORM lpComplete_Movement_Invoice (inMovementId := inMovementId_Invoice
                                                      , inUserId     := inUserId);
              END IF;
         END IF;
     END IF;
  -----------
*/
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);


    -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);


     IF inProductId > 0
     THEN
         -- ищем строку док. с лодкой, находим  - перезаписываем, не находим создаем
         vbMI_Id := (SELECT MovementItem.Id 
                     FROM MovementItem 
                     WHERE MovementItem.MovementId = ioId
                       AND MovementItem.isErased = FALSE
                       AND MovementItem.DescId = zc_MI_Master()
                       AND MovementItem.ObjectId = inProductId
                    );
         -- сохраняем лодку в строчную часть
         PERFORM lpInsertUpdate_MovementItem_OrderClient (ioId            := vbMI_Id
                                                        , inMovementId    := ioId
                                                        , inGoodsId       := inProductId
                                                        , inAmount        := 1  ::TFloat
                                                        , ioOperPrice     := gpSelect.Basis_summ
                                                        , inOperPriceList := gpSelect.Basis_summ_orig
                                                        , inCountForPrice := 1  ::TFloat
                                                        , inComment       := '' ::TVarChar
                                                        , inUserId        := inUserId
                                                        )
         FROM gpSelect_Object_Product (FALSE, FALSE, inUserId :: TVarChar) AS gpSelect
         WHERE gpSelect.MovementId_OrderClient = ioId;
     END IF;
                                                      
                                                      
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.02.21         *
 15.02.21         *
*/

-- тест
--