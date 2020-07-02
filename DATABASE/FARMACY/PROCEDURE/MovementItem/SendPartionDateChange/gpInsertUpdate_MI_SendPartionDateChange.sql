-- Function: gpInsertUpdate_MI_SendPartionDateChange()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SendPartionDateChange (Integer, Integer, Integer, TFloat, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SendPartionDateChange(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inNewExpirationDate   TDateTime , -- ����� ���� ��������
    IN inContainerId         Integer   , -- ���������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;

   DECLARE vbAmount         TFloat;
   DECLARE vbDescId         Integer;
   DECLARE vbExpirationDate TDateTime;
   DECLARE vbDate_6            TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;

    IF COALESCE (ioId, 0) = 0
    THEN
      IF COALESCE (inAmount, 0) <= 0
      THEN
        RAISE EXCEPTION '������. ���������� ������ ���� ������ 0.';
      END IF;
    ELSE
      IF COALESCE (inAmount, 0) < 0
      THEN
        RAISE EXCEPTION '������. ���������� ������ ���� ������ ��� ����� 0.';
      END IF;
    END IF;

    IF EXISTS(SELECT MovementItem.Id
              FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                               ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                              AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MIFloat_ContainerId.ValueData::Integer = inContainerId
                AND MovementItem.Id         <> ioId)
    THEN
      RAISE EXCEPTION '������. ��������� ����� ���� ����������� ������ ��� � ���������.';
    END IF;

    --���������� ������ ���������
    SELECT MovementLinkObject_Unit.ObjectId                             AS UnitId
    INTO vbUnitId
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    -- ��������� ���� �� ����������  �����
    SELECT Date_6 INTO vbDate_6 FROM lpSelect_PartionDateKind_SetDate ();

    -- �������� �������� �� ����������
    SELECT Container.DescId
         , Container.Amount
         , COALESCE (ObjectDate_ExpirationDate.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
    INTO vbDescId, vbAmount, vbExpirationDate
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
         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

         LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

         LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

         LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                              ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()


     WHERE Container.DescId in (zc_Container_Count(), zc_Container_CountPartionDate())
       AND Container.Id = inContainerId;

     IF COALESCE (vbDescId, 0) = 0
     THEN
       RAISE EXCEPTION '������. ��������� �� ������.';
     END IF;

     IF vbDescId = zc_Container_Count()
     THEN
       IF COALESCE (inAmount, 0) <> COALESCE (vbAmount, 0) AND COALESCE (inAmount, 0) <> 0
       THEN
         RAISE EXCEPTION '������. ��� ������ �������� ���������� � ����� ���������� ������ ���� ����� �������.';
       END IF;

       IF COALESCE(inNewExpirationDate, vbDate_6 + INTERVAL '1 DAY') > vbDate_6
       THEN
         RAISE EXCEPTION '������. ���� �������� ������� <%> ������ ����������� ����������� <%> ��� �������� � �����.', inNewExpirationDate, vbDate_6;
       END IF;

     ELSE
       IF COALESCE (inAmount, 0) > COALESCE (vbAmount, 0)
       THEN
         RAISE EXCEPTION '������. ���������� ��������� ������� �� ������.';
       END IF;
     END IF;


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

      IF COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
      THEN
        RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);
      END IF;
    END IF;

     -- ���������
    ioId := lpInsertUpdate_MI_SendPartionDateChange (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inAmount             := inAmount
                                                   , inNewExpirationDate  := inNewExpirationDate
                                                   , inContainerId        := inContainerId
                                                   , inUserId             := vbUserId
                                                    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_SendPartionDateChange (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 02.07.20                                                                      *
*/

-- ����
-- select * from gpInsertUpdate_MI_SendPartionDateChange(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');