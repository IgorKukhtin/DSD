-- Function: gpInsertUpdate_MovementItem_SendAsset()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendAsset(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inAmount                TFloat    , -- Количество
    IN inContainerId           Integer   , -- Партия ОС 
    IN inStorageId             Integer   , -- Место хранения 
    
    IN inPartionModelId        Integer   ,    -- модель (партия)
    IN inInvNumber             TVarChar  ,    -- Инвентарный номер
    IN inSerialNumber          TVarChar  ,    -- Заводской номер
    IN inPassportNumber        TVarChar  ,    -- Номер паспорта  
    IN inProduction            TFloat    ,     -- Производительность, кг
    IN inKW                    TFloat    ,     -- Потребляемая Мощность KW   
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendAsset());

     -- сохранили
     ioId := lpInsertUpdate_MovementItem_SendAsset (ioId          := ioId
                                                  , inMovementId  := inMovementId
                                                  , inGoodsId     := inGoodsId
                                                  , inAmount      := inAmount
                                                  , inContainerId := inContainerId
                                                  , inStorageId   := inStorageId
                                                  , inUserId      := vbUserId
                                                   ) AS tmp;


     -- все свойства ОС сохраняем, + проверка если в справочнике заполнены данные , а в документе нет, тогда ошибка 
     IF EXISTS (SELECT 1 
                FROM ObjectLink 
                WHERE ObjectLink.ObjectId = inGoodsId 
                  AND ObjectLink.DescId = zc_ObjectLink_Asset_PartionModel()
                  AND COALESCE (ObjectLink.ChildObjectId,0) <> 0)
        AND COALESCE (inPartionModelId,0) = 0 
     THEN 
          RAISE EXCEPTION 'Ошибка.Для ОС <%> не установлена Модель (партия).', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;
     --
     IF EXISTS (SELECT 1 
                FROM ObjectString 
                WHERE ObjectString.ObjectId = inGoodsId 
                  AND ObjectString.DescId = zc_ObjectString_Asset_InvNumber()
                  AND COALESCE (ObjectString.ValueData,'') <> '')
         AND COALESCE (inInvNumber,'') = ''
     THEN 
          RAISE EXCEPTION 'Ошибка.Для ОС <%> не установлен Инвентарный номер.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;
     --
     IF EXISTS (SELECT 1 
                FROM ObjectString 
                WHERE ObjectString.ObjectId = inGoodsId 
                  AND ObjectString.DescId = zc_ObjectString_Asset_SerialNumber()
                  AND COALESCE (ObjectString.ValueData,'') <> '')
         AND COALESCE (inSerialNumber,'') = '' 
     THEN 
          RAISE EXCEPTION 'Ошибка.Для ОС <%> не установлен Заводской номер.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;
     --
     IF EXISTS (SELECT 1 
                FROM ObjectString 
                WHERE ObjectString.ObjectId = inGoodsId 
                  AND ObjectString.DescId = zc_ObjectString_Asset_PassportNumber()
                  AND COALESCE (ObjectString.ValueData,'') <> '')
         AND COALESCE (inPassportNumber,'') = ''
     THEN 
          RAISE EXCEPTION 'Ошибка.Для ОС <%> не установлен Номер паспорта.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;     
     --
     IF EXISTS (SELECT 1 
                FROM ObjectFloat 
                WHERE ObjectFloat.ObjectId = inGoodsId 
                  AND ObjectFloat.DescId = zc_ObjectFloat_Asset_Production()
                  AND COALESCE (ObjectFloat.ValueData, 0) <> 0)
         AND COALESCE (inProduction,0) = 0 
     THEN 
          RAISE EXCEPTION 'Ошибка.Для ОС <%> не установлена Производительность.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;
     --
     IF EXISTS (SELECT 1 
                FROM ObjectFloat 
                WHERE ObjectFloat.ObjectId = inGoodsId 
                  AND ObjectFloat.DescId = zc_ObjectFloat_Asset_KW()
                  AND COALESCE (ObjectFloat.ValueData, 0) <> 0)
         AND COALESCE (inKW,0) = 0
     THEN 
          RAISE EXCEPTION 'Ошибка.Для ОС <%> не установлена Мощность.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;
          
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_PartionModel(), inGoodsId, inPartionModelId);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_InvNumber(), inGoodsId, inInvNumber);
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_SerialNumber(), inGoodsId, inSerialNumber);
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_PassportNumber(), inGoodsId, inPassportNumber);    
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Asset_Production(), inGoodsId, inProduction);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Asset_KW(), inGoodsId, inKW);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 
 28.06.23         *
 16.03.20         *
*/

-- тест
--