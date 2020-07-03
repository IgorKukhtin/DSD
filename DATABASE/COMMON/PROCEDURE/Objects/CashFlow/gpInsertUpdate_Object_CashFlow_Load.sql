-- Название для ценника

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashFlow_Load (Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar);
--gpinsertupdate_object_cashflow_from_excel

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashFlow_Load(
    IN inCashFlowCode_in          Integer,       -- код статьи ДДС расход
    IN inCashFlowName_in          TVarChar,      -- Название статьи ДДС расход
    IN inCashFlowCode_out         Integer,       -- код статьи ДДС приход
    IN inCashFlowName_out         TVarChar,      -- Название статьи ДДС приход
    IN inInfoMoneyName            TVarChar,      -- Название статьи УП
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCashFlowId Integer;
  DECLARE vbInfoMoneyId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CashFlow());
   vbUserId:= lpGetUserBySession (inSession);

   -- убираем из Назв. статьи УП 'УП статья назначения : '
   inInfoMoneyName:= TRIM (REPLACE (TRIM(inInfoMoneyName), 'УП статья назначения : ', ''));
   -- находим статью УП
   vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Infomoney() AND TRIM (Object.ValueData) = TRIM (inInfoMoneyName) limit 1);


   IF COALESCE (inCashFlowCode_out,0) <> 0
   THEN
       -- поиск в спр. статьей ДДС сначала расход
       vbCashFlowId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CashFlow() AND Object.isErased = FALSE AND Object.ObjectCode = inCashFlowCode_out limit 1);
       
       -- Eсли не нашли записываем
       IF COALESCE (vbCashFlowId,0) = 0
       THEN
           vbCashFlowId := gpInsertUpdate_Object_CashFlow (ioId      := COALESCE (vbCashFlowId)
                                                         , inCode    := inCashFlowCode_out
                                                         , inName    := TRIM (inCashFlowName_out)
                                                         , inSession := inSession
                                                           );
       END IF;
    
       -- записываем связь zc_ObjectLink_InfoMoney_CashFlow_out если такой нет
       IF COALESCE (vbInfoMoneyId,0) <> 0 AND COALESCE (vbCashFlowId,0) <> 0
          AND NOT EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_InfoMoney_CashFlow_out() AND ObjectLink.ObjectId = vbInfoMoneyId AND ObjectLink.ChildObjectId = vbCashFlowId)
       THEN
           -- сохранили связь с <Статья отчета ДДС расход>
           PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow_out(), vbInfoMoneyId, vbCashFlowId);
           
           -- сохранили протокол
           PERFORM lpInsert_ObjectProtocol (vbInfoMoneyId, vbUserId);
       
       END IF;
   END IF;
   
   -- аналогично со статьей ДДС приход
       
   IF COALESCE (inCashFlowCode_in,0) <> 0
   THEN
       -- поиск в спр. статьей ДДС сначала приход
       vbCashFlowId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CashFlow() AND Object.isErased = FALSE AND Object.ObjectCode = inCashFlowCode_in limit 1);
       
       -- Eсли не нашли записываем
       IF COALESCE (vbCashFlowId,0) = 0
       THEN
           vbCashFlowId := gpInsertUpdate_Object_CashFlow (ioId      := COALESCE (vbCashFlowId)
                                                         , inCode    := inCashFlowCode_in
                                                         , inName    := TRIM (inCashFlowName_in)
                                                         , inSession := inSession
                                                           );
       END IF;
           
       -- записываем связь zc_ObjectLink_InfoMoney_CashFlow_in если такой нет
       IF COALESCE (vbInfoMoneyId,0) <> 0 AND COALESCE (vbCashFlowId,0) <> 0
          AND NOT EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_InfoMoney_CashFlow_in() AND ObjectLink.ObjectId = vbInfoMoneyId AND ObjectLink.ChildObjectId = vbCashFlowId)
       THEN
           -- сохранили связь с <Статья отчета ДДС приход>
           PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow_in(), vbInfoMoneyId, vbCashFlowId);

           -- сохранили протокол
           PERFORM lpInsert_ObjectProtocol (vbInfoMoneyId, vbUserId);
       END IF;
   END IF;
  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
22.06.20          *
*/

-- тест
--