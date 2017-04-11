-- Function: gpInsertUpdate_MIEdit_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_Income (Integer, Integer, TVarChar, TVarChar, TVarChar ,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MIEdit_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsGroupName      TVarChar   , --
    IN inGoodsName           TVarChar   , -- Товары
    IN inGoodsInfoName       TVarChar   , --
    IN inGoodsSize           TVarChar   , --
    IN inCompositionName     TVarChar   , --
    IN inLineFabricaName     TVarChar   , --
    IN inLabelName           TVarChar   , --
    IN inMeasureName         TVarChar   , --
    IN inAmount              TFloat    , -- Количество
    IN inOperPrice           TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
    IN inOperPriceList       TFloat    , -- Цена по прайсу
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsGroupId Integer;
   DECLARE vbMeasureId Integer;
   DECLARE vbLineFabricaId Integer;
   DECLARE vbCompositionId Integer; 
   DECLARE vbGoodsSizeId Integer;
   DECLARE vbGoodsId Integer;   
   DECLARE vbGoodsInfoId Integer;
   DECLARE vbGoodsItem Integer;
   DECLARE vblabelid Integer;   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Income());

     -- Заменили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

   -- сохраняем все справочники  TVarChar
   IF COALESCE (inGoodsGroupName, '') <> ''
      THEN
          inGoodsGroupName:= TRIM (COALESCE (inGoodsGroupName, ''));
          -- 
          vbGoodsGroupId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inGoodsGroupName));
          IF COALESCE (vbGoodsGroupId,0) = 0
             THEN
                 -- не нашли Сохраняем
                 vbGoodsGroupId := lpInsertUpdate_Object_GoodsGroup (ioId    := 0
                                                                   , inCode  := lfGet_ObjectCode(0, zc_Object_GoodsGroup()) 
                                                                   , inName  := inGoodsGroupName
                                                                   , inUserId:= vbUserId
                                                                    );
                        -- сохранили протокол
                        PERFORM lpInsert_ObjectProtocol (vbGoodsGroupId, vbUserId);
          END IF;
   END IF;
  --2
   IF COALESCE (inMeasureName, '') <> ''
      THEN
          inMeasureName:= TRIM (COALESCE (inMeasureName, ''));
          -- 
          vbMeasureId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Measure() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inMeasureName));
          IF COALESCE (vbMeasureId,0) = 0
             THEN
                 -- не нашли Сохраняем
                 vbMeasureId := lpInsertUpdate_Object (0, zc_Object_Measure(), lfGet_ObjectCode(0, zc_Object_Measure()), inMeasureName);
                 -- сохранили протокол
                 PERFORM lpInsert_ObjectProtocol (vbMeasureId, vbUserId);
          END IF;
   END IF;
   --3
   IF COALESCE (inLineFabricaName, '') <> ''
      THEN
          inLineFabricaName:= TRIM (COALESCE (inLineFabricaName, ''));
          -- 
          vbLineFabricaId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_LineFabrica() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inLineFabricaName));
          IF COALESCE (vbLineFabricaId,0) = 0
             THEN
                 -- не нашли Сохраняем
                 vbLineFabricaId := gpInsertUpdate_Object_LineFabrica (ioId    := 0
                                                                     , inCode   := lfGet_ObjectCode(0, zc_Object_LineFabrica()) 
                                                                     , inName   := inLineFabricaName
                                                                     , inSession:= inSession
                                                                    );
          END IF;
   END IF;
   --4
   IF COALESCE (inCompositionName, '') <> ''
      THEN
          inCompositionName:= TRIM (COALESCE (inCompositionName, ''));
          -- 
          vbCompositionId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Composition() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inCompositionName));
          IF COALESCE (vbCompositionId,0) = 0
             THEN
                 -- не нашли Сохраняем
                 vbCompositionId := lpInsertUpdate_Object (0, zc_Object_Composition(), lfGet_ObjectCode(0, zc_Object_Composition()), inCompositionName);
                 -- сохранили протокол
                 PERFORM lpInsert_ObjectProtocol (vbCompositionId, vbUserId);
          END IF;
   END IF;
   --5
   IF COALESCE (inGoodsInfoName, '') <> ''
      THEN
          inGoodsInfoName:= TRIM (COALESCE (inGoodsInfoName, ''));
          -- 
          vbGoodsInfoId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsInfo() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inGoodsInfoName));
          IF COALESCE (vbGoodsInfoId,0) = 0
             THEN
                 -- не нашли Сохраняем
                 vbGoodsInfoId := gpInsertUpdate_Object_GoodsInfo (ioId    := 0
                                                                 , inCode  := lfGet_ObjectCode(0, zc_Object_GoodsInfo()) 
                                                                 , inName  := inGoodsInfoName
                                                                 , inSession:= inSession
                                                                  );
          END IF;
   END IF;
   --6
   IF COALESCE (inLabelName, '') <> ''
      THEN
          inLabelName:= TRIM (COALESCE (inLabelName, ''));
          -- 
          vbLabelId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Label() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inLabelName));
          IF COALESCE (vbLabelId,0) = 0
             THEN
                 -- не нашли Сохраняем
                 vbLabelId := gpInsertUpdate_Object_Label (ioId    := 0
                                                         , inCode   := lfGet_ObjectCode(0, zc_Object_Label()) 
                                                         , inName   := inLabelName
                                                         , inSession:= inSession
                                                         );
          END IF;
   END IF;
   --7
   IF COALESCE (inGoodsSize, '') <> ''
      THEN
          inGoodsSize:= TRIM (COALESCE (inGoodsSize, ''));
          -- 
          vbGoodsSizeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsSize() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inGoodsSize));
          IF COALESCE (vbGoodsSizeId,0) = 0
             THEN
                 -- не нашли Сохраняем
                 vbGoodsSizeId := gpInsertUpdate_Object_GoodsSize (ioId    := 0
                                                                 , inCode  := lfGet_ObjectCode(0, zc_Object_GoodsSize()) 
                                                                 , inName  := inGoodsSize
                                                                 , inSession:= inSession
                                                                    );
          END IF;
   END IF;
   --7
   IF COALESCE (inGoodsName, '') <> ''
      THEN
          inGoodsName:= TRIM (COALESCE (inGoodsName, ''));
          -- 
          vbGoodsId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inGoodsName));
        --  IF COALESCE (vbGoodsId,0) = 0
          --   THEN
                 -- не нашли Сохраняем
                 vbGoodsId := gpInsertUpdate_Object_Goods (ioId    := COALESCE (vbGoodsId,0)
                                                         , inCode          := lfGet_ObjectCode(0, zc_Object_Goods()) 
                                                         , inName          := inGoodsName
                                                         , inGoodsGroupId  := COALESCE(vbGoodsGroupId,0)
                                                         , inMeasureId     := COALESCE(vbMeasureId,0)
                                                         , inCompositionId := COALESCE(vbCompositionId,0)
                                                         , inGoodsInfoId   := COALESCE(vbGoodsInfoId,0)
                                                         , inLineFabricaId := COALESCE(vbLineFabricaId,0)
                                                         , inLabelId       := COALESCE(vbLabelId,0)
                                                         , inSession       := inSession
                                                         );
            
      --    END IF;
   END IF;
   ----gpInsertUpdate_Object_GoodsItem нужно сохранить связь товар - размер
   IF COALESCE (vbGoodsId, 0) <> 0 AND COALESCE (vbGoodsSizeId, 0) <> 0
      THEN
          --
          vbGoodsItem := (SELECT Object_GoodsItem.Id FROM Object_GoodsItem WHERE Object_GoodsItem.GoodsId = vbGoodsId AND Object_GoodsItem.GoodsSizeId = vbGoodsSizeId);
          IF COALESCE (vbGoodsItem,0) = 0
             THEN
                 -- добавили новый элемент справочника и вернули значение <Ключ объекта>
                 INSERT INTO Object_GoodsItem (GoodsId, GoodsSizeId)
                        VALUES (vbGoodsId, vbGoodsSizeId); --RETURNING Id INTO vbGoodsItem;

          END IF;
   END IF;

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := COALESCE (vbGoodsId,0)
                                              , inAmount             := inAmount
                                              , inOperPrice          := inOperPrice
                                              , inCountForPrice      := ioCountForPrice
                                              , inOperPriceList      := inOperPriceList
                                              , inUserId             := vbUserId
                                               );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.17         *
*/

-- тест
-- 