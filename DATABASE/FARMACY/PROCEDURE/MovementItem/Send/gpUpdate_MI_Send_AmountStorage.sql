-- Function: gpUpdate_MI_Send_AmountStorage()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_AmountStorage (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_AmountStorage(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount     Integer;
   DECLARE vbStatusId    Integer;
   DECLARE vbisDeferred  Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession;
     
     SELECT Movement.StatusId
          , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)   ::Boolean AS isDeferred
     INTO vbStatusId, vbisDeferred
     FROM Movement

          LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                    ON MovementBoolean_Deferred.MovementId = Movement.Id
                                   AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

     WHERE Movement.Id = inMovementId;     
     
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
     THEN
        RAISE EXCEPTION '������. ��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
     END IF;


     IF vbisDeferred = TRUE
     THEN
        RAISE EXCEPTION '������. ��������� ���������� ��������� �� ��������.';
     END IF;
             
     -- ���������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountStorage(), MovementItem.id, MovementItem.amount)
     FROM MovementItem 
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.Amount > 0
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.isErased = False;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
  08.03.22                                                      *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_Send_AmountStorage (inMovementId:= 0, inUserId:= 2)