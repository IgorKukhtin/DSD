-- Function: gpInsertUpdate_Object_PartionDateWages()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartionDateWages (Integer, Integer, TDateTime, TFloat, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartionDateWages(
 INOUT ioId                 Integer   ,    -- ключ объекта <>
    IN inPartionDateKindId  Integer   ,    -- Тип срок/не срок
    IN inDateStart          TDateTime ,    -- Дата начала действия
    IN inPercent            TFloat    ,    -- Поправочный коэффициент при начислении	
    IN inisNotCharge        Boolean   ,    -- Не начислять ЗП
    IN inSession            TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectWagesPercentage());
   vbUserId := lpGetUserBySession (inSession); 

   inDateStart := DATE_TRUNC ('DAY', inDateStart);
   
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Разрешено только системному администратору';
   END IF;
   
   -- пытаемся найти код
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_PartionDateWages());

   IF COALESCE(inPartionDateKindId, 0) = 0
   THEN
     RAISE EXCEPTION 'Не определен <Тип срок/не срок>';
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PartionDateWages(), vbCode_calc, '');

   -- сохранили связь с <Пользователи>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartionDateWages_PartionDateKind(), ioId, inPartionDateKindId);

   -- сохранили свойство <Дата начала действия>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_PartionDateWages_DateStart(), ioId, inDateStart);

   -- сохранили свойство <Поправочный коэффициент при начислении>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjectFloat_PartionDateWages_Percent(), ioId, inPercent);

   -- сохранили свойство <Не начислять ЗП>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_PartionDateWages_NotCharge(), ioId, inisNotCharge);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.01.23                                                       *
*/

-- тест
-- select * from gpInsertUpdate_Object_PartionDateWages(ioId := 0 , inPartionDateKindId := 11648988 , inDateStart := ('01.02.2023')::TDateTime , inPercent := 0 , inisNotCharge := True ,  inSession := '3');