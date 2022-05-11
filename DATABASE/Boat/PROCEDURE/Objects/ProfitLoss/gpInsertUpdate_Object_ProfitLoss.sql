-- Function: gpInsertUpdate_Object_ProfitLoss()

-- DROP FUNCTION gpInsertUpdate_Object_ProfitLoss();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProfitLoss(
 INOUT ioId                     Integer,    -- ключ объекта <Статьи отчета о прибылях и убытках>
    IN inCode                   Integer,    -- Код объекта 
    IN inName                   TVarChar,   -- Название объекта 
    IN inProfitLossGroupId      Integer,    -- Группа
    IN inProfitLossDirectionId  Integer,    -- Аналитика 
    IN inInfoMoneyDestinationId Integer,    -- Управленческие аналитики
    IN inInfoMoneyId            Integer,    -- Управленческие аналитики
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- !!! это временно !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_ProfitLoss());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProfitLoss());
   vbUserId:= lpGetUserBySession (inSession);


   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ProfitLoss());
  
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ProfitLoss(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProfitLoss(), vbCode_calc, inName);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ProfitLoss_onComplete(), ioId, FALSE);

   -- сохранили связь с <Группой товара>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_ProfitLossGroup(), ioId, inProfitLossGroupId);
   -- сохранили связь с <Аналитика>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_ProfitLossDirection(), ioId, inProfitLossDirectionId);
   -- сохранили связь с <Управленческие аналитики>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_InfoMoneyDestination(), ioId, inInfoMoneyDestinationId);
   -- сохранили связь с <Управленческие аналитики>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLoss_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ProfitLoss(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, tvarchar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.04.14                                        * rem !!! это временно !!!
 31.01.14                                        * add zc_ObjectBoolean_ProfitLoss_onComplete
 08.09.13                                        * !!! это временно !!!
 18.06.13          *   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ProfitLoss());             
 18.06.13          *
 05.06.13          
*/
-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProfitLoss()
