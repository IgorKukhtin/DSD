-- Function: lpSetErased_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetErased_Movement (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_Movement(
    IN inMovementId        Integer  , -- ���� ������� <��������>
    IN inUserId            Integer    -- ������������
)                              
  RETURNS void
AS
$BODY$
BEGIN

  -- ������� ��� ��������
  PERFORM lpDelete_MovementItemContainer (inMovementId);

  -- ������� ��� �������� ��� ������
  PERFORM lpDelete_MovementItemReport (inMovementId);

  -- ����������� ������ ������ ���������
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() WHERE Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSetErased_Movement (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.10.13                                        * add inUserId
 01.09.13                                        * add lpDelete_MovementItemReport
*/

-- ����
-- SELECT * FROM lpSetErased_Movement (inMovementId:= 55, inSession:= '2')
