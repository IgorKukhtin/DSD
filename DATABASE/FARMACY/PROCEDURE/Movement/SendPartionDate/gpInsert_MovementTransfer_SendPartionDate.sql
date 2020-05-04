-- Function: gpInsert_MovementTransfer_SendPartionDate()

DROP FUNCTION IF EXISTS gpInsert_MovementTransfer_SendPartionDate (Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementTransfer_SendPartionDate(
    IN inContainerID    Integer    , -- ID ���������� ��� ��������� �����
    IN inExpirationDate TDateTime , -- ����� ����
    IN inAmount         TFloat    , -- ����������
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMIMasterId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbRemains TFloat;
   DECLARE vbExpirationDate TDateTime;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);
  inExpirationDate := DATE_TRUNC ('DAY', inExpirationDate);

  IF inSession::Integer NOT IN (3, 375661, 4183126, 8001630, 9560329, 8051421, 14080152 )
  THEN
      RAISE EXCEPTION '������. �������� ����� ���������.';
  END IF;

  IF NOT EXISTS(SELECT 1 FROM Container
                WHERE Container.DescId    = zc_Container_CountPartionDate()
                  AND Container.Id        = inContainerID)
  THEN
    RAISE EXCEPTION '������. ��������� �� ������.';
  END IF;

  SELECT Container.WhereObjectId, Container.ObjectId, Container.Amount, ObjectDate_ExpirationDate.ValueData
  INTO vbUnitId, vbGoodsId, vbRemains, vbExpirationDate
  FROM Container

       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

       LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                            ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                           AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

  WHERE Container.DescId    = zc_Container_CountPartionDate()
    AND Container.Id        = inContainerID;

  IF vbRemains < inAmount
  THEN
    RAISE EXCEPTION '������. ���������� �� ��������� ����� <%> ������ ������� <%>.', inAmount, vbRemains;
  END IF;

  IF vbExpirationDate > CURRENT_DATE
  THEN
    RAISE EXCEPTION '������. �������� ���� ����� ������ � ������������� ������.';
  END IF;

  IF inExpirationDate < CURRENT_DATE
  THEN
    RAISE EXCEPTION '������. �������� ���� ����� ������ �� ��������������.';
  END IF;

  IF NOT EXISTS(SELECT 1  FROM Movement

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                              LEFT JOIN MovementBoolean AS MovementBoolean_Transfer
                                                        ON MovementBoolean_Transfer.MovementId = Movement.Id
                                                       AND MovementBoolean_Transfer.DescId = zc_MovementBoolean_Transfer()

                         WHERE Movement.DescId = zc_Movement_SendPartionDate()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND MovementLinkObject_Unit.ObjectId = vbUnitId
                           AND COALESCE(MovementBoolean_Transfer.ValueData, False) = False)
  THEN
    RAISE EXCEPTION '������. ���������� �������� ��������� ����� �� ������.';
  END IF;

  SELECT MAX(Movement.ID)
  INTO vbMovementId
  FROM Movement

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

       LEFT JOIN MovementBoolean AS MovementBoolean_Transfer
                                 ON MovementBoolean_Transfer.MovementId = Movement.Id
                                AND MovementBoolean_Transfer.DescId = zc_MovementBoolean_Transfer()

  WHERE Movement.DescId = zc_Movement_SendPartionDate()
    AND Movement.StatusId = zc_Enum_Status_Complete()
    AND MovementLinkObject_Unit.ObjectId = vbUnitId
    AND COALESCE(MovementBoolean_Transfer.ValueData, False) = False;

  SELECT gpInsertUpdate_Movement_SendPartionDate(ioId               := 0,
                                                          inInvNumber        := CAST (NEXTVAL ('Movement_SendPartionDate_seq') AS TVarChar),
                                                          inOperDate         := CURRENT_DATE,
                                                          inUnitId           := vbUnitId,
                                                          inChangePercent    := MovementFloat_ChangePercent.ValueData,
                                                          inChangePercentMin := MovementFloat_ChangePercentMin.ValueData,
                                                          inComment          := '',
                                                          inSession          := inSession
                                                          )
  INTO vbMovementId
  FROM Movement

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercentMin
                                    ON MovementFloat_ChangePercentMin.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercentMin.DescId = zc_MovementFloat_ChangePercentMin()

  WHERE Movement.Id = vbMovementId;

  -- ��������� <��������� ����� ������>
  PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Transfer(), vbMovementId, True);

  SELECT gpInsertUpdate_MI_SendPartionDate_Master(ioId               := 0,            -- ���� ������� <������� ���������>
                                                  inMovementId       := vbMovementId, -- ���� ������� <��������>
                                                  inGoodsId          := vbGoodsId, -- ������
                                                  inAmount           := inAmount, -- ����������
                                                  inAmountRemains    := vbRemains, --
                                                  inChangePercent    := ObjectFloat_PartionGoods_Value.ValueData, -- % (���� �� 1 ��� �� 6 ���)
                                                  inChangePercentMin := ObjectFloat_PartionGoods_ValueMin.ValueData, -- % (���� ������ ������)
                                                  inContainerId      := inContainerID, -- ��������� ��� ��������� �����
                                                  inSession          := inSession    -- ������ ������������
                                                  )
  INTO vbMIMasterId
  FROM Container

       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

       LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                             ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  ContainerLinkObject.ObjectId
                            AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()

       LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                             ON ObjectFloat_PartionGoods_Value.ObjectId =  ContainerLinkObject.ObjectId
                            AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()

  WHERE Container.DescId    = zc_Container_CountPartionDate()
    AND Container.Id        = inContainerID;

  -- ��������� <����� ����>
  PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), MovementItem.Id, inExpirationDate)
  FROM MovementItem
  WHERE MovementItem.MovementId = vbMovementId
    AND MovementItem.ParentId = vbMIMasterId
    AND MovementItem.DescId = zc_MI_Child()
    AND MovementItem.isErased = FALSE;

  PERFORM gpUpdate_Status_SendPartionDate(inMovementId := vbMovementId , inStatusCode := 2 ,  inSession := inSession);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.06.19                                                       *
*/

-- ����
-- SELECT * FROM gpInsert_MovementTransfer_SendPartionDate (inContainerID := 10016974, inExpirationDate := '01.01.2020', inAmount := 1,  inSession:= '3')       