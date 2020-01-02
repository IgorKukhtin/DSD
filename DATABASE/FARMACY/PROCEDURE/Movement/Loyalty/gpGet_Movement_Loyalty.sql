-- Function: gpGet_Movement_Loyalty()

DROP FUNCTION IF EXISTS gpGet_Movement_Loyalty (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Loyalty(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber     TVarChar
             , OperDate      TDateTime
             , StatusCode    Integer
             , StatusName    TVarChar
             , RetailId      Integer
             , RetailName    TVarChar
             , StartPromo    TDateTime
             , EndPromo      TDateTime
             , StartSale     TDateTime
             , EndSale       TDateTime
             , StartSummCash TFloat
             , MonthCount    Integer
             , DayCount      Integer
             , SummLimit     TFloat
             , ChangePercent TFloat
             , ServiceDate   TDateTime
             , InsertId      Integer
             , InsertName    TVarChar
             , InsertDate    TDateTime
             , UpdateId      Integer
             , UpdateName    TVarChar
             , UpdateDate    TDateTime
             , Comment       TVarChar
             , PercentUsed   TFloat
             , isBeginning   Boolean)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Promo());
    vbUserId := inSession;

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                           AS Id
          , CAST (NEXTVAL ('movement_Loyalty_seq') AS TVarChar) AS InvNumber
          , inOperDate		            AS OperDate
          , Object_Status.Code          AS StatusCode
          , Object_Status.Name          AS StatusName
          , NULL  ::Integer             AS RetailId
          , NULL  ::TVarChar            AS RetailName
          , Null  :: TDateTime          AS StartPromo
          , Null  :: TDateTime          AS EndPromo 
          , Null  :: TDateTime          AS StartSale
          , Null  :: TDateTime          AS EndSale
          , 0     ::TFloat              AS StartSummCash
          , 0     ::Integer             AS MonthCount
          , 0     ::Integer             AS DayCount
          , 0     ::TFloat              AS SummLimit
          , 0     ::TFloat              AS ChangePercent
          , Null  :: TDateTime          AS ServiceDate
          , NULL  ::Integer             AS InsertId
          , Object_Insert.ValueData     AS InsertName
          , CURRENT_TIMESTAMP :: TDateTime AS InsertDate
          , NULL  ::Integer             AS UpdateId
          , NULL  ::TVarChar            AS UpdateName
          , Null  :: TDateTime          AS UpdateDate
          , NULL  ::TVarChar            AS Comment
          , 0     ::TFloat              AS PercentUsed
          , FALSE                       AS isBeginning
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId;
  
   ELSE
 
  RETURN QUERY
        WITH
        tmpMIF AS (SELECT * FROM MovementFloat AS MovementFloat_MovementItemId
                   WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                  )
      , tmpMI AS (SELECT MI_Sign.Id
                       , MI_Sign.Amount
                       , MI_Sign.ObjectId
                       , MI_Sign.ParentId                                      AS MovementId
                       , MovementFloat_MovementItemId.MovementId               AS MovementSaleId

                  FROM MovementItem AS MI_Sign
                       LEFT JOIN tmpMIF AS MovementFloat_MovementItemId
                                        ON MovementFloat_MovementItemId.ValueData = MI_Sign.Id
                  WHERE MI_Sign.MovementId = inMovementId
                    AND MI_Sign.DescId = zc_MI_Sign()
                    AND MI_Sign.isErased = FALSE
                  )
      , tmpCheck AS (SELECT tmpMI.Id                   AS ID
                          , CASE WHEN Movement.ID = tmpMI.MovementId THEN True ELSE FALSE END AS isIssue
                          , Movement.OperDate          AS OperDate
                          , Movement.Invnumber         AS Invnumber
                          , CASE WHEN COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) > tmpMI.Amount THEN tmpMI.Amount
                            ELSE COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) END AS TotalSummChangePercent
                     FROM tmpMI

                          LEFT JOIN Movement ON Movement.ID IN (tmpMI.MovementId, tmpMI.MovementSaleId)

                          LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                  ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.ID
                                                 AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()
                     )

      , tmpSign  AS (SELECT Sum(MI_Sign.Amount)                                                     AS Accrued
                          , Count(*)                                                                AS AccruedCount
                          , Sum(tmpCheckSale.TotalSummChangePercent)                                AS SummChange
                          , Sum(CASE WHEN COALESCE(tmpCheckSale.TotalSummChangePercent, 0) = 0 THEN 0 ELSE 1 END)  AS ChangeCount

                     FROM tmpMI AS MI_Sign

                         LEFT JOIN tmpCheck ON tmpCheck.Id = MI_Sign.Id
                                           AND tmpCheck.isIssue = True

                         LEFT JOIN tmpCheck AS tmpCheckSale
                                            ON tmpCheckSale.Id = MI_Sign.Id
                                           AND tmpCheckSale.isIssue = False
                     )



      , tmpPercentUsed AS (SELECT (1.0*tmpSign.ChangeCount/tmpSign.AccruedCount*100)::TFloat   AS PercentUsed
                           FROM tmpSign)

     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                                       AS StatusCode
          , Object_Status.ValueData                                        AS StatusName
          , Object_Retail.Id                                               AS RetailId
          , Object_Retail.ValueData                                        AS RetailName
          , MovementDate_StartPromo.ValueData                              AS StartPromo
          , MovementDate_EndPromo.ValueData                                AS EndPromo
          , MovementDate_StartSale.ValueData                               AS StartSale
          , MovementDate_EndSale.ValueData                                 AS EndSale
          , COALESCE(MovementFloat_StartSummCash.ValueData,0)::TFloat      AS StartSummCash
          , COALESCE(MovementFloat_MonthCount.ValueData,0)::Integer        AS MonthCount
          , COALESCE(MovementFloat_DayCount.ValueData,0)::Integer          AS DayCount
          , COALESCE(MovementFloat_Limit.ValueData,0)::TFloat              AS SummLimit
          , MovementFloat_ChangePercent.ValueData                          AS ChangePercent
          , MovementDate_ServiceDate.ValueData                             AS ServiceDate
          , Object_Insert.Id                                               AS InsertId
          , Object_Insert.ValueData                                        AS InsertName
          , MovementDate_Insert.ValueData                                  AS InsertDate
          , Object_Update.Id                                               AS UpdateId
          , Object_Update.ValueData                                        AS UpdateName
          , MovementDate_Update.ValueData                                  AS UpdateDate
          , MovementString_Comment.ValueData                               AS Comment
          , tmpPercentUsed.PercentUsed::TFloat                             AS PercentUsed
          , COALESCE(MovementBoolean_Beginning.ValueData, FALSE)           AS isBeginning
     FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_StartSummCash
                                ON MovementFloat_StartSummCash.MovementId =  Movement.Id
                               AND MovementFloat_StartSummCash.DescId = zc_MovementFloat_StartSummCash()
        LEFT JOIN MovementFloat AS MovementFloat_MonthCount
                                ON MovementFloat_MonthCount.MovementId =  Movement.Id
                               AND MovementFloat_MonthCount.DescId = zc_MovementFloat_MonthCount()
        LEFT JOIN MovementFloat AS MovementFloat_DayCount
                                ON MovementFloat_DayCount.MovementId =  Movement.Id
                               AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()
        LEFT JOIN MovementFloat AS MovementFloat_Limit
                                ON MovementFloat_Limit.MovementId =  Movement.Id
                               AND MovementFloat_Limit.DescId = zc_MovementFloat_Limit()
        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

        LEFT JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId = Movement.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_EndSale
                               ON MovementDate_EndSale.MovementId = Movement.Id
                              AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
        LEFT JOIN MovementDate AS MovementDate_ServiceDate
                               ON MovementDate_ServiceDate.MovementId = Movement.Id
                              AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementBoolean AS MovementBoolean_Beginning
                                  ON MovementBoolean_Beginning.MovementId = Movement.Id
                                 AND MovementBoolean_Beginning.DescId = zc_MovementBoolean_Beginning()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
                              
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                     ON MovementLinkObject_Insert.MovementId = Movement.Id
                                    AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId 

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                     ON MovementLinkObject_Update.MovementId = Movement.Id
                                    AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId  

        LEFT JOIN tmpPercentUsed ON 1 = 1
        
     WHERE Movement.Id =  inMovementId;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.  Шаблий О.В.
 12.09.18                                                                                  *
 13.12.17         *
*/

--тест 
--select * from gpGet_Movement_Loyalty(inMovementId := 0 , inOperDate := ('13.03.2016')::TDateTime ,  inSession := '3');
--select * from gpGet_Movement_Loyalty(inMovementId := 16406918 , inOperDate := ('24.04.2016')::TDateTime ,  inSession := '3');