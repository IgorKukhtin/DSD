-- Function: gpGet_StoredProcCheck()

DROP FUNCTION IF EXISTS gpGet_StoredProcCheck (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_StoredProcCheck(
    IN inStoredProc   TVarChar , -- �������� ���������
    IN inParam1       TVarChar , -- �������� ���������
    IN inValue1       TVarChar , -- ��������
    IN inParam2       TVarChar , -- �������� ���������
    IN inValue2       TVarChar , -- ��������
    IN inParam3       TVarChar , -- �������� ���������
    IN inValue3       TVarChar , -- ��������
    IN inParam4       TVarChar , -- �������� ���������
    IN inValue4       TVarChar , -- ��������
    IN inParam5       TVarChar , -- �������� ���������
    IN inValue5       TVarChar , -- ��������
    IN inParam6       TVarChar , -- �������� ���������
    IN inValue6       TVarChar , -- ��������
    IN inParam7       TVarChar , -- �������� ���������
    IN inValue7       TVarChar , -- ��������
    IN inParam8       TVarChar , -- �������� ���������
    IN inValue8       TVarChar , -- ��������
    IN inParam9       TVarChar , -- �������� ���������
    IN inValue9       TVarChar , -- ��������
    IN inParam10      TVarChar , -- �������� ���������
    IN inValue10      TVarChar , -- ��������
    IN inSession      TVarChar   -- ������ ������������
)
RETURNS BOOLEAN
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpGetUserBySession (inSession);
      
      RETURN False;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
  18.08.23                                                      *
*/

-- ����
-- 
SELECT * FROM gpGet_StoredProcCheck (inStoredProc := 'gpSelect_Movement_Income', inParam1 := 'inStartDate', inValue1 := '25.07.2023', inParam2 := 'inEndDate', inValue2 := '25.07.2023', inParam3 := 'inIsErased', inValue3 := 'False', inParam4 := 'inJuridicalBasisId', inValue4 := '9399', inParam5 := '', inValue5 := '', inParam6 := '', inValue6 := '', inParam7 := '', inValue7 := '', inParam8 := '', inValue8 := '', inParam9 := '', inValue9 := '', inParam10 := '', inValue10 := '', inSession:= zfCalc_UserAdmin())
