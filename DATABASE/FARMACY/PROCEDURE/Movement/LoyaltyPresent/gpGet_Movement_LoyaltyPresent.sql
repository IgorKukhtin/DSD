-- Function: gpGet_Movement_LoyaltyPresent()

DROP FUNCTION IF EXISTS gpGet_Movement_LoyaltyPresent (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_LoyaltyPresent(
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
             , StartSale     TDateTime
             , EndSale       TDateTime
             , MonthCount    Integer
             , InsertId      Integer
             , InsertName    TVarChar
             , InsertDate    TDateTime
             , UpdateId      Integer
             , UpdateName    TVarChar
             , UpdateDate    TDateTime
             , Comment       TVarChar
             , isElectron    Boolean
             , SummRepay     TFloat
             , AmountPresent TFloat
             )
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
          , CAST (NEXTVAL ('movement_LoyaltyPresent_seq') AS TVarChar) AS InvNumber
          , inOperDate		            AS OperDate
          , Object_Status.Code          AS StatusCode
          , Object_Status.Name          AS StatusName
          , NULL  ::Integer             AS RetailId
          , NULL  ::TVarChar            AS RetailName
          , Null  :: TDateTime          AS StartSale
          , Null  :: TDateTime          AS EndSale
          , 0     ::Integer             AS MonthCount
          , NULL  ::Integer             AS InsertId
          , Object_Insert.ValueData     AS InsertName
          , CURRENT_TIMESTAMP :: TDateTime AS InsertDate
          , NULL  ::Integer             AS UpdateId
          , NULL  ::TVarChar            AS UpdateName
          , Null  :: TDateTime          AS UpdateDate
          , NULL  ::TVarChar            AS Comment
          , FALSE                       AS isElectron
          , 0     ::TFloat              AS SummRepay
          , 0     ::TFloat              AS AmountPresent
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId;
  
   ELSE
 
  RETURN QUERY
     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                                       AS StatusCode
          , Object_Status.ValueData                                        AS StatusName
          , Object_Retail.Id                                               AS RetailId
          , Object_Retail.ValueData                                        AS RetailName
          , MovementDate_StartSale.ValueData                               AS StartSale
          , MovementDate_EndSale.ValueData                                 AS EndSale
          , COALESCE(MovementFloat_MonthCount.ValueData,0)::Integer        AS MonthCount
          , Object_Insert.Id                                               AS InsertId
          , Object_Insert.ValueData                                        AS InsertName
          , MovementDate_Insert.ValueData                                  AS InsertDate
          , Object_Update.Id                                               AS UpdateId
          , Object_Update.ValueData                                        AS UpdateName
          , MovementDate_Update.ValueData                                  AS UpdateDate
          , MovementString_Comment.ValueData                               AS Comment
          , COALESCE(MovementBoolean_Electron.ValueData, FALSE) ::Boolean  AS isElectron
          , MovementFloat_SummRepay.ValueData                              AS SummRepay
          , MovementFloat_AmountPresent.ValueData                          AS AmountPresent
     FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_MonthCount
                                ON MovementFloat_MonthCount.MovementId =  Movement.Id
                               AND MovementFloat_MonthCount.DescId = zc_MovementFloat_MonthCount()
        LEFT JOIN MovementFloat AS MovementFloat_SummRepay
                                ON MovementFloat_SummRepay.MovementId =  Movement.Id
                               AND MovementFloat_SummRepay.DescId = zc_MovementFloat_SummRepay()
        LEFT JOIN MovementFloat AS MovementFloat_AmountPresent
                                ON MovementFloat_AmountPresent.MovementId =  Movement.Id
                               AND MovementFloat_AmountPresent.DescId = zc_MovementFloat_AmountPresent()

        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_EndSale
                               ON MovementDate_EndSale.MovementId = Movement.Id
                              AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

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

        LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                  ON MovementBoolean_Electron.MovementId =  Movement.Id
                                 AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
        
     WHERE Movement.Id =  inMovementId;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.09.20                                                       *
*/

--тест 
--select * from gpGet_Movement_LoyaltyPresent(inMovementId := 0 , inOperDate := ('13.03.2016')::TDateTime ,  inSession := '3');
--select * from gpGet_Movement_LoyaltyPresent(inMovementId := 16406918 , inOperDate := ('24.04.2016')::TDateTime ,  inSession := '3');