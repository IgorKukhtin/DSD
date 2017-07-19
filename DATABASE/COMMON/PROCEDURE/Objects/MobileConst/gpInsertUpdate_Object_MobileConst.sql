-- Function: gpInsertUpdate_ObjObjectect_MobileConst

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileConst (Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MobileConst (
 INOUT ioId                Integer  ,
    IN inType              TVarChar , -- Тип констант. "Public" или "Private"
    IN inMobileVersion     TVarChar , -- Версия мобильного приложения. Пример: "1.0.3.625"
    IN inMobileAPKFileName TVarChar , -- Название ".apk" файла мобильного приложения
    IN inOperDateDiff      Integer  , -- На сколько дней позже создавать док Возврат и Приход денег
    IN inReturnDayCount    Integer  , -- Сколько дней принимаются возвраты по старым ценам
    IN inCriticalOverDays  Integer  , -- Количество дней просрочки, после которого формирование заявки невозможно
    IN inCriticalDebtSum   TFloat   , -- Сумма долга, после которого формирование заявки невозможно
    IN inUserId            Integer  , -- Связь констант для мобильного приложения с пользователем
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS Integer
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCode Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      IF inType NOT IN (zc_Enum_MobileConst_Public(), zc_Enum_MobileConst_Private())
      THEN
           RAISE EXCEPTION 'Неверный тип констант для мобильного приложения: %', COALESCE (inType, 'NULL');
      END IF;

      IF COALESCE (inUserId, 0) <> 0 AND NOT EXISTS (SELECT 1 FROM Object AS Object_User WHERE Object_User.Id = inUserId AND Object_User.DescId = zc_Object_User())
      THEN
           RAISE EXCEPTION 'Несуществующий ИД пользователя: %', inUserId;
      END IF;

      IF COALESCE (inUserId, 0) = 0 AND inType = zc_Enum_MobileConst_Private() 
      THEN 
           RAISE EXCEPTION 'Для частных настроек необходимо задать пользователя';
      END IF;

      vbCode:= CASE inType 
                    WHEN zc_Enum_MobileConst_Public() THEN 0::Integer 
                    WHEN zc_Enum_MobileConst_Private() THEN inUserId
               END; 

      ioId:= NULL; 

      SELECT Object_MobileConst.Id
      INTO ioId
      FROM Object AS Object_MobileConst
      WHERE Object_MobileConst.DescId = zc_Object_MobileConst()
        AND Object_MobileConst.ObjectCode = vbCode
        AND Object_MobileConst.ValueData = inType;

      IF ioId IS NULL
      THEN 
           -- сохранили <Объект>
           ioId:= lpInsertUpdate_Object (ioId, zc_Object_MobileConst(), vbCode, inType);
      END IF;

      IF inType = zc_Enum_MobileConst_Public()
      THEN
           IF inMobileVersion IS NOT NULL 
           THEN 
                -- сохранили св-во <Версия мобильного приложения>
                PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MobileConst_MobileVersion(), ioId, inMobileVersion);
           END IF;

           IF inMobileAPKFileName IS NOT NULL 
           THEN 
                -- сохранили св-во <Название ".apk" файла мобильного приложения>
                PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MobileConst_MobileAPKFileName(), ioId, inMobileAPKFileName);
           END IF;
      END IF;

      -- сохранили св-во <На сколько дней позже создавать док Возврат и Приход денег>
      PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileConst_OperDateDiff(), ioId, inOperDateDiff::TFloat);
      -- сохранили св-во <Сколько дней принимаются возвраты по старым ценам>
      PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileConst_ReturnDayCount(), ioId, inReturnDayCount::TFloat);
      -- сохранили св-во <Количество дней просрочки, после которого формирование заявки невозможно>
      PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileConst_CriticalOverDays(), ioId, inCriticalOverDays::TFloat);
      -- сохранили св-во <Сумма долга, после которого формирование заявки невозможно>
      PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileConst_CriticalDebtSum(), ioId, inCriticalDebtSum);

      IF inType = zc_Enum_MobileConst_Private()
      THEN
           -- сохранили связь с <Связь констант для мобильного приложения с пользователем>
           PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileConst_User(), ioId, inUserId);
      END IF;

      -- сохранили протокол
      PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 19.07.17                                                       *
*/

-- тест
/*
SELECT * FROM gpInsertUpdate_Object_MobileConst (ioId:= 0::Integer
                                               , inType:= zc_Enum_MobileConst_Public()
                                               , inMobileVersion:= '1.26.0'::TVarChar
                                               , inMobileAPKFileName:= 'ProjectMobile.apk'::TVarChar
                                               , inOperDateDiff:= 0::Integer
                                               , inReturnDayCount:= 14::Integer
                                               , inCriticalOverDays:= 21::Integer
                                               , inCriticalDebtSum:= 1::TFloat
                                               , inUserId:= 0::Integer
                                               , inSession:= zfCalc_UserAdmin()
                                                ); 

SELECT * FROM gpInsertUpdate_Object_MobileConst (ioId:= 0::Integer
                                               , inType:= zc_Enum_MobileConst_Private()
                                               , inMobileVersion:= '1.26.0'::TVarChar
                                               , inMobileAPKFileName:= 'ProjectMobile.apk'::TVarChar
                                               , inOperDateDiff:= 1::Integer
                                               , inReturnDayCount:= 14::Integer
                                               , inCriticalOverDays:= 21::Integer
                                               , inCriticalDebtSum:= 25::TFloat
                                               , inUserId:= lpGetUserBySession (zfCalc_UserAdmin())
                                               , inSession:= zfCalc_UserAdmin()
                                                ); 
*/
