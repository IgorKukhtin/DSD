--- Function: lpSelect_MovementItem_GoodsSP_onDate()


DROP FUNCTION IF EXISTS lpSelect_MovementItem_GoodsSP_onDate (TDateTime, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_MovementItem_GoodsSP_onDate(
    IN inStartDate               TDateTime,    -- 
    IN inEndDate                 TDateTime,    -- 
    IN inMedicalProgramSPId      Integer = 0,  -- ����������� ��������� ���. ��������
    IN inGroupMedicalProgramSPId Integer = 0   -- ������ ����������� �������� ���. ��������
)    
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar
             , MovementItemId Integer
             , GoodsId Integer
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
             , MedicalProgramSPId Integer 
             , GroupMedicalProgramSPId Integer 
             , isElectronicPrescript Boolean
              )
AS
$BODY$
BEGIN
           -- ���������
           RETURN QUERY
           SELECT Movement.Id            AS MovementId
                , Movement.OperDate      AS OperDate
                , Movement.InvNumber     AS InvNumber
                , MovementItem.Id        AS MovementItemId
                , MovementItem.ObjectId  AS GoodsId
                , MovementDate_OperDateStart.ValueData AS OperDateStart
                , MovementDate_OperDateEnd.ValueData   AS OperDateEnd
                , MLO_MedicalProgramSP.ObjectId        AS MedicalProgramSPId
                , ObjectLink_GroupMedicalProgramSP.ChildObjectId AS GroupMedicalProgramSPId
                , COALESCE (ObjectBoolean_ElectronicPrescript.ValueData, False) AS isElectronicPrescript
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

                 LEFT JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                              ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                             AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                                               
                 LEFT JOIN ObjectLink AS ObjectLink_GroupMedicalProgramSP
                                      ON ObjectLink_GroupMedicalProgramSP.ObjectId = MLO_MedicalProgramSP.ObjectId
                                     AND ObjectLink_GroupMedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP()
                                     
                 LEFT JOIN ObjectBoolean AS ObjectBoolean_ElectronicPrescript
                                         ON ObjectBoolean_ElectronicPrescript.ObjectId = COALESCE (MLO_MedicalProgramSP.ObjectId, 18076882)
                                        AND ObjectBoolean_ElectronicPrescript.DescId = zc_ObjectBoolean_MedicalProgramSP_ElectronicPrescript()

           WHERE Movement.StatusId = zc_Enum_Status_Complete()
             AND Movement.DescId = zc_Movement_GoodsSP()
             AND (COALESCE (MLO_MedicalProgramSP.ObjectId, 0) = inMedicalProgramSPId OR COALESCE (inMedicalProgramSPId, 0) = 0)
             AND (COALESCE (ObjectLink_GroupMedicalProgramSP.ChildObjectId, 0) = inGroupMedicalProgramSPId OR COALESCE(inGroupMedicalProgramSPId, 0) = 0)
             
           ;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.19         *
*/

-- 
SELECT * FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE);