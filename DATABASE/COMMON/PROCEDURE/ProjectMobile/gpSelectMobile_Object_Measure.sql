-- Function: gpSelectMobile_Object_Measure (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Measure (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Measure (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- Код
             , ValueData  TVarChar -- Название
             , isErased   Boolean  -- Удаленный ли элемент
             , isSync     Boolean  -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- Убрал, есть ошибка у одного торгового - пусть выгружется ВСЕ
      IF 1 = 0 -- inSyncDateIn > zc_DateStart()
      THEN
          -- Результат
          RETURN QUERY
             WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS MeasureId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                  FROM ObjectProtocol
                                       JOIN Object AS Object_Measure
                                                   ON Object_Measure.Id = ObjectProtocol.ObjectId
                                                  AND Object_Measure.DescId = zc_Object_Measure() 
                                  WHERE ObjectProtocol.OperDate > inSyncDateIn
                                  GROUP BY ObjectProtocol.ObjectId
                                 )
             SELECT Object_Measure.Id
                  , Object_Measure.ObjectCode
                  , Object_Measure.ValueData
                  , Object_Measure.isErased
                  , (NOT Object_Measure.isErased) AS isSync
             FROM Object AS Object_Measure
                  JOIN tmpProtocol ON tmpProtocol.MeasureId = Object_Measure.Id
             WHERE Object_Measure.DescId = zc_Object_Measure()
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
             ;
      ELSE
           -- Результат
           RETURN QUERY
             SELECT Object_Measure.Id
                  , Object_Measure.ObjectCode
                  , Object_Measure.ValueData
                  , Object_Measure.isErased
                  , TRUE AS isSync
             FROM Object AS Object_Measure
             WHERE Object_Measure.DescId = zc_Object_Measure()
               -- Убрал - НАДО выгружать ВСЕ
               -- AND Object_Measure.isErased = FALSE
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;  

      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_Measure(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
