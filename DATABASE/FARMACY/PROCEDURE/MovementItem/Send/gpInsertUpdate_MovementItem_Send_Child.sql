-- Function: gpInsertUpdate_MovementItem_Send_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send_Child (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inAmount              TFloat    , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbUnitId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
   
   DECLARE vbParentId Integer; 
   DECLARE vbGoodsId Integer;
   DECLARE vbContainerId Integer;   
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;
    
    IF COALESCE (ioId, 0) < 0
    THEN
       RAISE EXCEPTION '������. ������ �� ����������� ������� ��� ������ 100 ���� ������������� ������.';
    END IF;

    IF COALESCE (ioId, 0) = 0
    THEN
       RAISE EXCEPTION '������. ������������� ����� �������� �����, ����������� ��� �����������!';
    END IF;

    --���������� ������������� ����������
    SELECT MovementLinkObject_To.ObjectId AS UnitId
    INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_To
    WHERE MovementLinkObject_To.MovementId = inMovementId
      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To();
      
    -- �������� ���������� �������� ���������
    SELECT
           MovementItem.ParentId
         , MovementItem.ObjectId
         , MIFloat_ContainerId.ValueData::Integer
    INTO vbParentId, vbGoodsId, vbContainerId
    FROM MovementItem
         LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                     ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                    AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId() 
    WHERE MovementItem.Id = ioId;
      

    -- ��� ���� "������" ��������� ��������
    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_Cashless())
    THEN
      -- ��� ���� "������ ������"
      IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
      THEN
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;

        IF COALESCE (vbUserUnitId, 0) = 0
        THEN
          RAISE EXCEPTION '������. �� ������� ������������� ����������.';
        END IF;

        --���������� ������������� �����������
        SELECT MovementLinkObject_From.ObjectId AS vbFromId
               INTO vbFromId
        FROM MovementLinkObject AS MovementLinkObject_From
        WHERE MovementLinkObject_From.MovementId = inMovementId
          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();

        IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN
          RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);
        END IF;
      END IF;
    END IF;

     -- ���������
    ioId := lpInsertUpdate_MovementItem_Send_Child (ioId          := ioId
                                                  , inParentId    := vbParentId  
                                                  , inMovementId  := inMovementId
                                                  , inGoodsId     := vbGoodsId
                                                  , inAmount      := inAmount
                                                  , inContainerId := vbContainerId
                                                  , inUserId      := vbUserId
                                                   );
                                                   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Send_Child (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 07.08.19                                                                      *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Send_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')