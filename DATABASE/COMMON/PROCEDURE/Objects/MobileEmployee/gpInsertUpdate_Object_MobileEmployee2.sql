-- Function: gpInsertUpdate_Object_MobileEmployee  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MobileEmployee2(
 INOUT ioId                       Integer   ,    -- ключ объекта <> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inLimit                    TFloat  ,    -- 
    IN inDutyLimit                TFloat  ,    --
    IN inNavigator                TFloat  ,    -- 
    IN inComment                  TVarChar  ,    --
    IN inPersonalId               Integer   ,    --
    IN inMobileTariffId           Integer   ,    -- 
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
   DECLARE vbObjectId Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MobileEmployee());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MobileEmployee()); 
   

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MobileEmployee(), vbCode_calc, inName);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileEmployee_Limit(), ioId, inLimit);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileEmployee_DutyLimit(), ioId, inDutyLimit);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileEmployee_Navigator(), ioId, inNavigator);
  
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MobileEmployee_Comment(), ioId, inComment);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileEmployee_Personal(), ioId, inPersonalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileEmployee_MobileTariff(), ioId, inMobileTariffId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.09.16         *
*/

-- тест
-- select * from gpInsertUpdate_Object_MobileEmployee2(ioId := 0 , inCode := 1 , inName := 'Белов' , inLimit := '4444' , DutyLimit := 'выа@kjjkj' , Comment := '' , inPartnerId := 258441 , inJuridicalId := 0 , inPersonalId := 0 , inMobileEmployeeKindId := 153272 ,  inSession := '5');
