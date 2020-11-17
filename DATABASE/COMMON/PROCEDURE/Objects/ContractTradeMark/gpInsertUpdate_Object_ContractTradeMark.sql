-- Function: gpInsertUpdate_Object_ContractTradeMark  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractTradeMark (Integer,Integer,Integer,Integer,TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractTradeMark(
 INOUT ioId                Integer   ,    -- ключ объекта <> 
    IN inCode              Integer   ,    -- Код объекта <>
    IN inContractId        Integer   ,    --   
    IN inTradeMarkId       Integer   ,    -- 
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractTradeMark());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- проверка
   IF COALESCE (inContractId,0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Договор не выбран.';
   END IF;
   IF COALESCE (inTradeMarkId,0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Торговая марка не выбрана.';
   END IF;
   
      
   ioId := lpInsertUpdate_Object_ContractTradeMark(ioId          := ioId          :: Integer
                                                 , inCode        := inCode        ::Integer
                                                 , inContractId  := inContractId
                                                 , inTradeMarkId := inTradeMarkId
                                                 , inUserId      := vbUserId
                                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.11.20         *
*/

-- тест
--