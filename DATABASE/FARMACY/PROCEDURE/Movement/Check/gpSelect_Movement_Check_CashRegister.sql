--  gpSelect_Movement_Check_CashRegister()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_CashRegister (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_CashRegister(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitID Integer, UnitCode Integer, UnitName TVarChar
             , CashRegisterID Integer, CashRegisterCode Integer, CashRegisterName TVarChar
             , SerialNumber TVarChar
             , CheckCount Integer)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
   vbUserId:= lpGetUserBySession (inSession);

     -- Результат
  RETURN QUERY
  SELECT
     Object_Unit.ID                       AS UnitID,
     Object_Unit.ObjectCode               AS UnitCode,
     Object_Unit.ValueData                AS UnitName,

     Object_CashRegister.ID               AS CashRegisterID,
     Object_CashRegister.ObjectCode       AS CashRegisterCode,
     Object_CashRegister.ValueData        AS CashRegisterName,
     ObjectString_SerialNumber.ValueData  AS SerialNumber,
     count(*)::Integer                    AS CheckCount
  FROM Movement

       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       INNER JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

       INNER JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                    ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                   AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                                   
       INNER JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId
       LEFT JOIN ObjectString AS ObjectString_SerialNumber 
                              ON ObjectString_SerialNumber.ObjectId = Object_CashRegister.Id
                             AND ObjectString_SerialNumber.DescId = zc_ObjectString_CashRegister_SerialNumber()

  WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate) 
    AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
    AND Movement.DescId = zc_Movement_Check()
  GROUP BY Object_Unit.ID, Object_Unit.ObjectCode, Object_Unit.ValueData, 
           Object_CashRegister.ID, Object_CashRegister.ObjectCode, Object_CashRegister.ValueData,
           ObjectString_SerialNumber.ValueData  
  ORDER BY Object_Unit.ObjectCode, Object_CashRegister.ObjectCode;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 23.11.18                                                                                    *
*/

-- тест
-- select * from gpSelect_Movement_Check_CashRegister(inStartDate := ('01.08.2018')::TDateTime, inEndDate := ('01.12.2018')::TDateTime, inSession := '3');