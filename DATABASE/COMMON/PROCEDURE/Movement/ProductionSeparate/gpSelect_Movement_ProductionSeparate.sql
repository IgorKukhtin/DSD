-- Function: gpSelect_Movement_ProductionSeparate()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionSeparate(
    IN inStartDate         TDateTime,
    IN inEndDate           TDateTime,
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
               , TotalCount TFloat, TotalCountChild TFloat, TotalHeadCount TFloat, TotalHeadCountChild TFloat
               , PartionGoods TVarChar
               , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
               , isCalculated Boolean, isAuto Boolean
               , UnionName TVarChar
               , UnionDate TDateTime
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsIrna Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Movement_ProductionSeparate());
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!Только просмотр Аудитор!!!
   PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

   -- !!!Ирна!!!
   vbIsIrna:= zfCalc_User_isIrna (vbUserId);


   RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )

     SELECT Movement.Id                          AS Id
          , Movement.InvNumber                   AS InvNumber
          , Movement.OperDate                    AS OperDate
          , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
          , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName

          , MovementFloat_TotalCount.ValueData          AS TotalCount
          , MovementFloat_TotalCountChild.ValueData     AS TotalCountChild
          , MovementFloat_TotalHeadCount.ValueData      AS TotalHeadCount
          , MovementFloat_TotalHeadCountChild.ValueData AS TotalHeadCountChild
          , MovementString_PartionGoods.ValueData       AS PartionGoods

          , Object_From.Id                       AS FromId
          , Object_From.ValueData                AS FromName
          , Object_To.Id                         AS ToId
          , Object_To.ValueData                  AS ToName
          , COALESCE (MovementBoolean_Calculated.ValueData, FALSE) :: Boolean AS isCalculated
          , COALESCE(MovementBoolean_isAuto.ValueData, False)      :: Boolean AS isAuto

          , Object_Union.ValueData               AS UnionName
          , MovementDate_Union.ValueData         AS UnionDate

     FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_ProductionSeparate() AND Movement.StatusId = tmpStatus.StatusId
--                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                  LEFT JOIN ObjectLink AS ObjectLink_Unit_Business_from
                                       ON ObjectLink_Unit_Business_from.ObjectId = MovementLinkObject_From.ObjectId
                                      AND ObjectLink_Unit_Business_from.DescId   = zc_ObjectLink_Unit_Business()
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                  LEFT JOIN ObjectLink AS ObjectLink_Unit_Business_to
                                       ON ObjectLink_Unit_Business_to.ObjectId = MovementLinkObject_To.ObjectId
                                      AND ObjectLink_Unit_Business_to.DescId   = zc_ObjectLink_Unit_Business()
           WHERE (vbIsIrna IS NULL
               OR (vbIsIrna = FALSE AND COALESCE (ObjectLink_Unit_Business_from.ChildObjectId, 0) <> zc_Business_Irna())
               OR (vbIsIrna = FALSE AND COALESCE (ObjectLink_Unit_Business_to.ChildObjectId, 0)   <> zc_Business_Irna())
               OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business_from.ChildObjectId = zc_Business_Irna())
               OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business_to.ChildObjectId   = zc_Business_Irna())
                 )
            ) AS tmpMovement

          LEFT JOIN Movement ON Movement.id = tmpMovement.id

          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                  ON MovementFloat_TotalCount.MovementId = Movement.Id
                                 AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

          LEFT JOIN MovementFloat AS MovementFloat_TotalCountChild
                                  ON MovementFloat_TotalCountChild.MovementId = Movement.Id
                                 AND MovementFloat_TotalCountChild.DescId = zc_MovementFloat_TotalCountChild()

          LEFT JOIN MovementFloat AS MovementFloat_TotalHeadCount
                                  ON MovementFloat_TotalHeadCount.MovementId = Movement.Id
                                 AND MovementFloat_TotalHeadCount.DescId = zc_MovementFloat_TotalHeadCount()

          LEFT JOIN MovementFloat AS MovementFloat_TotalHeadCountChild
                                  ON MovementFloat_TotalHeadCountChild.MovementId = Movement.Id
                                 AND MovementFloat_TotalHeadCountChild.DescId = zc_MovementFloat_TotalHeadCountChild()

          LEFT JOIN MovementString AS MovementString_PartionGoods
                                   ON MovementString_PartionGoods.MovementId = Movement.Id
                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

          LEFT JOIN MovementBoolean AS MovementBoolean_Calculated
                                    ON MovementBoolean_Calculated.MovementId = Movement.Id
                                   AND MovementBoolean_Calculated.DescId = zc_MovementBoolean_Calculated()

          LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                    ON MovementBoolean_isAuto.MovementId = Movement.Id
                                   AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Union
                                       ON MovementLinkObject_Union.MovementId = Movement.Id
                                      AND MovementLinkObject_Union.DescId = zc_MovementLinkObject_Union()
          LEFT JOIN Object AS Object_Union ON Object_Union.Id = MovementLinkObject_Union.ObjectId

          LEFT JOIN MovementDate AS MovementDate_Union 
                                 ON MovementDate_Union.MovementId = Movement.Id
                                AND MovementDate_Union.DescId = zc_MovementDate_Union()

          ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.02.19         * add TotalHeadCount
 07.10.18         * add isCalculated
 05.10.16         * add inJuridicalBasisId
 03.06.14                                                        *
 28.05.14                                                        *
 16.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProductionSeparate (inStartDate:= '30.01.2022', inEndDate:= '01.02.2022', inIsErased:= FALSE, inJuridicalBasisId:= 0, inSession:= '2')
