--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney_Load (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney_Load(
    IN inCode                Integer,       -- код статьи
    IN inParentCode          Integer,       -- код группы
    IN inInfoMoneyName       TVarChar,      -- Название статьи
    IN inInfoMoneyKindName   TVarChar,      -- Название типа
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
  DECLARE vbInfoMoneyId      Integer;
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
       vbParentId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.ObjectCode = inParentCode);
       
       
       IF COALESCE (vbParentId,0) = 0
       THEN
           -- если не нашли группу  - создаем 
           vbParentId := gpInsertUpdate_Object_InfoMoney(ioId	            := vbParentId            :: Integer       -- ключ объекта <> 
                                                       , inCode             := inParentCode :: Integer       -- код объекта <> 
                                                       , inName             := (inParentCode||' Группа'):: TVarChar      -- Название объекта <>
                                                       , inisService        := FALSE:: Boolean    
                                                       , inisUserAll        := FALSE:: Boolean    
                                                       , inInfoMoneyKindId  := NULL :: Integer       --
                                                       , inParentId         := NULL    :: Integer       -- ключ объекта <Група>
                                                       , inSession          := vbUserProtocolId :: TVarChar
                                                       );
                                                        

       END IF;
   END IF;


   IF COALESCE (inCode,0) <> 0
   THEN
       -- поиск в спр. статьей
       vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.ObjectCode = inCode);
       
       -- Eсли не нашли записываем
       --IF COALESCE (vbInfoMoneyId,0) = 0
       --THEN
           -- записываем Статью
           vbInfoMoneyId := gpInsertUpdate_Object_InfoMoney (ioId               := COALESCE (vbInfoMoneyId,0)
                                                           , inCode             := inCode ::Integer
                                                           , inName             := TRIM (inInfoMoneyName) ::TVarChar
                                                           , inisService        := FALSE:: Boolean    
                                                           , inisUserAll        := FALSE:: Boolean    
                                                           , inInfoMoneyKindId  := CASE WHEN TRIM (inInfoMoneyKindName) = 'Приход' THEN zc_Enum_InfoMoney_In()
                                                                                        WHEN TRIM (inInfoMoneyKindName) = 'расход' THEN zc_Enum_InfoMoney_Out()
                                                                                        ELSE NULL
                                                                                   END :: Integer       --
                                                           , inParentId         := vbParentId    :: Integer       -- ключ объекта <Група>
                                                           , inSession          := vbUserProtocolId :: TVarChar
                                                           );

           -- сохранили свойство <Дата создания>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbInfoMoneyId, inProtocolDate ::TDateTime);
           -- сохранили свойство <Пользователь (создание)>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbInfoMoneyId, vbUserProtocolId);

           --если удален да
           IF inisErased = 1
           THEN
                PERFORM lpUpdate_Object_isErased (vbInfoMoneyId, TRUE, vbUserProtocolId);
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