-- DROP FUNCTION gpInsert_ReportProtocol;

DROP FUNCTION IF EXISTS gpInsert_ReportProtocol (TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ReportProtocol (
    IN inProtocolData TBlob,
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
return;
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������� 
     PERFORM lpInsert_ReportProtocol (inUserId       := vbUserId
                                    , inProtocolData := inProtocolData
                                     );
   
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 31.05.17                                                       *
*/
