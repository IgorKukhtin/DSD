-- Function: gpGet_GoodsRemains_FileName(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_GoodsRemains_FileName (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GoodsRemains_FileName(
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
     SELECT ('GoodsRemains_' || CURRENT_DATE) AS outFileName
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
 31.07.20         *
*/


-- ����
-- SELECT * FROM gpGet_GoodsRemains_FileName (inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
