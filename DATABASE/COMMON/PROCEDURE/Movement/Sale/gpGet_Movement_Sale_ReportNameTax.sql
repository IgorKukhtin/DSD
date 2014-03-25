-- Function: gpGet_Movement_Sale_ReportNameTax()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_ReportNameTax (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_ReportNameTax (
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
            COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_Tax')
       INTO vbPrintFormName
       FROM Movement

       LEFT JOIN PrintForms_View
              ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
             AND PrintForms_View.ReportType = 'Tax'

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Sale();


     RETURN (vbPrintFormName);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale_ReportNameTax (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.02.14                                                        *
*/

-- ����
--SELECT gpGet_Movement_Sale_ReportNameTax FROM gpGet_Movement_Sale_ReportNameTax(inMovementId := 40874,  inSession := '5'); -- ���
--SELECT * FROM gpGet_Movement_Sale_ReportNameTax(inMovementId := 40869,  inSession := '5'); -- �����