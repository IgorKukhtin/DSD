-- Function: gpGet_Movement_Tax_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Tax_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Tax_ReportName (
    IN inMovementId         Integer  , -- ���� ���������
    IN inSession            TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN
       -- �������� ���� ������������ �� ����� ���������
       -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());


       -- ����� �����
       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_Tax')
              INTO vbPrintFormName
       FROM (-- ����� ����
             SELECT MAX (CASE WHEN Movement.OperDate > COALESCE (MovementDate_DateRegistered.ValueData, Movement.OperDate) THEN Movement.OperDate ELSE COALESCE (MovementDate_DateRegistered.ValueData, Movement.OperDate) END) AS OperDate
             FROM Movement
                  LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                         ON MovementDate_DateRegistered.MovementId = Movement.Id
                                        AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
             WHERE Movement.Id =  inMovementId
               AND Movement.DescId = zc_Movement_Tax()
            ) AS Movement
            LEFT JOIN PrintForms_View
                   ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                  AND PrintForms_View.ReportType = 'Tax'
       ;

       -- ���������
       RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Tax_ReportName (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.03.16                                        *
 27.02.14                                                        *
 05.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Tax_ReportName (inMovementId:= 3414237 , inSession:= '5'); -- ���
