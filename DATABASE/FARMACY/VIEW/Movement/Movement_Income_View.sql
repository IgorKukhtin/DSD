-- View: Object_Unit_View

DROP VIEW IF EXISTS Movement_Income_View;

CREATE OR REPLACE VIEW Movement_Income_View AS 
SELECT       Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Movement.StatusId                          AS StatusId
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementLinkObject_From.ObjectId           AS FromId
           , Object_From.ValueData                      AS FromName
           , MovementLinkObject_To.ObjectId             AS ToId
           , Object_To.ValueData                        AS ToName
           , MovementLinkObject_NDSKind.ObjectId        AS NDSKindId
           , Object_NDSKind.ValueData                   AS NDSKindName

       FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                         ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()

            LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId


            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

           WHERE Movement.DescId = zc_Movement_Income();

ALTER TABLE Movement_Income_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 12.09.14                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_Income_View where id = 805
