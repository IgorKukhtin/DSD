-- �� ��������� ������� ���������� ���������
-- Function: gpReport_StaffListMovement ()

DROP FUNCTION IF EXISTS gpReport_StaffListMovement (TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_StaffListMovement (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StaffListMovement(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inUnitId         Integer,   --�������������
    IN inDepartmentId   Integer,   --�����������
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
              DepartmentId                   Integer
            , DepartmentName                 TVarChar
            , UnitId                         Integer
            , UnitName                       TVarChar
            , PositionId                     Integer
            , PositionName                   TVarChar
            , PositionLevelId                Integer
            , PositionLevelName              TVarChar
            , PositionPropertyName           TVarChar  --������������� ��������� 
            , PersonalId                     Integer   --�������� �� ��������� 
            , PersonalName                   TVarChar  -- 
            , StaffHoursDayName              TVarChar  -- ������ ������
            , StaffHoursName                 TVarChar  --������ ������
            , AmountPlan                     TFloat    --���� �� (�� ��������������)
            , AmountFact                     TFloat    --���� ��
            , Amount_diff                    TFloat    --������ 
            , Persent_diff                   TFloat    -- % �����������
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY

      
  -- ���������                      
    SELECT 0  ::Integer   AS DepartmentId                
         , '' ::TVarChar  AS DepartmentName      
         , 0  ::Integer   AS UnitId              
         , '' ::TVarChar  AS UnitName            
         , 0  ::Integer   AS PositionId          
         , '' ::TVarChar  AS PositionName        
         , 0  ::Integer   AS PositionLevelId     
         , '' ::TVarChar  AS PositionLevelName   
         , '' ::TVarChar  AS PositionPropertyName
         , 0  ::Integer   AS PersonalId          
         , '' ::TVarChar  AS PersonalName        
         , '' ::TVarChar  AS StaffHoursDayName   
         , '' ::TVarChar  AS StaffHoursName      
         , 0  ::TFloat    AS AmountPlan              
         , 0  ::TFloat    AS AmountFact          
         , 0  ::TFloat    AS Amount_diff
         , 0  ::TFloat    AS Persent_diff         
    
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/* -------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.08.25         *
*/
-- ����
-- select * from gpReport_StaffListMovement (inStartDate:= '26.08.2025'::TDateTime, inEndDate:= '26.08.2025'::TDateTime, inUnitId := 8395 , inDepartmentId := 0 , inSession := '5');