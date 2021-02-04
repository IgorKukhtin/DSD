-- Function: gpUpdate_MovementItem_Send_ContainerId()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Send_ContainerId (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Send_ContainerId(
     IN inMovementItemId      Integer   , -- ���� ������� <������� ���������>
     IN inParentId            Integer   , -- ���� ������� <������� ���������>
     IN inContainerID         Integer   , -- ���������
     IN inisAddNewLine        Boolean   , -- ������� ����� ������
     IN inSession             TVarChar    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbAmount     Integer;
   DECLARE vbAmountUse  Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

     -- ��������� ������ ����������� � ������� ������
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin()))
    THEN
      RAISE EXCEPTION '��������� �������� ��� ���������, ���������� � ���������� ��������������';
    END IF;
    
    

    IF EXISTS (SELECT 1
               FROM MovementItem

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                AND MIFloat_ContainerId.ValueData      = inContainerID

               WHERE MovementItem.ParentId = inParentId
                 AND MovementItem.isErased = True)
    THEN
      UPDATE MovementItem SET isErased = False
      WHERE MovementItem.Id = 
              (SELECT MovementItem.Id
               FROM MovementItem

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                AND MIFloat_ContainerId.ValueData      = inContainerID

               WHERE MovementItem.ParentId = inParentId
                 AND MovementItem.Amount = 0);
    
      RETURN;
    ELSEIF EXISTS (SELECT 1
               FROM MovementItem

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                AND MIFloat_ContainerId.ValueData      = inContainerID

               WHERE MovementItem.ParentId = inParentId
                 AND MovementItem.Amount = 0)
    THEN
      vbAmount := COALESCE((SELECT Container.Amount
                            FROM Container
                            WHERE Container.ID = inContainerID), 0);

      UPDATE MovementItem SET Amount = vbAmount
      WHERE MovementItem.Id = 
              (SELECT MovementItem.Id
               FROM MovementItem

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                AND MIFloat_ContainerId.ValueData      = inContainerID

               WHERE MovementItem.ParentId = inParentId
                 AND MovementItem.Amount = 0);
    
      RETURN;
    ELSEIF EXISTS (SELECT 1
               FROM MovementItem

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                AND MIFloat_ContainerId.ValueData      = inContainerID

               WHERE MovementItem.ParentId = inParentId)
    THEN
      RAISE EXCEPTION '� ���������� ���������� ����� ��� ����.';
    END IF;

    IF inisAddNewLine = TRUE
    THEN

      IF COALESCE (inParentId, 0) = 0
      THEN
        RAISE EXCEPTION '�� �������� ������� ������ ���������.';
      END IF;

      vbAmount := COALESCE((SELECT Container.Amount
                            FROM Container
                            WHERE Container.ID = inContainerID), 0);

      vbAmountUse := COALESCE((SELECT SUM(MovementItem.Amount)
                               FROM MovementItem
                               WHERE MovementItem.ParentId = inParentId), 0);

      PERFORM lpInsertUpdate_MovementItem_Send_Child(ioId                  := 0,
                                                     inParentId            := MovementItem.ID,
                                                     inMovementId          := MovementItem.MovementID  ,
                                                     inGoodsId             := MovementItem.ObjectId,
                                                     inAmount              := CASE WHEN MovementItem.Amount <= vbAmountUse THEN 0
                                                                                   WHEN (MovementItem.Amount - vbAmountUse) > vbAmount THEN vbAmount
                                                                                   ELSE MovementItem.Amount - vbAmountUse END,
                                                     inContainerId         := inContainerID,
                                                     inUserId              := vbUserId
                                                  )
      FROM MovementItem
      WHERE MovementItem.ID = inParentId;
    ELSE

      IF COALESCE (inMovementItemId, 0) = 0
      THEN
        RAISE EXCEPTION '�������� �������� � ������ ����� ������ �� ��������� ������.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), inMovementItemId, inContainerID);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
  22.09.20                                                       *
*/

-- ����
-- select * from gpUpdate_MovementItem_Send_ContainerId(inMovementItemId := 367430631 , inParentId := 367429823 , inContainerID := 23812831 , inisAddNewLine := False, inSession := '3');

--select * from gpUpdate_MovementItem_Send_ContainerId(inMovementItemId := 0 , inParentId := 400731454 , inContainerID := 23354530 , inisAddNewLine := 'False' ,  inSession := '3');