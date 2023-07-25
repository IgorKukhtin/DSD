-- Function: gpInsertUpdate_Movement_ProductionUnion()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProductionUnion (Integer, Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProductionUnion (Integer, Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ProductionUnion(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inParentId            Integer   , --
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого
    IN inToId                Integer   , -- Кому   
    IN inInvNumberInvoice    TVarChar  , -- номер счета
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbProductId Integer;
   DECLARE vbProductId_mi Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbVATPercent TFloat;
BEGIN
     -- Проверка
     /*IF COALESCE (inFromId, 0) = 0 OR COALESCE (inToId, 0) = 0
     THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должены быть определены <Склады>.' :: TVarChar
                                               , inProcedureName := 'lpInsertUpdate_Movement_ProductionUnion'
                                               , inUserId        := inUserId
                                                );
     END IF;*/


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProductionUnion(), inInvNumber, inOperDate, (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = ioId), inUserId);

     -- сохранили связь с <От кого >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);


     -- сохранили <номер счета>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberInvoice(), ioId, inInvNumberInvoice);
     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

  
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

     -- zc_MovementLinkObject_Partner  - формируется автоматически из данных zc_MI_Detail
     vbPartnerId := (SELECT ObjectLink_Partner.ChildObjectId  
                     FROM MovementItem AS tmp
                          INNER JOIN ObjectLink AS ObjectLink_Partner
                                                ON ObjectLink_Partner.ObjectId = tmp.ObjectId
                                               AND ObjectLink_Partner.DescId = zc_ObjectLink_ReceiptService_Partner()
                     WHERE tmp.MovementId = ioId AND tmp.DescId = zc_MI_Detail() AND tmp.isErased = FALSE
                     LIMIT 1
                     );
     IF COALESCE (vbPartnerId,0) <> 0
     THEN
         -- сохранили связь с <Кому >
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, vbPartnerId); 
         
         vbVATPercent := (SELECT ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value
                          FROM ObjectLink AS ObjectLink_TaxKind
                               INNER JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                      ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                     AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()          
                          WHERE ObjectLink_TaxKind.ObjectId = vbPartnerId
                            AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Partner_TaxKind()
           );
         -- сохранили <% НДС>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, vbVATPercent);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

     -----строки
     -- записываем лодку из заказа в мастер если  есть что записывать
     /*vbProductId := (SELECT MovementLinkObject_Product.ObjectId       AS ProductId
                     FROM MovementLinkObject AS MovementLinkObject_Product
                     WHERE MovementLinkObject_Product.MovementId = inParentId
                       AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                     );

     IF COALESCE (vbProductId,0) <> 0
     THEN
          -- если уже есть строка с лодкой то заменяем лодку, если нет создаем строку
          SELECT MovementItem.Id
               , MovementItem.ObjectId
        INTO vbMovementItemId, vbProductId_mi
          FROM MovementItem
              INNER JOIN Object ON Object.Id = MovementItem.ObjectId
                               AND Object.DescId = zc_Object_Product()
          WHERE MovementItem.MovementId = ioId
            AND MovementItem.DescId = zc_MI_Master()
            AND MovementItem.isErased = FALSE
          ;
     
          -- определяем признак Создание/Корректировка
          vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;
          --если поменялась лодка удаляем чайлды
          IF vbIsInsert = FALSE AND (COALESCE(vbProductId,0) <> COALESCE(vbProductId_mi,0))
          THEN
              UPDATE MovementItem
               SET isErased = TRUE
              WHERE MovementItem.MovementId = ioId
                AND MovementItem.ParentId = COALESCE (vbMovementItemId,0)
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.isErased = FALSE;
          END IF;

     --
     PERFORM lpInsertUpdate_MovementItem_ProductionUnion (COALESCE (vbMovementItemId, 0)
                                                        , ioId
                                                        , vbProductId
                                                        , COALESCE (ObjectLink_ReceiptProdModel.ChildObjectId,0)
                                                        , 1  :: TFloat
                                                        , '' :: TVarChar
                                                        , inUserId
                                                        )
     FROM ObjectLink AS ObjectLink_ReceiptProdModel
     WHERE ObjectLink_ReceiptProdModel.ObjectId = vbProductId
       AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel();

     END IF;*/
     
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.07.23         *
 12.07.21         *
*/

-- тест
--