-- Function: lpInsertUpdate_MI_ProductionUnion_Detail()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Detail (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Detail(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inReceiptServiceId       Integer   , -- работы
    IN inPersonalId             Integer   , -- Сотрудник
    IN inAmount                 TFloat    , -- 
    IN inOperPrice              TFloat    , -- 
    IN inHours                  TFloat    , -- 
    IN inSumm                   TFloat    , -- 
    IN inComment                TVarChar  , --
    IN inUserId                 Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartnerId Integer;
   DECLARE vbVATPercent TFloat;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inReceiptServiceId, Null, inMovementId, inAmount, inParentId, inUserId); 
     
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Personal(), ioId, inPersonalId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Hours(), ioId, inHours); 
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     
     -- Поставщик услуг - формируется автоматически из данных zc_MI_Detail
     vbPartnerId := (SELECT MAX (ObjectLink_Partner.ChildObjectId)
                     FROM MovementItem
                          INNER JOIN MovementItem AS MovementItem_parent ON MovementItem_parent.Id       = MovementItem.ParentId
                                                                        AND MovementItem_parent.isErased = FALSE
                          INNER JOIN ObjectLink AS ObjectLink_Partner
                                                ON ObjectLink_Partner.ObjectId      = MovementItem.ObjectId
                                               AND ObjectLink_Partner.DescId        = zc_ObjectLink_ReceiptService_Partner()
                                               AND ObjectLink_Partner.ChildObjectId > 0
                     WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Detail() AND MovementItem.isErased = FALSE
                    );
     -- сохранили связь с <Поставщик услуг>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), inMovementId, vbPartnerId); 
     
     -- % НДС
     vbVATPercent:= (SELECT ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value
                     FROM ObjectLink AS ObjectLink_TaxKind
                          INNER JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()          
                     WHERE ObjectLink_TaxKind.ObjectId = vbPartnerId
                       AND ObjectLink_TaxKind.DescId   = zc_ObjectLink_Partner_TaxKind()
                    );
     -- сохранили <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inMovementId, COALESCE (vbVATPercent, 0));


     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.01.23         *
*/

-- тест
--