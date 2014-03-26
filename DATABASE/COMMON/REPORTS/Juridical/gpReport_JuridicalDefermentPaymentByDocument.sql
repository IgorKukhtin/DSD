-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPaymentByDocument (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPaymentByDocument(
    IN inOperDate         TDateTime , -- 
    IN inContractDate     TDateTime , -- 
    IN inJuridicalId      INTEGER   ,
    IN inPeriodCount      Integer   , --
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, OperDate TDateTime, InvNumber TVarChar, TotalSumm TFloat, FromName TVarChar, ToName TVarChar)
AS
$BODY$
   DECLARE vbLenght Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- �������� ������� �� ���� �� ��. ����� � ������� ���������. 
     -- ��� �� �������� ������� � �������� �� ������ 
  vbLenght := 7;

  RETURN QUERY  
    SELECT 
            Movement.Id
          , Movement.OperDate
          , Movement.InvNumber
          , Movement.TotalSumm::TFloat
          , Object_From.ValueData AS FromName
          , Object_To.ValueData   AS ToName
     FROM 
        (SELECT 
              Movement.Id
            , Movement.OperDate
            , Movement.InvNumber
            , MovementFloat_TotalSumm.ValueData  AS TotalSumm
            , MovementLinkObject_From.ObjectId as FromId 
            , MovementLinkObject_To.ObjectId as ToId 
         FROM Movement 
              JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
              JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        WHERE Movement.DescId = zc_Movement_Sale()
          AND Movement.StatusId = zc_enum_status_complete()
          AND Movement.OperDate > (inContractDate::date - vbLenght * inPeriodCount) 
          AND Movement.OperDate <= (inContractDate::date - vbLenght * (inPeriodCount - 1))
          AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId
        
  UNION SELECT 
              Movement.Id
            , Movement.OperDate
            , Movement.InvNumber
            , - MovementFloat_TotalSumm.ValueData  AS TotalSumm
            , MovementLinkObject_From.ObjectId as FromId 
            , MovementLinkObject_To.ObjectId as ToId 
         FROM Movement 
              JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
              JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        WHERE Movement.DescId = zc_Movement_ReturnIn()
          AND Movement.StatusId = zc_enum_status_complete()
          AND Movement.OperDate > (inContractDate::date - vbLenght * inPeriodCount) 
          AND Movement.OperDate <= (inContractDate::date - vbLenght * (inPeriodCount - 1))
          AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId) AS Movement
        LEFT JOIN Object AS Object_From 
               ON Object_From.Id = Movement.FromId
        LEFT JOIN Object AS Object_To
               ON Object_To.Id = Movement.ToId
    ORDER BY OperDate;
          
          --, zc_Movement_ReturnIn()) 
    -- �����. �������� ��������� ������. 
    -- ����� �������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalDefermentPaymentByDocument (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.02.14                          * 
*/

-- ����
-- SELECT * FROM gpReport_JuridicalDefermentPayment ('01.01.2014'::TDateTime, '01.02.2013'::TDateTime, 0, inSession:= '2'::TVarChar); 
