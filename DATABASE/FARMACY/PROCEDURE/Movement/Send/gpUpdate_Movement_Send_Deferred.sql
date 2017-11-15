-- Function: gpUpdate_Movement_Send_Deferred()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_Deferred(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_Deferred(
    IN inMovementId          Integer   ,    -- ���� ���������
    IN inisDeferred          Boolean   ,    -- �������
   OUT outisDeferred         Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

   -- ���������� �������
   outisDeferred:=  inisDeferred;
   -- ��������� �������
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, outisDeferred);


   IF inisDeferred = TRUE
   THEN
       -- ���������� ��������
       PERFORM lpComplete_Movement_Send(inMovementId  -- ���� ���������
                                      , vbUserId);    -- ������������  
   ELSE
       -- ������� ��������
       PERFORM lpUnComplete_Movement (inMovementId
                                    , vbUserId);
   END IF;

   
   -- ���������� ������ ���������
   -- UPDATE Movement SET StatusId = vbStatusId WHERE Id = inMovementId;
   
   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 08.11.17         *
*/