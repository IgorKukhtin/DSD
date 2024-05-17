-- Function: gpSelect_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpSelect_Movement_StoreReal(TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_StoreReal(TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_StoreReal (
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inIsErased         Boolean   ,
    IN inJuridicalBasisId Integer   ,
    IN inMemberId         Integer   ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InsertDate TDateTime
             , InsertMobileDate TDateTime
             , UpdateMobileDate TDateTime
             , PeriodSecMobile Integer
             , InsertName TVarChar
             , PartnerName TVarChar
             , GUID TVarChar
             , Comment TVarChar
             , MemberName TVarChar
             , UnitCode Integer
             , UnitName TVarChar
             , PositionName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbUserId_Mobile Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StoreReal());
     vbUserId := lpGetUserBySession(inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- !!!меняем значение!!! - с какими параметрами пользователь может просматривать данные с мобильного устройства
     SELECT lfGet.MemberId, lfGet.UserId INTO inMemberId, vbUserId_Mobile FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet;


     -- Результат
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                          )
         , tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
             , tmpUser AS (-- PersonalTrade - Сотрудник (торговый)
                           SELECT DISTINCT ObjectLink_User_Member_trade.ObjectId AS UserId
                           FROM ObjectLink AS ObjectLink_User_Member
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                      ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                     AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS OL
                                                      ON OL.ChildObjectId = ObjectLink_Personal_Member.ObjectId
                                                     AND OL.DescId        = zc_ObjectLink_Partner_Personal()
                                INNER JOIN ObjectLink AS OL_Partner_PersonalTrade
                                                      ON OL_Partner_PersonalTrade.ObjectId = OL.ObjectId
                                                     AND OL_Partner_PersonalTrade.DescId   = zc_ObjectLink_Partner_PersonalTrade()
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member_trade
                                                      ON ObjectLink_Personal_Member_trade.ObjectId = OL_Partner_PersonalTrade.ChildObjectId
                                                     AND ObjectLink_Personal_Member_trade.DescId   = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS ObjectLink_User_Member_trade
                                                      ON ObjectLink_User_Member_trade.ChildObjectId = ObjectLink_Personal_Member_trade.ChildObjectId
                                                     AND ObjectLink_User_Member_trade.DescId        = zc_ObjectLink_User_Member()
                           WHERE ObjectLink_User_Member.ObjectId = vbUserId_Mobile
                             AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()

                          UNION
                           -- PersonalMerch - Сотрудник (мерчандайзер)
                           SELECT DISTINCT ObjectLink_User_Member_merch.ObjectId AS UserId
                           FROM ObjectLink AS ObjectLink_User_Member
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                      ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                     AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS OL
                                                      ON OL.ChildObjectId = ObjectLink_Personal_Member.ObjectId
                                                     AND OL.DescId        = zc_ObjectLink_Partner_Personal()
                                INNER JOIN ObjectLink AS OL_Partner_PersonalMerch
                                                      ON OL_Partner_PersonalMerch.ObjectId = OL.ObjectId
                                                     AND OL_Partner_PersonalMerch.DescId   = zc_ObjectLink_Partner_PersonalMerch()
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member_merch
                                                      ON ObjectLink_Personal_Member_merch.ObjectId = OL_Partner_PersonalMerch.ChildObjectId
                                                     AND ObjectLink_Personal_Member_merch.DescId   = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS ObjectLink_User_Member_merch
                                                      ON ObjectLink_User_Member_merch.ChildObjectId = ObjectLink_Personal_Member_merch.ChildObjectId
                                                     AND ObjectLink_User_Member_merch.DescId        = zc_ObjectLink_User_Member()
                           WHERE ObjectLink_User_Member.ObjectId = vbUserId_Mobile
                             AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()

                          UNION
                           SELECT DISTINCT ObjectLink_User_Member_trade.ObjectId AS UserId
                           FROM ObjectLink AS ObjectLink_User_Member
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                      ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                     AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS OL
                                                      ON OL.ChildObjectId = ObjectLink_Personal_Member.ObjectId
                                                     AND OL.DescId        = zc_ObjectLink_Partner_Personal()
                                INNER JOIN ObjectLink AS OL_Partner_PersonalTrade
                                                      ON OL_Partner_PersonalTrade.ObjectId = OL.ObjectId
                                                     AND OL_Partner_PersonalTrade.DescId   = zc_ObjectLink_Partner_PersonalTrade()
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member_trade
                                                      ON ObjectLink_Personal_Member_trade.ObjectId = OL_Partner_PersonalTrade.ChildObjectId
                                                     AND ObjectLink_Personal_Member_trade.DescId   = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS ObjectLink_User_Member_trade
                                                      ON ObjectLink_User_Member_trade.ChildObjectId = ObjectLink_Personal_Member_trade.ChildObjectId
                                                     AND ObjectLink_User_Member_trade.DescId        = zc_ObjectLink_User_Member()
                           WHERE ObjectLink_User_Member.ObjectId = 1130000 -- Люклянчук О.В.
                             AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                             AND vbUserId_Mobile = 4538468 -- Спічка Є.А.

                          UNION
                           SELECT vbUserId_Mobile AS UserId
                          UNION
                           SELECT Object.Id AS UserId FROM Object WHERE Object.DescId = zc_Object_User() AND vbUserId_Mobile = 0
                          )
        -- Результат
        SELECT Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode               AS StatusCode
             , Object_Status.ValueData                AS StatusName
             , MovementDate_Insert.ValueData          AS InsertDate
             , MovementDate_InsertMobile.ValueData    AS InsertMobileDate
             , MovementDate_UpdateMobile.ValueData    AS UpdateMobileDate
             , CASE WHEN MovementDate_UpdateMobile.ValueData IS NULL THEN NULL
                    ELSE EXTRACT (SECOND FROM MovementDate_UpdateMobile.ValueData - MovementDate_Insert.ValueData)
                       + 60 * EXTRACT (MINUTE FROM MovementDate_UpdateMobile.ValueData - MovementDate_Insert.ValueData)
                       + 60 * 60 * EXTRACT (HOUR FROM MovementDate_UpdateMobile.ValueData - MovementDate_Insert.ValueData)
               END :: Integer AS PeriodSecMobile
             , Object_User.ValueData                  AS InsertName
             , Object_Partner.ValueData               AS PartnerName
             , MovementString_GUID.ValueData          AS GUID
             , MovementString_Comment.ValueData       AS Comment
             , Object_Member.ValueData   AS MemberName
             , Object_Unit.ObjectCode    AS UnitCode
             , Object_Unit.ValueData     AS UnitName
             , Object_Position.ValueData AS PositionName
        FROM tmpStatus
             JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_StoreReal()
                          AND Movement.StatusId = tmpStatus.StatusId

             INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                           ON MovementLinkObject_Insert.MovementId = Movement.Id
                                          AND MovementLinkObject_Insert.DescId     = zc_MovementLinkObject_Insert()
             INNER JOIN tmpUser ON tmpUser.UserId = MovementLinkObject_Insert.ObjectId

             LEFT JOIN Object AS Object_User   ON Object_User.Id   = MovementLinkObject_Insert.ObjectId
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
             LEFT JOIN MovementDate AS MovementDate_InsertMobile
                                    ON MovementDate_InsertMobile.MovementId = Movement.Id
                                   AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()
             LEFT JOIN MovementDate AS MovementDate_UpdateMobile
                                    ON MovementDate_UpdateMobile.MovementId = Movement.Id
                                   AND MovementDate_UpdateMobile.DescId = zc_MovementDate_UpdateMobile()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                          ON MovementLinkObject_Partner.MovementId = Movement.Id
                                         AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
             LEFT JOIN MovementString AS MovementString_GUID
                                      ON MovementString_GUID.MovementId = Movement.Id
                                     AND MovementString_GUID.DescId = zc_MovementString_GUID()

             LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                  ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                 AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
             LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

             LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId

        -- WHERE MovementLinkObject_Insert.ObjectId = vbUserId_Mobile
        --    OR vbUserId_Mobile = 0
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 22.04.17         *
 25.03.17         *
 16.02.17                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_StoreReal(instartdate := ('01.01.2017')::TDateTime , inenddate := ('31.12.2017')::TDateTime , inIsErased := 'False' , inJuridicalBasisId := 9399 , inMemberId := 0 ,  inSession := '5');
