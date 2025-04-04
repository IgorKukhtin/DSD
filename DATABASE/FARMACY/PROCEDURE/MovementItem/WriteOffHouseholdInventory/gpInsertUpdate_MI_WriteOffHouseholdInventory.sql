-- Function: gpInsertUpdate_MI_WriteOffHouseholdInventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_WriteOffHouseholdInventory (Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_WriteOffHouseholdInventory(
 INOUT ioId                           Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                   Integer   , -- ���� ������� <��������>
    IN inPartionHouseholdInventoryId  Integer   , -- ������ �������������� ���������
    IN inAmount                       TFloat    , -- ����������
    IN inComment                      TVarChar  , -- �����������
    IN inSession                      TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WriteOffHouseholdInventory());
    
    IF COALESCE (inAmount, 0) <> 1
    THEN
        RAISE EXCEPTION '������.���������� ������ ���� 1.';    
    END IF;

    --���������� ������ ���������
    SELECT MovementLinkObject_Unit.ObjectId                             AS UnitId, Movement.InvNumber
    INTO vbUnitId, vbInvNumber 
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;


     -- ���������
    ioId := lpInsertUpdate_MI_WriteOffHouseholdInventory (ioId                           := ioId
                                                        , inMovementId                   := inMovementId
                                                        , inPartionHouseholdInventoryId  := inPartionHouseholdInventoryId
                                                        , inAmount                       := inAmount
                                                        , inComment                      := inComment
                                                        , inUserId                       := vbUserId
                                                         );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_WriteOffHouseholdInventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 09.07.20                                                                      *
*/

-- ����
-- select * from gpInsertUpdate_MI_WriteOffHouseholdInventory(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');
