-- Function: gpGet_Movement_Quality_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Quality_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Quality_ReportName (
    IN inMovementId         Integer  , -- ���� ���������
    IN inSession            TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Quality());

       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_Quality')
              INTO vbPrintFormName
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     
            LEFT JOIN PrintForms_View
                   ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                  AND PrintForms_View.JuridicalId = CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementLinkObject_To.ObjectId ELSE ObjectLink_Partner_Juridical.ChildObjectId END
                  AND PrintForms_View.ReportType = 'Quality'
                  AND PrintForms_View.DescId = zc_Movement_Sale()

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Sale();

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.22.18         *
*/

-- ����
--SELECT * FROM gpGet_Movement_Quality_ReportName(inMovementId := 35168,  inSession := '5'); -- ���
