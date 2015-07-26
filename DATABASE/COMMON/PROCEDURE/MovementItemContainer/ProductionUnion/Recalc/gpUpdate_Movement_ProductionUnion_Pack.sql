-- Function: gpUpdate_Movement_ProductionUnion_Pack (TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Pack (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Pack(
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inUnitId       Integer,    -- 
    IN inSession      TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnion_Defroster());

   -- ��������
   PERFORM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate  := TRUE
                                                 , inStartDate := inStartDate
                                                 , inEndDate   := inEndDate
                                                 , inUnitId    := inUnitId
                                                 , inUserId    := zc_Enum_Process_Auto_Pack() -- vbUserId
                                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.07.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Pack (inStartDate:= '01.07.2015', inEndDate:= '19.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin()) -- ��� ��������
