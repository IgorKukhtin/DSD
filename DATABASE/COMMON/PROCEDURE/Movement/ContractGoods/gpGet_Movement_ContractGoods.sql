-- Function: gpGet_Movement_ContractGoods()

DROP FUNCTION IF EXISTS gpGet_Movement_ContractGoods (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ContractGoods(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, EndBeginDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , StartDate_Contract TDateTime, EndDate_Contract TDateTime
             , ContractKindName TVarChar
             , ContractStateKindId Integer
             , ContractStateKindCode Integer
             , ContractStateKindName TVarChar
             , ContractTagId Integer, ContractTagName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ContractGoods());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_ContractGoods_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , inOperDate                                       AS EndBeginDate

             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName

             , 0                     AS ContractId
             , 0                     AS ContractCode
             , CAST ('' AS TVarChar) AS ContractName
             , NULL ::TDateTime      AS StartDate_Contract
             , NULL ::TDateTime      AS EndDate_Contract
             , CAST ('' AS TVarChar) AS ContractKindName
             , 0                     AS ContractStateKindId
             , 0                     AS ContractStateKindCode
             , CAST ('' AS TVarChar) AS ContractStateKindName
             , 0                     AS ContractTagId
             , CAST ('' AS TVarChar) AS ContractTagName
             
             , 0                                                AS JuridicalId
             , CAST ('' AS TVarChar) 	                        AS JuridicalName

             , CAST ('' AS TVarChar) 		                AS Comment
             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP        ::TDateTime             AS InsertDate

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              LEFT JOIN Object AS Object_Insert          ON Object_Insert.Id          = vbUserId
           ;
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate ::TDateTime          AS OperDate
           , MovementDate_EndBegin.ValueData        AS EndBeginDate

           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName

           , View_Contract.ContractId            AS ContractId
           , View_Contract.ContractCode          AS ContractCode
           , View_Contract.InvNumber             AS ContractName
           , View_Contract.StartDate  ::TDateTime AS StartDate_Contract
           , View_Contract.EndDate    ::TDateTime AS EndDate_Contract
           , View_Contract.ContractKindName
           , View_Contract.ContractStateKindId
           , View_Contract.ContractStateKindCode
           , View_Contract.ContractStateKindName
           , View_Contract.ContractTagId
           , View_Contract.ContractTagName

           , Object_Juridical.Id                    AS JuridicalId
           , Object_Juridical.ValueData             AS JuridicalName

           , MovementString_Comment.ValueData       AS Comment

           , Object_Insert.ValueData                AS InsertName
           , MovementDate_Insert.ValueData          AS InsertDate
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                 ON ObjectLink_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId

            LEFT JOIN MovementDate AS MovementDate_EndBegin
                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_ContractGoods();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.21         * 
*/

-- тест
-- SELECT * FROM gpGet_Movement_ContractGoods (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= '9818')
