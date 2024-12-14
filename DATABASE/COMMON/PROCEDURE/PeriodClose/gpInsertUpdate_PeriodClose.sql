-- Function: gpInsertUpdate_PeriodClose (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_PeriodClose (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_PeriodClose (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_PeriodClose (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_PeriodClose (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,  Integer, TDateTime, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_PeriodClose (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,  Integer, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_PeriodClose(
 INOUT ioId	              Integer   ,     -- ключ объекта
    IN inCode                 Integer   ,     -- 
    IN inName                 TVarChar  ,     -- Описание
    IN inRoleId               Integer   ,     -- Роль
    IN inRoleCode             Integer   ,     -- Роль
    IN inUserId_excl          Integer   ,     -- Пользователь - Исключение
    IN inUserCode_excl        Integer   ,     -- Пользователь - Исключение     
    IN inUserByGroupId_excl   Integer   ,     -- группировка пользователя - исключение
    IN inUserByGroupCode_excl Integer   ,     -- группировка пользователя - исключение
    IN inDescId               Integer   ,     -- Вид Документа
    IN inDescId_excl          Integer   ,     -- Вид Документа - Исключение
    IN inBranchId             Integer   ,     -- 
    IN inBranchCode           Integer   ,     -- 
    IN inPaidKindId           Integer   ,     -- 
    IN inPaidKindCode         Integer   ,     -- 
    IN inPeriod               Integer   ,     -- Дни
    IN inCloseDate            TDateTime ,     -- Закрытый период
    IN inCloseDate_excl       TDateTime ,     -- Закрытый период - Исключение
    IN inCloseDate_store      TDateTime ,     -- Период закрыт до (для кол-во склад)
    IN inSession              TVarChar        -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInterval Interval;
   DECLARE vbAccessKeyId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);


   -- Проверка
   IF COALESCE (inCode, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Код> не определено.';
   END IF;
   IF COALESCE (inName, '') = ''
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Описание> не определено.';
   END IF;

   -- Проверка
   IF inDescId > 0 AND NOT EXISTS (SELECT 1 FROM lpSelect_PeriodClose_Desc (inUserId:= vbUserId) AS tmp WHERE tmp.DescId = inDescId)
   THEN
       RAISE EXCEPTION 'Ошибка.Вид Документа не найден.';
   END IF;
   -- Проверка
   IF inDescId_excl > 0 AND NOT EXISTS (SELECT 1 FROM lpSelect_PeriodClose_Desc (inUserId:= vbUserId) AS tmp WHERE tmp.DescId = inDescId_excl)
   THEN
       RAISE EXCEPTION 'Ошибка.Вид Документа - Исключение не найден.';
   END IF;


   -- замена
   IF (inRoleCode      = 0)        OR (inRoleId      = 0)        THEN inRoleId            := NULL; END IF;
   IF (inUserCode_excl = 0)        OR (inUserId_excl = 0)        THEN inUserId_excl       := NULL; END IF;
   IF (inBranchCode    = 0)        OR (inBranchId    = 0)        THEN inBranchId          := NULL; END IF;
   IF (inPaidKindCode  = 0)        OR (inPaidKindId  = 0)        THEN inPaidKindId        := NULL; END IF;
   IF (inUserByGroupCode_excl = 0) OR (inUserByGroupId_excl = 0) THEN inUserByGroupId_excl:= NULL; END IF;


   -- для Админа  - Все Права
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
      OR vbUserId = 9464 -- Рудик Н.В.
   THEN vbAccessKeyId:= 0;
   ELSE vbAccessKeyId:= (SELECT AccessKeyId_PeriodClose FROM Object_RoleAccessKeyGuide_View WHERE AccessKeyId_PeriodClose <> 0 AND UserId = vbUserId GROUP BY AccessKeyId_PeriodClose);
   END IF;

   IF vbAccessKeyId <> 0 AND COALESCE (ioId, 0) <> 3
   THEN
       RAISE EXCEPTION 'Ошибка.Нет Прав.';
   END IF;


   -- 
   IF NOT EXISTS (SELECT 1 FROM PeriodClose WHERE Id = ioId AND Name = inName) AND ioId > 0
   THEN
       RAISE EXCEPTION 'Ошибка.Нет Прав изменять название.';
   END IF;


   -- отброслили время
   inCloseDate:= DATE_TRUNC ('DAY', inCloseDate);
   inCloseDate_store:= DATE_TRUNC ('DAY', inCloseDate_store);
   -- преобразовали в период
   vbInterval := (TO_CHAR (inPeriod, '999') || ' DAY') :: INTERVAL;


   IF COALESCE (ioId, 0) = 0 THEN
      -- добавили новый элемент справочника и вернули значение <Ключ объекта>
      INSERT INTO PeriodClose (OperDate, UserId, RoleId, Period, CloseDate, Code, Name, DescId, DescId_excl, BranchId, PaidKindId, UserId_excl, CloseDate_excl,CloseDate_store)
                  VALUES (CURRENT_TIMESTAMP, vbUserId, inRoleId, vbInterval, inCloseDate, inCode, inName, inDescId, inDescId_excl, inBranchId, inPaidKindId, inUserId_excl, inCloseDate_excl, inCloseDate_store) RETURNING Id INTO ioId;
   ELSE
       -- изменили элемент справочника по значению <Ключ объекта>
       UPDATE PeriodClose SET OperDate        = CURRENT_TIMESTAMP
                            , UserId          = vbUserId
                            , RoleId          = inRoleId
                            , Period          = vbInterval
                            , CloseDate       = inCloseDate
                            , Code            = inCode
                            , Name            = inName
                            , DescId          = inDescId
                            , DescId_excl     = inDescId_excl
                            , BranchId        = inBranchId
                            , PaidKindId      = inPaidKindId
                            , UserId_excl     = inUserId_excl
                            , CloseDate_excl  = inCloseDate_excl
                            , CloseDate_store = inCloseDate_store 
                            , UserByGroupId_excl = inUserByGroupId_excl
       WHERE Id = ioId;
       -- если такой элемент не был найден
       IF NOT FOUND THEN
          -- добавили новый элемент справочника со значением <Ключ объекта>
          INSERT INTO PeriodClose (OperDate, UserId, RoleId, Period, CloseDate, Code, Name, DescId, DescId_excl, BranchId, PaidKindId, UserId_excl, CloseDate_excl, CloseDate_store, UserByGroupId_excl)
                  VALUES (CURRENT_TIMESTAMP, vbUserId, inRoleId, vbInterval, inCloseDate, inCode, inName, inDescId, inDescId_excl, inBranchId, inPaidKindId, inUserId_excl, inCloseDate_excl, inCloseDate_store, inUserByGroupId_excl)
                  RETURNING Id INTO ioId;
       END IF; -- if NOT FOUND

   END IF; -- if COALESCE (ioId, 0) = 0


   -- Ведение протокола
   INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
      SELECT vbUserId, CURRENT_TIMESTAMP, vbUserId
           , '<XML>'
          || '<Field FieldName = "Ключ" FieldValue = "'       || COALESCE (ioId :: TVarChar, '') || '"/>'
          || '<Field FieldName = "Код" FieldValue = "'        || COALESCE (inCode :: TVarChar, '') || '"/>'
          || '<Field FieldName = "Название" FieldValue = "'   || COALESCE (inName, '') || '"/>'
          || '<Field FieldName = "Роль" FieldValue = "'       || COALESCE (lfGet_Object_ValueData (inRoleId), '') || '"/>'
          || '<Field FieldName = "Роль (код)" FieldValue = "' || COALESCE (inRoleCode :: TVarChar, '') || '"/>'

          || '<Field FieldName = "Пользователь - Исключение" FieldValue = "'       || COALESCE (lfGet_Object_ValueData (inUserId_excl), '') || '"/>'
          || '<Field FieldName = "Пользователь - Исключение (код)" FieldValue = "' || COALESCE (inUserCode_excl :: TVarChar, '') || '"/>'

          || '<Field FieldName = "Пользователь - Исключение" FieldValue = "'       || COALESCE (lfGet_Object_ValueData (inUserByGroupId_excl), '') || '"/>'
          || '<Field FieldName = "Пользователь - Исключение (код)" FieldValue = "' || COALESCE (inUserByGroupCode_excl :: TVarChar, '') || '"/>'

--          || '<Field FieldName = "Вид Документа" FieldValue = "' || COALESCE (inDescId :: TVarChar, '') || '"/>'
--          || '<Field FieldName = "Вид Документа - Исключение" FieldValue = "' || COALESCE (inDescId_excl :: TVarChar, '') || '"/>'

          || '<Field FieldName = "Филиал" FieldValue = "'       || COALESCE (lfGet_Object_ValueData (inBranchId), '') || '"/>'
          || '<Field FieldName = "Филиал (код)" FieldValue = "' || COALESCE (inBranchCode :: TVarChar, '') || '"/>'

          || '<Field FieldName = "ФО" FieldValue = "'       || COALESCE (lfGet_Object_ValueData (inPaidKindId), '') || '"/>'
          || '<Field FieldName = "ФО (код)" FieldValue = "' || COALESCE (inPaidKindCode :: TVarChar, '') || '"/>'

          || '<Field FieldName = "Дни" FieldValue = "' || COALESCE (inPeriod :: TVarChar, '') || '"/>'

          || '<Field FieldName = "Период закрыт до" FieldValue = "' || zfConvert_DateToString (inCloseDate) || '"/>'       

          || '<Field FieldName = "Группировка - Исключение" FieldValue = "'|| COALESCE (lfGet_Object_ValueData (inUserByGroupId_excl), '') || '"/>'
          
          || CASE WHEN inCloseDate_excl  > zc_DateStart() THEN '<Field FieldName = "Период закрыт до - Исключение с" FieldValue = "' || zfConvert_DateToString (inCloseDate_excl) || '"/>' ELSE '' END
          || CASE WHEN inCloseDate_store > zc_DateStart() THEN '<Field FieldName = "Период закрыт до - для кол-во склад" FieldValue = "' || zfConvert_DateToString (inCloseDate_store) || '"/>' ELSE '' END

          || '</XML>' AS ProtocolData
           , TRUE AS isInsert
            ;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.22         * add inUserByGroupId_excl
 09.12.16         * add inCloseDate_store
 24.04.16                                        *
 25.05.14                                        *
 23.09.13                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_UserRole()
