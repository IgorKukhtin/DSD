-- Function: gpSelect_LoadFReportFTPParams_cash(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_LoadFReportFTPParams_cash(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_LoadFReportFTPParams_cash(
    OUT outHost TVarChar,
    OUT outPort Integer,
    OUT outUsername TVarChar,
    OUT outPassword TVarChar,
    OUT outDaysStorage Integer,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS RECORD 
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

    outHost := '31.193.90.212';
    outPort := 13222;
    outUsername := 'zreport';
    outPassword := 'ZAaYuMuDg3bv9ZHF';
    outDaysStorage := 31;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.12.18                                                       *              

*/

-- ����
-- SELECT * FROM gpSelect_LoadFReportFTPParams_cash('3')