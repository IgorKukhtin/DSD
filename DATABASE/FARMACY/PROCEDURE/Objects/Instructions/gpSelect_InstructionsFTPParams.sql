-- Function: gpSelect_InstructionsFTPParams(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_InstructionsFTPParams(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_InstructionsFTPParams(
     IN inID           Integer,
    OUT outHost        TVarChar,
    OUT outPort        Integer,
    OUT outUsername    TVarChar,
    OUT outPassword    TVarChar,
    OUT outDir         TVarChar,
    OUT outFileNameFTP TVarChar,
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS RECORD 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

    IF COALESCE (inID, 0) = 0
    THEN
        RAISE EXCEPTION '������. ��������� ����� ����� ������ ����� ���������� ����������.';
    END IF;

    outHost := 'ftp.neboley.dp.ua';
    outPort := 13021;
    outUsername := 'education';
    outPassword := 'qG2BwS4M';
    outDir := 'Instructions';
    outFileNameFTP := 'Instruction_'||inID::Integer;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.02.21                                                       *              

*/

-- ����
-- SELECT * FROM gpSelect_InstructionsFTPParams(0133, '3')