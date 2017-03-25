-- Function: gpSelect_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpSelect_Movement_StoreReal(TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_StoreReal(TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_StoreReal (
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inIsErased         Boolean   ,
    IN inJuridicalBasisId Integer   ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusName TVarChar
             , InsertDate TDateTime
             , InsertName TVarChar
             , PartnerName TVarChar
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId      Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StoreReal());
      vbUserId := lpGetUserBySession(inSession);

      -- Результат
      RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                           UNION 
                           SELECT zc_Enum_Status_UnComplete() AS StatusId
                           UNION 
                           SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                          )
        SELECT Movement.Id
             , Movement.InvNumber    
             , Movement.OperDate       
             , Object_Status.ValueData          AS StatusName
             , MovementDate_Insert.ValueData    AS InsertDate
             , Object_User.ValueData            AS InsertName
             , Object_Partner.ValueData         AS PartnerName
             , MovementString_Comment.ValueData AS Comment
        FROM (SELECT Movement.Id
              FROM tmpStatus
                   JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                                AND Movement.DescId = zc_Movement_StoreReal() 
                                AND Movement.StatusId = tmpStatus.StatusId
             ) AS tmpMovement
             LEFT JOIN Movement ON Movement.Id = tmpMovement.Id

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

             LEFT JOIN MovementDate AS MovementDate_Insert 
                                    ON MovementDate_Insert.MovementId = Movement.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

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
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment();
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 16.02.17                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_StoreReal(inStartDate:= '01.01.2017', inEndDate:= CURRENT_DATE, inIsErased:= FALSE, inJuridicalBasisId:= 0, inSession := zfCalc_UserAdmin())
