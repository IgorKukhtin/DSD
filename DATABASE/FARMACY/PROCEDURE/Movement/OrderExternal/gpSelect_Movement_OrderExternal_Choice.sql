-- Function: gpSelect_Movement_OrderExternal_Choice()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal_Choice (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal_Choice (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternal_Choice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inJuridicalId   Integer,
    IN inUnitId        Integer,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumber_full TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , isDeferred Boolean
             , OrderKindId Integer, OrderKindName TVarChar
             , UpdateDate TDateTime
             , Comment TVarChar
             , isDifferent Boolean
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
--     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)

       SELECT
             Movement_OrderExternal_View.Id
           , Movement_OrderExternal_View.InvNumber
           , ('№ ' || Movement_OrderExternal_View.InvNumber ||' от '||TO_CHAR(Movement_OrderExternal_View.OperDate , 'DD.MM.YYYY') ) :: TVarChar AS InvNumber_full
           , Movement_OrderExternal_View.OperDate
           , Movement_OrderExternal_View.StatusCode
           , Movement_OrderExternal_View.StatusName
           , Movement_OrderExternal_View.TotalCount
           , Movement_OrderExternal_View.TotalSum
           , Movement_OrderExternal_View.FromId
           , Movement_OrderExternal_View.FromName
           , Movement_OrderExternal_View.ToId
           , Movement_OrderExternal_View.ToName
           , Movement_OrderExternal_View.JuridicalName
           , Movement_OrderExternal_View.ContractId
           , Movement_OrderExternal_View.ContractName
           , Movement_OrderExternal_View.isDeferred

           , Object_OrderKind.Id           AS OrderKindId
           , Object_OrderKind.ValueData    AS OrderKindName
           , MovementDate_Update.ValueData AS UpdateDate
           , Movement_OrderExternal_View.Comment
           , COALESCE (MovementBoolean_Different.ValueData, FALSE) :: Boolean  AS isDifferent
       FROM Movement_OrderExternal_View 
             JOIN tmpStatus ON tmpStatus.StatusId = Movement_OrderExternal_View.StatusId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderKind
                                          ON MovementLinkObject_OrderKind.MovementId = Movement_OrderExternal_View.MasterId
                                         AND MovementLinkObject_OrderKind.DescId = zc_MovementLinkObject_OrderKind()
             LEFT JOIN Object AS Object_OrderKind ON Object_OrderKind.Id = MovementLinkObject_OrderKind.ObjectId
    
             LEFT JOIN MovementDate AS MovementDate_Update
                                    ON MovementDate_Update.MovementId = Movement_OrderExternal_View.Id
                                   AND MovementDate_Update.DescId = zc_MovementDate_Update()

             -- точка другого юр.лица
             LEFT JOIN MovementBoolean AS MovementBoolean_Different
                                       ON MovementBoolean_Different.MovementId = Movement_OrderExternal_View.Id
                                      AND MovementBoolean_Different.DescId = zc_MovementBoolean_Different()

       WHERE Movement_OrderExternal_View.OperDate BETWEEN inStartDate AND inEndDate
         AND (Movement_OrderExternal_View.FromId = inJuridicalId OR inJuridicalId = 0)
         AND (Movement_OrderExternal_View.ToId = inUnitId OR inUnitId = 0)
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.12.16         * add isDeferred
 25.04.16         *
 22.04.16         *
*/


-- тест
-- SELECT * FROM gpSelect_Movement_OrderExternal_Choice (inStartDate:= '01.02.2016', inEndDate:= '08.02.2016', inIsErased := FALSE, inJuridicalId:= 0, inSession:= '3')
-- select * from gpSelect_Movement_OrderExternal_Choice(instartdate := ('01.02.2016')::TDateTime , inenddate := ('28.02.2016')::TDateTime , inIsErased := 'False' , inJuridicalId := 183353 ,  inSession := '3');