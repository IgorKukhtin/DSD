-- Function: gpInsertUpdate_MI_IncomeHouseholdInventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_IncomeHouseholdInventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_IncomeHouseholdInventory(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inHouseholdInventoryId  Integer   , -- ������������� ���������
    IN inAmount                TFloat    , -- ����������
    IN inCountForPrice         TFloat    , -- ������������� 
    IN inComment               TVarChar  , -- �����������
    IN inSession               TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeHouseholdInventory());

    --���������� ������ ���������
    SELECT MovementLinkObject_Unit.ObjectId                             AS UnitId, Movement.InvNumber
    INTO vbUnitId, vbInvNumber 
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    IF COALESCE (inAmount, 0) < 0 OR ceil(inAmount) <> inAmount
    THEN
        RAISE EXCEPTION '������.���������� ������ ���� ����� � ������ ��� ����� 0.';    
    END IF;

     -- ���������
    ioId := lpInsertUpdate_MI_IncomeHouseholdInventory (ioId                    := ioId
                                                      , inMovementId            := inMovementId
                                                      , inHouseholdInventoryId  := inHouseholdInventoryId
                                                      , inAmount                := inAmount
                                                      , inCountForPrice         := inCountForPrice
                                                      , inComment               := inComment
                                                      , inUserId                := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_IncomeHouseholdInventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 30.07.20                                                                      *
 09.07.20                                                                      *
*/

-- ����
-- select * from gpInsertUpdate_MI_IncomeHouseholdInventory(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');
