-- View: Movement_Medoc_View

DROP VIEW IF EXISTS Movement_Medoc_View;

CREATE OR REPLACE VIEW Movement_Medoc_View AS 
SELECT       
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.ParentId
           , Movement.StatusId
           , Object_Status.ObjectCode                     AS StatusCode
           , Object_Status.ValueData                      AS StatusName
           , MovementString_InvNumberPartner.ValueData    AS InvNumberPartner
           , MovementString_InvNumberBranch.ValueData     AS InvNumberBranch
           , MovementString_InvNumberRegistered.ValueData AS InvNumberRegistered
           , MovementDate_DateRegistered.ValueData        AS DateRegistered
           , MovementString_FromINN.ValueData             AS FromINN
           , MovementString_ToINN.ValueData               AS ToINN
           , MovementString_Desc.ValueData                AS Desc
           , MovementFloat_TotalSumm.ValueData            AS TotalSumm
           , MovementBoolean_isIncome.ValueData           AS isIncome 

       FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

           LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                     ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                    AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()

             LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementString AS MovementString_FromINN
                                     ON MovementString_FromINN.MovementId = Movement.Id
                                    AND MovementString_FromINN.DescId = zc_MovementString_FromINN()

            LEFT JOIN MovementString AS MovementString_ToINN
                                     ON MovementString_ToINN.MovementId = Movement.Id
                                    AND MovementString_ToINN.DescId = zc_MovementString_ToINN()

            LEFT JOIN MovementString AS MovementString_Desc
                                     ON MovementString_Desc.MovementId = Movement.Id
                                    AND MovementString_Desc.DescId = zc_MovementString_Desc()

            LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId = Movement.Id
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()

           WHERE Movement.DescId = zc_Movement_Medoc()
             -- AND Movement.StatusId <> zc_Enum_Status_Erased()
          ;

ALTER TABLE Movement_Medoc_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 18.05.15                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_Income_View where id = 805
