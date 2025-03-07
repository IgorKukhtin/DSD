-- Function: gpUpdate_Movement_ProductionUnion_Defroster (TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Defroster (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Defroster(
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
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnion_Defroster());


   -- ��������
   PERFORM lpUpdate_Movement_ProductionUnion_Defroster (inIsUpdate  := TRUE
                                                      , inStartDate := inStartDate
                                                      , inEndDate   := inEndDate
                                                      , inUnitId    := inUnitId
                                                      , inUserId    := vbUserId
                                                       );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.07.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Defroster (inStartDate:= '01.07.2015', inEndDate:= '19.07.2015', inUnitId:= 8440, inUserId:= zfCalc_UserAdmin()) -- ���������

