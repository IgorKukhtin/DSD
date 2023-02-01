-- �� �������� ����������
-- Function: gpReport_StaffList ()

DROP FUNCTION IF EXISTS gpReport_StaffList (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StaffList(
    IN inUnitId         Integer,   --�������������
    IN inModelServiceId Integer,   --������ ����������
    IN inMemberId       Integer,   --���������
    IN inPositionId     Integer,   --���������
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
     StaffListId                    Integer
    ,DocumentKindId                 Integer
    ,UnitId                         Integer
    ,UnitName                       TVarChar
    ,PositionId                     Integer
    ,PositionName                   TVarChar
    ,PositionLevelId                Integer
    ,PositionLevelName              TVarChar
    ,Count_Member                   Integer   -- ���-�� ������� (���)
    ,HoursPlan                      TFloat
    ,HoursDay                       TFloat
    ,PersonalGroupId                Integer
    ,PersonalGroupName              TVarChar
    ,MemberId                       Integer
    ,MemberName                     TVarChar
    ,SheetWorkTime_Date             TDateTime
    ,SUM_MemberHours                TFloat     -- ����� ����� ���� ����������� (� ���� ����������+...) - !!!���.!!!
    ,SheetWorkTime_Amount           TFloat     -- ����� ����� ���������� - !!!���.!!!
    ,Ord_SheetWorkTime              Integer    -- � �/� - SheetWorkTime
    ,ServiceModelId                 Integer
    ,ServiceModelCode               Integer
    ,ServiceModelName               TVarChar
    ,Price                          TFloat
    ,FromId                         Integer
    ,FromName                       TVarChar
    ,ToId                           Integer
    ,ToName                         TVarChar
    ,MovementDescId                 Integer
    ,MovementDescName               TVarChar
    ,SelectKindId                   Integer
    ,SelectKindName                 TVarChar
    ,Ratio                          TFloat
    ,ModelServiceItemChild_FromId   Integer
    ,ModelServiceItemChild_FromDescId Integer
    ,ModelServiceItemChild_FromName TVarChar
    ,ModelServiceItemChild_ToId     Integer
    ,ModelServiceItemChild_ToDescId Integer
    ,ModelServiceItemChild_ToName   TVarChar

    ,StorageLineId_From             Integer
    ,StorageLineName_From           TVarChar
    ,StorageLineId_To               Integer
    ,StorageLineName_To             TVarChar
    ,GoodsKind_FromId               Integer
    ,GoodsKind_FromName             TVarChar
    ,GoodsKindComplete_FromId       Integer
    ,GoodsKindComplete_FromName     TVarChar
    ,GoodsKind_ToId                 Integer
    ,GoodsKind_ToName               TVarChar
    ,GoodsKindComplete_ToId         Integer
    ,GoodsKindComplete_ToName       TVarChar


)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY
    WITH 

    
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.02.23         *

-- ����
-- select * from gpReport_StaffList(inUnitId := 8395 , inModelServiceId := 3363159 , inMemberId := 0 , inPositionId := 0 , inDetailDay := 'True' , inDetailModelService := 'True' , inDetailModelServiceItemMaster := 'True' , inDetailModelServiceItemChild := 'True' ,  inSession := '5');