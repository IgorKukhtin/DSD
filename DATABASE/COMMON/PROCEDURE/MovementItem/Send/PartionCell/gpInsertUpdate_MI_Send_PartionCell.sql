-- Function: gpInsertUpdate_MI_Send_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_PartionCell (Integer, Integer, Integer, Integer, TFloat
                                                          , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                          , TVarChar
                                                           );

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
 INOUT ioPartionCellName_6     TVarChar   ,
 INOUT ioPartionCellName_7     TVarChar   ,
 INOUT ioPartionCellName_8     TVarChar   ,
 INOUT ioPartionCellName_9     TVarChar   ,
 INOUT ioPartionCellName_10    TVarChar   ,
 INOUT ioPartionCellName_11    TVarChar   ,
 INOUT ioPartionCellName_12    TVarChar   ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;

     ----могут изменить товар / вид товара / кол-во  поэтому сохраняем
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := inId
                                             , inMovementId          := inMovementId
                                             , inGoodsId             := inGoodsId
                                             , inAmount              := inAmount
                                             , inPartionGoodsDate    := COALESCE (MIDate_PartionGoods.ValueData,NULL)    ::TDateTime
                                             , inCount               := COALESCE (MIFloat_CountPack.ValueData,0)      ::TFloat
                                             , inHeadCount           := COALESCE (MIFloat_HeadCount.ValueData,0)      ::TFloat
                                             , ioPartionGoods        := COALESCE (MIString_PartionGoods.ValueData,'')  ::TVarChar
                                             , ioPartNumber          := COALESCE (MIString_PartNumber.ValueData,'')    ::TVarChar
                                             , inGoodsKindId         := inGoodsKindId                    ::Integer
                                             , inGoodsKindCompleteId := COALESCE (MILO_GoodsKindComplete.ObjectId, 0) ::Integer
                                             , inAssetId             := COALESCE (MILinkObject_Asset.ObjectId,0)      ::Integer
                                             , inAssetId_two         := COALESCE (MILinkObject_Asset_two.ObjectId,0)  ::Integer
                                             , inUnitId              := NULL ::Integer
                                             , inStorageId           := COALESCE (MILinkObject_Storage.ObjectId,0)      ::Integer
                                             , inPartionModelId      := COALESCE (MILinkObject_PartionModel.ObjectId,0) ::Integer
                                             , inPartionGoodsId      := COALESCE (MILinkObject_PartionGoods.ObjectId,0) ::Integer
                                             , inUserId              := vbUserId                         ::Integer
                                              ) 
     --FROM gpSelect_MovementItem_Send (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS tmp  
     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                           ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                          AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                           ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                           ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionModel
                                           ON MILinkObject_PartionModel.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PartionModel.DescId = zc_MILinkObject_PartionModel()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                           ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                           ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()

          LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                      ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                     AND MIFloat_CountPack.DescId         = zc_MIFloat_CountPack()
          LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                      ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                     AND MIFloat_HeadCount.DescId         = zc_MIFloat_HeadCount()
          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                     ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                    AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
          LEFT JOIN MovementItemString AS MIString_PartionGoods
                                       ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIString_PartionGoods.DescId         = zc_MIString_PartionGoods()

          LEFT JOIN MovementItemString AS MIString_PartNumber
                                       ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                      AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
     WHERE MovementItem.Id = inId 
       AND MovementItem.MovementId = inMovementId
     ; 
  
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

     --  6  
     IF COALESCE (ioPartionCellName_6, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_6) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_6)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_6))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_6;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_6(), inId, vbPartionCellId);
         
         ioPartionCellName_6 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_6(), inId, Null);
     END IF;

     --  7  
     IF COALESCE (ioPartionCellName_7, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_7) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_7)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_7))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_7;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_7(), inId, vbPartionCellId);
         
         ioPartionCellName_7 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_7(), inId, Null);
     END IF;


     --  8  
     IF COALESCE (ioPartionCellName_8, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_8) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_8)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_8))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_8;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_8(), inId, vbPartionCellId);
         
         ioPartionCellName_8 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_8(), inId, Null);
     END IF;


     --  9  
     IF COALESCE (ioPartionCellName_9, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_9) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_9)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_9))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_9;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_9(), inId, vbPartionCellId);
         
         ioPartionCellName_9 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_9(), inId, Null);
     END IF;


     --  10  
     IF COALESCE (ioPartionCellName_10, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_10) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_10)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_10))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_10;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_10(), inId, vbPartionCellId);
         
         ioPartionCellName_10 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_10(), inId, Null);
     END IF;


     --  11  
     IF COALESCE (ioPartionCellName_11, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_11) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_11)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_11))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_11;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_11(), inId, vbPartionCellId);
         
         ioPartionCellName_11 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_11(), inId, Null);
     END IF;


     --  12  
     IF COALESCE (ioPartionCellName_12, '') <> '' THEN
         -- !!!поиск ИД !!! 
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_12) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_12)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_12))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         END IF;
         
         --если не нашли ошибка
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка <%>.', ioPartionCellName_12;
         END IF;

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_12(), inId, vbPartionCellId);
         
         ioPartionCellName_12 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_12(), inId, Null);
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