-- Function: gpInsertUpdate_Object_ReportExternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReportExternal(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReportExternal(
 INOUT ioId          Integer  ,    -- ид
    IN inName        TVarChar ,    -- Название функции (отчета)
    IN inSession     TVarChar      -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
DECLARE 
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());


     -- на всякий случай - найдем
     IF COALESCE (ioId, 0) = 0
     THEN 
         -- проверка - свойство должно быть установлено
         IF TRIM (COALESCE (inName, '')) = '' THEN
            RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
         END IF;
         -- поиск
         ioId:= (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_ReportExternal());
         -- если не нашли
         IF COALESCE (ioId, 0) = 0
         THEN 
             -- найдем первый - среди пустых
             ioId:= (SELECT MIN (Id) FROM Object WHERE TRIM (COALESCE (ValueData, '')) = '' AND DescId = zc_Object_ReportExternal());
         END IF;
     END IF;
     
     -- проверка уникальности для свойства <Название>
     IF TRIM (inName) <> '' THEN
       PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ReportExternal(), inName);
     END IF;

     -- сохранили <Объект>
     ioId:= lpInsertUpdate_Object (ioId, zc_Object_ReportExternal(), CASE WHEN COALESCE (ioId, 0) = 0 THEN lfGet_ObjectCode (0, zc_Object_ReportExternal()) ELSE (SELECT ObjectCode FROM Object WHERE Id = ioId) END, inName);

     -- Ведение протокола
     PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*  
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.   Шаблий О.В.
 06.01.19                                                                       *
 25.04.17                                                        *
*/

-- тест
-- SELECT * FROM Object WHERE DescId = zc_Object_ReportExternal() ORDER BY Id DESC;
--
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal (ioId:= 0, inName:= 'gpGet_Movement_Check_ConfirmedKind', inSession:= zfCalc_UserAdmin());
