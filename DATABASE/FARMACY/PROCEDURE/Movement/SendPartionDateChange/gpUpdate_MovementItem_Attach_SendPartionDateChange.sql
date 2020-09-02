-- Function: gpUpdate_MovementItem_Attach_SendPartionDateChange()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Attach_SendPartionDateChange (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Attach_SendPartionDateChange(
    IN inContainerID    Integer   , -- ID ���������� ��� ��������� �����
    IN inMISendId       TVarChar  , -- �������� �����������
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMISendId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIndex Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbGoodsId Integer;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);

  IF NOT EXISTS(SELECT 1 FROM Container
                WHERE Container.DescId    in (zc_Container_Count(), zc_Container_CountPartionDate())
                  AND Container.Id        = inContainerID)
  THEN
    RAISE EXCEPTION '������. ��������� �� ������.';
  END IF;

  SELECT Container.WhereObjectId, Container.ObjectId
  INTO vbUnitId, vbGoodsId
  FROM Container
  WHERE Container.DescId    in (zc_Container_Count(), zc_Container_CountPartionDate())
    AND Container.Id        = inContainerID;



  SELECT MAX(MovementItem.Id)
  INTO vbMovementItemId
  FROM Movement

       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    AND MovementLinkObject_Unit.ObjectId = vbUnitId

       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.ObjectId = vbGoodsId
                              AND MovementItem.Amount > 0
                              AND MovementItem.isErased = FALSE


   WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '5 DAY'
     AND Movement.DescId = zc_Movement_SendPartionDateChange();

  IF COALESCE (vbMovementItemId, 0) = 0
  THEN
    RAISE EXCEPTION '������. �� ���������� �� ������� ������ �� ��������� �����.';
  END IF;


 -- ������ �����������
  vbIndex := 1;
  WHILE SPLIT_PART (inMISendId, ',', vbIndex) <> '' LOOP
      -- ��������� �� ��� �����
      vbMISendId := SPLIT_PART (inMISendId, ',', vbIndex) :: Integer;
      -- ��������� �������� <���������� ����>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MISendPDChangeId(), vbMISendId, vbMovementItemId);
      -- ������ ����������
      vbIndex := vbIndex + 1;
  END LOOP;

--  RAISE EXCEPTION '������. %', vbMovementItemId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.09.20                                                       *
*/

-- ����
-- select * from gpUpdate_MovementItem_Attach_SendPartionDateChange(inContainerID := 21745442 , inMISendId := '371008924' ,  inSession := '3');