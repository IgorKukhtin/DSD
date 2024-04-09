-- Function: gpSelect_MovementGoodsBarCode_Print()

DROP FUNCTION IF EXISTS gpSelect_MovementGoodsBarCode_Print (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementGoodsBarCode_Print(
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inisShowAll           Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId_User  Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Определяется <Физическое лицо> - кто сформировал визу inReestrKindId
     vbMemberId_User:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;

     -- Проверка
     IF COALESCE (vbMemberId_User, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя <%> не определно значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
     END IF;


     -- Результат
     OPEN Cursor1 FOR
    
       SELECT inStartDate AS StartDate
            , inEndDate   AS EndDate
            , 'Проверен (да / нет)'  ::TVarChar   AS ReestrName
            , Object_User.ValueData    AS UserName
       FROM Object AS Object_User
       WHERE Object_User.Id = vbUserId;

    RETURN NEXT Cursor1;

     OPEN Cursor2 FOR

     WITH 
     -- выбираем строки Актов сверки по пользователю (или всем пользователям)
     tmpMovement AS (SELECT MovementDate_Checked.MovementId      AS Id
                          , MovementLinkObject_Checked.ObjectId  AS CheckedId
                          , MovementDate_Checked.ValueData       AS CheckedDate
                     FROM MovementDate AS MovementDate_Checked

                          INNER JOIN MovementLinkObject AS MovementLinkObject_Checked
                                                        ON MovementLinkObject_Checked.MovementId = MovementDate_Checked.MovementId
                                                       AND MovementLinkObject_Checked.DescId = zc_MovementLinkObject_Checked()
                                                       AND (MovementLinkObject_Checked.ObjectId = vbMemberId_user OR inisShowAll = True)
                          -- может быть еще ограничить деском документов
                     WHERE MovementDate_Checked.DescId = zc_MovementDate_Checked()
                       AND MovementDate_Checked.ValueData >= inStartDate AND MovementDate_Checked.ValueData < inEndDate + INTERVAL '1 DAY'
                     )

     -- Результат
     SELECT  Movement.Id
           , MovementDesc.ItemName              AS ItemName_Movement
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) ::TVarChar AS IdBarCode
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , MovementFloat_TotalCount.ValueData AS TotalCount
           , Object_From.ValueData              AS FromName
           , ObjectDesc_from.ItemName           AS ItemName_from
           , Object_To.ValueData                AS ToName
           , ObjectDesc_to.ItemName             AS ItemName_to
           , MovementString_Comment.ValueData   AS Comment
           , Object_Checked.ValueData           AS CheckedName
           , tmpMovement.CheckedDate            AS CheckedDate
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) AS Checked
         
     FROM tmpMovement
            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId = Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Checked 
                                   ON MovementDate_Checked.MovementId = Movement.Id
                                  AND MovementDate_Checked.DescId = zc_MovementDate_Checked()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectDesc AS ObjectDesc_from ON ObjectDesc_from.Id = Object_From.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectDesc AS ObjectDesc_to ON ObjectDesc_to.Id = Object_To.DescId

            LEFT JOIN Object AS Object_Checked ON Object_Checked.Id = tmpMovement.CheckedId
         ORDER BY MovementDesc.ItemName 
                , Movement.OperDate 
                , Movement.InvNumber 
                , Object_From.ValueData
                , Object_To.ValueData
         ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.10.18         *
*/

-- тест
-- 