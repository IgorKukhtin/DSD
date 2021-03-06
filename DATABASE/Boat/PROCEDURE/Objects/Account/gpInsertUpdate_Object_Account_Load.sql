--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Account_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Account_Load(
    IN inAccountCode              Integer,       -- код статьи
    IN inAccountName              TVarChar,      -- Название счет
    IN inAccountDirectionName   TVarChar,      -- Название Назначения
    IN inAccountGroupName         TVarChar,      -- Название группы
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGroupId          Integer;
  DECLARE vbGroupCode        Integer;
  DECLARE vbDirectionId    Integer;
  DECLARE vbDirectionCode  Integer;
  DECLARE vbAccountId        Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inAccountCode,0) <> 0
   THEN
       -- поиск в спр. статьей
       vbAccountId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Account() AND Object.isErased = FALSE AND Object.ObjectCode = inAccountCode limit 1);
       
       -- Eсли не нашли записываем
       IF COALESCE (vbAccountId,0) = 0 OR 1=1
       THEN
       
           /*код формируется с обнулением  последних 2х/4х цифр
           если код статьи 21201
           AccountDirectionCode = 21200
           AccountGroupCode = 20000
           */
           --проверяем есть ли  Назначение
           vbDirectionCode := (SELECT RPAD (LEFT (inAccountCode ::TVarChar, 3), 5,'0')) ::Integer;
           vbDirectionId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_AccountDirection() AND Object.isErased = FALSE AND Object.ObjectCode = vbDirectionCode limit 1);
           IF COALESCE (vbDirectionId,0) = 0
           THEN
               --записываем новый элемент
               vbDirectionId := gpInsertUpdate_Object_AccountDirection (ioId      := 0
                                                                            , inCode    := vbDirectionCode
                                                                            , inName    := TRIM (inAccountDirectionName)
                                                                            , inSession := inSession
                                                                              );
           END IF;

           --проверяем есть ли  Группа
           vbGroupCode := (SELECT RPAD (LEFT (inAccountCode ::TVarChar, 1), 5,'0')) ::Integer;
           vbGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_AccountGroup() AND Object.isErased = FALSE AND Object.ObjectCode = vbGroupCode limit 1);
           IF COALESCE (vbGroupId,0) = 0
           THEN
               vbGroupId := gpInsertUpdate_Object_AccountGroup (ioId      := 0
                                                                , inCode    := vbGroupCode
                                                                , inName    := TRIM (inAccountGroupName)
                                                                , inSession := inSession
                                                                  );
           END IF;

           -- записываем Статью
           PERFORM gpInsertUpdate_Object_Account (ioId                   := vbAccountId
                                                , inCode                 := inAccountCode ::Integer
                                                , inName                 := TRIM (inAccountName) ::TVarChar
                                                , inAccountGroupId       := vbGroupId       ::Integer
                                                , inAccountDirectionId   := vbDirectionId   ::Integer
                                                , inInfoMoneyDestinationId := 0             ::Integer
                                                , inInfoMoneyId          := 0               ::Integer
                                                , inSession              := inSession
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
 03.03.21          *
*/

-- тест
--