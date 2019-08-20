-- Function: gpUpdate_Movement_Send_isSUN()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_isSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_isSUN(
    IN inMovementId     Integer   ,    -- ���� ���������
    IN inisSUN          Boolean   ,    -- 
   OUT outisSUN         Boolean   ,
    IN inSession        TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisDefSUN Boolean;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   -- �������� ����
   --vbUserId := lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Send_IsSUN());

   -- ��������� ���������
   SELECT COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) isDefSUN
   INTO vbisDefSUN
   FROM MovementBoolean AS MovementBoolean_DefSUN
   WHERE MovementBoolean_DefSUN.MovementId = inMovementId
     AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN();

   -- ��������������
   outisSUN := not inisSUN;
   
   -- �������� ���� ��� ����������� ����� isDefSUN
   IF outisSUN = TRUE AND vbisDefSUN = TRUE
   THEN
       outisSUN := inisSUN;
       RAISE EXCEPTION '������. ��� ����������� �������� ��������� ����������� �� ���.';
   END IF;

   -- ��������� �������
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(), inMovementId, outisSUN);
   
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