
--DROP FUNCTION IF EXISTS gpGet_PersonalService_FileNameCSV (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_PersonalService_FileNameCSV (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PersonalService_FileNameCSV(
    IN inMovementId           Integer   ,  
    IN inParam                Integer,    -- = 1 ��� 4CardSecond, INN, SummCardSecondRecalc, PersonalName 
                                          --CSV  = 2 ��� CardBankSecond, SummCardSecondRecalc
                                          --XLS  = 3 ��� CardBankSecond, SummCardSecondRecalc
                                          --XLS  = 4 ��� ������������� �� ����������
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
            ||CASE WHEN inParam = 2 OR inParam = 3 THEN ' �� � �����'
                   WHEN inParam = 4 THEN ' ������������� �� ������ �2'
                   ELSE '' END
            ||'_'||zfCalc_MonthName(MovementDate_ServiceDate.ValueData)  
             ::TVarChar AS outFileName

          , CASE WHEN inParam IN (3,4) THEN '.xls' ELSE '.csv' END ::TVarChar  AS outDefaultFileExt

          , CASE WHEN inParam IN (3,4) THEN FALSE ELSE TRUE END    ::Boolean   AS outEncodingANSI
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
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.03.24         *
 08.02.24         *
 17.11.21         *
*/


-- ����
-- SELECT * FROM gpGet_PersonalService_FileNameCSV (21011498, 2, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()

