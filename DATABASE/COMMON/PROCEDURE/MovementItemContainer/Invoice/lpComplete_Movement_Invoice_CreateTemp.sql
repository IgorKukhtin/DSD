-- Function: lpComplete_Movement_Invoice_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_Invoice_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_Invoice_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.16         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Invoice_CreateTemp ()
