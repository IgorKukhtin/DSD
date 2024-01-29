-- Function: gpInsertUpdate_MI_Send_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Send_PartionCell(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ> 
    IN inGoodsId               Integer   , -- 
    IN inGoodsKindId           Integer   , -- 
    IN inAmount                TFloat,
    --IN inPartionGoodsDate      TDateTime , -- 
 INOUT ioPartionCellName_1     TVarChar   , -- 
 INOUT ioPartionCellName_2     TVarChar   ,
 INOUT ioPartionCellName_3     TVarChar   ,
 INOUT ioPartionCellName_4     TVarChar   ,
 INOUT ioPartionCellName_5     TVarChar   ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
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

     ----могут изменить товар / вид товара / кол-во  поэтому сохраняем
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := inId
                                             , inMovementId          := inMovementId
                                             , inGoodsId             := inGoodsId
                                             , inAmount              := inAmount
                                             , inPartionGoodsDate    := tmp.PartionGoodsDate
                                             , inCount               := tmp.Count
                                             , inHeadCount           := tmp.HeadCount
                                             , ioPartionGoods        := tmp.PartionGoods
                                             , ioPartNumber          := tmp.PartNumber
                                             , inGoodsKindId         := inGoodsKindId
                                             , inGoodsKindCompleteId := tmp.GoodsKindId_Complete
                                             , inAssetId             := tmp.AssetId
                                             , inAssetId_two         := tmp.AssetId_two
                                             , inUnitId              := NULL ::Integer
                                             , inStorageId           := tmp.StorageId
                                             , inPartionModelId      := tmp.PartionModelId
                                             , inPartionGoodsId      := tmp.PartionGoodsId
                                             , inUserId              := vbUserId
                                              ) 
     FROM gpSelect_MovementItem_Send (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS tmp
     WHERE tmp.Id = inId; 
  
     --  1  
     IF COALESCE (ioPartionCellName_1, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_1) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_1)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_1))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_1;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, vbPartionCellId); 
         
         ioPartionCellName_1 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId); 
     ELSE 
      --RAISE EXCEPTION 'Ошибка.555';
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, Null);
     END IF;

     --  2  
     IF COALESCE (ioPartionCellName_2, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_2) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_2)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_2))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_12;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inId, vbPartionCellId);
         
         ioPartionCellName_2 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);

     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inId, Null);
     END IF;


     --  3  
     IF COALESCE (ioPartionCellName_3, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_3) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_3)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_3))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_3;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inId, vbPartionCellId); 
         
         ioPartionCellName_3 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);

     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inId, Null);
     END IF;
     
     --  4  
     IF COALESCE (ioPartionCellName_4, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_4) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_4)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_4))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_4;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inId, vbPartionCellId);
         
         ioPartionCellName_4 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inId, Null);
     END IF;

     --  5  
     IF COALESCE (ioPartionCellName_5, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_5) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_5)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_5))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_5;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inId, vbPartionCellId);
         
         ioPartionCellName_5 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inId, Null);
     END IF;



     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
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