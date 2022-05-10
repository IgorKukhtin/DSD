--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProfitLoss_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProfitLoss_Load(
    IN inProfitLossCode              Integer,       -- код статьи
    IN inProfitLossName              TVarChar,      -- Название счет
    IN inProfitLossDirectionName   TVarChar,      -- Название Назначения
    IN inProfitLossGroupName         TVarChar,      -- Название группы
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGroupId          Integer;
  DECLARE vbGroupCode        Integer;
  DECLARE vbDirectionId      Integer;
  DECLARE vbDirectionCode    Integer;
  DECLARE vbProfitLossId     Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inProfitLossCode,0) <> 0
   THEN
       -- поиск в спр. статьей
       vbProfitLossId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProfitLoss() AND Object.isErased = FALSE AND Object.ObjectCode = inProfitLossCode);

       -- Eсли не нашли записываем
       IF COALESCE (vbProfitLossId,0) = 0 OR 1=1
       THEN

           /*код формируется с обнулением  последних 2х/4х цифр
           если код статьи 21201
           ProfitLossDirectionCode = 21200
           ProfitLossGroupCode = 20000
           */
           --проверяем есть ли  Назначение
           vbDirectionCode := (SELECT RPAD (LEFT (inProfitLossCode ::TVarChar, 3), 5,'0')) ::Integer;
           vbDirectionId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProfitLossDirection() AND Object.isErased = FALSE AND Object.ObjectCode = vbDirectionCode);
           --
           IF COALESCE (vbDirectionId,0) = 0 OR 1=1
           THEN
               -- записываем новый элемент
               vbDirectionId := gpInsertUpdate_Object_ProfitLossDirection (ioId      := vbDirectionId
                                                                         , inCode    := vbDirectionCode
                                                                         , inName    := TRIM (inProfitLossDirectionName)
                                                                         , inSession := inSession
                                                                          );
           END IF;

           --проверяем есть ли  Группа
           vbGroupCode := (SELECT RPAD (LEFT (inProfitLossCode ::TVarChar, 1), 5,'0')) ::Integer;
           vbGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ProfitLossGroup() AND Object.isErased = FALSE AND Object.ObjectCode = vbGroupCode limit 1);
           --
           IF COALESCE (vbGroupId,0) = 0 OR 1=1
           THEN
               vbGroupId := gpInsertUpdate_Object_ProfitLossGroup (ioId      := vbGroupId
                                                                 , inCode    := vbGroupCode
                                                                 , inName    := TRIM (inProfitLossGroupName)
                                                                 , inSession := inSession
                                                                  );
           END IF;

           -- записываем Статью
           PERFORM gpInsertUpdate_Object_ProfitLoss (ioId                    := vbProfitLossId
                                                   , inCode                  := inProfitLossCode
                                                   , inName                  := TRIM (inProfitLossName)
                                                   , inProfitLossGroupId     := vbGroupId
                                                   , inProfitLossDirectionId := vbDirectionId
                                                   , inInfoMoneyDestinationId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE TRIM (inProfitLossName) AND Object.DescId = zc_Object_InfoMoneyDestination())
                                                   , inInfoMoneyId           := 0
                                                   , inSession               := inSession
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
 10.05.21          *
*/

-- тест
--