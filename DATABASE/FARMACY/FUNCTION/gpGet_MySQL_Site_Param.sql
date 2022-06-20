-- Function: gpGet_MySQL_Site_Param()

DROP FUNCTION IF EXISTS gpGet_MySQL_Site_Param (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MySQL_Site_Param(
    OUT outHost TVarChar,
    OUT outPort Integer,
    OUT outDataBase TVarChar,
    OUT outUsername TVarChar,
    OUT outPassword TVarChar,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());
    vbUserId := inSession;
    
    outHost := '172.17.2.13';
    outPort := 3306;
    outDataBase := 'neboley';
    outUsername := 'neboley';
    outPassword := 'H4i7Lohx';
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.09.21                                                       *  
*/

-- ����
-- 
SELECT * FROM gpGet_MySQL_Site_Param (inSession:= '3')

