-- Function: gpGet_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpGet_Movement_StoreReal(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_StoreReal (
    IN inMovementId Integer  , -- ключ Документа
    IN inOperDate   TDateTime, -- дата Документа
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , GUID TVarChar
             , InsertDate TDateTime
             , InsertMobileDate TDateTime
             , InsertName TVarChar
             , PartnerId Integer
             , PartnerName TVarChar
             , Comment TVarChar 
             , InvNumberFull_last1 TVarChar
             , InvNumberFull_last2 TVarChar
             , InvNumberFull_last3 TVarChar
             , InvNumberFull_last4 TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUserName TVarChar;
   DECLARE vbPartnerId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_StoreReal());
      vbUserId:= lpGetUserBySession (inSession);
      vbUserName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = vbUserId);

      vbPartnerId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Partner());
      vbOperDate  := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
      
      IF COALESCE(inMovementId, 0) = 0 
      THEN
           RETURN QUERY
             SELECT 0::Integer                                  AS Id
                  , NEXTVAL('movement_storereal_seq')::TVarChar AS InvNumber
                  , CURRENT_DATE::TDateTime                     AS OperDate
                  , Object_Status.Code                          AS StatusCode
                  , Object_Status.Name                          AS StatusName
                  , ''::TVarChar                                AS GUID
                  , CURRENT_TIMESTAMP::TDateTime                AS InsertDate
                  , Null ::TDateTime                            AS InsertMobileDate
                  , vbUserName                                  AS InserName 
                  , 0::Integer                                  AS PartnerId
                  , '' ::TVarChar                               AS PartnerName
                  , '' ::TVarChar                               AS Comment

                  , '' ::TVarChar                               AS InvNumberFull_last1
                  , '' ::TVarChar                               AS InvNumberFull_last2
                  , '' ::TVarChar                               AS InvNumberFull_last3
                  , '' ::TVarChar                               AS InvNumberFull_last4 
             FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
      ELSE
           RETURN QUERY
           WITH 
            --предыдущие 4  документа
            tmpMovement_last AS (SELECT MAX (CASE WHEN tmp.Ord = 1 THEN zfConvert_DateToString (tmp.OperDate) || ' / ' || tmp.InvNumber ELSE '' END) :: TVarChar AS InvNumberFull_last1
                                      , MAX (CASE WHEN tmp.Ord = 2 THEN zfConvert_DateToString (tmp.OperDate) || ' / ' || tmp.InvNumber ELSE '' END) :: TVarChar AS InvNumberFull_last2
                                      , MAX (CASE WHEN tmp.Ord = 3 THEN zfConvert_DateToString (tmp.OperDate) || ' / ' || tmp.InvNumber ELSE '' END) :: TVarChar AS InvNumberFull_last3
                                      , MAX (CASE WHEN tmp.Ord = 4 THEN zfConvert_DateToString (tmp.OperDate) || ' / ' || tmp.InvNumber ELSE '' END) :: TVarChar AS InvNumberFull_last4
                                FROM (SELECT Movement.*
                                           , ROW_NUMBER() OVER (ORDER BY Movement.OperDate Desc) AS Ord
                                      FROM Movement
                                           INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                                                        AND MovementLinkObject_Partner.ObjectId = vbPartnerId
                                      WHERE Movement.DescId = zc_Movement_StoreReal()
                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                                        AND Movement.Id <> inMovementId
                                        AND Movement.OperDate <=vbOperDate
                                      ) AS tmp
                                WHERE tmp.Ord < 5
                                )


             SELECT Movement.Id                           
                  , Movement.InvNumber                        
                  , Movement.OperDate                      
                  , Object_Status.ObjectCode         AS StatusCode
                  , Object_Status.ValueData          AS StatusName
                  , MovementString_GUID.ValueData    AS GUID
                  , MovementDate_Insert.ValueData    AS InsertDate
                  , MovementDate_InsertMobile.ValueData AS InsertMobileDate
                  , Object_User.ValueData            AS InsertName
                  , Object_Partner.Id                AS PartnerId
                  , Object_Partner.ValueData         AS PartnerName
                  , MovementString_Comment.ValueData AS Comment
                  , tmpMovement_last.InvNumberFull_last1 ::TVarChar
                  , tmpMovement_last.InvNumberFull_last2 ::TVarChar
                  , tmpMovement_last.InvNumberFull_last3 ::TVarChar
                  , tmpMovement_last.InvNumberFull_last4 ::TVarChar
             FROM Movement
                  LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                  LEFT JOIN MovementString AS MovementString_GUID 
                                           ON MovementString_GUID.MovementId = Movement.Id
                                          AND MovementString_GUID.DescId = zc_MovementString_GUID()

                  LEFT JOIN MovementString AS MovementString_Comment
                                           ON MovementString_Comment.MovementId = Movement.Id
                                          AND MovementString_Comment.DescId = zc_MovementString_Comment()

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
                  
                  LEFT JOIN tmpMovement_last ON 1 = 1
             
             WHERE Movement.Id = inMovementId
               AND Movement.DescId = zc_Movement_StoreReal();
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 25.03.17         *
 15.02.17                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_StoreReal (inMovementId := 1, inOperDate := CURRENT_DATE, inSession := '9818')
