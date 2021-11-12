-- Function: gpReport_UserProtocolGroup (TDateTime, TDateTime, TVarChar)

--DROP FUNCTION IF EXISTS gpReport_MovementProtocolGroup (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_MovementProtocolGroup (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementProtocolGroup(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
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
             , UnitName_Movement   TVarChar
             , JuridicalName       TVarChar
             , PartnerName         TVarChar
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

    -- Данные из протокола строк документа
  , tmpMI_Protocol AS (SELECT MovementProtocol.UserId              AS UserId
                            , MovementProtocol.OperDate            AS OperDate_Protocol
                            , MovementProtocol.MovementId          AS MovementId
                            , Movement.ParentId                    AS ParentId
                            , Movement.StatusId                    AS StatusId_Movement
                            , Movement.OperDate                    AS OperDate_Movement
                            , Movement.Invnumber                   AS Invnumber_Movement
                            , Movement.DescId                      AS DescId_Movement
                            , MovementDesc.ItemName                AS DescName_Movement
                            , 1 AS Count -- параметр для расчета операций
                       FROM MovementProtocol
                            LEFT JOIN Movement ON Movement.Id = MovementProtocol.MovementId
                            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                       WHERE (MovementProtocol.UserId = inUserId OR inUserId = 0)
                         AND (MovementProtocol.OperDate >= inStartDate AND MovementProtocol.OperDate < inEndDate + INTERVAL '1 DAY')
                         AND inIsMovement = FALSE
                    UNION
                       SELECT MovementProtocol.UserId              AS UserId
                            , MovementProtocol.OperDate            AS OperDate_Protocol
                            , MovementProtocol.MovementId          AS MovementId
                            , Movement.ParentId                    AS ParentId
                            , Movement.StatusId                    AS StatusId_Movement
                            , Movement.OperDate                    AS OperDate_Movement
                            , Movement.Invnumber                   AS Invnumber_Movement
                            , Movement.DescId                      AS DescId_Movement
                            , MovementDesc.ItemName                AS DescName_Movement
                            , 1 AS Count -- параметр для расчета операций
                       FROM Movement
                            LEFT JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.Id
                            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                       WHERE (MovementProtocol.UserId = inUserId OR inUserId = 0)
                         AND (Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate + INTERVAL '1 DAY')
                         AND inIsMovement = TRUE
                        
                      )
        , tmpMovement AS (SELECT DISTINCT tmpMI_Protocol.MovementId, tmpMI_Protocol.ParentId
                               , tmpMI_Protocol.DescId_Movement
                               , tmpMI_Protocol.StatusId_Movement
                               , tmpMI_Protocol.OperDate_Movement
                               , tmpMI_Protocol.Invnumber_Movement
                          FROM tmpMI_Protocol
                         )


        , tmpMovementDate AS (SELECT MovementDate.*
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement UNION SELECT DISTINCT tmpMovement.ParentId FROM tmpMovement)
                                AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                              )

        , tmpMLO AS (SELECT MovementLinkObject.*
                     FROM MovementLinkObject
                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement UNION SELECT DISTINCT tmpMovement.ParentId FROM tmpMovement)
                       AND MovementLinkObject.DescId IN (zc_MovementLinkObject_To()
                                                       , zc_MovementLinkObject_From()
                                                       , zc_MovementLinkObject_Juridical()
                                                       , zc_MovementLinkObject_Car()
                                                       , zc_MovementLinkObject_PersonalServiceList()
                                                         )
                     )

        , MovementProtocol_insert AS(SELECT MovementProtocol.*
                                     FROM MovementProtocol
                                     WHERE MovementProtocol.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement UNION SELECT DISTINCT tmpMovement.ParentId FROM tmpMovement)
                                       AND MovementProtocol.IsInsert = TRUE
                                     )

        , tmpMI AS (SELECT MI.*
                    FROM MovementItem AS MI
                    WHERE MI.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement
                                            WHERE tmpMovement.DescId_Movement IN (zc_Movement_Cash()
                                                                   , zc_Movement_Service()
                                                                   , zc_Movement_BankAccount()
                                                                   , zc_Movement_PersonalAccount()
                                                                   , zc_Movement_ProfitLossService()
                                                                   , zc_Movement_SendDebt()
                                                                    )
                                           )
                      AND MI.DescId = zc_MI_Master()
                    )

        , tmpMILO AS (SELECT MILO_MoneyPlace.*
                      FROM MovementItemLinkObject AS MILO_MoneyPlace
                      WHERE MILO_MoneyPlace.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
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

          , tmpMovement.Id         ::Integer AS MovementId
          , MovementProtocol_insert.OperDate    ::TDateTime AS InsertDate

          , MAX (tmpData.OperDate_Protocol) ::TDateTime AS UpdateDate
          , SUM (tmpData.Count)  ::TFloat AS Count_korr--, кол-во таких корр (или удалений.) этим пользователем

          , tmpMovement.Invnumber      ::Integer AS Invnumber_Movement
          , tmpData.DescId_Movement    ::Integer
          --, tmpData.DescName_Movement  ::TVarChar
          , MovementDesc.ItemName      ::TVarChar AS DescName_Movement  

          --, tmpData.OperDate_Movement               ::TDateTime AS OperDate
          , tmpMovement.OperDate             ::TDateTime AS OperDate
          , MovementDate_OperDatePartner.ValueData  ::TDateTime AS OperDatePartner

          , Object_Status.ObjectCode          AS StatusCode
          , Object_Status.ValueData           AS StatusName
 
          , Object_Unit_mov.ValueData         ::TVarChar  AS UnitName_Movement

          , Object_Juridical.ValueData ::TVarChar AS JuridicalName
          , Object_Partner.ValueData  ::TVarChar  AS PartnerName
          
     FROM tmpMI_Protocol AS tmpData

          LEFT JOIN tmpMovement AS tmpMovementCost ON tmpMovementCost.MovementId = tmpData.MovementId AND tmpMovementCost.DescId_Movement IN (zc_Movement_IncomeCost(), zc_Movement_PromoPartner())
          LEFT JOIN Movement AS tmpMovement ON tmpMovement.Id = COALESCE (tmpMovementCost.ParentId, tmpData.MovementId)
          LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.DescId_Movement

          LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId

          LEFT JOIN tmpMLO AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = tmpMovement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN tmpMLO AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = tmpMovement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN tmpMLO AS MovementLinkObject_Car
                                       ON MovementLinkObject_Car.MovementId = tmpMovement.Id
                                      AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
          LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

          LEFT JOIN tmpMLO AS MovementLinkObject_PersonalServiceList
                                       ON MovementLinkObject_PersonalServiceList.MovementId = tmpMovement.Id
                                      AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()

          LEFT JOIN tmpMLO AS MovementLinkObject_Juridical
                                       ON MovementLinkObject_Juridical.MovementId = tmpMovement.Id
                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

          LEFT JOIN tmpMI ON tmpMI.MovementId = tmpMovement.Id

          LEFT JOIN tmpMILO AS MILO_MoneyPlace
                            ON MILO_MoneyPlace.MovementItemId = tmpMI.Id
                          -- AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()

          LEFT JOIN Object AS Object_Partner on Object_Partner.Id = CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id
                                                                         WHEN Object_To.DescId   = zc_Object_Partner() THEN Object_To.Id
                                                                         WHEN MILO_MoneyPlace.ObjectId > 0 THEN MILO_MoneyPlace.ObjectId
                                                                         WHEN tmpMI.ObjectId > 0 THEN tmpMI.ObjectId
                                                                    END

          LEFT JOIN ObjectLink AS ObjectLink_Jur
                               ON ObjectLink_Jur.ObjectId = Object_Partner.Id
                              AND ObjectLink_Jur.DescId   = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = CASE WHEN Object_From.DescId = zc_Object_PartnerExternal() THEN Object_From.Id
                                                                             WHEN ObjectLink_Jur.ChildObjectId > 0 THEN ObjectLink_Jur.ChildObjectId
                                                                             WHEN MILO_MoneyPlace.ObjectId > 0 THEN MILO_MoneyPlace.ObjectId
                                                                             WHEN tmpMI.ObjectId > 0 THEN tmpMI.ObjectId
                                                                            -- WHEN Object_From.DescId = zc_Object_Juridical() THEN Object_From.Id
                                                                             WHEN Object_To.DescId = zc_Object_Juridical() THEN Object_To.Id
                                                                             ELSE MovementLinkObject_Juridical.ObjectId
                                                                        END

          LEFT JOIN Object AS Object_Unit_mov ON Object_Unit_mov.Id = CASE WHEN tmpData.DescId_Movement = zc_Movement_Loss() THEN Object_From.Id
                                                                           WHEN tmpData.DescId_Movement = zc_Movement_TransportGoods() THEN Object_Car.Id
                                                                           WHEN tmpData.DescId_Movement = zc_Movement_PersonalService() THEN MovementLinkObject_PersonalServiceList.ObjectId
                                                                           ELSE CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id 
                                                                                     WHEN Object_To.DescId = zc_Object_Unit() THEN Object_To.Id
                                                                                END
                                                                      END


          LEFT JOIN tmpUser ON tmpUser.UserId = tmpData.UserId
          LEFT JOIN Object AS Object_User ON Object_User.Id = tmpData.UserId

          LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpUser.MemberId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpUser.PositionId 
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUser.UnitId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpUser.BranchId

          LEFT JOIN MovementProtocol_insert ON MovementProtocol_insert.MovementId = tmpMovement.Id
                                           --AND MovementProtocol_insert.IsInsert = TRUE
          LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                    ON MovementDate_OperDatePartner.MovementId = tmpMovement.Id
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
          , tmpMovement.Id
          , MovementProtocol_insert.OperDate
          , tmpMovement.Invnumber
          , tmpData.DescId_Movement
          , MovementDesc.ItemName
          , tmpMovement.OperDate
          , MovementDate_OperDatePartner.ValueData
          , Object_Status.ObjectCode 
          , Object_Status.ValueData
          , Object_Unit_mov.ValueData
          , Object_Juridical.ValueData
          , Object_Partner.ValueData

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
SELECT * FROM gpReport_MovementProtocolGroup (inStartDate:= '01.10.2021' ::TDateTime, inENDDate:= '08.10.2021'::TDateTime, inUnitId:= 0, inUserId:= 343013, inIsMovement:=TRUE, inSession:= '5'::TVarChar)
where MovementId = 21161737
order by DescName_Movement, OperDate, MovementId
*/

--SELECT * FROM gpReport_MovementProtocolGroup (inStartDate:= '03.09.2021' ::TDateTime, inENDDate:= '03.09.2021'::TDateTime,  inUserId:= 6131893, inIsMovement:=TRUE, inSession:= '5'::TVarChar)
