-- View: Object_Unit_View

DROP VIEW IF EXISTS Movement_LossDebt_View;

CREATE OR REPLACE VIEW Movement_LossDebt_View AS 
       SELECT
             Movement.Id                                AS Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Movement.StatusId                          AS StatusId
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , MovementLinkObject_JuridicalBasis.ObjectId AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData            AS JuridicalBasisName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_JuridicalBasis
                                         ON MovementLinkObject_JuridicalBasis.MovementId = Movement.Id
                                        AND MovementLinkObject_JuridicalBasis.DescId = zc_MovementLinkObject_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = MovementLinkObject_JuridicalBasis.ObjectId
            
      WHERE Movement.DescId = zc_Movement_LossDebt();

ALTER TABLE Movement_LossDebt_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 30.01.15                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_Income_View where id = 805
