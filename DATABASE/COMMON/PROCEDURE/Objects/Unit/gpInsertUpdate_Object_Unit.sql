-- Function: gpInsertUpdate_Object_Unit

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                      Integer   , -- ключ объекта <Подразделение>
    IN inCode                    Integer   , -- Код объекта <Подразделение>
    IN inName                    TVarChar  , -- Название объекта <Подразделение>
    IN inisPartionDate           Boolean   , -- Партии даты в учете
    IN inisPartionGoodsKind      Boolean   , -- Партии по виду упаковки
    IN inisCountCount            Boolean   , -- Учет батонов
    IN inisPartionGP             Boolean   , -- Партии для ГП и Тушенки
    IN inisAvance                Boolean   , -- Начисление аванс автомат.
    IN inParentId                Integer   , -- ссылка на подразделение
    IN inBranchId                Integer   , -- ссылка на филиал
    IN inBusinessId              Integer   , -- ссылка на бизнес
    IN inJuridicalId             Integer   , -- ссылка на Юридические лицо
    IN inContractId              Integer   , -- ссылка на договор
    IN inAccountDirectionId      Integer   , -- ссылка на Аналитики управленческих счетов
    IN inProfitLossDirectionId   Integer   , -- ссылка на Аналитики статей отчета ПиУ
    IN inRouteId                 Integer   , -- Маршрут
    IN inRouteSortingId          Integer   , -- Сортировка маршрутов
    IN inAreaId                  Integer   , -- регион
    IN inCityId                  Integer   , -- город
    IN inPersonalHeadId          Integer   , -- Руководитель подразделения
    IN inFounderId               Integer   , --
    IN inDepartmentId            Integer   , -- департамент
    IN inDepartment_twoId        Integer   , -- департамент 2-го уровня
    IN inSheetWorkTimeId         Integer   , -- Режим работы (Шаблон табеля р.вр.)
    IN inAddress                 TVarChar  , -- Адрес
    IN inAddressEDIN             TVarChar  , -- Адрес для EDIN
    IN inComment                 TVarChar  , -- Примечание
    IN inGLN                     TVarChar  ,
    IN inKATOTTG                 TVarChar  ,
    IN inSession                 TVarChar    -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbOldId Integer;
   DECLARE vbOldParentId integer;
   DECLARE vbOldValue_Address TVarChar;
   DECLARE vbAddress TVarChar;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Unit());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!

