-- Function: gpGet_ScaleCeh_Movement()

-- DROP FUNCTION IF EXISTS gpGet_ScaleCeh_Movement (Integer, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpGet_ScaleCeh_Movement (Integer, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ScaleCeh_Movement(
    IN inMovementId            Integer     , --
    IN inOperDate              TDateTime   , --
    IN inIsNext                Boolean     , --
    IN inBranchCode            Integer     , --
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (MovementId       Integer
             , BarCode          TVarChar
             , InvNumber        TVarChar
             , OperDate         TDateTime

             , isProductionIn     Boolean
             , MovementDescNumber Integer

             , isSticker_Ceh      Boolean
             , isSticker_KVK      Boolean

             , isKVK              Boolean
             , isAsset            Boolean
             , isPartionCell      Boolean
             , isPartionPassport  Boolean

             , MovementDescId Integer
             , FromId         Integer, FromCode         Integer, FromName       TVarChar
             , ToId           Integer, ToCode           Integer, ToName         TVarChar

             , SubjectDocId   Integer
             , SubjectDocCode Integer
             , SubjectDocName TVarChar

             , PersonalGroupId   Integer
             , PersonalGroupCode Integer
             , PersonalGroupName TVarChar

             , MovementId_Order Integer
             , MovementDescId_Order Integer
             , InvNumber_Order  TVarChar
             , OrderExternalName_master TVarChar
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       WITH tmpMovement_find AS (-- если inMovementId = 0, тогда - последний не закрытый
                                 SELECT MAX (Movement.Id) AS Id
                                 FROM (SELECT (inOperDate - INTERVAL '3 DAY') AS StartDate, (inOperDate + INTERVAL '3 DAY') AS EndDate WHERE COALESCE (inMovementId, 0) = 0) AS tmp
                                      INNER JOIN Movement
                                              ON Movement.DescId = zc_Movement_WeighingProduction()
                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             AND Movement.OperDate BETWEEN tmp.StartDate AND tmp.EndDate
                                      INNER JOIN MovementLinkObject
                                              AS MovementLinkObject_User
                                              ON MovementLinkObject_User.MovementId = Movement.Id
                                             AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()
                                             AND MovementLinkObject_User.ObjectId   = vbUserId
                                UNION
                                 -- или "следующий" не закрытый, т.е. <> inMovementId, для inIsNext = TRUE
                                 SELECT Movement.Id AS Id
                                 FROM (SELECT (inOperDate - INTERVAL '1 DAY') AS StartDate, (inOperDate + INTERVAL '1 DAY') AS EndDate WHERE inIsNext = TRUE) AS tmp
                                      INNER JOIN Movement
                                              ON Movement.DescId = zc_Movement_WeighingProduction()
                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             AND Movement.OperDate BETWEEN tmp.StartDate AND tmp.EndDate
                                      INNER JOIN MovementLinkObject
                                              AS MovementLinkObject_User
                                              ON MovementLinkObject_User.MovementId = Movement.Id
                                             AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                             AND MovementLinkObject_User.ObjectId = vbUserId
                                 WHERE Movement.Id <> inMovementId
                                 -- LIMIT 2 -- если больше 1-ого то типа ошибка
                                UNION
                                 -- или inMovementId если он тоже не закрытый, для inIsNext = FALSE
                                 SELECT Movement.Id
                                 FROM (SELECT inMovementId AS MovementId WHERE inMovementId > 0 AND inIsNext = FALSE) AS tmp
                                      INNER JOIN Movement
                                              ON Movement.Id = tmp.MovementId
                                             AND Movement.DescId = zc_Movement_WeighingProduction()
                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                )
               , tmpMovement AS (SELECT tmpMovement_find.Id
                                      , Movement.InvNumber
                                      , Movement.OperDate
                                      , MovementFloat_MovementDesc.ValueData        AS MovementDescId
                                      , MovementLinkObject_From.ObjectId            AS FromId
                                      , MovementLinkObject_To.ObjectId              AS ToId
                                      , MovementLinkObject_SubjectDoc.ObjectId      AS SubjectDocId
                                      , MovementLinkObject_PersonalGroup.ObjectId   AS PersonalGroupId
                                      , MovementLinkMovement_Order.MovementChildId  AS MovementId_Order
                                 FROM tmpMovement_find
                                      LEFT JOIN Movement ON Movement.Id = tmpMovement_find.Id
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                                                   ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                                                  AND MovementLinkObject_SubjectDoc.DescId     = zc_MovementLinkObject_SubjectDoc()
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                                   ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                                                  AND MovementLinkObject_PersonalGroup.DescId     = zc_MovementLinkObject_PersonalGroup()

                                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                     ON MovementLinkMovement_Order.MovementId = Movement.Id
                                                                    AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

                                      LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                                              ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                             AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                 WHERE tmpMovement_find.Id > 0
                                )
       -- Результат
       SELECT tmpMovement.Id                                 AS MovementId
            , '' ::TVarChar                                  AS BarCode
            , tmpMovement.InvNumber                          AS InvNumber
            , tmpMovement.OperDate                           AS OperDate

            , MovementBoolean_isIncome.ValueData             AS isProductionIn
            , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber

              -- определили <печатать Стикер на термопринтере>
            , (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
               FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                     , inLevel2      := 'Movement'
                                                     , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat_MovementDescNumber.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat_MovementDescNumber.ValueData :: Integer) :: TVarChar
                                                     , inItemName    := 'isSticker_Ceh'
                                                     , inDefaultValue:= 'FALSE'
                                                     , inSession     := inSession
                                                      ) AS RetV
                    ) AS tmp
              ) :: Boolean AS isSticker_Ceh

              -- определили <печатать Стикер-KVK на термопринтере>
            , (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
               FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                     , inLevel2      := 'Movement'
                                                     , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat_MovementDescNumber.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat_MovementDescNumber.ValueData :: Integer) :: TVarChar
                                                     , inItemName    := 'isSticker_KVK'
                                                     , inDefaultValue:= 'FALSE'
                                                     , inSession     := inSession
                                                      ) AS RetV
                    ) AS tmp
              ) :: Boolean AS isSticker_KVK

              -- определили <isKVK>
            , (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
               FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                     , inLevel2      := 'Movement'
                                                     , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat_MovementDescNumber.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat_MovementDescNumber.ValueData :: Integer) :: TVarChar
                                                     , inItemName    := 'isKVK'
                                                     , inDefaultValue:= 'FALSE'
                                                     , inSession     := inSession
                                                      ) AS RetV
                    ) AS tmp
              ) :: Boolean AS isKVK

              -- определили <isAsset>
            , (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
               FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                     , inLevel2      := 'Movement'
                                                     , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat_MovementDescNumber.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat_MovementDescNumber.ValueData :: Integer) :: TVarChar
                                                     , inItemName    := 'isAsset'
                                                     , inDefaultValue:= 'FALSE'
                                                     , inSession     := inSession
                                                      ) AS RetV
                    ) AS tmp
              ) :: Boolean AS isAsset

              -- определили <isPartionCell>
            , (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
               FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                     , inLevel2      := 'Movement'
                                                     , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat_MovementDescNumber.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat_MovementDescNumber.ValueData :: Integer) :: TVarChar
                                                     , inItemName    := 'isPartionCell'
                                                     , inDefaultValue:= 'FALSE'
                                                     , inSession     := inSession
                                                      ) AS RetV
                    ) AS tmp
              ) :: Boolean AS isPartionCell

              -- определили <isPartionPassport>
            , (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
               FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                     , inLevel2      := 'Movement'
                                                     , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat_MovementDescNumber.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat_MovementDescNumber.ValueData :: Integer) :: TVarChar
                                                     , inItemName    := 'isPartionPassport'
                                                     , inDefaultValue:= 'FALSE'
                                                     , inSession     := inSession
                                                      ) AS RetV
                    ) AS tmp
              ) :: Boolean AS isPartionPassport



            , tmpMovement.MovementDescId :: Integer          AS MovementDescId
            , Object_From.Id                                 AS FromId
            , Object_From.ObjectCode                         AS FromCode
            , Object_From.ValueData                          AS FromName
            , Object_To.Id                                   AS ToId
            , Object_To.ObjectCode                           AS ToCode
            , Object_To.ValueData                            AS ToName

            , Object_SubjectDoc.Id                           AS SubjectDocId
            , Object_SubjectDoc.ObjectCode                   AS SubjectDocCode
            , Object_SubjectDoc.ValueData                    AS SubjectDocName

            , Object_PersonalGroup.Id                        AS PersonalGroupId
            , Object_PersonalGroup.ObjectCode                AS PersonalGroupCode
            , Object_PersonalGroup.ValueData                 AS PersonalGroupName

            , tmpMovement.MovementId_Order AS MovementId_Order
            , Movement_Order.DescId        AS MovementDescId_Order
            , Movement_Order.InvNumber     AS InvNumber_Order
            , ('№ <' || Movement_Order.InvNumber || '>' || ' от <' || DATE (Movement_Order.OperDate) :: TVarChar || '>') :: TVarChar AS OrderExternalName_master

            , MovementString_Comment.ValueData AS Comment

       FROM tmpMovement
            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
            LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovement.ToId
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = tmpMovement.SubjectDocId
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpMovement.PersonalGroupId

            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = tmpMovement.MovementId_Order

            LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId =  tmpMovement.Id
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId =  tmpMovement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  tmpMovement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_ScaleCeh_Movement (0, CURRENT_TIMESTAMP, FALSE, '201', zfCalc_UserAdmin())
-- SELECT * FROM gpGet_ScaleCeh_Movement (0, CURRENT_TIMESTAMP, FALSE, '201', zfCalc_UserAdmin())
