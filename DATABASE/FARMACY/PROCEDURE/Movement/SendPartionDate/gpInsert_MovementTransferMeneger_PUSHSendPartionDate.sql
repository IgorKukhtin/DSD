-- Function: gpInsert_MovementTransferMeneger_PUSHSendPartionDate()

DROP FUNCTION IF EXISTS gpInsert_MovementTransferMeneger_PUSHSendPartionDate (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementTransferMeneger_PUSHSendPartionDate(
    IN inContainerID    Integer   , -- ID ���������� ��� ��������� �����
    IN inContainerPGID  Integer   , -- ID ��������� ���������� ��� ��������� �����
    IN inExpirationDate TDateTime , -- ����� ����
    IN inAmount         TFloat    , -- ����������
   OUT outShowMessage   Boolean,          -- ��������� ���������
   OUT outPUSHType      Integer,          -- ��� ���������
   OUT outText          Text,             -- ����� ���������
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS RECORD AS
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
  outShowMessage := False;


  IF NOT EXISTS(SELECT 1 FROM Container
                WHERE Container.DescId    = zc_Container_Count()
                  AND Container.Id        = inContainerID)
  THEN
    outShowMessage := True;
    outPUSHType := 2;
    outText := '������. ��������� �� ������.';
    RETURN;
  END IF;

  IF COALESCE (inContainerPGID, 0) <> 0
  THEN

    IF NOT EXISTS(SELECT 1 FROM Container
                  WHERE Container.DescId    = zc_Container_CountPartionDate()
                    AND Container.Id        = inContainerPGID)
    THEN
      outShowMessage := True;
      outPUSHType := 2;
      outText := '������. ��������� �� ������.';
      RETURN;
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
      outShowMessage := True;
      outPUSHType := 2;
      outText := '������. �� ������� ��������� ��������� ��� ������.';
      RETURN;
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

  
  IF vbExpirationDate > inExpirationDate
  THEN
    IF NOT EXISTS(SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
    THEN
      outShowMessage := True;
      outPUSHType := 2;
      outText := '������. � ��� ��� ���� ���������� ���� ��������.';
      RETURN;
    END IF;    
  ELSE
    IF NOT EXISTS(SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_CashierPharmacy(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
    THEN
      outShowMessage := True;
      outPUSHType := 2;
      outText := '������. � ��� ��� ���� ���������� ���� ��������.';
      RETURN;
    END IF;  
  END IF;
  
  IF NOT EXISTS(SELECT 1 FROM Object AS Object_Unit
         INNER JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                 ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
                                AND ObjectBoolean_DividePartionDate.ValueData = True
    WHERE Object_Unit.DescId = zc_Object_Unit()
      AND Object_Unit.Id = vbUnitId)
  THEN
    outShowMessage := True;
    outPUSHType := 2;
    outText := '������. �� ������������� �� ������������� ��������� ������.';
    RETURN;
  END IF;

  IF vbRemains < inAmount
  THEN
    outShowMessage := True;
    outPUSHType := 2;
    outText := '���������� �� ��������� ����� <'||CAST(inAmount AS TEXT)||'> ������ ������� <'||CAST(vbRemains AS TEXT)||'>.';
    RETURN;
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
    outShowMessage := True;
    outPUSHType := 2;
    outText := '������. ���������� �������� ��������� ����� �� ������.';
    RETURN;
  END IF;

  IF DATE_TRUNC ('DAY', vbExpirationDate) >= inExpirationDate
  THEN
    outShowMessage := True;
    outPUSHType := 4;
    outText := '"�� �������� ��������� ���� ���� ������������ � ������! �������!"';
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.07.19                                                       *
*/

-- ����
-- SELECT * FROM gpInsert_MovementTransferMeneger_PUSHSendPartionDate (inContainerID := 10016974, inExpirationDate := '01.01.2020', inAmount := 1,  inSession:= '3')       
