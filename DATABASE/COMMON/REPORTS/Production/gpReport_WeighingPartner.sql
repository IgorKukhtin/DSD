-- Function: gpReport_WeighingPartner()

DROP FUNCTION IF EXISTS gpReport_WeighingPartner (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_WeighingPartner(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inPersonalId  Integer   , -- сотудник
    IN inPositionId  Integer   , -- должность
    IN inIsDay       Boolean   , -- признак группировки по дням - да/нет
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE ( OperDate TDateTime
             , PersonalCode Integer, PersonalName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , TotalCount TFloat, TotalCountPartner TFloat, TotalCountKg TFloat --
             , CountMI TFloat
             , CountMovement TFloat
            
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       WITH tmpListDesc AS ( SELECT zc_MovementLinkObject_PersonalComplete1() AS PersonalDescId, zc_MovementLinkObject_PositionComplete1() AS PositionDescId, 1 AS CountDesc 
                           Union 
                             SELECT zc_MovementLinkObject_PersonalComplete1() AS PersonalDescId, zc_MovementLinkObject_PositionComplete1() AS PositionDescId, 2 AS CountDesc
                           Union 
                             SELECT zc_MovementLinkObject_PersonalComplete2() AS PersonalDescId, zc_MovementLinkObject_PositionComplete2() AS PositionDescId, 2 AS CountDesc

                           Union 
                             SELECT zc_MovementLinkObject_PersonalComplete1() AS PersonalDescId, zc_MovementLinkObject_PositionComplete1() AS PositionDescId, 3 AS CountDesc
                           Union 
                             SELECT zc_MovementLinkObject_PersonalComplete2() AS PersonalDescId, zc_MovementLinkObject_PositionComplete2() AS PositionDescId, 3 AS CountDesc
                           Union 
                             SELECT zc_MovementLinkObject_PersonalComplete3() AS PersonalDescId, zc_MovementLinkObject_PositionComplete3() AS PositionDescId, 3 AS CountDesc
 
                           Union 
                             SELECT zc_MovementLinkObject_PersonalComplete1() AS PersonalDescId, zc_MovementLinkObject_PositionComplete1() AS PositionDescId, 4 AS CountDesc
                           Union 
                             SELECT zc_MovementLinkObject_PersonalComplete2() AS PersonalDescId, zc_MovementLinkObject_PositionComplete2() AS PositionDescId, 4 AS CountDesc
                           Union 
                             SELECT zc_MovementLinkObject_PersonalComplete3() AS PersonalDescId, zc_MovementLinkObject_PositionComplete3() AS PositionDescId, 4 AS CountDesc
                           Union 
                             SELECT zc_MovementLinkObject_PersonalComplete4() AS PersonalDescId, zc_MovementLinkObject_PositionComplete4() AS PositionDescId, 4 AS CountDesc
                           )
                           
       , tmpMovement AS (SELECT    Movement.Id AS MovementId 
                                 , Movement.InvNumber
                                 , Movement.OperDate
                                 , Count(MovementLinkObject_Personal.ObjectId)::TFloat AS CountPersonal  --MovementLinkObject_Personal.ObjectId AS PersonalID
                            FROM Movement
                            LEFT JOIN tmpListDesc on tmpListDesc. CountDesc = 4
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                      ON MovementLinkObject_Personal.MovementId = Movement.Id
                                                     and tmpListDesc.PersonalDescId = MovementLinkObject_Personal.DescId
                            WHERE Movement.DescId = zc_Movement_WeighingPartner()
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                             -- AND Movement.Id in (759166,740060,740078)
                            --  AND Movement.StatusId = zc_Enum_Status_Complete()    
                          GROUP BY  Movement.Id, Movement.InvNumber, Movement.OperDate
                         
                          )
        

       , tmpMovementMI AS (SELECT MovementItem.MovementId AS MovementId
                                , Count(MovementItem.Id) AS CountMI 
                           FROM MovementItem 
                           WHERE MovementItem.MovementId in (Select tmpMovement.MovementId from tmpMovement)
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = False
                           GROUP BY MovementItem.MovementId 
                          )
          
        SELECT  tmp.OperDate
              , tmp.PersonalCode
              , tmp.PersonalName
              , tmp.PositionCode
              , tmp.PositionName
                   
              , SUM(tmp.TotalCount)::TFloat        as TotalCount 
              , SUM(tmp.TotalCountPartner)::TFloat as TotalCountPartner 
              , SUM(tmp.TotalCountKg)::TFloat      as TotalCountKg 
               
              , SUM(tmp.CountMI)::TFloat as CountMI 
              , SUM(tmp.CountMovement)::TFloat as CountMovement
              
        FROM ( SELECT CASE WHEN inIsDay = TRUE THEN tmpMovement.OperDate ELSE inEndDate END AS OperDate
           
             ,( CASE WHEN COALESCE(tmpMovement.CountPersonal,0) > 0 THEN MovementFloat_TotalCount.ValueData/tmpMovement.CountPersonal ELSE MovementFloat_TotalCount.ValueData END) ::TFloat                      AS TotalCount  
             ,( CASE WHEN COALESCE(tmpMovement.CountPersonal,0) > 0 THEN MovementFloat_TotalCountPartner.ValueData /tmpMovement.CountPersonal ELSE MovementFloat_TotalCountPartner.ValueData  END )::TFloat      AS TotalCountPartner
             ,( CASE WHEN COALESCE(tmpMovement.CountPersonal,0) > 0 THEN MovementFloat_TotalCountKg.ValueData/tmpMovement.CountPersonal ELSE MovementFloat_TotalCountKg.ValueData  END )::TFloat                 AS TotalCountKg
             
             , Object_Personal.ObjectCode AS PersonalCode, Object_Personal.ValueData AS PersonalName
             , Object_Position.ObjectCode AS PositionCode, Object_Position.ValueData AS PositionName

             , (CASE WHEN COALESCE(tmpMovement.CountPersonal,0) > 0 THEN tmpMI.CountMI/tmpMovement.CountPersonal ELSE tmpMI.CountMI END )::TFloat AS CountMI
             , 1 AS CountMovement
       FROM tmpMovement 
            LEFT JOIN tmpListDesc on  tmpListDesc.CountDesc  = tmpMovement.CountPersonal

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = tmpMovement.MovementId
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  tmpMovement.MovementId
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId = tmpMovement.MovementId
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  tmpMovement.MovementId
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                                   
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = tmpMovement.MovementId
                                        AND MovementLinkObject_Personal.DescId = tmpListDesc.PersonalDescId
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position
                                         ON MovementLinkObject_Position.MovementId =tmpMovement.MovementId
                                        AND MovementLinkObject_Position.DescId =  tmpListDesc.PositionDescId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MovementLinkObject_Position.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId =tmpMovement.MovementId
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

            INNER JOIN tmpMovementMI AS tmpMI on tmpMI.MovementId = tmpMovement.MovementId
            ) AS tmp 
     GROUP BY tmp.OperDate
              , tmp.PersonalCode
              , tmp.PersonalName
              , tmp.PositionCode
              , tmp.PositionName
                    

      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpReport_WeighingPartner (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.05.15         *
*/

-- тест
--SELECT * FROM gpReport_WeighingPartner (inStartDate:= '01.12.2014', inEndDate:= '02.12.2014', inPersonalId:=0, inPositionId:=0, inIsDay:=False, inSession:= zfCalc_UserAdmin())
 --SELECT * FROM gpReport_WeighingPartner (inStartDate:= '01.12.2014', inEndDate:= '02.12.2014', inPersonalId:=0, inPositionId:=0, inIsDay:=True, inSession:= zfCalc_UserAdmin())
