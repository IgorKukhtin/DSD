-- Function: gpInsertUpdate_MI_Send_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Send_PartionCell(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inPartionGoodsDate      TDateTime , -- 
 INOUT ioPartionCellName_1     TVarChar   , -- 
 INOUT ioPartionCellName_2     TVarChar   ,
 INOUT ioPartionCellName_3     TVarChar   ,
 INOUT ioPartionCellName_4     TVarChar   ,
 INOUT ioPartionCellName_5     TVarChar   ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
 
     --  1  
     IF COALESCE (ioPartionCellName_1, '') <> '' THEN
         -- !!!поиск ИД товара!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_1))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --если есть ничего не делаем, если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_1;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, vbPartionCellId);
     END IF;

     --  2  
     IF COALESCE (ioPartionCellName_2, '') <> '' THEN
         -- !!!поиск ИД товара!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_2))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --если есть ничего не делаем, если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_2;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inId, vbPartionCellId);
     END IF;


     --  3  
     IF COALESCE (ioPartionCellName_3, '') <> '' THEN
         -- !!!поиск ИД товара!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_3))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --если есть ничего не делаем, если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_3;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inId, vbPartionCellId);
     END IF;

     --  4  
     IF COALESCE (ioPartionCellName_4, '') <> '' THEN
         -- !!!поиск ИД товара!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_4))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --если есть ничего не делаем, если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_4;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inId, vbPartionCellId);
     END IF;

     --  5  
     IF COALESCE (ioPartionCellName_5, '') <> '' THEN
         -- !!!поиск ИД товара!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_5))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --если есть ничего не делаем, если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_5;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inId, vbPartionCellId);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.12.23         *
*/

-- тест
--