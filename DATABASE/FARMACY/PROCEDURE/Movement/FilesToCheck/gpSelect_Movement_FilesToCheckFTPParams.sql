-- Function: gpSelect_Movement_FilesToCheckFTPParams(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_FilesToCheckFTPParams(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_FilesToCheckFTPParams(
     IN inID           Integer,
    OUT outHost        TVarChar,
    OUT outPort        Integer,
    OUT outUsername    TVarChar,
    OUT outPassword    TVarChar,
    OUT outDir         TVarChar,
    OUT outFileNameFTP TVarChar,
    OUT outFileName    TVarChar,
     IN inSession      TVarChar       -- ������ ������������
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
        RAISE EXCEPTION '������. ��������� ����� ����� ������ ����� ���������� ���������.';
    END IF;

    outHost := 'ftp.neboley.dp.ua';
    outPort := 13021;
    outUsername := 'instruction';
    outPassword := 'lhu1xHqoi21I2qsG';
    outDir := '';
    outFileNameFTP := 'FilesToCheck_'||inID::Integer;
    outFileName := COALESCE((SELECT MovementString_FileName.ValueData 
                             FROM MovementString AS MovementString_FileName
                             WHERE MovementString_FileName.MovementId = inID
                               AND MovementString_FileName.DescId = zc_MovementString_FileName()
), '');
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.22                                                       *

*/

-- ����
-- SELECT * FROM gpSelect_Movement_FilesToCheckFTPParams(26734892, '3')