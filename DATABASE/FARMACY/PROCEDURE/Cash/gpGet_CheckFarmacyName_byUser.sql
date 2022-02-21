-- Function: gpGet_CheckFarmacyName_byUser()

--DROP FUNCTION IF EXISTS gpGet_CheckFarmacyName_byUser (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_CheckFarmacyName_byUser (Integer, TVarChar, TVarChar);



CREATE OR REPLACE FUNCTION gpGet_CheckFarmacyName_byUser(
    OUT    outIsEnter         Boolean , -- Разрешение на вход true - да, false - нет
    OUT    outUnitId          Integer , --
    OUT    outUnitCode        Integer , --
    OUT    outUnitName        TVarChar, -- Имя Аптеки под которой входит пользователь
    OUT    outUserCode        Integer , --
    IN     inUnitCode         Integer,  -- Имя Аптеки под которой входит пользователь
    IN     inUnitName         TVarChar, -- Имя Аптеки под которой входит пользователь
    IN     inSession          TVarChar  -- Сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId_find Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);


   -- Начали что есть ошибка
   outIsEnter := FALSE;

    -- Проверка ошибки
   IF COALESCE (inUnitName, '') = '' AND COALESCE(inUnitCode, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Название и код аптеки не может быть пустым.';
   END IF;

    --
   IF COALESCE(inUnitCode, 0) <> 0
   THEN
      IF 1 < (SELECT COUNT(*) FROM Object WHERE DescId = zc_Object_Unit() AND ObjectCode = inUnitCode AND isErased = FALSE)
      THEN
           RAISE EXCEPTION 'Ошибка.Код <%> определен у нескольких аптек.', inUnitCode;
      ELSE
           -- Нашли по коду
           vbUnitId_find:= (SELECT Id FROM Object WHERE DescId = zc_Object_Unit() AND ObjectCode = inUnitCode AND isErased = FALSE);
           -- Проверка ошибки
           IF COALESCE (vbUnitId_find, 0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Код аптеки <%> не найден.', inUnitCode;
           END IF;
      END IF;
    
   ELSE
    
      IF 1 < (SELECT COUNT(*) FROM Object WHERE DescId = zc_Object_Unit() AND LOWER (ValueData) = LOWER (inUnitName) AND isErased = FALSE)
      THEN
           RAISE EXCEPTION 'Ошибка.Название <%> определено у нескольких аптек.', inUnitName;
      ELSE
           -- Нашли по названию
           vbUnitId_find:= (SELECT Id FROM Object WHERE DescId = zc_Object_Unit() AND LOWER (ValueData) = LOWER (inUnitName) AND isErased = FALSE);
           -- Проверка ошибки
           IF COALESCE (vbUnitId_find, 0) = 0
           THEN
               RAISE EXCEPTION 'Ошибка.Название аптеки <%> не найдено.', inUnitName;
           END IF;
      END IF;
   END IF;
    
   -- получили "текущее" значение из дефолтов
   vbUnitKey := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN vbUnitKey := '0'; END IF;
   vbUnitId := vbUnitKey :: Integer;

   IF vbUnitId <> 0
   THEN

       -- Проверка - уже НЕ нужна
       -- IF COALESCE (vbUnitId, 0) = 0 THEN
       --   RAISE EXCEPTION 'Ошибка.Для пользователя <%> не установлено значение <Подразделение>.', lfGet_Object_ValueData (vbUserId);
       -- END IF;

       -- Проверка - !!!Сеть не должна измениться!!!
       IF zfGet_Unit_Retail (vbUnitId) <> zfGet_Unit_Retail (vbUnitId_find) OR lpGet_DefaultValue ('zc_Object_Retail', vbUserId) <> zfGet_Unit_Retail (vbUnitId_find) :: TVarChar
       THEN
            RAISE EXCEPTION 'Ошибка.Пользователь <%> зарегистрирован в сети <%> и не может работать в аптеках сети <%>.', lfGet_Object_ValueData (vbUserId), lfGet_Object_ValueData (zfGet_Unit_Retail(vbUnitId)), lfGet_Object_ValueData (zfGet_Unit_Retail(vbUnitId_find));
       END IF;


       -- На всякий случай проверили что заменим 1 запись
       IF 1 <> (SELECT COUNT (*)
                FROM DefaultKeys
                     LEFT JOIN DefaultValue ON DefaultValue.DefaultKeyId = DefaultKeys.Id
                                           AND DefaultValue.UserKeyId     = vbUserId
                WHERE LOWER (DefaultKeys.Key) = LOWER ('zc_Object_Unit'))
       THEN
           RAISE EXCEPTION 'Ошибка.Не найден один дефолт у пользователя <%> с ключом <zc_Object_Unit>.Кол-во найденных = <%>.'
                         , lfGet_Object_ValueData (vbUserId)
                         , (SELECT COUNT (*)
                            FROM DefaultKeys
                                 LEFT JOIN DefaultValue ON DefaultValue.DefaultKeyId = DefaultKeys.Id
                                                       AND DefaultValue.UserKeyId    = vbUserId
                            WHERE LOWER (DefaultKeys.Key) = LOWER ('zc_Object_Unit'));
       END IF;

   END IF;

   -- Заменили пользователю - АПТЕКУ
   PERFORM gpInsertUpdate_DefaultValue (ioId           := DefaultValue.Id
                                      , inDefaultKeyId := DefaultKeys.Id
                                      , inUserKey      := vbUserId
                                      , inDefaultValue := vbUnitId_find :: TVarChar
                                      , inSession      := '3'
                                       )
   FROM DefaultKeys
        LEFT JOIN DefaultValue ON DefaultValue.DefaultKeyId = DefaultKeys.Id
                              AND DefaultValue.UserKeyId    = vbUserId
   WHERE LOWER (DefaultKeys.Key) = LOWER ('zc_Object_Unit')
     AND vbUnitId_find <> vbUnitId;


   -- Вернули что нет ошибки
   outIsEnter := TRUE;
   
   
   -- Вернули Код сотрудника
   outUserCode := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbUserId);
    

   -- Вернули
   SELECT Object.id, Object.ObjectCode, Object.ValueData
   INTO outUnitId, outUnitCode, outUnitName
   FROM Object 
   WHERE Object.DescId = zc_Object_Unit() 
     AND Object.ID = COALESCE (vbUnitId_find, 0);
    

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.02.20                                                       *
*/

-- тест
--
 SELECT * FROM gpGet_CheckFarmacyName_byUser (inUnitCode := 18, inUnitName:= 'Аптека_1 пр_Правды_6',  inSession:= zfCalc_UserAdmin());
