-- Function: gpUpdate_Movement_Pretension_Deferred()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Pretension_Deferred(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Pretension_Deferred(
    IN inMovementId          Integer   ,    -- ���� ���������
    IN inisDeferred          Boolean   ,    -- �������
   OUT outisDeferred         Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisDeferred Boolean;
BEGIN

   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

    -- ��������� ���������
    SELECT
        Movement.StatusId,
        COALESCE (MovementBoolean_Deferred.ValueData, FALSE)
    INTO
        vbStatusId,
        vbisDeferred
    FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement.Id = inMovementId;
   
   -- �������� ������ � �� ����������� ����������
   IF COALESCE (vbStatusId, 0) = zc_Enum_Status_UnComplete()
   THEN
       -- ���������� �������
       outisDeferred:=  inisDeferred;
       -- ��������� �������
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, outisDeferred);
    
       IF inisDeferred = TRUE
       THEN
           IF EXISTS(SELECT 1
                     FROM MovementLinkMovement 
                          INNER JOIN Movement ON Movement.Id =  MovementLinkMovement.MovementId
                                             AND Movement.StatusId <> zc_Enum_Status_Erased() 
                     WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Pretension()
                       AND MovementLinkMovement.MovementChildId = inMovementId)
           THEN
             RAISE EXCEPTION '������� ���������. ������ ������� ����������.';       
           END IF;
           
                      -- ���������� ��������
           PERFORM lpComplete_Movement_Pretension(inMovementId  -- ���� ���������
                                               , vbUserId);    -- ������������  
       ELSE
           -- ������� ��������
           PERFORM lpUnComplete_Movement (inMovementId
                                        , vbUserId);
       END IF;
   ELSE 
       RAISE EXCEPTION '������.��������� �������� ������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);   
   END IF;
   
   outisDeferred := COALESCE (outisDeferred, COALESCE (vbisDeferred, FALSE));
   
   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.21                                                       *
*/

-- select * from gpUpdate_Movement_Pretension_Deferred(inMovementId := 26087688 , inisDeferred := 'True' ,  inSession := '3');