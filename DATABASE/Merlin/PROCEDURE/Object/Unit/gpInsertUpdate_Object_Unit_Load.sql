--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit_Load (Integer, Integer, TVarChar, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit_Load(
    IN inCode                Integer,       -- код 
    IN inParentCode          Integer,       -- код группы
    IN inUnitName            TVarChar,      -- Название 
    IN inUserId              Integer,       -- Id пользователя
    IN inisErased            Integer,       -- удален
    IN inProtocolDate        TDateTime,     -- дата протокола
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUserProtocolId   Integer;
  DECLARE vbParentId         Integer;
  DECLARE vbUnitId      Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   vbUserProtocolId := CASE WHEN inUserId = 1 THEN 5
                            WHEN inUserId = 6 THEN 139  -- zfCalc_UserMain_1()
                            WHEN inUserId = 7 THEN 2020 -- zfCalc_UserMain_2()
                            WHEN inUserId = 10 THEN 40561
                            WHEN inUserId = 11 THEN 40562
                       END;


--RAISE EXCEPTION 'Ошибка. <%>   .', vbUserProtocolId ;

   IF COALESCE (inParentCode,0) <> 0
   THEN
       vbParentId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.ObjectCode = inParentCode);
       
       
       IF COALESCE (vbParentId,0) = 0
       THEN
           -- если не нашли группу  - создаем 
           SELECT tmp.ioId
         INTO vbParentId
           FROM gpInsertUpdate_Object_Unit(ioId	 := vbParentId   :: Integer       -- ключ объекта <> 
                                         , ioCode      := inParentCode :: Integer       -- код объекта <> 
                                         , inName      := (inParentCode||' Группа'):: TVarChar      -- Название объекта <>
                                         , inPhone     := NULL:: TVarChar    
                                         , inComment   := NULL:: TVarChar  
                                         , inParentId  := NULL    :: Integer       -- ключ объекта <Група>
                                         , inSession   := vbUserProtocolId :: TVarChar
                                         ) AS tmp;
       END IF;
   END IF;


   IF COALESCE (inCode,0) <> 0
   THEN
       -- поиск в спр. отделов
       vbUnitId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.ObjectCode = inCode);
       
       -- Eсли не нашли записываем
       --IF COALESCE (vbUnitId,0) = 0
       --THEN
           -- записываем Статью
           SELECT tmp.ioId
         INTO vbUnitId
           FROM gpInsertUpdate_Object_Unit (ioId        := COALESCE (vbUnitId,0)
                                          , ioCode      := inCode ::Integer
                                          , inName      := TRIM (inUnitName) ::TVarChar
                                          , inPhone     := NULL:: TVarChar    
                                          , inComment   := NULL:: TVarChar 
                                          , inParentId  := vbParentId    :: Integer       -- ключ объекта <Група>
                                          , inSession   := vbUserProtocolId :: TVarChar
                                          ) AS tmp;

           -- сохранили свойство <Дата создания>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbUnitId, inProtocolDate ::TDateTime);
           -- сохранили свойство <Пользователь (создание)>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbUnitId, vbUserProtocolId);

           --если удален да
           IF inisErased = 1
           THEN
                PERFORM lpUpdate_Object_isErased (vbUnitId, TRUE, vbUserProtocolId);
           END IF;

       --END IF;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.21          *
*/

-- тест
--