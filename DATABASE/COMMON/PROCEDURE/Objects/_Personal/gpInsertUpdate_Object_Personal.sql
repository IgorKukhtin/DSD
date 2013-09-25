-- Function: gpInsertUpdate_Object_Personal()

-- DROP FUNCTION gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer,Integer,Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                  Integer   , -- ключ объекта <Сотрудники>
    IN inCode                Integer   , -- Код объекта 
    IN inMemberId            Integer   , -- ссылка на Физ.лица 
    IN inPositionId          Integer   , -- ссылка на Должность
    IN inUnitId              Integer   , -- ссылка на Подразделение
    IN inPersonalGroupId     Integer   , -- Группировки Сотрудников
    IN inDateIn              TDateTime , -- Дата принятия
    IN inDateOut             TDateTime , -- Дата увольнения
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Personal()());
   vbUserId := inSession;
   
   --  Если код не установлен, определяем его как последний+1 
   vbCode:=lfGet_ObjectCode (inCode, zc_Object_Personal());
   
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Personal(), vbCode);


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), vbCode, '');
   -- сохранили связь с <физ.лицом>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- сохранили связь с <должностью>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), ioId, inUnitId);
      -- сохранили связь с <Группировки Сотрудников>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalGroup(), ioId, inPersonalGroupId);
   -- сохранили свойство <Дата принятия>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_In(), ioId, inDateIn);
   -- сохранили свойство <Дата увольнения>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), ioId, inDateOut);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Personal (Integer, Integer, Integer, Integer,Integer,Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.13         * add _PersonalGroup; remove _Juridical, _Business              
 06.09.13                         * inName - УБРАЛ. Не нашел для него применения
 24.07.13                                        * inName - БЫТЬ !!! или хотя бы vbMemberName
 01.07.13          * 
 19.07.13                         * 
 19.07.13         *    rename zc_ObjectDate...

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Personal (ioId:=0, inCode:=0, inName:='ЧУМАК заготовитель', inMemberId:=26622, inPositionId:=0, inUnitId:=21778, inJuridicalId:=23966, inBusinessId:=0, inDateIn:=null, inDateOut:=null, inSession:='2')
