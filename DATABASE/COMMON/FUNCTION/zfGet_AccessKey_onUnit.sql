-- Function: zfGet_AccessKey_onUnit

DROP FUNCTION IF EXISTS zfGet_AccessKey_onUnit (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfGet_AccessKey_onUnit (inUnitId Integer, inProcessId Integer, inUserId Integer)
RETURNS Integer
AS
$BODY$
 DECLARE vbAccessKeyId Integer;
BEGIN
     vbAccessKeyId:= CASE WHEN inUnitId IN (8411   -- ����� �� � ����
                                          , 428365 -- ����� ��������� �.����
                                           )
                              THEN zc_Enum_Process_AccessKey_DocumentKiev()

                          WHEN inUnitId IN (346093 -- ����� �� �.������
                                          , 346094 -- ����� ��������� �.������
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa()

                          WHEN inUnitId IN (8413   -- ����� �� �.������ ���
                                          , 428366 -- ����� ��������� �.������ ���
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog()

                          WHEN inUnitId IN (8417   -- ����� �� �.�������� (������)
                                          , 428364 -- ����� ��������� �.�������� (������)
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev()

                          WHEN inUnitId IN (8425   -- ����� �� �.�������
                                          , 409007 -- ����� ��������� �.�������
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov()

                          WHEN inUnitId IN (8415   -- ����� �� �.�������� (����������)
                                          , 428363 -- ����� ��������� �.�������� (����������)
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi()

                          WHEN inUnitId IN (301309 -- ����� �� �.���������
                                          , 309599 -- ����� ��������� �.���������
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye()

                          WHEN inUnitId IN (3080691 -- ����� �� �.�����
                                          , 3080696 -- ����� ��������� �.�����
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentLviv()

                          WHEN inUnitId IN (11921035 -- ����� �� �.³�����
                                          , 11921036 -- ����� ��������� �.³�����
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentVinnica()

                          WHEN inUnitId IN (8020714 -- ����� ���� �� (����)
                                          , 8020715 -- ����� ��������� (����)
                                           )
                               THEN zc_Enum_Process_AccessKey_DocumentIrna()

                          ELSE lpGetAccessKey (inUserId, inProcessId)

                     END;
     --
     RETURN (vbAccessKeyId);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.03.2025                                      *
*/

-- ����
-- SELECT zfGet_AccessKey_onUnit (346093, 5, zc_Enum_Process_InsertUpdate_Movement_Loss()) -- ����� �� �.������
