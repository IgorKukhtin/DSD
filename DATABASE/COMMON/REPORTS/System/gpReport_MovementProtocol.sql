-- Function: gpReport_UserProtocol (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_MovementProtocol (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementProtocol(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer , --
    IN inUserId             Integer , --
    IN inIsMovement         Boolean , --
    IN inSession            TVarChar  -- сессия пользователя
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar
             , MemberName     TVarChar
             , PositionName   TVarChar
             , UnitId Integer, UnitName TVarChar
             , BranchId Integer, BranchName TVarChar

             , MovementId          Integer
             , OperDate_Protocol   TDateTime
             , Invnumber_Movement  Integer
             , DescId_Movement     Integer
             , DescName_Movement   TVarChar
             , OperDate            TDateTime
             , OperDatePartner     TDateTime
             , StatusCode          Integer
             , StatusName          TVarChar
             , FromName            TVarChar
             , ToName              TVarChar
             , IsInsert      Boolean
             , isErased      Boolean
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
  , tmpMI_Protocol AS (-- 1.
                       SELECT MovementProtocol.UserId              AS UserId
                            , MovementProtocol.IsInsert            AS IsInsert
                            , MovementProtocol.OperDate            AS OperDate_Protocol
                            , MovementProtocol.MovementId          AS MovementId
                            , Movement.StatusId                    AS StatusId_Movement
                            , Movement.OperDate                    AS OperDate_Movement
                            , Movement.Invnumber                   AS Invnumber_Movement
                            , Movement.DescId                      AS DescId_Movement
                            , MovementDesc.ItemName                AS DescName_Movement
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата накладной у контрагента"] /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS OperDatePartner
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата документа"]               /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS OperDate
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Статус"]                       /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS StatusName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "От кого (в документе)"]        /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS FromName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Кому (в документе)"]           /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS ToName
                       FROM MovementProtocol
                            LEFT JOIN Movement ON Movement.Id = MovementProtocol.MovementId
                            INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                                                   AND MovementDesc.Id IN (zc_Movement_ReturnOut()
                                                                         , zc_Movement_Send()
                                                                         , zc_Movement_SendAsset()
                                                                         , zc_Movement_SendOnPrice()
                                                                         , zc_Movement_Sale()
                                                                         , zc_Movement_ReturnIn()
                                                                         , zc_Movement_Loss()
                                                                         , zc_Movement_ProductionSeparate()
                                                                         , zc_Movement_ProductionUnion()
                                                                         , zc_Movement_Inventory()
                                                                         , zc_Movement_Income()
                                                                         , zc_Movement_WeighingPartner()
                                                                         , zc_Movement_WeighingProduction())

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

                      UNION ALL
                       -- 2.
                       SELECT MovementProtocol.UserId              AS UserId
                            , MovementProtocol.IsInsert            AS IsInsert
                            , MovementProtocol.OperDate            AS OperDate_Protocol
                            , MovementProtocol.MovementId          AS MovementId
                            , Movement.StatusId                    AS StatusId_Movement
                            , Movement.OperDate                    AS OperDate_Movement
                            , Movement.Invnumber                   AS Invnumber_Movement
                            , Movement.DescId                      AS DescId_Movement
                            , MovementDesc.ItemName                AS DescName_Movement
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата накладной у контрагента"] /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS OperDatePartner
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата документа"]               /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS OperDate
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Статус"]                       /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS StatusName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "От кого (в документе)"]        /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS FromName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Кому (в документе)"]           /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS ToName
                       FROM MovementProtocol_arc AS MovementProtocol
                            LEFT JOIN Movement ON Movement.Id = MovementProtocol.MovementId
                            INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                                                   AND MovementDesc.Id IN (zc_Movement_ReturnOut()
                                                                         , zc_Movement_Send()
                                                                         , zc_Movement_SendAsset()
                                                                         , zc_Movement_SendOnPrice()
                                                                         , zc_Movement_Sale()
                                                                         , zc_Movement_ReturnIn()
                                                                         , zc_Movement_Loss()
                                                                         , zc_Movement_ProductionSeparate()
                                                                         , zc_Movement_ProductionUnion()
                                                                         , zc_Movement_Inventory()
                                                                         , zc_Movement_Income()
                                                                         , zc_Movement_WeighingPartner()
                                                                         , zc_Movement_WeighingProduction())

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

                      UNION ALL
                       -- 3.
                       SELECT MovementProtocol.UserId              AS UserId
                            , MovementProtocol.IsInsert            AS IsInsert
                            , MovementProtocol.OperDate            AS OperDate_Protocol
                            , MovementProtocol.MovementId          AS MovementId
                            , Movement.StatusId                    AS StatusId_Movement
                            , Movement.OperDate                    AS OperDate_Movement
                            , Movement.Invnumber                   AS Invnumber_Movement
                            , Movement.DescId                      AS DescId_Movement
                            , MovementDesc.ItemName                AS DescName_Movement
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата накладной у контрагента"] /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS OperDatePartner
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Дата документа"]               /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS OperDate
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Статус"]                       /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS StatusName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "От кого (в документе)"]        /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS FromName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Кому (в документе)"]           /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS ToName
                       FROM MovementProtocol_arc_arc AS MovementProtocol
                            LEFT JOIN Movement ON Movement.Id = MovementProtocol.MovementId
                            INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                                                   AND MovementDesc.Id IN (zc_Movement_ReturnOut()
                                                                         , zc_Movement_Send()
                                                                         , zc_Movement_SendAsset()
                                                                         , zc_Movement_SendOnPrice()
                                                                         , zc_Movement_Sale()
                                                                         , zc_Movement_ReturnIn()
                                                                         , zc_Movement_Loss()
                                                                         , zc_Movement_ProductionSeparate()
                                                                         , zc_Movement_ProductionUnion()
                                                                         , zc_Movement_Inventory()
                                                                         , zc_Movement_Income()
                                                                         , zc_Movement_WeighingPartner()
                                                                         , zc_Movement_WeighingProduction())

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
          , tmpData.OperDate_Protocol  ::TDateTime
          , CASE WHEN COALESCE (tmpData.Invnumber_Movement, '') = '' THEN '0' ELSE tmpData.Invnumber_Movement END ::Integer AS Invnumber_Movement
          , tmpData.DescId_Movement    ::Integer
          , tmpData.DescName_Movement  ::TVarChar

          --, Object_Status.ObjectCode          AS StatusCode
          --, Object_Status.ValueData           AS StatusName

          , (CASE WHEN COALESCE (tmpData.OperDate, '')        = '' THEN NULL ELSE tmpData.OperDate END)         ::TDateTime AS OperDate
          , (CASE WHEN COALESCE (tmpData.OperDatePartner, '') = '' THEN NULL ELSE tmpData.OperDatePartner END)  ::TDateTime AS OperDatePartner

          , CASE WHEN REPLACE(tmpData.StatusName, '"' ,'') = 'Не проведен' THEN 1
                 WHEN REPLACE(tmpData.StatusName, '"' ,'') = 'Проведен'    THEN 2
                 WHEN REPLACE(tmpData.StatusName, '"' ,'') = 'Удален'      THEN 3
            END                                    ::Integer   AS StatusCode
          , REPLACE(tmpData.StatusName, '"' ,'')   ::TVarChar  AS StatusName

          , REPLACE(tmpData.FromName, '"' ,'')     ::TVarChar  AS FromName
          , REPLACE(tmpData.ToName, '"' ,'')       ::TVarChar  AS ToName
          , tmpData.IsInsert                       ::Boolean   AS IsInsert
          , CASE WHEN tmpData.StatusName = 'Удален' OR tmpData.StatusId_Movement = zc_Enum_Status_Erased() THEN TRUE ELSE FALSE END  ::Boolean AS isErased


     FROM tmpMI_Protocol AS tmpData

          --LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId_Movement
          --LEFT JOIN Object AS Object_To ON Object_To.Id = tmpData.ToId_Movement
          --LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId_Movement

          LEFT JOIN tmpUser ON tmpUser.UserId = tmpData.UserId
          LEFT JOIN Object AS Object_User ON Object_User.Id = tmpData.UserId

          LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpUser.MemberId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpUser.PositionId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUser.UnitId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpUser.BranchId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.20         * zc_Movement_SendAsset
 07.11.16         *
*/
-- тест
-- SELECT * FROM gpReport_MovementProtocol (inStartDate:= '08.12.2017' ::TDateTime, inEndDate:= '08.12.2017'::TDateTime, inUnitId:= 0, inUserId:= 0, inIsMovement:=TRUE, inSession:= '5'::TVarChar);
