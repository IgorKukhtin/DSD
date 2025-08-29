-- �� ��������� ������� ���������� 
-- Function: gpReport_StaffListRanking ()

DROP FUNCTION IF EXISTS gpReport_StaffListRanking (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StaffListRanking(
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
            , AmountPlan                     TFloat    --���� �� (�� ��������������)
            , Amount                         TFloat    --���� �� 
            , AmountFact                     TFloat    --���� ��
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
         , 0  ::TFloat    AS AmountPlan
         , 0  ::TFloat    AS Amount              
         , 0  ::TFloat    AS AmountFact          

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
-- select * from gpReport_StaffListRanking (inStartDate:= '26.08.2025'::TDateTime, inEndDate:= '26.08.2025'::TDateTime, inUnitId := 8395 , inDepartmentId := 0 , inSession := '5');