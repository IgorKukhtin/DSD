-- Function: gpGet_FarmacyUnitName()

DROP FUNCTION IF EXISTS gpGet_FarmacyUnitName (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_FarmacyUnitName(
    OUT    outUnitCode        Integer , --
    OUT    outUnitName        TVarChar, -- Имя Аптеки под которой входит пользователь
    IN     inUnitCode         Integer,  -- Имя Аптеки под которой входит пользователь
    IN     inSession          TVarChar  -- Сессия пользователя
)
RETURNS record AS
$body$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId_find Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);

    -- Проверка ошибки
   IF COALESCE(inUnitCode, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Код аптеки не может быть пустым.';
   END IF;

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

   -- Вернули
   SELECT Object.ObjectCode, Object.ValueData
   INTO outUnitCode, outUnitName
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
 SELECT * FROM gpGet_FarmacyUnitName (inUnitCode := 18, inSession:= zfCalc_UserAdmin());
