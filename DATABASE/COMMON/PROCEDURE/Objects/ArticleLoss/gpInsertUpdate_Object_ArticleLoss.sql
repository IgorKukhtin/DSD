-- Function: gpInsertUpdate_Object_ArticleLoss()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ArticleLoss(
 INOUT ioId                       Integer   ,     -- ключ объекта <Статьи списания>
    IN inCode                     Integer   ,     -- Код объекта
    IN inName                     TVarChar  ,     -- Название объекта
    IN inComment                  TVarChar  ,     -- Примечание    
    IN inInfoMoneyId              Integer   ,     -- Статьи назначения
    IN inProfitLossDirectionId    Integer   ,     -- Аналитики статей отчета о прибылях и убытках - направление
    IN inBusinessId               Integer   ,     -- Бизнес
    IN inBranchId                 Integer   ,     -- Филиал
    IN inSession                  TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ArticleLoss());


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ArticleLoss());

   -- проверка уникальности для свойства <Наименование> + <Область>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ArticleLoss(), inName);

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ArticleLoss(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ArticleLoss(), vbCode_calc, inName);

   -- сохранили связь с <Статьи назначения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили связь с <направление>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_ProfitLossDirection(), ioId, inProfitLossDirectionId);
   -- сохранили связь с <Бизнес>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_Business(), ioId, inBusinessId);
   -- сохранили связь с <Филиал>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_Branch(), ioId, inBranchId);
   -- сохранили cсвойство с <ПРимечание>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ArticleLoss_Comment(), ioId, inComment);
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 16.11.20         * inBranchId
 27.07.17         * add inBusinessId
 05.07.17         * add inComment
 01.09.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ArticleLoss(ioId:=null, inCode:=null, inName:='Регион 1', inComment:= '', inInfoMoneyId:=0, inProfitLossDirectionId:=0, inBusinessId:=0, inSession:= zfCalc_UserAdmin())
