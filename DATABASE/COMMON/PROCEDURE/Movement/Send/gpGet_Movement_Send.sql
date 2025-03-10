-- Function: gpGet_Movement_Send()

-- DROP FUNCTION gpGet_Movement_Send (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Send (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Send (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Send(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , Comment TVarChar
             , isAuto Boolean
             , isRePack Boolean
             , InsertName TVarChar
             , InsertDate TDateTime
             , MovementId_Send Integer, InvNumber_SendFull TVarChar
             , MovementId_Order Integer, InvNumberOrder TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = -1
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не выбран.' ;
     END IF;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , CAST (0 AS TFloat)                               AS TotalCount
             , 0                                                AS FromId
             , CAST ('' AS TVarChar)                            AS FromName
             , 0                                                AS ToId
             , CAST ('' AS TVarChar)                            AS ToName
             , 0                                                AS DocumentKindId
             , CAST ('' AS TVarChar)                            AS DocumentKindName
             
             , CAST ('' as TVarChar)                            AS Comment

             , FALSE                                            AS isAuto
             , FALSE                                            AS isRePack

             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP ::TDateTime                    AS InsertDate

             , 0                                                AS MovementId_Send
             , CAST ('' AS TVarChar)                            AS InvNumber_SendFull
             , 0                                                AS MovementId_Order
             , CAST ('' AS TVarChar)                            AS InvNumberOrder
             
             , 0                                                AS SubjectDocId
             , CAST ('' AS TVarChar)                            AS SubjectDocName
             , 0                                                AS PersonalGroupId
             , CAST ('' AS TVarChar)                            AS PersonalGroupName

             , 0                                                AS MovementId_Production
             , CAST ('' AS TVarChar)                            AS InvNumber_ProductionFull
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , Object_From.Id                                     AS FromId
           , (CASE WHEN Object_From.ValueData ILIKE Object_To.ValueData THEN '(' || Object_From.ObjectCode :: TVarChar ||') ' ELSE '' END || Object_From.ValueData) :: TVarChar AS FromName
           , Object_To.Id                                       AS ToId
           , (CASE WHEN Object_From.ValueData ILIKE Object_To.ValueData THEN '(' || Object_To.ObjectCode :: TVarChar ||') '  ELSE '' END || Object_To.ValueData) :: TVarChar AS ToName
           , Object_DocumentKind.Id                             AS DocumentKindId
           , Object_DocumentKind.ValueData                      AS DocumentKindName
           , MovementString_Comment.ValueData                   AS Comment

           , COALESCE(MovementBoolean_isAuto.ValueData, False)    :: Boolean  AS isAuto
           , COALESCE (MovementBoolean_isRePack.ValueData, FALSE) :: Boolean  AS isRePack

           , Object_Insert.ValueData                            AS InsertName
           , COALESCE (MovementDate_Insert.ValueData, Movement.OperDate) :: TDateTime AS InsertDate
           
           , COALESCE(Movement_Send.Id, -1)                         AS MovementId_Send
           , COALESCE(CASE WHEN Movement_Send.StatusId = zc_Enum_Status_Erased()
                       THEN '***'
                   WHEN Movement_Send.StatusId = zc_Enum_Status_UnComplete()
                       THEN '*'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (Movement_Send.DescId, MovementDesc_Send.ItemName, Movement_Send.InvNumber, Movement_Send.OperDate)
             , ' ')                     :: TVarChar      AS InvNumber_SendFull

           -- заявка
           , MovementLinkMovement_Order.MovementChildId         AS MovementId_Order
           , CASE WHEN MovementLinkMovement_Order.MovementChildId IS NOT NULL
                  THEN CASE WHEN Movement_Order.StatusId IN (zc_Enum_Status_Complete())
                                 THEN ''
                            ELSE '???'
                       END
                    || CASE WHEN TRIM (COALESCE (MovementString_InvNumberPartner_Order.ValueData, '')) <> ''
                                 THEN MovementString_InvNumberPartner_Order.ValueData
                            ELSE '***' || Movement_Order.InvNumber
                       END
             END                                    :: TVarChar AS InvNumberOrder

           , Object_SubjectDoc.Id                                 AS SubjectDocId
           , COALESCE (Object_SubjectDoc.ValueData,'') ::TVarChar AS SubjectDocName
           
           , Object_PersonalGroup.Id                              AS PersonalGroupId
           , Object_PersonalGroup.ValueData                       AS PersonalGroupName

           , COALESCE(Movement_Production.Id, -1)                 AS MovementId_Production
           , COALESCE(CASE WHEN Movement_Production.StatusId = zc_Enum_Status_Erased()
                       THEN '***'
                   WHEN Movement_Production.StatusId = zc_Enum_Status_UnComplete()
                       THEN '*'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (Movement_Production.DescId, MovementDesc_Production.ItemName, Movement_Production.InvNumber, Movement_Production.OperDate)
             , ' ')                              :: TVarChar      AS InvNumber_ProductionFull
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
            LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                      ON MovementBoolean_isRePack.MovementId = Movement.Id
                                     AND MovementBoolean_isRePack.DescId = zc_MovementBoolean_isRePack()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                         ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
            LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Send
                                           ON MovementLinkMovement_Send.MovementId = Movement.Id
                                          AND MovementLinkMovement_Send.DescId     = zc_MovementLinkMovement_Send()
            LEFT JOIN Movement AS Movement_Send ON Movement_Send.Id = COALESCE (MovementLinkMovement_Send.MovementChildId, Movement.ParentId)
            LEFT JOIN MovementDesc AS MovementDesc_Send ON MovementDesc_Send.Id = Movement_Send.DescId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Order
                                     ON MovementString_InvNumberPartner_Order.MovementId = Movement_Order.Id
                                    AND MovementString_InvNumberPartner_Order.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Production
                                           ON MovementLinkMovement_Production.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_Production.DescId          = zc_MovementLinkMovement_Production()
            LEFT JOIN Movement AS Movement_Production ON Movement_Production.Id = MovementLinkMovement_Production.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Production ON MovementDesc_Production.Id = Movement_Production.DescId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Send()
       LIMIT 1
      ;

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Send (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.07.24         *
 09.12.22         * add MovementId_Production
 07.08.20         *
 27.02.19         *
 03.10.17         * add Comment
 14.07.16         *
 17.06.16         *
 22.05.14                                                        *
 07.12.13                                        * rename UserRole_View -> ObjectLink_UserRole_View
 09.11.13                                        * add tmpUserTransport
 28.10.13                          * Дефолты для новых записей
 15.07.13         * удалили колонки
 09.07.13                                        * Красота
 08.07.13                                        * zc_MovementFloat_ChangePercent
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Send (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= '9818')
