-- Function: gpGet_Movement_MarginCategory()

DROP FUNCTION IF EXISTS gpGet_Movement_MarginCategory (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_MarginCategory(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , InvNumber        Integer     --Номер документа
             , OperDate         TDateTime   --Дата документа
             , StatusCode       Integer     --код статуса
             , StatusName       TVarChar    --Статус
             , StartSale        TDateTime   --
             , EndSale          TDateTime   --
             , OperDateStart    TDateTime   --
             , OperDateEnd      TDateTime   --
             , Comment          TVarChar    --
             , UnitId           INTEGER     --
             , UnitName         TVarChar    --
             , InsertId         Integer     --
             , InsertName       TVarChar    --
             , InsertDate       TDateTime   --
             , UpdateId         Integer     --
             , UpdateName       TVarChar    --
             , UpdateDate       TDateTime   --
             , Amount           TFloat      -- мин кол-во продаж за анализируемый период
             , ChangePercent    TFloat      -- % отклонения продаж
             , DayCount         TFloat      -- дней в периоде анализа
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                           AS Id
          , CAST (NEXTVAL ('movement_MarginCategory_seq') AS Integer)  AS InvNumber
          , inOperDate	                                AS OperDate
          , Object_Status.Code                          AS StatusCode
          , Object_Status.Name                          AS StatusName
          , NULL::TDateTime                             AS StartSale
          , NULL::TDateTime                             AS EndSale
          , NULL::TDateTime                             AS OperDateStart
          , NULL::TDateTime                             AS OperDateEnd
          , NULL::TVarChar                              AS Comment
          , NULL::Integer                               AS UnitId
          , NULL::TVarChar                              AS UnitName
          , Object_Insert.Id                            AS InsertId
          , Object_Insert.ValueData                     AS InsertName
          , CURRENT_TIMESTAMP   ::TDateTime             AS InsertDate
          , NULL::Integer                               AS UpdateId
          , NULL::TVarChar                              AS UpdateName
          , NULL::TDateTime                             AS UpdateDate
                              
          , NULL::TFloat                                AS Amount
          , NULL::TFloat                                AS ChangePercent
          , NULL::TFloat                                AS DayCount

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            LEFT OUTER JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId;
    ELSE
        RETURN QUERY
         SELECT Movement_MarginCategory.Id
              , Movement_MarginCategory.InvNumber  :: Integer
              , Movement_MarginCategory.OperDate
              , Object_Status.ObjectCode        :: Integer  AS StatusCode
              , Object_Status.ValueData         :: TVarChar AS StatusName
              , MovementDate_StartSale.ValueData            AS StartSale
              , MovementDate_EndSale.ValueData              AS EndSale
              , MovementDate_OperDateStart.ValueData        AS OperDateStart
              , MovementDate_OperDateEnd.ValueData          AS OperDateEnd
              , MovementString_Comment.ValueData            AS Comment
              , MovementLinkObject_Unit.ObjectId            AS UnitId
              , Object_Unit.ValueData                       AS UnitName
 
              , Object_Insert.Id                            AS InsertId
              , Object_Insert.ValueData                     AS InsertName
              , MovementDate_Insert.ValueData               AS InsertDate
              , Object_Update.Id                            AS UpdateId
              , Object_Update.ValueData                     AS UpdateName
              , MovementDate_Update.ValueData               AS UpdateDate
              
              , MovementFloat_Amount.ValueData              AS Amount
              , MovementFloat_ChangePercent.ValueData       AS ChangePercent
              , MovementFloat_DayCount.ValueData            AS DayCount

        FROM Movement AS Movement_MarginCategory 
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_MarginCategory.StatusId

             LEFT JOIN MovementDate AS MovementDate_StartSale
                                    ON MovementDate_StartSale.MovementId = Movement_MarginCategory.Id
                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
             LEFT JOIN MovementDate AS MovementDate_EndSale
                                    ON MovementDate_EndSale.MovementId = Movement_MarginCategory.Id
                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

             LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                    ON MovementDate_OperDateStart.MovementId = Movement_MarginCategory.Id
                                   AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

             LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                    ON MovementDate_OperDateEnd.MovementId = Movement_MarginCategory.Id
                                   AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_MarginCategory.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement_MarginCategory.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_MarginCategory.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

             LEFT JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement_MarginCategory.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

             LEFT JOIN MovementDate AS MovementDate_Update
                                    ON MovementDate_Update.MovementId = Movement_MarginCategory.Id
                                   AND MovementDate_Update.DescId = zc_MovementDate_Update()

             LEFT JOIN MovementLinkObject AS MLO_Update
                                          ON MLO_Update.MovementId = Movement_MarginCategory.Id
                                         AND MLO_Update.DescId = zc_MovementLinkObject_Update()
             LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId 
     
             LEFT JOIN MovementFloat AS MovementFloat_Amount
                                     ON MovementFloat_Amount.MovementId = Movement_MarginCategory.Id
                                    AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
     
             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                     ON MovementFloat_ChangePercent.MovementId = Movement_MarginCategory.Id
                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

             LEFT JOIN MovementFloat AS MovementFloat_DayCount
                                     ON MovementFloat_DayCount.MovementId = Movement_MarginCategory.Id
                                    AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()
                                    
        WHERE Movement_MarginCategory.Id =  inMovementId
          AND Movement_MarginCategory.DescId = zc_Movement_MarginCategory();
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 19.11.17         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_MarginCategory (inMovementId:= 0, inOperDate:= '30.11.2015', inSession:= zfCalc_UserAdmin())
