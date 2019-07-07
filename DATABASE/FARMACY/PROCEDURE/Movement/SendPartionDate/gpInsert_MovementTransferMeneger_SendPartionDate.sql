-- Function: gpInsert_MovementTransferMeneger_SendPartionDate()

DROP FUNCTION IF EXISTS gpInsert_MovementTransferMeneger_SendPartionDate (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementTransferMeneger_SendPartionDate(
    IN inContainerID    Integer   , -- ID ���������� ��� ��������� �����
    IN inContainerPGID  Integer   , -- ID ��������� ���������� ��� ��������� �����
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


  IF NOT EXISTS(SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), 59582, 393039))
  THEN
    RAISE EXCEPTION '������. � ��� ��� ���� ���������� ���� ��������.';
  END IF;

  IF NOT EXISTS(SELECT 1 FROM Container
                WHERE Container.DescId    = zc_Container_Count()
                  AND Container.Id        = inContainerID)
  THEN
    RAISE EXCEPTION '������. ��������� �� ������.';
  END IF;

  IF COALESCE (inContainerPGID, 0) <> 0
  THEN

    IF NOT EXISTS(SELECT 1 FROM Container
                  WHERE Container.DescId    = zc_Container_CountPartionDate()
                    AND Container.Id        = inContainerPGID)
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
      AND Container.Id        = inContainerPGID;

  ELSE

    IF EXISTS(SELECT 1 FROM Container
                  WHERE Container.DescId    = zc_Container_CountPartionDate()
                    AND Container.ParentId  = inContainerID
                    AND Container.Amount > 0)
    THEN
      RAISE EXCEPTION '������. �� ������� ��������� ��������� ��� ������.';
    END IF;

    SELECT Container.WhereObjectId, Container.ObjectId, Container.Amount, MIDate_ExpirationDate.ValueData
    INTO vbUnitId, vbGoodsId, vbRemains, vbExpirationDate
    FROM Container
         LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                       ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                      AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
         LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
         -- ������� �������
         LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
         -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
         LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                     ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                    AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
         -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                              -- AND 1=0
         LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

    WHERE Container.DescId    = zc_Container_Count()
      AND Container.Id        = inContainerID;

   inAmount := vbRemains;
  END IF;

  IF NOT EXISTS(SELECT 1 FROM Object AS Object_Unit
         INNER JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                 ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
                                AND ObjectBoolean_DividePartionDate.ValueData = True
    WHERE Object_Unit.DescId = zc_Object_Unit()
      AND Object_Unit.Id = vbUnitId)
  THEN
    RAISE EXCEPTION '������. �� ������������� �� ������������� ��������� ������.';
  END IF;

  IF vbRemains < inAmount
  THEN
    RAISE EXCEPTION '������. ���������� �� ��������� ����� <%> ������ ������� <%>.', inAmount, vbRemains;
  END IF;

  IF DATE_TRUNC ('DAY', vbExpirationDate) = inExpirationDate
  THEN
    RAISE EXCEPTION '������. ���� �� ���������.';
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

  IF COALESCE (inContainerPGID, 0) <> 0
  THEN
    SELECT gpInsertUpdate_MI_SendPartionDate_Master(ioId               := 0,            -- ���� ������� <������� ���������>
                                                    inMovementId       := vbMovementId, -- ���� ������� <��������>
                                                    inGoodsId          := vbGoodsId,    -- ������
                                                    inAmount           := inAmount,     -- ����������
                                                    inAmountRemains    := vbRemains,    --
                                                    inChangePercent    := ObjectFloat_PartionGoods_Value.ValueData, -- % (���� �� 1 ��� �� 6 ���)
                                                    inChangePercentMin := ObjectFloat_PartionGoods_ValueMin.ValueData, -- % (���� ������ ������)
                                                    inContainerId      := inContainerPGID,  -- ��������� ��� ��������� �����
                                                    inSession          := inSession     -- ������ ������������
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
      AND Container.Id        = inContainerPGID;
  ELSE
    SELECT gpInsertUpdate_MI_SendPartionDate_Master(ioId               := 0,             -- ���� ������� <������� ���������>
                                                    inMovementId       := vbMovementId,  -- ���� ������� <��������>
                                                    inGoodsId          := vbGoodsId,     -- ������
                                                    inAmount           := inAmount,      -- ����������
                                                    inAmountRemains    := vbRemains,     --
                                                    inChangePercent    := 0,             -- % (���� �� 1 ��� �� 6 ���)
                                                    inChangePercentMin := 0,             -- % (���� ������ ������)
                                                    inContainerId      := inContainerID, -- ��������� ��� ��������� �����
                                                    inSession          := inSession      -- ������ ������������
                                                    )
    INTO vbMIMasterId
    FROM Container

    WHERE Container.DescId    = zc_Container_Count()
      AND Container.Id        = inContainerID;
  
  END IF;

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
 07.07.19                                                       *
*/

-- ����
-- SELECT * FROM gpInsert_MovementTransferMeneger_SendPartionDate (inContainerID := 10016974, inExpirationDate := '01.01.2020', inAmount := 1,  inSession:= '3')       