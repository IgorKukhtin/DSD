-- Function: gpInsertUpdate_Object_Member(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tblob, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tblob, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tblob, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tblob, Integer, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tblob, Integer, Boolean, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tblob, Integer, Boolean, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Tblob, Integer, Boolean, Integer, Integer, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member(
 INOUT ioId                  Integer   ,    -- ключ объекта <Физические лица> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта <
    IN inNameUkr             TVarChar  ,    -- ФИО на Украинском языке
    IN inIsOfficial          Boolean   ,    -- Оформлен официально
    IN inINN                 TVarChar  ,    -- Код ИНН
    IN inDriverCertificate   TVarChar  ,    -- Водительское удостоверение 
    IN inComment             TVarChar  ,    -- Примечание 

    IN inPhone               TVarChar  , 
    IN inAddress             TVarChar  , 
    IN inPhoto               Tblob     ,

    IN inEducationId         Integer   ,    --
    
    IN inManagerPharmacy     Boolean   ,    -- Заведующая аптекой
    IN inPositionID          Integer   ,    -- Должность
    IN inUnitID              Integer   ,    -- Подразделение
    IN inisNotSchedule       Boolean   ,    -- Не требовать отмечаться в кассе 
    IN inisReleasedMarketingPlan Boolean   ,-- Освобожден от плана маркетинга
    
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- !!! это временно !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_Member());
   -- END IF;

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Member());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Member(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Member(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Member(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- сохранили свойство <Оформлен официально>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Official(), ioId, inIsOfficial);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_NameUkr(), ioId, inNameUkr);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_INN(), ioId, inINN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_DriverCertificate(), ioId, inDriverCertificate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Comment(), ioId, inComment);
   

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Phone(), ioId, inPhone);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Address(), ioId, inAddress);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob( zc_ObjectBlob_Member_Photo(), ioId, inPhoto);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Education(), ioId, inEducationId);

   -- сохранили свойство <Заведующая аптекой>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_ManagerPharmacy(), ioId, inManagerPharmacy);
   -- сохранили свойство <Не требовать отмечаться в кассе>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_NotSchedule(), ioId, inisNotSchedule);
   -- сохранили свойство <Освобожден от плана маркетинга>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_ReleasedMarketingPlan(), ioId, inisReleasedMarketingPlan);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Member_Position(), ioId, inPositionID);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Member_Unit(), ioId, inUnitID);

   -- синхронизируем <Физические лица> и <Сотрудники>
   UPDATE Object SET ValueData = inName, ObjectCode = vbCode_calc
   WHERE Id IN (SELECT ObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Personal_Member() AND ChildObjectId = ioId);  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.19                                                       *
 02.09.19                                                       *
 25.08.19                                                       *
 25.01.16         *
*/

-- !!!синхронизируем <Физические лица> и <Сотрудники>!!!
-- UPDATE Object SET ValueData = Object2.ValueData , ObjectCode = Object2.ObjectCode from (SELECT Object.*, ObjectId FROM ObjectLink join Object on Object.Id = ObjectLink.ChildObjectId WHERE ObjectLink.DescId = zc_ObjectLink_Personal_Member()) as Object2 WHERE Object.Id  = Object2. ObjectId;
-- тест
-- SELECT * FROM gpInsertUpdate_Object_Member()