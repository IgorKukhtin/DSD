-- Function: gpMovement_UnnamedEnterprisesExactly_AddOrderInternal()

DROP FUNCTION IF EXISTS gpMovement_UnnamedEnterprisesExactly_AddOrderInternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovement_UnnamedEnterprisesExactly_AddOrderInternal(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;

BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
    vbUserId:= inSession;

  RAISE EXCEPTION '������. � ����������';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovement_UnnamedEnterprisesExactly_AddOrderInternal (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������ �.�.
 07.11.18        *
*/

-- SELECT * FROM gpMovement_UnnamedEnterprisesExactly_AddOrderInternal (inMovementId := 10582535, inSession:= '5');