-- Function: gpGet_Object_MobileConst_BySession

DROP FUNCTION IF EXISTS gpGet_Object_MobileConst_BySession (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MobileConst_BySession (
    IN inSession TVarChar
)
RETURNS TABLE (Code              Integer
             , Name              TVarChar 
             , MobileVersion     TVarChar  -- Версия мобильного приложения. Пример: "1.0.3.625"
             , MobileAPKFileName TVarChar  -- Название ".apk" файла мобильного приложения
             , OperDateDiff      Integer   -- На сколько дней позже создавать док Возврат и Приход денег
             , ReturnDayCount    Integer   -- Сколько дней принимаются возвраты по старым ценам
             , CriticalOverDays  Integer   -- Количество дней просрочки, после которого формирование заявки невозможно
             , CriticalDebtSum   TFloat    -- Сумма долга, после которого формирование заявки невозможно
              )
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPublicId Integer;
  DECLARE vbPrivateId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- получаем ИД общих настроек
      SELECT Object_MobileConst.Id
      INTO vbPublicId
      FROM Object AS Object_MobileConst
      WHERE Object_MobileConst.DescId = zc_Object_MobileConst()
        AND Object_MobileConst.ObjectCode = 0;
      
      -- получаем ИД частных настроек
      SELECT Object_MobileConst.Id
      INTO vbPrivateId
      FROM Object AS Object_MobileConst
      WHERE Object_MobileConst.DescId = zc_Object_MobileConst()
        AND Object_MobileConst.ObjectCode = vbUserId;
      
      -- результат
      RETURN QUERY
        SELECT COALESCE (mcPrivate.Code,              mcPublic.Code)                        AS Code
             , COALESCE (mcPrivate.Name,              mcPublic.Name)                        AS Name
             , CASE WHEN vbUserId = 5 THEN COALESCE (mcPrivate.MobileVersion,     mcPublic.MobileVersion) ELSE '1.61.0' END ::TVarChar     AS MobileVersion
             , COALESCE (mcPrivate.MobileAPKFileName, mcPublic.MobileAPKFileName)::TVarChar AS MobileAPKFileName
             , COALESCE (mcPrivate.OperDateDiff,      mcPublic.OperDateDiff)::Integer       AS OperDateDiff
             , COALESCE (mcPrivate.ReturnDayCount,    mcPublic.ReturnDayCount)::Integer     AS ReturnDayCount
             , COALESCE (mcPrivate.CriticalOverDays,  mcPublic.CriticalOverDays)::Integer   AS CriticalOverDays
             , COALESCE (mcPrivate.CriticalDebtSum,   mcPublic.CriticalDebtSum)::TFloat     AS CriticalDebtSum
        FROM lpGet_Object_MobileConst (inId:= vbPublicId) AS mcPublic
             LEFT JOIN lpGet_Object_MobileConst (inId:= vbPrivateId) AS mcPrivate ON 1 = 1
        ;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 19.07.17                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_MobileConst_BySession (inSession:= zfCalc_UserAdmin());
