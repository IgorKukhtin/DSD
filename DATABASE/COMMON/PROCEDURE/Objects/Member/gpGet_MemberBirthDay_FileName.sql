
DROP FUNCTION IF EXISTS gpGet_MemberBirthDay_FileName (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MemberBirthDay_FileName(
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
     SELECT 
            '' ::TVarChar AS outFileNamePrefix

          , ('������_����������_'
           ||(zfConvert_DateToString (CURRENT_TIMESTAMP)
           || ' ' || CASE WHEN EXTRACT (HOUR   FROM CURRENT_TIMESTAMP) < 10 THEN '0' ELSE '' END || EXTRACT (HOUR   FROM CURRENT_TIMESTAMP) :: TVarChar
           || '_' || CASE WHEN EXTRACT (MINUTE FROM CURRENT_TIMESTAMP) < 10 THEN '0' ELSE '' END || EXTRACT (MINUTE FROM CURRENT_TIMESTAMP) :: TVarChar
              ))      ::TVarChar  AS outFileName

          ,  '.xls'  ::TVarChar AS outDefaultFileExt

          ,  FALSE     ::Boolean   AS outEncodingANSI
   INTO outFileNamePrefix, outFileName, outDefaultFileExt, outEncodingANSI
     ; 
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.08.25         *
*/


-- ����
-- SELECT * FROM gpGet_MemberBirthDay_FileName (inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()

