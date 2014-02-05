-- Function: gpGet_Movement_Sale_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_ReportName (
    IN inMovementId         Integer  , -- ���� ���������
    IN inSession            TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbPartnerId Integer;
   DECLARE vbPrintFormName TVarChar;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

       SELECT
            COALESCE (PrintForms_View.PrintFormName, PrintForms_View_Default.PrintFormName)
       INTO vbPrintFormName
       FROM Movement
       LEFT JOIN MovementLinkObject AS MovementLinkObject_To
              ON MovementLinkObject_To.MovementId = Movement.Id
             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

       LEFT JOIN PrintForms_View
              ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
             AND PrintForms_View.PartnerId = MovementLinkObject_To.ObjectId

       LEFT JOIN PrintForms_View AS PrintForms_View_Default
              ON Movement.OperDate BETWEEN PrintForms_View_Default.StartDate AND PrintForms_View_Default.EndDate
             AND PrintForms_View_Default.PartnerId = 0

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Sale();


     RETURN (vbPrintFormName);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale_ReportName (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.02.14                                                        *
*/

-- ����
--SELECT gpGet_Movement_Sale_ReportName FROM gpGet_Movement_Sale_ReportName(inMovementId := 40874,  inSession := '5'); -- ���
--SELECT * FROM gpGet_Movement_Sale_ReportName(inMovementId := 40869,  inSession := '5'); -- �����