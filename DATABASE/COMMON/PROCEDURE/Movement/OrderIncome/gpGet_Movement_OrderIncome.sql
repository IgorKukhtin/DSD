-- Function: gpGet_Movement_OrderIncome()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderIncome (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderIncome(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , InsertDate TDateTime, InsertName TVarChar
             , TotalCount TFloat, TotalSumm TFloat 
             , PartnerId Integer, PartnerName TVarChar
             , ContractId Integer, ContractName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderIncome());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_OrderIncome_seq') AS TVarChar) AS InvNumber
             , inOperDate                                 AS OperDate
             , Object_Status.Code                         AS StatusCode
             , Object_Status.Name                         AS StatusName
             
             , CURRENT_TIMESTAMP ::TDateTime              AS InsertDate
             , Object_Insert.ValueData                    AS InsertName
                          
             , 0                                          AS PartnerId
             , CAST ('' as TVarChar)                      AS PartnerName
             , 0                                          AS ContractId
             , CAST ('' as TVarChar)                      AS ContractName
             , 0                                          AS PaidKindId
             , CAST ('' as TVarChar)                      AS PaidKindName  
  
             , CAST ('' as TVarChar) 	                  AS Comment

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY
      SELECT Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate                      AS OperDate
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName
           
           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Insert.ValueData                AS InsertName
           
           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm

           , Object_Partner.Id                      AS PartnerId
           , Object_Partner.ValueData               AS PartnerName

           , Object_Contract.Id                     AS ContractId
           , Object_Contract.ValueData              AS ContractName

           , Object_PaidKind.Id                     AS PaidKindId
           , Object_PaidKind.ValueData              AS PaidKindName

           , MovementString_Comment.ValueData       AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId =  Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_OrderIncome();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.07.16         *                                                       *
*/

-- тест
-- 