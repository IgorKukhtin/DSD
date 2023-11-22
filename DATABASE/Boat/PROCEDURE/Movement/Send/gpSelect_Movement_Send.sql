-- Function: gpSelect_Movement_SendChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InvNumberInvoice TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , MovementId_parent Integer
             , InvNumberFull_parent TVarChar
             , InvNumber_parent TVarChar
             , DescName_parent TVarChar
             , FromName_parent TVarChar
             , ProductName_parent TVarChar
             , ModelName_parent TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Временно замена!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_Send AS ( SELECT Movement_Send.Id
                                  , Movement_Send.ParentId
                                  , Movement_Send.InvNumber
                                  , Movement_Send.OperDate             AS OperDate
                                  , Movement_Send.StatusId             AS StatusId
                                  , MovementLinkObject_To.ObjectId     AS ToId
                                  , MovementLinkObject_From.ObjectId   AS FromId
                             FROM tmpStatus
                                  INNER JOIN Movement AS Movement_Send
                                                      ON Movement_Send.StatusId = tmpStatus.StatusId
                                                     AND Movement_Send.OperDate BETWEEN inStartDate AND inEndDate
                                                     AND Movement_Send.DescId = zc_Movement_Send()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement_Send.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement_Send.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            )

        SELECT Movement_Send.Id
             , zfConvert_StringToNumber (Movement_Send.InvNumber) AS InvNumber
             , zfCalc_InvNumber_isErased ('', Movement_Send.InvNumber, Movement_Send.OperDate, Movement_Send.StatusId) AS InvNumber_Full
             , Movement_Send.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , MovementString_InvNumberInvoice.ValueData  AS InvNumberInvoice

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm

             , Object_From.Id                             AS FromId
             , Object_From.ObjectCode                     AS FromCode
             , Object_From.ValueData                      AS FromName
             , Object_To.Id                               AS ToId
             , Object_To.ObjectCode                       AS ToCode
             , Object_To.ValueData                        AS ToName
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

             , Movement_Parent.Id                         AS MovementId_parent
             , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumberFull_parent
             , Movement_Parent.InvNumber                  AS InvNumber_parent
             , MovementDesc_Parent.ItemName               AS DescName_parent
             , Object_From_parent.ValueData               AS FromName_parent
             , Object_Product_parent.ValueData            AS ProductName_parent
             , Object_Model_parent.ValueData              AS ModelName_parent

        FROM Movement_Send

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Send.StatusId
             LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement_Send.FromId
             LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement_Send.ToId

             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_Send.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId = Movement_Send.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_Send.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementString AS MovementString_InvNumberInvoice
                                      ON MovementString_InvNumberInvoice.MovementId = Movement_Send.Id
                                     AND MovementString_InvNumberInvoice.DescId = zc_MovementString_InvNumberInvoice()

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_Send.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
             LEFT JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement_Send.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             LEFT JOIN MovementDate AS MovementDate_Update
                                    ON MovementDate_Update.MovementId = Movement_Send.Id
                                   AND MovementDate_Update.DescId = zc_MovementDate_Update()
             LEFT JOIN MovementLinkObject AS MLO_Update
                                          ON MLO_Update.MovementId = Movement_Send.Id
                                         AND MLO_Update.DescId = zc_MovementLinkObject_Update()
             LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

            -- Parent - если указан
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement_Send.ParentId
            LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From_parent
                                         ON MovementLinkObject_From_parent.MovementId = Movement_Parent.Id
                                        AND MovementLinkObject_From_parent.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From_parent ON Object_From_parent.Id = MovementLinkObject_From_parent.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Product_parent
                                         ON MovementLinkObject_Product_parent.MovementId = Movement_Parent.Id
                                        AND MovementLinkObject_Product_parent.DescId = zc_MovementLinkObject_Product()
            LEFT JOIN Object AS Object_Product_parent ON Object_Product_parent.Id = MovementLinkObject_Product_parent.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Model_parent
                                 ON ObjectLink_Model_parent.ObjectId = Object_Product_parent.Id
                                AND ObjectLink_Model_parent.DescId = zc_ObjectLink_Product_Model()
            LEFT JOIN Object AS Object_Model_parent ON Object_Model_parent.Id = ObjectLink_Model_parent.ChildObjectId

           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.06.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Send (inStartDate:= '29.01.2023', inEndDate:= '01.02.2023', inIsErased := FALSE, inSession:= zfCalc_UserAdmin())
