-- �������� �����

DROP FUNCTION IF EXISTS gpUpdate_Object_Brand_ReportOLAP (Integer, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Brand_ReportOLAP(
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
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Brand());
   vbUserId:= lpGetUserBySession (inSession);


   -- ������� �� ��-���
   vbReportOLAPId := lpInsertFind_Object_ReportOLAP (inCode     := 1
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
30.04.18                                         *
*/
