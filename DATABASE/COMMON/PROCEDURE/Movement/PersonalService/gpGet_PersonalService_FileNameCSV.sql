
--DROP FUNCTION IF EXISTS gpGet_PersonalService_FileNameCSV (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_PersonalService_FileNameCSV (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PersonalService_FileNameCSV(
    IN inMovementId           Integer   ,  
    IN inParam                Integer,    -- = 1 ��� CardSecond, INN, SummCardSecondRecalc, PersonalName 
                                          -- = 2 ��� CardBankSecond, SummCardSecondRecalc
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
          , Object_PersonalServiceList.ValueData 
            ||CASE WHEN inParam = 2 THEN ' �� � �����' ELSE '' END
            ||'_'||zfCalc_MonthName(MovementDate_ServiceDate.ValueData)  
             AS outFileName
          , '.csv'                               AS outDefaultFileExt
          , TRUE                                 AS outEncodingANSI
   INTO outFileNamePrefix, outFileName, outDefaultFileExt, outEncodingANSI
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
     WHERE Movement.Id = inMovementId; 
     
     --��������� ����������� �������� CSV - � ����� �2

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.11.21         *
*/


-- ����
-- SELECT * FROM gpGet_PersonalService_FileNameCSV (21011498, 2, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()

