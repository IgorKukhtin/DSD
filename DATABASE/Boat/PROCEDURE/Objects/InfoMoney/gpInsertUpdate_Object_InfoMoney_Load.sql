--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InfoMoney_Load (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoney_Load(
    IN inInfoMoneyCode              Integer,       -- код статьи
    IN inUnitCode                   Integer,       -- код Подразделения
    IN inInfoMoneyName              TVarChar,      -- Название статьи
    IN inInfoMoneyDestinationName   TVarChar,      -- Название Назначения
    IN inInfoMoneyGroupName         TVarChar,      -- Название группы
    IN inSession                    TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbUnitId           Integer;
  DECLARE vbGroupId          Integer;
  DECLARE vbGroupCode        Integer;
  DECLARE vbDestinationId    Integer;
  DECLARE vbDestinationCode  Integer;
  DECLARE vbInfoMoneyId      Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inInfoMoneyCode,0) <> 0
   THEN
       -- поиск в спр. статьей
       vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoney() AND Object.isErased = FALSE AND Object.ObjectCode = inInfoMoneyCode);
       
       -- Eсли не нашли записываем
       IF COALESCE (vbInfoMoneyId,0) = 0 OR 1=1
       THEN
       
           /*код формируется с обнулением  последних 2х/4х цифр
           если код статьи 21201
           InfoMoneyDestinationCode = 21200
           InfoMoneyGroupCode = 20000
           */
           --проверяем есть ли  Назначение
           vbDestinationCode := (SELECT RPAD (LEFT (inInfoMoneyCode ::TVarChar, 3), 5,'0')) ::Integer;
           vbDestinationId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoneyDestination() AND Object.isErased = FALSE AND Object.ObjectCode = vbDestinationCode);
           IF COALESCE (vbDestinationId,0) = 0
           THEN
               --записываем новый элемент
               vbDestinationId := gpInsertUpdate_Object_InfoMoneyDestination (ioId      := 0
                                                                            , inCode    := vbDestinationCode
                                                                            , inName    := TRIM (inInfoMoneyDestinationName)
                                                                            , inSession := inSession
                                                                              );
           END IF;

           --проверяем есть ли  Группа
           vbGroupCode := (SELECT RPAD (LEFT (inInfoMoneyCode ::TVarChar, 1), 5,'0')) ::Integer;
           vbGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_InfoMoneyGroup() AND Object.isErased = FALSE AND Object.ObjectCode = vbGroupCode);
           IF COALESCE (vbGroupId,0) = 0
           THEN
               vbGroupId := gpInsertUpdate_Object_InfoMoneyGroup (ioId      := 0
                                                                , inCode    := vbGroupCode
                                                                , inName    := TRIM (inInfoMoneyGroupName)
                                                                , inSession := inSession
                                                                  );
           END IF;

           -- если задан код подразделения пробем его найти
           IF COALESCE (inUnitCode, 0) <> 0
           THEN
               --
               vbUnitId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit() AND Object.isErased = FALSE AND Object.ObjectCode = inUnitCode limit 1);
               IF COALESCE (vbUnitId,0) = 0
               THEN
                   RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Подразделение с кодом <%> не найдено.' :: TVarChar
                                                         , inProcedureName := 'gpInsertUpdate_Object_InfoMoney_Load' :: TVarChar
                                                         , inUserId        := vbUserId
                                                         , inParam1        := inObjectCode :: TVarChar
                                                         );
               END IF;
           END IF;

           -- записываем Статью
           PERFORM gpInsertUpdate_Object_InfoMoney (ioId                     := vbInfoMoneyId
                                                  , inCode                   := inInfoMoneyCode ::Integer
                                                  , inName                   := TRIM (inInfoMoneyName) ::TVarChar
                                                  , inInfoMoneyGroupId       := vbGroupId       ::Integer
                                                  , inInfoMoneyDestinationId := vbDestinationId ::Integer
                                                  , inUnitId                 := vbUnitId        ::Integer
                                                  , inisProfitLoss           := FALSE           ::Boolean
                                                  , inSession                := inSession
                                                    );
       END IF;
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