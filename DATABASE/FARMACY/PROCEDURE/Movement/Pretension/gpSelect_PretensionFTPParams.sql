-- Function: gpSelect_PretensionFTPParams(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_PretensionFTPParams(TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PretensionFTPParams(
     IN inInvNumber TVarChar,
    OUT outHost TVarChar,
    OUT outPort Integer,
    OUT outUsername TVarChar,
    OUT outPassword TVarChar,
    OUT outDir TVarChar,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS RECORD 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());
    vbUserId:= lpGetUserBySession (inSession);


    outHost := 'ftp.neboley.dp.ua';
    outPort := 12021;
    outUsername := 'vozvrat';
    outPassword := 'ae3hux4oPheiMaib';
    outDir := '/'||repeat('0', 10 - LengTh(TRIM(inInvNumber)))||TRIM(inInvNumber);
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.12.21                                                       *              

*/

-- ����
-- SELECT * FROM gpSelect_PretensionFTPParams('5', '3')