-- Function: gpSelect_Object_CheckoutTesting()

DROP FUNCTION IF EXISTS gpSelect_Object_CheckoutTesting (boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CheckoutTesting(
    IN inShowAll       boolean,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id integer, Code integer, Name TVarChar,
               UnitId Integer, UnitName TVarChar, 
               UserId Integer, UserName TVarChar, 
               CashRegister TVarChar,
               isUpdates Boolean, DateUpdate TDateTime,
               isErased Boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CheckoutTesting());

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


   SELECT Object_CheckoutTesting.Id
        , Object_CheckoutTesting.ObjectCode                     AS Code
        , Object_CheckoutTesting.ValueData                      AS Name
        
        , Object_Unit.Id                     AS UnitId
        , Object_Unit.valuedata              AS UnitName
        , Object_User.Id                     AS UserId
        , Object_User.valuedata              AS UserName
        
        , EmployeeWorkLog.CashRegister       AS CashRegister
                                                 
        , ObjectBoolean_Updates.ValueData             AS isUpdates
        , ObjectDate_DateUpdate.ValueData             AS DateUpdate
                                                 
        , Object_CheckoutTesting.isErased
                                                 
    FROM Object AS Object_CheckoutTesting
                                             
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Updates
                                ON ObjectBoolean_Updates.ObjectId = Object_CheckoutTesting.Id
                               AND ObjectBoolean_Updates.DescId = zc_ObjectBoolean_CheckoutTesting_Updates()

        LEFT JOIN ObjectDate AS ObjectDate_DateUpdate
                             ON ObjectDate_DateUpdate.ObjectId = Object_CheckoutTesting.Id
                            AND ObjectDate_DateUpdate.DescId = zc_ObjectDate_CheckoutTesting_DateUpdate()
                            
        LEFT JOIN tmpEmployeeWorkLog AS EmployeeWorkLog
                                     ON EmployeeWorkLog.CashSessionId = Object_CheckoutTesting.ValueData 
                                    AND EmployeeWorkLog.Ord = 1
 
        LEFT JOIN Object AS Object_Unit ON Object_Unit.id = EmployeeWorkLog.UnitId

        LEFT JOIN Object AS Object_User ON Object_User.id = EmployeeWorkLog.UserId
                            
    WHERE Object_CheckoutTesting.DescId = zc_Object_CheckoutTesting()
      AND (inShowAll = True OR Object_CheckoutTesting.isErased = False)
    ORDER BY  Object_CheckoutTesting.ObjectCode  
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.06.21                                                       *
*/

-- тест
-- 
select * from gpSelect_Object_CheckoutTesting(inShowAll := False, inSession := '3');