-- Function: gpSelect_Movement_Task()

DROP FUNCTION IF EXISTS gpSelect_Movement_Task (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Task(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsErased           Boolean   ,
    IN inJuridicalBasisId   Integer   ,
    IN inMemberId           Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , PersonalTradeId Integer, PersonalTradeCode Integer, PersonalTradeName TVarChar
             , InsertId Integer, InsertCode Integer, InsertName TVarChar
             , InsertDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId          Integer;

   DECLARE vbIsProjectMobile Boolean;
   DECLARE vbUserId_Member   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Task());
     vbUserId:= lpGetUserBySession (inSession);


     -- Только так определяется что пользователь inSession - Торговый агент - т.е. у него есть моб телефон, может потом для этого заведем спец роль и захардкодим
     vbIsProjectMobile:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = vbUserId AND ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile());

     IF inMemberId > 0
     THEN
         -- Определяется для <Физическое лицо> - его UserId
         vbUserId_Member:= (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Member() AND OL.ChildObjectId = inMemberId);
         -- Проверка
         IF COALESCE (vbUserId_Member, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Для ФИО <%> не определно значение <Пользователь>.', lfGet_Object_ValueData (inMemberId);
         END IF;

     ELSEIF vbIsProjectMobile = TRUE
     THEN
         -- в этом случае - видит только себя
         vbUserId_Member:= vbUserId;
         -- !!!меняем значение!!! - Определяется для UserId - его <Физическое лицо>
         inMemberId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Member() AND OL.ObjectId = vbUserId);
         -- Проверка
         IF COALESCE (inMemberId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Для Пользователя <%> не определно значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
         END IF;
     ELSE
         -- в этом случае - видит ВСЕ
         vbUserId_Member:= 0;
         -- !!!меняем значение!!!
         inMemberId:= 0;
     END IF;


     -- Проверка - Торговый агент видит только себя
     IF vbIsProjectMobile = TRUE AND vbUserId_Member <> vbUserId
     THEN
         RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.';
     END IF;


     -- Результат
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                          )
         , tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
        -- Результат
        SELECT
             Movement.Id                               AS Id
           , Movement.InvNumber                        AS InvNumber
           , Movement.OperDate                         AS OperDate
           , Object_Status.ObjectCode                  AS StatusCode
           , Object_Status.ValueData                   AS StatusName
           , Object_Branch.ObjectCode                  AS BranchCode
           , Object_Branch.ValueData                   AS BranchName
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName
           , Object_Position.ObjectCode                AS PositionCode
           , Object_Position.ValueData                 AS PositionName
           , Object_PersonalTrade.Id                   AS PersonalTradeId
           , Object_PersonalTrade.ObjectCode           AS PersonalTradeCode
           , Object_PersonalTrade.ValueData            AS PersonalTradeName
           , Object_Insert.Id                          AS InsertId
           , Object_Insert.ObjectCode                  AS InsertCode
           , Object_Insert.ValueData                   AS InsertName
           , MovementDate_Insert.ValueData             AS InsertDate
           
        FROM tmpStatus
             INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                AND Movement.DescId = zc_Movement_Task()
                                AND Movement.StatusId = tmpStatus.StatusId
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

             LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                       ON MovementBoolean_Closed.MovementId = Movement.Id
                                      AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                          ON MovementLinkObject_PersonalTrade.MovementId = Movement.Id
                                         AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
             LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId
             LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_PersonalTrade.Id

             LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId
             LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpPersonal.UnitId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                          ON MovementLinkObject_Insert.MovementId = Movement.Id
                                         AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

        WHERE MovementLinkObject_PersonalTrade.ObjectId = inMemberId
           OR vbUserId_Member = 0
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.03.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Task (inStartDate:= '01.01.2017', inEndDate:= CURRENT_DATE, inIsErased:= TRUE, inJuridicalBasisId:= 0, inMemberId:= 0, inSession:= zfCalc_UserAdmin())
