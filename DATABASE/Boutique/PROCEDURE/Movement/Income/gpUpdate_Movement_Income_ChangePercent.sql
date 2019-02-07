-- Function: gpUpdate_Movement_Income_ChangePercent()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_ChangePercent (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_ChangePercent(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inChangePercent         TFloat    , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());


     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;

     -- ��������� �������� <% ���. ������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inMovementId, inChangePercent);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.02.19         *
*/

-- ����
-- 