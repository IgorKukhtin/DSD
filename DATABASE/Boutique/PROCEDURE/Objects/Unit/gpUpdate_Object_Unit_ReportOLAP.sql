-- �������������

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_ReportOLAP (Integer, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_ReportOLAP(
    IN inId           Integer,
    IN inIsReportOLAP Boolean, 
    IN inSession      TVarChar
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbReportOLAPId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);


   -- ������� �� ��-���
   vbReportOLAPId := lpInsertFind_Object_ReportOLAP (inCode     := zc_ReportOLAP_Unit()
                                                   , inObjectId := inId
                                                   , inUserId   := vbUserId
                                                    );
   -- �������� ��� vbReportOLAPId
   PERFORM lpUpdate_Object_isErased (inObjectId:= vbReportOLAPId, inIsErased:= NOT inIsReportOLAP, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
27.07.18          *
*/
