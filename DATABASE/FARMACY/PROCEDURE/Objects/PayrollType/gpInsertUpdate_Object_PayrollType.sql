-- Function: gpInsertUpdate_Object_PayrollType()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PayrollType(Integer, Integer, TVarChar, TVarChar, Integer, TFloat, TFloat, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PayrollType (
  INOUT ioId integer,
     IN inCode integer,
     IN inName TVarChar,
     IN inShortName TVarChar,
     IN inPayrollGroupID integer,
     IN inPercent TFloat,
     IN inMinAccrualAmount TFloat,
     IN inPayrollTypeID integer,
     IN inSession TVarChar
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PayrollType());
   vbUserId := inSession;
  
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PayrollType());

   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PayrollType(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PayrollType(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PayrollType(), vbCode_calc, inName);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_PayrollType_ShortName(), ioId, inShortName);

   -- сохранили связь с <Группа расчета заработной платы>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PayrollType_PayrollGroup(), ioId, inPayrollGroupID);
   
   -- сохранили связь с <Дополнительный расчет заработной платы	>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PayrollType_PayrollType(), ioId, inPayrollTypeID);
   
   -- Процент от базы
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PayrollType_Percent(), ioId, inPercent);
   -- % ночной
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PayrollType_MinAccrualAmount(), ioId, inMinAccrualAmount);

   -- Мин сумма начисления
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.19                                                        *
 22.08.19                                                        *

*/

-- тест