-- Function: gpSelectMobile_Object_SubjectDoc()

DROP FUNCTION IF EXISTS gpSelectMobile_Object_SubjectDoc(TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_SubjectDoc(
    IN inSyncDateIn  TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- Код
             , ValueData  TVarChar -- Название
             , isErased   boolean  -- Удаленный ли элемент
             , isSync     Boolean  -- Синхронизируется (да/нет)
             ) 
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
         RETURN QUERY 
         SELECT 
                Object.Id         AS Id 
              , Object.ObjectCode AS Code
              , Object.ValueData  AS Name
              , Object.isErased   AS isErased
              , TRUE AS isSync
         FROM Object
         WHERE Object.DescId = zc_Object_SubjectDoc();
      END IF;
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.11.23                                                       * 

*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_SubjectDoc(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())