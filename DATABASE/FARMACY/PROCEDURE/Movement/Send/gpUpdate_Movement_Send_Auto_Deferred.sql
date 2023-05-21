-- Function: gpInsertUpdate_MovementItem_Send_Auto()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_Auto_Deferred (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_Auto_Deferred(
    IN inFromId              Integer   , -- �� ����
    IN inOperDate            TDateTime , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS  
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE text_var1   Text;   
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;

      -- ���� �� ��������� (���� - ����, �� ����, ����, ������ �������������)
    FOR vbMovementId IN
      SELECT Movement.Id  
      FROM Movement
        Inner JOIN MovementBoolean AS MovementBoolean_isAuto
                                   ON MovementBoolean_isAuto.MovementId = Movement.Id
                                  AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                  AND COALESCE(MovementBoolean_isAuto.ValueData, False) = True
 
        Inner Join MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.ID
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                     AND MovementLinkObject_From.ObjectId = inFromId

        Left JOIN MovementBoolean AS MovementBoolean_SUN
                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
        Left JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

      WHERE Movement.DescId = zc_Movement_Send() 
          AND Movement.OperDate = inOperDate
          AND Movement.StatusId = zc_Enum_Status_UnComplete()
          AND COALESCE(MovementBoolean_SUN.ValueData, False) = False
          AND COALESCE (MovementBoolean_Deferred.ValueData, False) = False
    LOOP
    
       BEGIN
         PERFORM gpUpdate_Movement_Send_Deferred(Integer, vbMovementId, inSession);
       EXCEPTION
          WHEN others THEN
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       END;
    
    END LOOP;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.06.16         *
*/

-- ����
-- 
select * from gpUpdate_Movement_Send_Auto_Deferred(inFromId := 183292 , inOperDate := CURRENT_DATE,  inSession := '3');
