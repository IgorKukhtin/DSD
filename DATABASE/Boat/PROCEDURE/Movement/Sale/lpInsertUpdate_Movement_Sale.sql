-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale (Integer, Integer, TVarChar, TDateTime, Integer, Integer, Boolean, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Sale(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inParentId            Integer   , -- Заказ
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому 
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , --
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;

   DECLARE vbProductId Integer;
   DECLARE vbProductId_mi Integer;
   DECLARE vbMovementItemId Integer;
   
BEGIN
     -- Проверка
    /* IF COALESCE (inToId, 0) = 0
     THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть определен <Lieferanten>.' :: TVarChar
                                               , inProcedureName := 'lpInsertUpdate_Movement_Sale'
                                               , inUserId        := vbUserId
                                                );
     END IF;
*/
/*
     -- Проверка
     IF COALESCE (inToId, 0) <> -1
    AND COALESCE (inVATPercent, 0) <> COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                 FROM ObjectLink AS OL_Client_TaxKind
                                                      LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                                            ON ObjectFloat_TaxKind_Value.ObjectId = OL_Client_TaxKind.ChildObjectId 
                                                                           AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()   
                                                 WHERE OL_Client_TaxKind.ObjectId = inToId
                                                   AND OL_Client_TaxKind.DescId   = zc_ObjectLink_Client_TaxKind()
                                                ), 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <% НДС> в документе = <%> не соответствует значению у Клиента = <%>.'
                       , '%'
                       , zfConvert_FloatToString (inVATPercent)
                       , zfConvert_FloatToString (COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                             FROM ObjectLink AS OL_Client_TaxKind
                                                                  LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                                                        ON ObjectFloat_TaxKind_Value.ObjectId = OL_Client_TaxKind.ChildObjectId 
                                                                                       AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()   
                                                             WHERE OL_Client_TaxKind.ObjectId = inToId
                                                               AND OL_Client_TaxKind.DescId   = zc_ObjectLink_Client_TaxKind()
                                                            ), 0))
                        ;
     END IF;
*/ 

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Sale(), inInvNumber, inOperDate, inParentId, inUserId);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили значение <НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);

  --------

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

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);                                        


     -----строки
     -- записываем лодку из заказа в мастер если  есть что записывать
     vbProductId := (SELECT MovementLinkObject_Product.ObjectId       AS ProductId
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
     PERFORM lpInsertUpdate_MovementItem_Sale (COALESCE (vbMovementItemId, 0) ::Integer
                                             , ioId                           ::Integer
                                             , vbProductId                    ::Integer
                                             , tmp.Amount                     ::TFloat
                                             , tmp.OperPrice                  ::TFloat
                                             , tmp.OperPriceList              ::TFloat
                                             , tmp.BasisPrice                 ::TFloat
                                             , tmp.CountForPrice              ::TFloat
                                             , ''                             ::TVarChar
                                             , inUserId                       ::Integer
                                             )
     FROM gpSelect_MI_OrderClient_Master (inMovementId:= inParentId , inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inUserId :: TVarChar) AS tmp
     WHERE tmp.DescId = zc_Object_Product();

     END IF;
                                                      
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.21         *
*/

-- тест
--