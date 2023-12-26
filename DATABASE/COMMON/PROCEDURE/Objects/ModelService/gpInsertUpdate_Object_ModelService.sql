-- Function: gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer,TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ModelService(Integer,Integer, Integer, TVarChar,TVarChar,Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ModelService(
 INOUT ioId                   Integer   ,    -- ключ объекта <Модели начисления>
    IN inMaskId               Integer   ,    -- id для копирования      если добавляют по маске копируем ItemMaster и ItemChild
    IN inCode                 Integer   ,    -- Код объекта
    IN inName                 TVarChar  ,    -- Название объекта
    IN inComment              TVarChar  ,    -- Примечание
    IN inUnitId               Integer   ,    -- Подразделение
    IN inModelServiceKindId   Integer   ,    -- Типы модели начисления
    IN inisTrainee            Boolean   ,    -- ЗП стажеров в общем фонде(да/нет - значит идут как доплата)
    IN inSession              TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ModelService());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка прав
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_ModelService())
      AND vbUserId <> 5
   THEN
        RAISE EXCEPTION 'Ошибка.%Нет прав корректировать = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_ModelService())
                       ;
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ModelService());

   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ModelService(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ModelService(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ModelService(), vbCode_calc, inName);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ModelService_Comment(), ioId, inComment);

   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ModelService_Unit(), ioId, inUnitId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ModelService_ModelServiceKind(), ioId, inModelServiceKindId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ModelService_Trainee(), ioId, inisTrainee);

   IF COALESCE (inMaskId,0) <> 0
   THEN
        --ItemMaster
        PERFORM gpInsertUpdate_Object_ModelServiceItemMaster( ioId             := 0                      ::Integer   -- ключ объекта < Главные элементы Модели начисления>
                                                            , inMovementDescId := tmp.MovementDescId     ::TFloat    -- Код документа
                                                            , inRatio          := tmp.Ratio              ::TFloat    -- Коэффициент для выбора данных
                                                            , inComment        := tmp.Comment            ::TVarChar  -- Примечание
                                                            , inModelServiceId := ioId                   ::Integer   -- Модели начисления
                                                            , inFromId         := tmp.FromId             ::Integer   -- Подразделения(От кого)
                                                            , inToId           := tmp.ToId               ::Integer   -- Подразделения(Кому)
                                                            , inSelectKindId   := tmp.SelectKindId       ::Integer   -- Тип выбора данных
                                                            , inDocumentKindId := tmp.DocumentKindId     ::Integer   -- Тип выбора данных
                                                            , inSession        := inSession              ::TVarChar  -- сессия пользователя
                                                            )
        FROM gpSelect_Object_ModelServiceItemMaster(FALSE, inSession) AS tmp
        WHERE tmp.ModelServiceId = inMaskId;
        --ItemChild
        PERFORM gpInsertUpdate_Object_ModelServiceItemChild( ioId             := 0                       ::Integer
                                                           , inComment        := tmp.Comment             ::TVarChar                            -- Примечание
                                                           , inFromId         := tmp.FromId              ::Integer                             -- Товар(От кого)
                                                           , inToId           := tmp.ToId                ::Integer                             -- Товар(Кому)
                                                           , inFromGoodsKindId:= tmp.FromGoodsKindId     ::Integer                             -- Вид товара(От кого)
                                                           , inToGoodsKindId  := tmp.ToGoodsKindId       ::Integer                             -- Вид товара(Кому)
                                                           , inFromGoodsKindCompleteId  := tmp.FromGoodsKindCompleteId                         -- Вид товара(От кого, готовая продукция)
                                                           , inToGoodsKindCompleteId    := tmp.ToGoodsKindCompleteId     ::Integer             -- Вид товара(Кому, готовая продукция)
                                                           , inModelServiceItemMasterId := tmp.ModelServiceItemMasterId  ::Integer             -- главный элемент
                                                           , inFromStorageLineId := tmp.FromStorageLineId                ::Integer             -- линия пр-ва (От кого)
                                                           , inToStorageLineId   := tmp.ToStorageLineId    ::Integer                           -- линия пр-ва (Кому)
                                                           , inSession           := inSession              ::TVarChar  -- сессия пользователя
                                                           )
        FROM
             (WITH
              -- ItemMaster нового элемента
              tmpItemMaster AS (SELECT *
                                FROM gpSelect_Object_ModelServiceItemMaster(FALSE, inSession) AS tmp
                                WHERE tmp.ModelServiceId = ioId
                                )
            , tmpItemMasterMask AS (SELECT *
                                    FROM gpSelect_Object_ModelServiceItemMaster(FALSE, inSession) AS tmp
                                    WHERE tmp.ModelServiceId = inMaskId
                                    )
            --по каким ItemMaster были созданы новые, для связки с ItemChild
            , tmpItemMasterUnion AS (SELECT tmpItemMaster.Id
                                          , tmpItemMasterMask.Id AS Id_mask
                                     FROM tmpItemMaster
                                          INNER JOIN tmpItemMasterMask ON COALESCE (tmpItemMasterMask.MovementDescId,0) = COALESCE (tmpItemMaster.MovementDescId,0)
                                                                      AND COALESCE (tmpItemMasterMask.Ratio,0) = COALESCE (tmpItemMaster.Ratio,0)
                                                                      AND COALESCE (tmpItemMasterMask.Comment,'') = COALESCE (tmpItemMaster.Comment,'')
                                                                      AND COALESCE (tmpItemMasterMask.FromId,0) = COALESCE (tmpItemMaster.FromId,0)
                                                                      AND COALESCE (tmpItemMasterMask.ToId,0) = COALESCE (tmpItemMaster.ToId,0)
                                                                      AND COALESCE (tmpItemMasterMask.SelectKindId,0) = COALESCE (tmpItemMaster.SelectKindId,0)
                                     )
            , tmpItemChildMask AS (SELECT * FROM gpSelect_Object_ModelServiceItemChild(FALSE,FALSE, inSession) AS tmp)

              SELECT tmpItemMasterUnion.Id AS ModelServiceItemMasterId
                   , tmpItemChildMask.Comment
                   , tmpItemChildMask.FromId
                   , tmpItemChildMask.ToId
                   , tmpItemChildMask.FromGoodsKindId
                   , tmpItemChildMask.ToGoodsKindId
                   , tmpItemChildMask.FromGoodsKindCompleteId
                   , tmpItemChildMask.ToGoodsKindCompleteId
                   , tmpItemChildMask.FromStorageLineId
                   , tmpItemChildMask.ToStorageLineId
              FROM tmpItemMasterUnion
                   INNER JOIN tmpItemChildMask ON tmpItemChildMask.ModelServiceItemMasterId = tmpItemMasterUnion.Id_mask
              ) AS tmp;

   END  IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.12.19         * inisTrainee
 19.10.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ModelService(0,0,'EREWG', 'ghygjf', 2,6,'2')
