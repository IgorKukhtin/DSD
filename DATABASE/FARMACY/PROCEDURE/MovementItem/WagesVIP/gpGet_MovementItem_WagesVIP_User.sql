-- Function: gpGet_MovementItem_WagesVIP_User()

DROP FUNCTION IF EXISTS gpGet_MovementItem_WagesVIP_User (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_WagesVIP_User(
    IN inOperDate          TDateTime , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate  TDateTime
             , MemberCode Integer, MemberName TVarChar
             , AmountAccrued TFloat
             , ApplicationAward TFloat
             , TotalSum TFloat
             , HoursWork TFloat
              )
AS
$BODY$
   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    
   IF vbUserId = 3
   THEN
     vbUserId := 390046;
   END IF;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_VIPManager())
   THEN
      RAISE EXCEPTION 'По вам не предусмотрен показ З/П.';   
   END IF;

    -- проверка наличия З/П
    IF EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', inOperDate)
              AND Movement.DescId = zc_Movement_WagesVIP())
    THEN
    
      SELECT Movement.ID 
      INTO vbMovementID
      FROM Movement
      WHERE Movement.OperDate = date_trunc('month', inOperDate)
        AND Movement.DescId = zc_Movement_WagesVIP();
            
        -- Наличие записи по сотруднику в З/П
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementId = vbMovementID
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.ObjectId = vbUserId)
      THEN

        RETURN QUERY
        SELECT  date_trunc('month', inOperDate)::TDateTime  AS OperDate
              , Object_Member.ObjectCode           AS MemberCode
              , Object_Member.ValueData            AS MemberName

              , MovementItem.Amount                AS AmountAccrued
              , MIFloat_ApplicationAward.ValueData AS ApplicationAward
              , (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_ApplicationAward.ValueData , 0))::TFloat AS TotalSum
              , MIFloat_HoursWork.ValueData        AS HoursWork
        FROM MovementItem

             LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                  ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
             LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId


             LEFT JOIN MovementItemFloat AS MIFloat_ApplicationAward
                                         ON MIFloat_ApplicationAward.MovementItemId = MovementItem.Id
                                        AND MIFloat_ApplicationAward.DescId = zc_MIFloat_ApplicationAward()

             LEFT JOIN MovementItemFloat AS MIFloat_HoursWork
                                         ON MIFloat_HoursWork.MovementItemId = MovementItem.Id
                                        AND MIFloat_HoursWork.DescId = zc_MIFloat_HoursWork()

        WHERE MovementItem.MovementId = vbMovementID
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.ObjectId = vbUserId
        ;
      ELSE
        RAISE EXCEPTION 'По вам не найдена З/П.';   
      END IF;	
    ELSE
      RAISE EXCEPTION 'З/П за % не найдена.', zfCalc_MonthYearName(inOperDate);   
    END IF;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_MovementItem_WagesVIP_User (TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.09.19                                                       *
 23.02.19                                                       *
*/

-- тест
-- select * from gpGet_MovementItem_EmployeeScheduleVIP_User(inSession := '3');

-- 

select * from gpGet_MovementItem_WagesVIP_User(inOperDate := '20.10.2021', inSession := '3');