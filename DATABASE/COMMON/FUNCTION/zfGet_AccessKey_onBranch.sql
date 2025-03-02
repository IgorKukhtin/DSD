-- Function: zfGet_AccessKey_onBranch

DROP FUNCTION IF EXISTS zfGet_AccessKey_onBranch (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfGet_AccessKey_onBranch (inBranchId Integer, inProcessId Integer, inUserId Integer)
RETURNS Integer
AS
$BODY$
 DECLARE vbAccessKeyId Integer;
BEGIN
     vbAccessKeyId:= CASE WHEN inBranchId IN (8379 -- ������ ����
                                             )
                              THEN zc_Enum_Process_AccessKey_DocumentKiev()

                          WHEN inBranchId IN (8374     -- ������ ������
                                             )
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa()

                          WHEN inBranchId IN (8377 -- ������ ��.���
                                             )
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog()

                          WHEN inBranchId IN (8373 -- ������ �������� (������)
                                             )
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev()

                          WHEN inBranchId IN (8381 -- ������ �������
                                             )
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov()

                          WHEN inBranchId IN (8375 -- ������ ��������
                                             )
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi()

                          WHEN inBranchId IN (301310 -- ������ ���������
                                             )
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye()

                          WHEN inBranchId IN (3080683 -- ������ �����
                                             )
                               THEN zc_Enum_Process_AccessKey_DocumentLviv()

                          WHEN inBranchId IN (11920989 -- ������ �������
                                             )
                               THEN zc_Enum_Process_AccessKey_DocumentVinnica()

                          WHEN inBranchId IN (8109544 -- ������ ����
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
-- SELECT zfGet_AccessKey_onBranch (3080683, 5, zc_Enum_Process_InsertUpdate_Movement_Tax()) -- ����� �� �.�����
