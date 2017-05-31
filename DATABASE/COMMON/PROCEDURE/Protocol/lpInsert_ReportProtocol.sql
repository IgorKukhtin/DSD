-- DROP FUNCTION lpInsert_ReportProtocol;

DROP FUNCTION IF EXISTS lpInsert_ReportProtocol (Integer, TBlob);

CREATE OR REPLACE FUNCTION lpInsert_ReportProtocol (
    IN inUserId       Integer,
    IN inProtocolData TBlob
)
RETURNS VOID
AS
$BODY$
BEGIN
 
      -- ���������
      INSERT INTO ReportProtocol (UserId, OperDate, ProtocolData)
      VALUES (inUserId, CURRENT_TIMESTAMP, inProtocolData);
   
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 31.05.17                                                       *
*/
