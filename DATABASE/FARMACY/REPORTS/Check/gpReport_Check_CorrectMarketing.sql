-- Function:  gpReport_Check_CorrectMarketing()

DROP FUNCTION IF EXISTS gpReport_Check_CorrectMarketing (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_CorrectMarketing(
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  Id            Integer,
  UnitId        Integer,
  UnitCode      Integer,
  UnitName      TVarChar,
  JuridicalName TVarChar,
  OperDate      TDateTime,
  InvNumber     TVarChar,
  TotalSumm     TFloat
)
AS
$BODY$
   DECLARE vbUserId      Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
    WITH tmpMovement AS (SELECT MovementBoolean_CorrectMarketing.MovementId
                         FROM MovementBoolean AS MovementBoolean_CorrectMarketing
                         WHERE MovementBoolean_CorrectMarketing.DescId = zc_MovementBoolean_CorrectMarketing()
                           AND MovementBoolean_CorrectMarketing.ValueData = TRUE)

    SELECT Movement.Id
         , Object_Unit.Id
         , Object_Unit.ObjectCode
         , Object_Unit.valuedata
         , Object_Juridical.valuedata
         , Movement.OperDate
         , Movement.InvNumber
         , MovementFloat_TotalSumm.ValueData
    FROM tmpMovement  
    
         INNER JOIN Movement ON Movement.ID = tmpMovement.MovementId
                            AND Movement.OperDate >= inDateStart
                            AND Movement.OperDate < inDateFinal + INTERVAL '1 DAY'
                            AND Movement.DescId = zc_Movement_Check()
                            AND Movement.StatusId = zc_Enum_Status_Complete()

         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         INNER JOIN Object AS Object_Unit ON Object_Unit.ID = MovementLinkObject_Unit.ObjectId

         INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                               ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_Unit.ObjectId
                              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
         INNER JOIN Object AS Object_Juridical ON Object_Juridical.ID = ObjectLink_Unit_Juridical.ChildObjectId

         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 25.03.21                                                      *
*/

-- тест
-- 
select * from gpReport_Check_CorrectMarketing(inDateStart := ('01.03.2021')::TDateTime , inDateFinal := ('31.03.2021')::TDateTime,  inSession := '3');