-- Function: gpComplete_Movement_PromoBonus()

DROP FUNCTION IF EXISTS gpComplete_Movement_PromoBonus  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PromoBonus(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Complete_PromoBonus());
  vbUserId := inSession;
    
--  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
--  THEN
--    RAISE EXCEPTION '����������� �������� ��� ���������, ���������� � ���������� ��������������';
--  END IF;

  -- ����������� �������� �����
  PERFORM lpInsertUpdate_PromoBonus_TotalSumm (inMovementId);
  
  -- ���������� ��������
  PERFORM lpComplete_Movement_PromoBonus(inMovementId, -- ���� ���������
                                                    vbUserId);    -- ������������ 
                         
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.02.21                                                       * 
 */

-- ����
-- SELECT * FROM gpComplete_Movement_PromoBonus (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')