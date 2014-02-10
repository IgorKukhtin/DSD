-- Function: gpGet_Movement_TaxCorrective_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_TaxCorrective_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_TaxCorrective_ReportName (
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
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_TaxCorrective());

       SELECT
            COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_TaxCorrective')
       INTO vbPrintFormName
       FROM Movement

       LEFT JOIN PrintForms_View
              ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
             AND PrintForms_View.ReportType = 'TaxCorrective'

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_TaxCorrective();


     RETURN (vbPrintFormName);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TaxCorrective_ReportName (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.02.14                                                        *
*/

-- ����
--SELECT gpGet_Movement_TaxCorrective_ReportName FROM gpGet_Movement_TaxCorrective_ReportName(inMovementId := 40874,  inSession := '5'); -- ���
