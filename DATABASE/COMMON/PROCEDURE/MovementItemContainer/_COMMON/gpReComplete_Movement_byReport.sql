-- Function: gpReComplete_Movement_byReport()

DROP FUNCTION IF EXISTS gpReComplete_Movement_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_byReport(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar               -- ������ ������������
)
  RETURNS void AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_());
     vbUserId:= lpGetUserBySession (inSession);
     
     IF vbUserId <> 5
     THEN
         RAISE EXCEPTION '������.��� ����.';
     END IF;
     
     
     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ������.';
     END IF;
     

     PERFORM gpComplete_All_Sybase (inMovementId, FALSE, inSession);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 17.12.24
*/
