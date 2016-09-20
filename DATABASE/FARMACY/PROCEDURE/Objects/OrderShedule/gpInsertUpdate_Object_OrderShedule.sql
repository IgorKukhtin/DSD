-- Function: gpInsertUpdate_Object_OrderShedule()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderShedule (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderShedule(
 INOUT ioId                       Integer ,   	-- ключ объекта <Договор>
    IN inCode                     Integer ,    -- Код объекта <>
    IN inValue1                   TVarChar  ,
    IN inValue2                   TVarChar  ,
    IN inValue3                   TVarChar  ,
    IN inValue4                   TVarChar  ,
    IN inValue5                   TVarChar  ,
    IN inValue6                   TVarChar  ,
    IN inValue7                   TVarChar  ,
    IN inUnitId                   Integer ,    -- ссылка подразделение
    IN inContractId               Integer ,    -- ссылка на договор
    IN inSession                  TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
   DECLARE vbName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderShedule());
   vbUserId:= inSession;

   -- Если код не установлен, определяем его как последний+1 
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_OrderShedule());
    
    -- проверка уникальности  по договор и подразделение
    IF COALESCE(ioId,0) = 0 THEN
       IF EXISTS (SELECT ObjectLink_OrderShedule_Contract.ObjectId
                  FROM ObjectLink AS ObjectLink_OrderShedule_Contract
                     INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                             ON ObjectLink_OrderShedule_Unit.ObjectId = ObjectLink_OrderShedule_Contract.ObjectId
                            AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                            AND ObjectLink_OrderShedule_Unit.ChildObjectId = inUnitId
                  WHERE ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                    AND ObjectLink_OrderShedule_Contract.ChildObjectId = inContractId
                  ) 
       THEN
          RAISE EXCEPTION 'Данные не уникальны - Аптека = "%" Договор "%" .', inUnitId, inContractId;
       END IF;
    END IF;

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_OrderShedule(), vbCode_calc);

   vbName:= (inValue1||';'||inValue2||';'||inValue3||';'||inValue4||';'||inValue5||';'||inValue6||';'||inValue7) :: TVarChar;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderShedule(), vbCode_calc, vbName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderShedule_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderShedule_Unit(), ioId, inUnitId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.16         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_OrderShedule ()                            
