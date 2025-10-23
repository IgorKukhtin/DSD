 -- Function: gpInsertUpdate_Object_Unit_CFO_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit_CFO_Load (Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit_CFO_Load(
    IN inUnitCode      Integer   , -- Код объекта <Товар>
    IN inUnitName      TVarChar    , -- 
    IN inCFOName  TVarChar    , -- 
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbCFOId Integer;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Пустое Подразделение  - Пропустили!!!
     IF COALESCE (inUnitName, '') = '' THEN
        RETURN; -- !!!ВЫХОД!!!
     END IF;

     -- !!!Пустая ЦФО - Пропустили!!!
     IF COALESCE (TRIM (inCFOName), '') = '' THEN
        RETURN; -- !!!ВЫХОД!!!
     END IF;

     -- !!!поиск ИД товара!!!
     vbUnitId:= (SELECT Object_Unit.Id
                 FROM Object AS Object_Unit
                 WHERE UPPER (TRIM (Object_Unit.ValueData)) = UPPER (TRIM (inUnitName))
                   AND Object_Unit.DescId     = zc_Object_Unit()
                );
     -- Проверка
     IF COALESCE (vbUnitId, 0) = 0 THEN
        RETURN;
        RAISE EXCEPTION 'Ошибка.Не найдено Подразделение <%> .', inUnitName;
     END IF;

     --пробуем найти ЦФО
     vbCFOId := ( SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CFO() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inCFOName)) );

     /*IF COALESCE (vbCFOId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Группа статистики <%> не найдена', inCFOName;
     END IF;
      */
     --создаем
     IF COALESCE (vbCFOId,0) = 0
     THEN
         --создаем
         vbCFOId := (SELECT tmp.ioId
                           FROM gpInsertUpdate_Object_CFO (ioId       := 0         :: Integer
                                                         , inCode     := 0         :: Integer
                                                         , inName     := TRIM (inCFOName) :: TVarChar
                                                         , inMemberId := Null      ::Integer
                                                         , inComment  := Null      ::TVarChar
                                                         , inSession  := inSession :: TVarChar
                                                          ) AS tmp);
     END IF;
     
     
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_CFO(), vbUnitId, vbCFOId);
    
     RAISE EXCEPTION 'Тест. Ок. <%> / <%>', vbUnitId, vbCFOId;
  
     IF vbUserId = 9457 OR vbUserId = 5
     THEN
           RAISE EXCEPTION 'Тест. Ок. <%> / <%>', vbUnitId, vbCFOId; 
     END IF;   

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbUnitId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.25         *
*/

-- тест
--
