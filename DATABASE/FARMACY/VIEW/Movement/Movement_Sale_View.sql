DROP VIEW IF EXISTS Movement_Sale_View;

CREATE OR REPLACE VIEW Movement_Sale_View AS 
    SELECT       
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , Movement.StatusId
      , Object_Status.ObjectCode                                       AS StatusCode
      , Object_Status.ValueData                                        AS StatusName
      , COALESCE(MovementFloat_TotalCount.ValueData,0)::TFloat         AS TotalCount
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat          AS TotalSumm
      , COALESCE(MovementFloat_TotalSummPrimeCost.ValueData,0)::TFloat AS TotalSummPrimeCost
      , MovementLinkObject_Unit.ObjectId                               AS UnitId
      , Object_Unit.ValueData                                          AS UnitName
      , MovementLinkObject_Juridical.ObjectId                          AS JuridicalId
      , Object_Juridical.ValueData                                     AS JuridicalName
      , MovementLinkObject_PaidKind.ObjectId                           AS PaidKindId  
      , Object_PaidKind.ValueData                                      AS PaidKindName 
    FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId =  Movement.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                   
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPrimeCost
                                ON MovementFloat_TotalSummPrimeCost.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummPrimeCost.DescId = zc_MovementFloat_TotalSummPrimeCost()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN Object AS Object_Unit 
                         ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT JOIN Object AS Object_Juridical 
                         ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                     ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
        LEFT JOIN Object AS Object_PaidKind 
                         ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
    WHERE Movement.DescId = zc_Movement_Sale();

ALTER TABLE Movement_Sale_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   ¬ÓÓ·Í‡ÎÓ ¿.¿.
 13.10.15                                                         * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_Sale_View  where id = 805
