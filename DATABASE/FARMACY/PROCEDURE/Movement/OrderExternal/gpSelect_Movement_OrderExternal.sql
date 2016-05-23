-- Function: gpSelect_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternal(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , MasterId Integer, MasterInvNumber TVarChar, OrderKindName TVarChar
             , Comment TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
--        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
  --                       UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
--                              )
        , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )

       SELECT
             Movement_OrderExternal_View.Id
           , Movement_OrderExternal_View.InvNumber
           , Movement_OrderExternal_View.OperDate
           , Movement_OrderExternal_View.StatusCode
           , Movement_OrderExternal_View.StatusName
           , Movement_OrderExternal_View.TotalCount
           , Movement_OrderExternal_View.TotalSum
--           , Movement_OrderExternal_View.PriceWithVAT
           , Movement_OrderExternal_View.FromId
           , Movement_OrderExternal_View.FromName
           , Movement_OrderExternal_View.ToId
           , Movement_OrderExternal_View.ToName
           , Movement_OrderExternal_View.JuridicalName
           , Movement_OrderExternal_View.ContractId
           , Movement_OrderExternal_View.ContractName
           , Movement_OrderExternal_View.MasterId
           , Movement_OrderExternal_View.MasterInvNumber
           , Object_OrderKind.ValueData                   AS OrderKindName
           , Movement_OrderExternal_View.Comment

       FROM tmpUnit
          LEFT JOIN Movement_OrderExternal_View ON Movement_OrderExternal_View.ToId = tmpUnit.UnitId
                                               AND Movement_OrderExternal_View.OperDate BETWEEN inStartDate AND inEndDate

          LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderKind
                                       ON MovementLinkObject_OrderKind.MovementId = Movement_OrderExternal_View.MasterId
                                      AND MovementLinkObject_OrderKind.DescId = zc_MovementLinkObject_OrderKind()
          LEFT JOIN Object AS Object_OrderKind ON Object_OrderKind.Id = MovementLinkObject_OrderKind.ObjectId

          JOIN tmpStatus ON tmpStatus.StatusId = Movement_OrderExternal_View.StatusId 
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_OrderExternal (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.05.16         *
 15.07.14                                                        *
 01.07.14                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderExternal (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')