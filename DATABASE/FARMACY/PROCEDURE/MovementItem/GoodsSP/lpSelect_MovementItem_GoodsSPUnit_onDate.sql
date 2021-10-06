--- Function: lpSelect_MovementItem_GoodsSPUnit_onDate()


DROP FUNCTION IF EXISTS lpSelect_MovementItem_GoodsSPUnit_onDate (TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpSelect_MovementItem_GoodsSPUnit_onDate(
    IN inStartDate           TDateTime,   -- 
    IN inEndDate             TDateTime,   -- 
    IN inUnitId              Integer      --
)    
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar
             , MovementItemId Integer
             , GoodsId Integer
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
             , MedicalProgramSPId Integer 
              )
AS
$BODY$
BEGIN
           -- –ÂÁÛÎ¸Ú‡Ú
           RETURN QUERY
           WITH tmpMedicalProgramSP AS (SELECT DISTINCT ObjectLink_MedicalProgramSP.ChildObjectId AS MedicalProgramSPId
                                        FROM Object AS Object_MedicalProgramSPLink
                                             LEFT JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                                                                  ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
                                             LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                                  ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                                        WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()   
                                          AND Object_MedicalProgramSPLink.isErased = False        
                                          AND (ObjectLink_Unit.ChildObjectId = inUnitId OR COALESCE(inUnitId, 0) = 0)
                                       ) 
           SELECT Movement.Id            AS MovementId
                , Movement.OperDate      AS OperDate
                , Movement.InvNumber     AS InvNumber
                , MovementItem.Id        AS MovementItemId
                , MovementItem.ObjectId  AS GoodsId
                , MovementDate_OperDateStart.ValueData AS OperDateStart
                , MovementDate_OperDateEnd.ValueData   AS OperDateEnd
                , MLO_MedicalProgramSP.ObjectId        AS MedicalProgramSPId
           FROM Movement
                 INNER JOIN MovementDate AS MovementDate_OperDateStart
                                         ON MovementDate_OperDateStart.MovementId = Movement.Id
                                        AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                        AND MovementDate_OperDateStart.ValueData  <= inEndDate
          
                 INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                         ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                        AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                        AND MovementDate_OperDateEnd.ValueData  >= inStartDate

                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                        AND MovementItem.DescId = zc_MI_Master()
                                        AND MovementItem.isErased = FALSE

                 INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                               ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                              AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                 INNER JOIN tmpMedicalProgramSP ON tmpMedicalProgramSP.MedicalProgramSPId = MLO_MedicalProgramSP.ObjectId
                                               
           WHERE Movement.StatusId = zc_Enum_Status_Complete()
             AND Movement.DescId = zc_Movement_GoodsSP()
           ;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   ÿ‡·ÎËÈ Œ.¬.
 06.10.21                                                       *
*/

-- 
SELECT * FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE, inUnitId := 3457773);