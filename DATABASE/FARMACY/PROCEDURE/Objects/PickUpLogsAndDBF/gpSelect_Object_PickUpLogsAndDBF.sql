-- Function: gpSelect_Object_PickUpLogsAndDBF()

DROP FUNCTION IF EXISTS gpSelect_Object_PickUpLogsAndDBF (boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PickUpLogsAndDBF(
    IN inShowAll       boolean,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id integer, Code integer, Name TVarChar,
               UnitId Integer, UnitName TVarChar, 
               UserId Integer, UserName TVarChar, 
               CashRegister TVarChar,
               isLoaded Boolean, DateLoaded TDateTime, isGetArchive Boolean,
               isErased Boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PickUpLogsAndDBF());

   vbUserId := lpGetUserBySession (inSession);

   RETURN QUERY 
   WITH tmpEmployeeWorkLog AS (
     SELECT ROW_NUMBER() OVER (PARTITION BY EmployeeWorkLog.CashSessionId ORDER BY EmployeeWorkLog.DateLogIn DESC) AS Ord
          , EmployeeWorkLog.CashSessionId      AS CashSessionId
          , EmployeeWorkLog.CashRegister       AS CashRegister
          , EmployeeWorkLog.DateLogIn          AS DateLogIn
          , EmployeeWorkLog.UnitId             AS UnitId 
          , EmployeeWorkLog.UserId             AS UserId 
     FROM EmployeeWorkLog
     WHERE EmployeeWorkLog.DateLogIn >= CURRENT_DATE - INTERVAL '5 DAY')  


   SELECT Object_PickUpLogsAndDBF.Id
        , Object_PickUpLogsAndDBF.ObjectCode                     AS Code
        , Object_PickUpLogsAndDBF.ValueData                      AS Name
        
        , Object_Unit.Id                     AS UnitId
        , Object_Unit.valuedata              AS UnitName
        , Object_User.Id                     AS UserId
        , Object_User.valuedata              AS UserName
        
        , EmployeeWorkLog.CashRegister       AS CashRegister
                                                 
        , ObjectBoolean_Loaded.ValueData     AS isLoaded
        , ObjectDate_DateLoaded.ValueData    AS DateLoaded
                                                 
        , COALESCE(ObjectBoolean_GetArchive.ValueData, False)  AS isGetArchive

        , Object_PickUpLogsAndDBF.isErased
                                                 
    FROM Object AS Object_PickUpLogsAndDBF
                                             
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Loaded
                                ON ObjectBoolean_Loaded.ObjectId = Object_PickUpLogsAndDBF.Id
                               AND ObjectBoolean_Loaded.DescId = zc_ObjectBoolean_PickUpLogsAndDBF_Loaded()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_GetArchive
                                ON ObjectBoolean_GetArchive.ObjectId = Object_PickUpLogsAndDBF.Id
                               AND ObjectBoolean_GetArchive.DescId = zc_ObjectBoolean_PickUpLogsAndDBF_GetArchive()

        LEFT JOIN ObjectDate AS ObjectDate_DateLoaded
                             ON ObjectDate_DateLoaded.ObjectId = Object_PickUpLogsAndDBF.Id
                            AND ObjectDate_DateLoaded.DescId = zc_ObjectDate_PickUpLogsAndDBF_DateLoaded()
                            
        LEFT JOIN tmpEmployeeWorkLog AS EmployeeWorkLog
                                     ON EmployeeWorkLog.CashSessionId = Object_PickUpLogsAndDBF.ValueData 
                                    AND EmployeeWorkLog.Ord = 1
 
        LEFT JOIN Object AS Object_Unit ON Object_Unit.id = EmployeeWorkLog.UnitId

        LEFT JOIN Object AS Object_User ON Object_User.id = EmployeeWorkLog.UserId
                            
    WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
      AND (inShowAll = True OR Object_PickUpLogsAndDBF.isErased = False)
    ORDER BY  Object_PickUpLogsAndDBF.ObjectCode  
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.01.22                                                       *
*/

-- тест
-- 
select * from gpSelect_Object_PickUpLogsAndDBF(inShowAll := False, inSession := '3');