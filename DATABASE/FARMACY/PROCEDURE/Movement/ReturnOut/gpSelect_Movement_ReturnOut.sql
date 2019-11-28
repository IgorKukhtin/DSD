-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnOut (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReturnOut(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , InvNumberPartner TVarChar
             , OperDate TDateTime
             , OperDatePartner TDateTime 
             , BranchDate TDateTime, BranchUser TVarChar 
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSumm TFloat
             , PriceWithVAT Boolean
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar, NDS TFloat
             , IncomeOperDate TDateTime, IncomeInvNumber TVarChar
             , JuridicalName TVarChar
             , ReturnTypeName TVarChar
             , AdjustingOurDate TDateTime
             , Comment TVarChar
             , isDeferred Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )

        , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )

       SELECT
             Movement_ReturnOut_View.Id
           , Movement_ReturnOut_View.InvNumber
           , Movement_ReturnOut_View.InvNumberPartner
           , Movement_ReturnOut_View.OperDate
           , Movement_ReturnOut_View.OperDatePartner
           , MovementDate_Branch.ValueData          AS BranchDate
           , Object_User.ValueData                  AS BranchUser
           , Movement_ReturnOut_View.StatusCode
           , Movement_ReturnOut_View.StatusName
           , Movement_ReturnOut_View.TotalCount
           , Movement_ReturnOut_View.TotalSummMVAT
           , Movement_ReturnOut_View.TotalSumm
           , Movement_ReturnOut_View.PriceWithVAT
           , Movement_ReturnOut_View.FromId
           , Movement_ReturnOut_View.FromName
           , Movement_ReturnOut_View.ToId
           , Movement_ReturnOut_View.ToName
           , Movement_ReturnOut_View.NDSKindId
           , Movement_ReturnOut_View.NDSKindName
           , ObjectFloat_NDSKind_NDS.ValueData      AS NDS
           , Movement_ReturnOut_View.IncomeOperDate
           , Movement_ReturnOut_View.IncomeInvNumber
           , Movement_ReturnOut_View.JuridicalName
           , Movement_ReturnOut_View.ReturnTypeName
           , Movement_ReturnOut_View.AdjustingOurDate
           , COALESCE (MovementString_Comment.ValueData,'')        :: TVarChar AS Comment
           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean  AS isDeferred
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
       FROM tmpUnit
           LEFT JOIN Movement_ReturnOut_View ON Movement_ReturnOut_View.FromId = tmpUnit.UnitId
                                            AND Movement_ReturnOut_View.OperDate BETWEEN inStartDate AND inEndDate
           INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_ReturnOut_View.StatusId

           LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                 ON ObjectFloat_NDSKind_NDS.ObjectId = Movement_ReturnOut_View.NDSKindId 
                                AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

           LEFT JOIN MovementDate AS MovementDate_Branch
                                  ON MovementDate_Branch.MovementId = Movement_ReturnOut_View.Id
                                 AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                        ON MovementLinkObject_User.MovementId = Movement_ReturnOut_View.Id
                                       AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
           LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

           LEFT JOIN MovementString AS MovementString_Comment
                                    ON MovementString_Comment.MovementId = Movement_ReturnOut_View.Id
                                   AND MovementString_Comment.DescId = zc_MovementString_Comment()

           LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                     ON MovementBoolean_Deferred.MovementId = Movement_ReturnOut_View.Id
                                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

           LEFT JOIN MovementDate AS MovementDate_Insert
                                  ON MovementDate_Insert.MovementId = Movement_ReturnOut_View.Id
                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
           LEFT JOIN MovementLinkObject AS MLO_Insert
                                        ON MLO_Insert.MovementId = Movement_ReturnOut_View.Id
                                       AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

           LEFT JOIN MovementDate AS MovementDate_Update
                                  ON MovementDate_Update.MovementId = Movement_ReturnOut_View.Id
                                 AND MovementDate_Update.DescId = zc_MovementDate_Update()
           LEFT JOIN MovementLinkObject AS MLO_Update
                                        ON MLO_Update.MovementId = Movement_ReturnOut_View.Id
                                       AND MLO_Update.DescId = zc_MovementLinkObject_Update()
           LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId 
  ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_ReturnOut (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 22.11.19         *
 19.11.19                                                                     *
 29.05.19         * add BranchDate
 29.05.18                                                                     * 
 05.01.18         * add NDS
 04.05.16         *
 06.02.15                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReturnOut (inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= '2')