-- Function: gpInsertUpdateMobile_Object_Partner

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Partner (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, 
                                                             TFloat, TFloat, TVarChar, Integer, TVarChar, TVarChar, TVarChar, 
                                                             Integer, TVarChar, TVarChar, TVarChar, Integer,
                                                             Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Partner (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, 
                                                             TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                             Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Partner (Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Partner (Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Object_Partner (
 INOUT ioId               Integer  ,  -- ключ объекта <Контрагент>
    IN inGUID             TVarChar ,  -- Глобальный уникальный идентификатор
    IN inName             TVarChar ,  -- наименование контрагента
    IN inAddress          TVarChar ,  -- Адрес точки доставки
    IN inPrepareDayCount  TFloat   ,  -- За сколько дней принимается заказ
    IN inDocumentDayCount TFloat   ,  -- Через сколько дней оформляется документально
    IN inJuridicalId      Integer  ,  -- Идентификатор юридического лица
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);


      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION 'Ошибка.Нет Прав.';
      END IF;


      -- Проверка - установлено ли юр.лицо
      IF COALESCE (inJuridicalId, 0) = 0  
      THEN
           RAISE EXCEPTION 'Не установлено юридическое лицо!';
      END IF;
   
      IF COALESCE (inGUID, '') = ''
      THEN
           RAISE EXCEPTION 'Ошибка. Не задан глобальный уникальный идентификатор';
      END IF;

      -- берем из констант идентификатор торгового агента
      SELECT PersonalId INTO vbPersonalId FROM gpGetMobile_Object_Const (inSession);

      -- ищем контрагента по значению глобального уникального идентификатора
      SELECT ObjectString_Partner_GUID.ObjectId
      INTO vbId
      FROM ObjectString AS ObjectString_Partner_GUID
           JOIN Object AS Object_Partner
                       ON Object_Partner.Id = ObjectString_Partner_GUID.ObjectId
                      AND Object_Partner.DescId = zc_Object_Partner()
      WHERE ObjectString_Partner_GUID.DescId = zc_ObjectString_Partner_GUID()
        AND ObjectString_Partner_GUID.ValueData = inGUID;

      vbId:= COALESCE (vbId, 0);

      -- проверка уникальности <Наименование>
      PERFORM lpCheckUnique_Object_ValueData(vbId, zc_Object_Partner(), inName);

      -- определяется признак Создание/Корректировка
      vbIsInsert:= (vbId = 0);

      -- сохранили <Объект>
      ioId := lpInsertUpdate_Object (vbId, zc_Object_Partner(), 0, inName);

      -- сохранили свойство <Адрес точки доставки>
      PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Partner_Address(), ioId, inAddress);
      -- сохранили свойство <За сколько дней принимается заказ>
      PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_PrepareDayCount(), ioId, CASE WHEN vbIsInsert AND COALESCE (inPrepareDayCount, 0) = 0 THEN 1 ELSE inPrepareDayCount END);
      -- сохранили свойство <Через сколько дней оформляется документально>
      PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_DocumentDayCount(), ioId, inDocumentDayCount);
      -- сохранили связь с <Юридические лица>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Juridical(), ioId, inJuridicalId);
      -- сохранили связь с <Сотрудник (торговый агент)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PersonalTrade(), ioId, vbPersonalId);
      -- сохранили свойство <Глобальный уникальный идентификатор>
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_GUID(), ioId, inGUID);

      -- сохранили протокол
      PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 05.04.17                                                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdateMobile_Object_Partner (ioId:= 0, inGUID:= '{FD0D2968-FE5A-49B8-AC9B-29E0FC741E91}', inName:= 'Контрагент с моб. устройства', inAddress:= 'г. Полтава, ул. Котляревского, 5', inPrepareDayCount:= 1, inDocumentDayCount:= 1, inJuridicalId:= 1005442, inSession:= zfCalc_UserAdmin())
