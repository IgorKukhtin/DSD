-- Function: gpUpdate_Movement_Send_isDefSUN()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_isDefSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_isDefSUN(
    IN inMovementId     Integer   ,    -- ���� ���������
    IN inisDefSUN       Boolean   ,    -- 
   OUT outisDefSUN      Boolean   ,
    IN inSession        TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisSUN Boolean;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   -- �������� ����
   --vbUserId := lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Send_IsDefSUN());
   
      -- ��������� ���������
   SELECT COALESCE (MovementBoolean_SUN.ValueData, FALSE) AS isSUN
   INTO vbisSUN
   FROM MovementBoolean AS MovementBoolean_SUN
   WHERE MovementBoolean_SUN.MovementId = inMovementId
     AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN();

   -- ��������������
   outisDefSUN := not inisDefSUN;
   
   -- �������� ���� ��� ����������� ����� isDefSUN
   IF outisDefSUN = TRUE AND vbisSUN = TRUE
   THEN
       outisDefSUN := inisDefSUN;
       RAISE EXCEPTION '������. ��� ����������� �������� ����������� �� ���.';
   END IF;

   -- ��������� �������
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DefSUN(), inMovementId, outisDefSUN);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.19         *
*/