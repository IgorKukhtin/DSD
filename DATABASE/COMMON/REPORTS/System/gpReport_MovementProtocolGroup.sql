-- Function: gpReport_UserProtocolGroup (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_MovementProtocolGroup (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementProtocolGroup(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer , --
    IN inUserId             Integer , --
    IN inIsMovement         Boolean , -- галка по дате док (по умолчанию - да) 
    IN inSession            TVarChar  -- сессия пользователя
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar
             , MemberName     TVarChar
             , PositionName   TVarChar
             , UnitId Integer, UnitName TVarChar
             , BranchId Integer, BranchName TVarChar
             , MovementId          Integer
             , InsertDate TDateTime
             , UpdateDate TDateTime 
             , Count_korr TFloat
             , Invnumber_Movement  Integer
             , DescId_Movement     Integer
             , DescName_Movement   TVarChar
             , OperDate   TDateTime
             , OperDatePartner TDateTime
             , StatusCode          Integer
             , StatusName          TVarChar
             , FromName            TVarChar
             , ToName              TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- Результат
   RETURN QUERY 
    WITH 
    tmpPersonal AS (SELECT View_Personal.MemberId
                          , MAX (View_Personal.PersonalId) AS PersonalId
                          , MAX (View_Personal.UnitId) AS UnitId
                          , MAX (View_Personal.PositionId) AS PositionId
                    FROM Object_Personal_View AS View_Personal
                    GROUP BY View_Personal.MemberId
                    )

  , tmpUser AS (SELECT Object_User.Id AS UserId
                     , Object_User.ObjectCode AS UserCode
                     , Object_User.ValueData  AS UserName
                     , tmpPersonal.MemberId 
                     , ObjectLink_Unit_Branch.ChildObjectId AS BranchId
                     , tmpPersonal.UnitId
                     , tmpPersonal.PositionId
                FROM Object AS Object_User
                      LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                      LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
                      LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = tmpPersonal.UnitId
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                WHERE Object_User.DescId = zc_Object_User()
                )

  , tmpUnit AS (SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId
                FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup
                WHERE inUnitId <> 0
               UNION
                SELECT Object.Id AS UnitId 
                FROM Object
                WHERE Object.DescId = zc_Object_Unit() 
                  AND COALESCE (inUnitId, 0) = 0
               )

    -- Данные из протокола строк документа
  , tmpMI_Protocol AS (SELECT MovementProtocol.UserId              AS UserId
                            , MovementProtocol.IsInsert            AS IsInsert
                            , MovementProtocol.OperDate            AS OperDate_Protocol
                            , MovementProtocol.MovementId          AS MovementId
                            , Movement.StatusId                    AS StatusId_Movement
                            , Movement.OperDate                    AS OperDate_Movement
                            , Movement.Invnumber                   AS Invnumber_Movement
                            , Movement.DescId                      AS DescId_Movement
                            , MovementDesc.ItemName                AS DescName_Movement
                            , MovementLinkObject_From.ObjectId     AS FromId_Movement
                            , MovementLinkObject_To.ObjectId       AS ToId_Movement
                            , 1 AS Count -- параметр для расчета операций
                            , MAX (MovementProtocol.OperDate) OVER (PARTITION BY MovementProtocol.MovementId, MovementProtocol.UserId) AS OperDate_Last
                       FROM MovementProtocol
                            LEFT JOIN Movement ON Movement.Id = MovementProtocol.MovementId
                            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                            INNER JOIN tmpUnit ON (tmpUnit.UnitId = MovementLinkObject_From.ObjectId 
                                                  OR 
                                                   tmpUnit.UnitId = MovementLinkObject_To.ObjectId)

                       WHERE  (MovementProtocol.UserId = inUserId OR inUserId = 0)
                          AND ( (inIsMovement = FALSE AND MovementProtocol.OperDate >= inStartDate AND MovementProtocol.OperDate < inEndDate + INTERVAL '1 DAY')
                               OR 
                                (inIsMovement = TRUE AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate + INTERVAL '1 DAY')
                              )
                        
                      ) 
        , tmpMovementDate AS (SELECT MovementDate.*
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMI_Protocol.MovementId FROM tmpMI_Protocol)
                                AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                              )
        , MovementProtocol_insert AS(SELECT MovementProtocol.*
                                     FROM MovementProtocol
                                     WHERE MovementProtocol.MovementId IN (SELECT DISTINCT tmpMI_Protocol.MovementId FROM tmpMI_Protocol)
                                       AND MovementProtocol.IsInsert = TRUE
                                     )

------------------------

     -- Результат 
     SELECT tmpData.UserId
          , COALESCE (tmpUser.UserCode, Object_User.ObjectCode) ::Integer  AS UserCode
          , COALESCE (tmpUser.UserName, Object_User.ValueData)  ::TVarChar AS UserName

          , Object_Member.ValueData           AS MemberName 
          , Object_Position.ValueData         AS PositionName 
          , Object_Unit.Id                    AS UnitId
          , Object_Unit.ValueData             AS UnitName
          , Object_Branch.Id                  AS BranchId
          , Object_Branch.ValueData           AS BranchName

          , tmpData.MovementId         ::Integer
          , MovementProtocol_insert.OperDate    ::TDateTime AS InsertDate
          --, tmpData.OperDate_Last ::TDateTime   ::TDateTime AS UpdateDate --, дата/вр последн корр (или удаления) этим пользователем
          , MAX (tmpData.OperDate_Protocol) ::TDateTime AS UpdateDate
          , SUM (tmpData.Count)  ::TFloat AS Count_korr--, кол-во таких корр (или удалений.) этим пользователем

          , CASE WHEN COALESCE (tmpData.Invnumber_Movement, '') = '' THEN '0' ELSE tmpData.Invnumber_Movement END ::Integer AS Invnumber_Movement
          , tmpData.DescId_Movement    ::Integer
          , tmpData.DescName_Movement  ::TVarChar

          , tmpData.OperDate_Movement               ::TDateTime AS OperDate
          , MovementDate_OperDatePartner.ValueData  ::TDateTime AS OperDatePartner

          , Object_Status.ObjectCode          AS StatusCode
          , Object_Status.ValueData           AS StatusName
 
          , Object_From.ValueData     ::TVarChar  AS FromName
          , Object_To.ValueData       ::TVarChar  AS ToName

     FROM tmpMI_Protocol AS tmpData
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId_Movement

          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId_Movement --and 0=9
          LEFT JOIN Object AS Object_To ON Object_To.Id = tmpData.ToId_Movement

          LEFT JOIN tmpUser ON tmpUser.UserId = tmpData.UserId
          LEFT JOIN Object AS Object_User ON Object_User.Id = tmpData.UserId

          LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpUser.MemberId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpUser.PositionId 
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUser.UnitId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpUser.BranchId

          LEFT JOIN MovementProtocol_insert ON MovementProtocol_insert.MovementId = tmpData.MovementId
                                           --AND MovementProtocol_insert.IsInsert = TRUE
          LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                    ON MovementDate_OperDatePartner.MovementId = tmpData.MovementId
                                   AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

    GROUP BY tmpData.UserId
          , COALESCE (tmpUser.UserCode, Object_User.ObjectCode)
          , COALESCE (tmpUser.UserName, Object_User.ValueData)
          , Object_Member.ValueData      
          , Object_Position.ValueData    
          , Object_Unit.Id          
          , Object_Unit.ValueData  
          , Object_Branch.Id
          , Object_Branch.ValueData 
          , tmpData.MovementId 
          , MovementProtocol_insert.OperDate
          --, tmpData.OperDate_Last
          , CASE WHEN COALESCE (tmpData.Invnumber_Movement, '') = '' THEN '0' ELSE tmpData.Invnumber_Movement END
          , tmpData.DescId_Movement
          , tmpData.DescName_Movement 
          , tmpData.OperDate_Movement  
          , MovementDate_OperDatePartner.ValueData 
          , Object_Status.ObjectCode 
          , Object_Status.ValueData
          , Object_From.ValueData
          , Object_To.ValueData

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.11.21         *
*/
-- тест
--
/*
SELECT * FROM gpReport_MovementProtocolGroup (inStartDate:= '01.10.2021' ::TDateTime, inEndDate:= '08.10.2021'::TDateTime, inUnitId:= 0, inUserId:= 343013, inIsMovement:=TRUE, inSession:= '5'::TVarChar)
where MovementId = 21161737
order by DescName_Movement, OperDate, MovementId
*/
