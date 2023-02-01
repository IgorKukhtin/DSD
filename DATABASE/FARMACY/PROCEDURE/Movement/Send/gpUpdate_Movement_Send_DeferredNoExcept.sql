-- Function: gpUpdate_Movement_Send_DeferredNoExcept()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_DeferredNoExcept(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_DeferredNoExcept(
    IN inMovementId          Integer   ,    -- ���� ���������
    IN inisDeferred          Boolean   ,    -- �������
   OUT outisDeferred         Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 Text;
BEGIN

   vbUserId := lpGetUserBySession (inSession);
   
   outisDeferred := inisDeferred;

    BEGIN
      outisDeferred := gpUpdate_Movement_Send_Deferred(inMovementId, inisDeferred, inSession);
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       outisDeferred := NOT inisDeferred;
    END;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 31.01.23                                                      *
*/