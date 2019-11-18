-- View: Object_Unit_View

DROP VIEW IF EXISTS Movement_OrderExternal_View;

CREATE OR REPLACE VIEW Movement_OrderExternal_View AS 
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Movement.StatusId                                  AS StatusId
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementLinkObject_From.ObjectId                   AS FromId
           , Object_From.ObjectCode                             AS FromCode
           , Object_From.ValueData                              AS FromName
           , MovementLinkObject_To.ObjectId                     AS ToId
           , Object_To.Code                                     AS ToCode
           , Object_To.Name                                     AS ToName
           , Object_To.JuridicalId                              AS JuridicalId
           , Object_To.JuridicalCode                            AS JuridicalCode
           , Object_To.JuridicalName                            AS JuridicalName
           , MovementLinkObject_Contract.ObjectId               AS ContractId
           , Object_Contract.ValueData                          AS ContractName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSum
           , Movement_Master.Id                                 AS MasterId
           , ('π '||Movement_Master.InvNumber || ' ÓÚ '|| TO_CHAR(Movement_Master.Operdate , 'DD.MM.YYYY')) :: TVarChar   AS MasterInvNumber 
           , COALESCE(MovementString_Comment.ValueData,'')        :: TVarChar AS Comment
           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) :: Boolean  AS isDeferred          

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                    
            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN Object_Unit_View AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkMovement AS MLM_Master
                                           ON MLM_Master.MovementId = Movement.Id
                                          AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MLM_Master.MovementChildId

       WHERE Movement.DescId = zc_Movement_OrderExternal();

ALTER TABLE Movement_OrderExternal_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 22.12.16         * add isDeferred
 10.05.16         *
 12.12.14                        * 
*/

-- ÚÂÒÚ
--SELECT * FROM Movement_OrderExternal_View where id = 2021037 
