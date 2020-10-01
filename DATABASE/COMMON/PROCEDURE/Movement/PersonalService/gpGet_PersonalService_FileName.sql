-- Function: gpGet_PersonalService_FileName(Integer, TVarChar)

--DROP FUNCTION IF EXISTS gpGet_PersonalService_FileName (TVarChar);
DROP FUNCTION IF EXISTS gpGet_PersonalService_FileName (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PersonalService_FileName(
    IN inMovementId           Integer   ,
   OUT outFileName            TVarChar  ,
   OUT outFileNamePrefix      TVarChar  ,
   OUT outDefaultFileExt      TVarChar  ,
   OUT outEncodingANSI        Boolean   ,
    IN inSession              TVarChar
)
  RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     SELECT ('PersonalService_' || CURRENT_DATE) AS outFileNamePrefix
          , Movement.Invnumber                AS outFileName
          , '.xml'                            AS outDefaultFileExt
          , TRUE                              AS outEncodingANSI
   INTO outFileNamePrefix, outFileName, outDefaultFileExt, outEncodingANSI
     FROM Movement
     WHERE Movement.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.09.20         *
*/


-- ����
-- SELECT * FROM gpGet_PersonalService_FileName (inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
