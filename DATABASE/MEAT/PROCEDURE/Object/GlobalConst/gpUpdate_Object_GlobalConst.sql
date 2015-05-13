-- Function: gpInsertUpdate_Object_Car(Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_GlobalConst (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GlobalConst(
 INOUT ioId                       Integer   ,    -- ключ объекта  
    IN inActualBankStatementDate  TDateTime ,    -- Дата
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка прав пользователя (конечно кроме пользователя Админа)
     IF NOT EXISTS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND AccessKeyId = ioId)
        AND vbUserId <> zfCalc_UserAdmin() :: Integer
     THEN
          RAISE EXCEPTION 'Ошибка.Нет прав изменять параметр <%>.', lfGet_Object_ValueData (ioId);
     END IF;

   -- сохранили <Дату ...>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GlobalConst_ActualBankStatement(), ioId, inActualBankStatementDate);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_GlobalConst (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.15                                        * add проверка прав пользователя (конечно кроме пользователя Админа)
 07.06.15                         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Car()