/*
   -- проверка
   IF inPersonalSheetWorkTimeId > 0
   THEN --
        RAISE EXCEPTION 'Ошибка.Нет прав заполнять <Сотрудник (доступ к табелю р.времени)>.';
   END IF;
*/

   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Unit(), vbCode_calc);

   -- проверка цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_Unit_Parent(), inParentId);

   -- сохраняем прошлое значение адреса
   vbOldValue_Address := (SELECT COALESCE(ObjectString_Unit_Address.ValueData,'') AS Address
                          FROM ObjectString AS ObjectString_Unit_Address
                          WHERE ObjectString_Unit_Address.ObjectId = ioId --8426  -- inUnitId
                            AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address());

   -- сохранили
   vbOldId:= ioId;
   -- сохранили
   vbOldParentId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent() AND ObjectId = ioId);

   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- сохранили свойство <Партии даты в учете>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PartionDate(), ioId, inisPartionDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PartionGoodsKind(), ioId, inisPartionGoodsKind);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_CountCount(), ioId, inisCountCount);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PartionGP(), ioId, inisPartionGP);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_Avance(), ioId, inisAvance);

   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Parent(), ioId, inParentId);
   -- сохранили связь с <Филиалы>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Branch(), ioId, inBranchId);
   -- сохранили связь с <Бизнесы>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Business(), ioId, inBusinessId);
   -- сохранили связь с <Юридические лица>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);

   -- сохранили связь с <Договор>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Contract(), ioId, inContractId);

   -- сохранили связь с <Аналитики управленческих счетов - направление>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_AccountDirection(), ioId, inAccountDirectionId);
   -- сохранили связь с <Аналитики статей отчета о прибылях и убытках - направление>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_ProfitLossDirection(), ioId, inProfitLossDirectionId);

   -- сохранили связь с <Маршруты>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Unit_Route(), ioId, inRouteId);
   -- сохранили связь с <Сортировки маршрутов>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Unit_RouteSorting(), ioId, inRouteSortingId);
   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Area(), ioId, inAreaId);
   -- сохранили связь с <город>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_City(), ioId, inCityId);
   -- сохранили связь с <Сотрудник (доступ к табелю р.времени)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_PersonalHead(), ioId, inPersonalHeadId);
   -- сохранили связь с <Режим работы (Шаблон табеля р.вр.)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_SheetWorkTime(), ioId, inSheetWorkTimeId);

   -- сохранили связь с <Учредители>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Founder(), ioId, inFounderId);
   -- сохранили связь с <Департамент>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Department(), ioId, inDepartmentId);
   -- сохранили связь с <Департамент 2 уровня>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Department_two(), ioId, inDepartment_twoId);
   
   -- Сохранили <Примечание>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Comment(), ioId, inComment);
   -- Сохранили <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_GLN(), ioId, inGLN);
   -- Сохранили <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_KATOTTG(), ioId, inKATOTTG);
   -- Сохранили <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_AddressEDIN(), ioId, inAddressEDIN);

   -- Если добавляли подразделение
   IF vbOldId <> ioId THEN
      -- Установить свойство лист\папка у себя
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;

   -- Точно теперь inParentId стал папкой
   IF COALESCE (inParentId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), inParentId, FALSE);
   END IF;

   IF COALESCE (vbOldParentId, 0) <> 0 THEN
      PERFORM lpUpdate_isLeaf (vbOldParentId, zc_ObjectLink_Unit_Parent());
   END IF;

   vbAddress := COALESCE (inAddress, '') ;

   IF vbAddress = '' THEN
     vbAddress := (SELECT COALESCE(ObjectString_Unit_Address.ValueData,'') as Address
                   FROM lfSelect_Object_UnitParent_byUnit (ioId) AS tmpUnitList
                        INNER JOIN ObjectString AS ObjectString_Unit_Address
                                ON ObjectString_Unit_Address.ObjectId = tmpUnitList.UnitId
                               AND ObjectString_Unit_Address.DescId   = zc_ObjectString_Unit_Address()
                               AND COALESCE(ObjectString_Unit_Address.ValueData,'') <>''
                   ORDER BY tmpUnitList.Level
                   LIMIT 1);
   END IF;


   -- сохранили свойство <адрес>
   -- установить у Подразделения и всех Child новый адрес, у которых был такой же или пустой
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Address(), tmpUnitList.UnitId, vbAddress)
   FROM lfSelect_Object_Unit_byGroup (ioId) AS tmpUnitList
         LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                ON ObjectString_Unit_Address.ObjectId = tmpUnitList.UnitId
                               AND ObjectString_Unit_Address.DescId   = zc_ObjectString_Unit_Address()
   WHERE (COALESCE(ObjectString_Unit_Address.ValueData,'') = vbOldValue_Address OR COALESCE(ObjectString_Unit_Address.ValueData,'') = '');


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.25         * inDepartment_twoId
 28.10.24         * inDepartmentId
 11.07.23         * inAddressEDIN
 28.06.23         *
 11.05.23         *
 14.03.23         * inisAvance
 03.10.22         * inisPartionGP
 27.07.22         * inisCountCount
 15.12.21         * add PersonalHead
                    dell PersonalSheetWorkTime
 04.10.21         * add inComment
 06.03.17         * add PartionGoodsKind
 16.11.16         * add inSheetWorkTimeId
 24.11.15         * add PersonalSheetWorkTime
 19.07.15         * add area
 03.07.15         * add ObjectLink_Unit_Route, ObjectLink_Unit_RouteSorting
 15.04.15         * add Contract
 08.12.13                                        * add inAccessKeyId
 20.07.13                                        * add inPartionDate
 16.06.13                                        * COALESCE (MAX (ObjectCode), 0)
 14.06.13          *
 13.05.13                                        * rem lpCheckUnique_Object_ValueData
 04.03.13          * vbCode_calc
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Unit ()
