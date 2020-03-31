-- Function: gpGet_Movement_PromoCode()

DROP FUNCTION IF EXISTS gpGet_Movement_PromoCode (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PromoCode(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber     TVarChar
             , OperDate      TDateTime
             , StatusCode    Integer
             , StatusName    TVarChar
             , StartPromo    TDateTime
             , EndPromo      TDateTime
             , ChangePercent TFloat
             , isElectron    Boolean
             , isOne         Boolean
             , isBuySite     Boolean     
             , PromoCodeId   Integer
             , PromoCodeName TVarChar
             , InsertId Integer
             , InsertName TVarChar
             , InsertDate TDateTime
             , UpdateId Integer
             , UpdateName TVarChar
             , UpdateDate TDateTime
             , Comment TVarChar
             , UnitName Text)
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
            0                                                AS Id
          , CAST (NEXTVAL ('movement_PromoCode_seq') AS TVarChar) AS InvNumber
          , inOperDate		                             AS OperDate
          , Object_Status.Code          AS StatusCode
          , Object_Status.Name          AS StatusName
          , Null  :: TDateTime          AS StartPromo
          , Null  :: TDateTime          AS EndPromo 
          , 0     ::TFloat              AS ChangePercent
          , FALSE ::Boolean             AS isElectron
          , FALSE ::Boolean             AS isOne
          , FALSE ::Boolean             AS isBuySite
          , NULL  ::Integer             AS PromoCodeId
          , NULL  ::TVarChar            AS PromoCodeName
          , NULL  ::Integer             AS InsertId
          , Object_Insert.ValueData     AS InsertName
          , CURRENT_TIMESTAMP :: TDateTime AS InsertDate
          , NULL  ::Integer             AS UpdateId
          , NULL  ::TVarChar            AS UpdateName
          , Null  :: TDateTime          AS UpdateDate
          , NULL  ::TVarChar            AS Comment
          , NULL  ::Text                AS UnitName
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId;
  
   ELSE
 
  RETURN QUERY
  WITH tmpUnitName AS (SELECT string_agg(Object_Object.ValueData, Chr(13)||Chr(10)) as UnitName
                       FROM MovementItem AS MI_PromoCode
                           INNER JOIN Object AS Object_Object ON Object_Object.Id = MI_PromoCode.ObjectId
                       WHERE MI_PromoCode.MovementId = inMovementId
                         AND MI_PromoCode.DescId = zc_MI_Child()
                         AND MI_PromoCode.isErased = FALSE
                         AND MI_PromoCode.Amount = 1)
     
     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          --, Movement.StatusId
          , Object_Status.ObjectCode                                       AS StatusCode
          , Object_Status.ValueData                                        AS StatusName
          , MovementDate_StartPromo.ValueData                              AS StartPromo
          , MovementDate_EndPromo.ValueData                                AS EndPromo
          , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat      AS ChangePercent
          , COALESCE(MovementBoolean_Electron.ValueData, FALSE) ::Boolean  AS isElectron
          , COALESCE(MovementBoolean_One.ValueData, FALSE)      ::Boolean  AS isOne
          , COALESCE(MovementBoolean_BuySite.ValueData, FALSE)  ::Boolean  AS isBuySite
          , MovementLinkObject_PromoCode.ObjectId                          AS PromoCodeId
          , Object_PromoCode.ValueData                                     AS PromoCodeName
          , Object_Insert.Id                                               AS InsertId
          , Object_Insert.ValueData                                        AS InsertName
          , MovementDate_Insert.ValueData                                  AS InsertDate
          , Object_Update.Id                                               AS UpdateId
          , Object_Update.ValueData                                        AS UpdateName
          , MovementDate_Update.ValueData                                  AS UpdateDate
          , MovementString_Comment.ValueData                               AS Comment
          , tmpUnitName.UnitName::Text                                     AS UnitName
     FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

        LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                  ON MovementBoolean_Electron.MovementId =  Movement.Id
                                 AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
        LEFT JOIN MovementBoolean AS MovementBoolean_One
                                  ON MovementBoolean_One.MovementId =  Movement.Id
                                 AND MovementBoolean_One.DescId = zc_MovementBoolean_One()
        LEFT JOIN MovementBoolean AS MovementBoolean_BuySite
                                  ON MovementBoolean_BuySite.MovementId =  Movement.Id
                                 AND MovementBoolean_BuySite.DescId = zc_MovementBoolean_BuySite()
                               
        LEFT JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId = Movement.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoCode
                                     ON MovementLinkObject_PromoCode.MovementId = Movement.Id
                                    AND MovementLinkObject_PromoCode.DescId = zc_MovementLinkObject_PromoCode()
        LEFT JOIN Object AS Object_PromoCode ON Object_PromoCode.Id = MovementLinkObject_PromoCode.ObjectId
        
        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
                              
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                     ON MovementLinkObject_Insert.MovementId = Movement.Id
                                    AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId 

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                     ON MovementLinkObject_Update.MovementId = Movement.Id
                                    AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId  
        
        LEFT JOIN tmpUnitName ON 1 = 1
        
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
--select * from gpGet_Movement_PromoCode(inMovementId := 0 , inOperDate := ('13.03.2016')::TDateTime ,  inSession := '3');
--select * from gpGet_Movement_PromoCode(inMovementId := 1923638 , inOperDate := ('24.04.2016')::TDateTime ,  inSession := '3');