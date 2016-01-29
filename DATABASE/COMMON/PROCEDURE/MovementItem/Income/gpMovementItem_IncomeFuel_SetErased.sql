-- Function: gpMovementItem_IncomeFuel_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_IncomeFuel_SetErased (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpMovementItem_IncomeFuel_SetErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������

   OUT outStartOdometre_calc TFloat    , --
   OUT outEndOdometre_calc   TFloat    , --
   OUT outDistanceDiff       TFloat    , --

    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS record
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbDistance Tfloat;
BEGIN
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_MI_IncomeFuel());

  -- ������������� ����� ��������
  outIsErased := TRUE;

  -- ����������� ������
  UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete() AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

 
     -- ������������� ��� ���� MovementItem
     SELECT SUM (COALESCE (MIFloat_EndOdometre.ValueData, 0) - COALESCE (MIFloat_StartOdometre.ValueData, 0))      -- ������ ���� ,��
          , MIN (COALESCE (MIFloat_StartOdometre.ValueData, 0)), MAX (COALESCE (MIFloat_EndOdometre.ValueData, 0)) -- ���. � ���. ��������� ����������
            INTO vbDistance, outStartOdometre_calc, outEndOdometre_calc 
     FROM MovementItem 
            LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                        ON MIFloat_StartOdometre.MovementItemId = MovementItem.Id
                                       AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
            LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                        ON MIFloat_EndOdometre.MovementItemId = MovementItem.Id
                                       AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()
     WHERE MovementItem.MovementId = vbMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = False;
     -- ����������
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovementFloat_Distance(), vbMovementId, vbDistance);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovementFloat_StartOdometre(), vbMovementId, outStartOdometre_calc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovementFloat_EndOdometre(), vbMovementId, outEndOdometre_calc);

     -- ������������ ������ ����, �� - ��� ���� MovementItem
     outDistanceDiff:= outEndOdometre_calc - outStartOdometre_calc;


  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

  -- !!! �� ������� - ������ ���� ���������� ��������!!!
  -- outIsErased := FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 29.01.16        *

*/

-- ����
-- SELECT * FROM gpMovementItem_IncomeFuel_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
