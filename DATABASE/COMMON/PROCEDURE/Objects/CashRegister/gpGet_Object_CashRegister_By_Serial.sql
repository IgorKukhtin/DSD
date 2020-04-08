DROP FUNCTION IF EXISTS gpGet_Object_CashRegister_By_Serial(TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CashRegister_By_Serial(
   OUT outId          Integer,       -- ключ объекта <кассового аппарата>
    IN inSerial       TVarChar,      --Серийный номер аппарата
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS Integer 
AS
$BODY$
  DECLARE vbCashRegisterKindId integer;
  DECLARE vbCashRegisterKindName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

  vbCashRegisterKindName := 'Datecs FP 3141';
  Select Id INTO vbCashRegisterKindId
  from Object
  Where
    DescId = zc_Object_CashRegisterKind()
    AND
    ValueData = vbCashRegisterKindName;
  
  Select 
    Id INTO outId 
  from 
    Object 
  Where 
    DescId = zc_Object_CashRegister() 
    AND 
    ValueData = inSerial;

  IF COALESCE(outId,0) = 0 THEN
    outId := gpInsertUpdate_Object_CashRegister(0,0,inSerial,vbCashRegisterKindId,CURRENT_DATE,CURRENT_DATE,False,inSession);
  END IF;  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CashRegister_By_Serial(TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
05.07.15                                                                       *  
*/

-- тест
-- SELECT * FROM gpGet_Object_CashRegister_By_Serial ('002', '2')