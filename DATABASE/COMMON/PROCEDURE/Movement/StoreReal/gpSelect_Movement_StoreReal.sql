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
             , InsertName TVarChar
             , PartnerName TVarChar
             , GUID TVarChar
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId          Integer;

   DECLARE vbIsProjectMobile Boolean;
   DECLARE vbUserId_Member   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StoreReal());
     vbUserId := lpGetUserBySession(inSession);


     -- Только так определяется что пользователь inSession - Торговый агент - т.е. у него есть моб телефон, может потом для этого заведем спец роль и захардкодим
     vbIsProjectMobile:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = vbUserId AND ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile());

     IF inMemberId > 0
     THEN
         -- Определяется для <Физическое лицо> - его UserId
         vbUserId_Member:= (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Member() AND OL.ChildObjectId = inMemberId);
         -- Проверка
         IF COALESCE (vbUserId_Member, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Для ФИО <%> не определно значение <Пользователь>.', lfGet_Object_ValueData (inMemberId);
         END IF;

     ELSEIF vbIsProjectMobile = TRUE
     THEN
         -- в этом случае - видит только себя
         vbUserId_Member:= vbUserId;
     ELSE
         -- в этом случае - видит ВСЕ
         vbUserId_Member:= 0;
     END IF;


     -- Проверка - Торговый агент видит только себя
     IF vbIsProjectMobile = TRUE AND vbUserId_Member <> vbUserId
     THEN
         RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.';
     END IF;


     -- Результат
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                          )
        -- Результат
        SELECT Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode               AS StatusCode
             , Object_Status.ValueData                AS StatusName
             , MovementDate_Insert.ValueData          AS InsertDate
             , MovementDate_InsertMobile.ValueData    AS InsertMobileDate
             , Object_User.ValueData                  AS InsertName
             , Object_Partner.ValueData               AS PartnerName
             , MovementString_GUID.ValueData          AS GUID
             , MovementString_Comment.ValueData       AS Comment
        FROM tmpStatus
             JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_StoreReal()
                          AND Movement.StatusId = tmpStatus.StatusId

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
             LEFT JOIN MovementDate AS MovementDate_InsertMobile
                                    ON MovementDate_InsertMobile.MovementId = Movement.Id
                                   AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                          ON MovementLinkObject_Insert.MovementId = Movement.Id
                                         AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId

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

        WHERE MovementLinkObject_Insert.ObjectId = vbUserId_Member
           OR vbUserId_Member = 0
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 25.03.17         *
 16.02.17                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_StoreReal (inStartDate:= '01.01.2017', inEndDate:= CURRENT_DATE, inIsErased:= FALSE, inJuridicalBasisId:= 0, inMemberId:= 0, inSession:= zfCalc_UserAdmin())
