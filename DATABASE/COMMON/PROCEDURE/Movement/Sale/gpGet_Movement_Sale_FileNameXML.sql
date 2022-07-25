-- Function: gpGet_Movement_Sale_FileNameXML(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_FileNameXML (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_FileNameXML(
   OUT outFileName            TVarChar  ,
   OUT outDefaultFileExt      TVarChar  ,
   OUT outEncodingANSI        Boolean   ,
    IN inMovementId           Integer   ,
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
     SELECT '������� ���������� '
            || '_' || REPLACE (zfConvert_DateShortToString (Movement.OperDate), '.', '')
            || '_' || Movement.InvNumber  AS outFileName
          , 'xml'                         AS outDefaultFileExt
          , TRUE                         AS outEncodingANSI
   INTO outFileName, outDefaultFileExt, outEncodingANSI
     FROM Movement
     WHERE Movement.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.07.22         *
*/


-- ����
-- SELECT * FROM gpGet_Movement_Sale_FileNameXML (inMovementId:= 14022564, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
