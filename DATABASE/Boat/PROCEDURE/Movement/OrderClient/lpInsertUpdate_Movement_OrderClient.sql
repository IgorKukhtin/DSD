-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer,Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderClient (Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer,Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderClient(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер документа (внешний)
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inDiscountNextTax     TFloat    , --
 INOUT ioSummTax             TFloat    , -- Cумма откорректированной скидки, без НДС
 INOUT ioSummReal            TFloat    , -- ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС
    IN inTransportSumm_load  TFloat    , -- транспорт
    IN inTransportSumm       TFloat    , -- транспорт
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inPaidKindId          Integer   , -- ФО
    IN inTaxKindId           Integer  ,  --
    IN inProductId           Integer   , -- Лодка
    IN inMovementId_Invoice  Integer,
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumberPoint Integer;
   DECLARE vbMI_Id Integer;
   DECLARE vbMovementId_Invoice Integer;
   DECLARE vbisComplete_Invoice Boolean;
BEGIN
     -- Проверка
     IF COALESCE (inFromId, 0) = 0 AND COALESCE (inFromId, 0) <> -1
     THEN
         RAISE EXCEPTION 'Ошибка.Должен быть определен <Kunden>(%).', inFromId;
     END IF;

     -- Проверка
     IF COALESCE (inVATPercent, 0) <> COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                 FROM ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 WHERE ObjectFloat_TaxKind_Value.ObjectId = inTaxKindId
                                                   AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()
                                                ), 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <% НДС> в документе не соответствует значению <Тип НДС>.', '%' ;
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderClient(), inInvNumber, inOperDate, NULL, inUserId);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили связь с <От кого (в документе)>
     IF COALESCE (inFromId, 0) <> -1 THEN PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId); END IF;
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <ФО>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- сохранили связь с <Лодка>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Product(), ioId, inProductId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_TaxKind(), ioId, inTaxKindId);

     -- сохранили значение <НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили значение <% скидки>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), ioId, inDiscountTax);
     -- сохранили значение <% скидки доп>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), ioId, inDiscountNextTax);
     -- сохранили значение <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm_load(), ioId, inTransportSumm_load);
     -- сохранили значение <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm(), ioId, inTransportSumm);
     
     -- сохранили <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили связь с документом <Счет>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);

     IF vbIsInsert = TRUE AND inProductId > 0
     THEN
         -- сохранили новое значение <NPP>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NPP(), ioId
                                             , 1 + COALESCE ((SELECT MAX (COALESCE (MovementFloat.ValueData, 0))
                                                              FROM MovementFloat
                                                                   INNER JOIN Movement ON Movement.Id     = MovementFloat.MovementId
                                                                                      AND Movement.DescId = zc_Movement_OrderClient()
                                                                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                              WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                                                             ), 0));

         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateBegin(), inProductId, inOperDate + INTERVAL '3 MONTH');

     END IF;

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

         IF EXISTS (SELECT 1 FROM gpSelect_Object_Product (ioId, FALSE, FALSE, inUserId :: TVarChar) AS gpSelect WHERE gpSelect.MovementId_OrderClient = ioId AND gpSelect.Basis_summ > 0)
         THEN
             -- сохраняем лодку в строчную часть
             vbMI_Id:= (WITH gpSelect AS (SELECT gpSelect.Basis_summ_pl, gpSelect.Basis_summ_orig_pl, gpSelect.Basis_summ1_orig_pl
                                          FROM gpSelect_Object_Product (ioId, FALSE, FALSE, inUserId :: TVarChar) AS gpSelect
                                          WHERE gpSelect.MovementId_OrderClient = ioId
                                         )
                        -- Результат
                        SELECT tmp.ioId
                        FROM lpInsertUpdate_MovementItem_OrderClient (ioId            := vbMI_Id
                                                                    , inMovementId    := ioId
                                                                    , inGoodsId       := inProductId
                                                                    , inAmount        := COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = vbMI_Id), 1)
                                                                      -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
                                                                    , ioOperPrice     := (SELECT gpSelect.Basis_summ_pl       FROM gpSelect)
                                                                      -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
                                                                    , inOperPriceList := (SELECT gpSelect.Basis_summ_orig_pl  FROM gpSelect)
                                                                      -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
                                                                    , inBasisPrice    := (SELECT gpSelect.Basis_summ1_orig_pl FROM gpSelect)
                                                                      --
                                                                    , inCountForPrice := 1  ::TFloat
                                                                    , inComment       := COALESCE ((SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbMI_Id AND MIS.DescId = zc_MIString_Comment()), '')
                                                                    , inUserId        := inUserId
                                                                     ) AS tmp
                       );
             -- сохранили протокол
             PERFORM lpInsert_MovementItemProtocol (vbMI_Id, inUserId, vbIsInsert);

         END IF;


         -- пересчитали Итоговые суммы
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (ioId);


         -- расчет после !!!пересчета!!!
         /*IF ioSummReal > 0
         THEN
             ioSummTax:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_TotalSumm()), 0)
                       - ioSummReal
                        ;
         ELSE
             ioSummReal:= 0;
         END IF;*/
         
         ioSummReal:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_TotalSumm()), 0) - ioSummTax; 

         -- сохранили значение <Cумма откорректированной скидки, без НДС>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTax(), ioId, ioSummTax);
         -- сохранили значение <ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС>
         --PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal(), ioId, ioSummReal);  --расчетное

     ELSE
         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (ioId);

     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.04.24         * inTransportSumm
 16.03.24         *
 01.06.23         * inTransportSumm_load
 15.05.23         *
 23.02.21         *
 15.02.21         *
*/

-- тест
--