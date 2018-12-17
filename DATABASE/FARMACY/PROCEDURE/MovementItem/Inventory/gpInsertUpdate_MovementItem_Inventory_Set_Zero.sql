-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_Set_Zero (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_Set_Zero(
    IN inMovementId          Integer   , -- ���� ������� <�������� ��������������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
	 
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
           vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;

        SELECT MLO_Unit.ObjectId
        INTO vbUnitId
        FROM  Movement
              INNER JOIN MovementLinkObject AS MLO_Unit
                                            ON MLO_Unit.MovementId = Movement.Id
                                           AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
        WHERE Movement.Id = inMovementId;

        IF COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN
           RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
     END IF;     

    -- ���������� �����
    PERFORM lpInsertUpdate_MI_Inventory_Child(inId                 := 0
                                            , inMovementId         := inMovementId
                                            , inParentId           := MovementItem.Id
                                            , inAmountUser         := 0::TFloat
                                            , inUserId             := vbUserId
                                              )
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.Amount <> 0
       AND MovementItem.isErased = FALSE;

    -- �������� ��� �������
    PERFORM lpInsertUpdate_MovementItem_Inventory (ioId                 := MovementItem.Id
                                                 , inMovementId         := MovementItem.MovementId
                                                 , inGoodsId            := MovementItem.ObjectId
                                                 , inAmount             := 0::TFloat
                                                 , inPrice              := COALESCE(MovementItemFloat_Price.ValueData,0)
                                                 , inSumm               := 0::TFloat
                                                 , inComment            := NULL::TVarChar
                                                 , inUserId             := vbUserId)
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price() 
    WHERE
        MovementItem.MovementId = inMovementId
        AND
        MovementItem.DescId = zc_MI_Master()
        AND
        MovementItem.Amount <> 0;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Inventory_Set_Zero (Integer, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.   ������ �.�.
  17.12.18                                                                                  *
  05.01.17        *
  03.08.15                                                                    *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_Set_Zero inMovementId:= 0, inSession:= '2')
