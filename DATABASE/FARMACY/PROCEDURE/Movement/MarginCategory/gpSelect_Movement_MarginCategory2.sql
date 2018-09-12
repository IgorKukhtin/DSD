-- Function: gpSelect_Movement_Promo()

DROP FUNCTION IF EXISTS gpSelect_Movement_MarginCategory2 (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MarginCategory2(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inPeriodForOperDate Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , InvNumber        Integer     --Номер документа
             , OperDate         TDateTime   --Дата документа
             , StatusCode       Integer     --код статуса
             , StatusName       TVarChar    --Статус
             , StartSale        TDateTime   --Дата начала отчета
             , EndSale          TDateTime   --Дата окончания отчета
             , OperDateStart    TDateTime   --Дата начала действия изменений по Категории наценки
             , OperDateEnd      TDateTime   --Дата окончания действия изменений по Категории наценки
             , Comment          TVarChar    --Примечание
             , UnitId           Integer     --Подразделение
             , UnitName         TVarChar    --Подразделение
             , InsertId         Integer     --
             , InsertName       TVarChar    --
             , InsertDate       TDateTime   --
             , UpdateId         Integer     --
             , UpdateName       TVarChar    --
             , UpdateDate       TDateTime   --
             , Amount           TFloat      -- мин кол-во продаж за анализируемый период
             , ChangePercent    TFloat      -- % отклонения продаж.
             , DayCount         TFloat      -- дней в периоде анализа
             , PriceMin         TFloat      --
             , PriceMax         TFloat      --
             , ObjectCode       Integer
             , ObjectName       TVarChar
             , DescName_Object  TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    
    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
           , tmpMovement AS (SELECT Movement_MarginCategory.*
                                  , MovementDate_StartSale.ValueData            AS StartSale
                                  , MovementDate_EndSale.ValueData              AS EndSale
                             FROM Movement AS Movement_MarginCategory 
                                  INNER JOIN tmpStatus ON Movement_MarginCategory.StatusId = tmpStatus.StatusId
    
                                  LEFT JOIN MovementDate AS MovementDate_StartSale
                                                         ON MovementDate_StartSale.MovementId = Movement_MarginCategory.Id
                                                        AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                  LEFT JOIN MovementDate AS MovementDate_EndSale
                                                         ON MovementDate_EndSale.MovementId = Movement_MarginCategory.Id
                                                        AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                             
                             WHERE Movement_MarginCategory.DescId = zc_Movement_MarginCategory()
                               AND ( (inPeriodForOperDate = FALSE AND Movement_MarginCategory.OperDate BETWEEN inStartDate AND inEndDate)
                                  OR (inPeriodForOperDate = TRUE AND (MovementDate_StartSale.ValueData BETWEEN inStartDate AND inEndDate
                                                                       OR inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                                                                      )
                                     )
                                   )
                            )
           --аптеки/ юр.лица (3 грид)
           , tmpMovementUnit AS (SELECT Movement.ParentId   AS ParentId
                                      , Object.ObjectCode   AS ObjectCode
                                      , Object.ValueData    AS ObjectName
                                      , ObjectDesc.ItemName AS DescName
                                      , Movement.StatusId   AS StatusId    --CASE WHEN Movement.StatusId = zc_Enum_Status_Erased() THEN TRUE ELSE FALSE END AS IsErased
                                 FROM tmpMovement
                                    LEFT JOIN Movement ON Movement.DescId = zc_Movement_MarginCategoryUnit()
                                                      AND Movement.ParentId = tmpMovement.Id
                                    INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId
                                    
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Object
                                                                 ON MovementLinkObject_Object.MovementId = Movement.Id
                                                                AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
                                    LEFT JOIN Object ON Object.Id = MovementLinkObject_Object.ObjectId
                                    LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
                                )

        SELECT Movement_MarginCategory.Id
             , Movement_MarginCategory.InvNumber  :: Integer
             , Movement_MarginCategory.OperDate
             , Object_Status.ObjectCode        :: Integer  AS StatusCode
             , Object_Status.ValueData         :: TVarChar AS StatusName
             , Movement_MarginCategory.StartSale           AS StartSale
             , Movement_MarginCategory.EndSale             AS EndSale
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

             , MovementFloat_PriceMin.ValueData            AS PriceMin
             , MovementFloat_PriceMax.ValueData            AS PriceMax
             
             , tmpMovementUnit.ObjectCode                  AS ObjectCode
             , tmpMovementUnit.ObjectName                  AS ObjectName
             , tmpMovementUnit.DescName                    AS DescName_Object
             

        FROM tmpMovement AS Movement_MarginCategory 
             
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

             LEFT JOIN MovementFloat AS MovementFloat_PriceMin
                                     ON MovementFloat_PriceMin.MovementId = Movement_MarginCategory.Id
                                    AND MovementFloat_PriceMin.DescId = zc_MovementFloat_PriceMin()
                                    
             LEFT JOIN MovementFloat AS MovementFloat_PriceMax
                                     ON MovementFloat_PriceMax.MovementId = Movement_MarginCategory.Id
                                    AND MovementFloat_PriceMax.DescId = zc_MovementFloat_PriceMax()

             LEFT JOIN tmpMovementUnit ON tmpMovementUnit.ParentId = Movement_MarginCategory.Id
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN tmpMovementUnit.StatusId = zc_Enum_Status_Erased() THEN tmpMovementUnit.StatusId ELSE Movement_MarginCategory.StatusId END
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.09.18         *
*/

-- SELECT * FROM gpSelect_Movement_MarginCategory2 (inStartDate:= '01.09.2018'::Tdatetime, inEndDate:= '01.09.2018' ::Tdatetime, inIsErased:= FALSE, inPeriodForOperDate:=TRUE, inSession:= zfCalc_UserAdmin())
