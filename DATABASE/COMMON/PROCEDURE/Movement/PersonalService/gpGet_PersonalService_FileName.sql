-- Function: gpGet_PersonalService_FileName(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_PersonalService_FileName (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PersonalService_FileName(
   OUT outFileName            TVarChar  ,
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
     SELECT ('PersonalService_Child_' || CURRENT_DATE) AS outFileName
          , 'xml'                             AS outDefaultFileExt
          , TRUE                              AS outEncodingANSI
   INTO outFileName, outDefaultFileExt, outEncodingANSI
     ;

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
