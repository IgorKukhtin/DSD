-- Function:  gpSelect_ResortCorrection

DROP FUNCTION IF EXISTS gpSelect_ResortCorrection (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ResortCorrection (
  inContainerId  Integer,
  inSession TVarChar
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbUnitId           Integer;
  DECLARE vbContainerRestId  Integer;
  DECLARE vbMICID            Integer;

  DECLARE vbAmount           TFloat;
  DECLARE vbAmountRest       TFloat;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������������� ��� ���������, ���������� � ���������� ��������������';
   END IF;

   SELECT Container.ObjectId, Container.WhereObjectId, Container.Amount
   INTO vbGoodsId, vbUnitId, vbAmount
   FROM Container
   WHERE Container.DescId = zc_Container_Count()
     AND Container.Id = inContainerId;

   IF COALESCE (vbAmount, 0) >= 0
   THEN
      RAISE EXCEPTION '������. ������� �� ������ ������ ���� ������ ����.';
   END IF;

   IF NOT EXISTS(SELECT Container.Id
                 FROM Container
                 WHERE Container.DescId = zc_Container_Count()
                   AND Container.ObjectId = vbGoodsId
                   AND Container.WhereObjectId = vbUnitId
                   AND Container.Amount > 0)
   THEN
      RAISE EXCEPTION '������. ��� ������� ��� �������� ���������.';
   END IF;

     -- ���� ���� ������ ���� ����������� ������� ����� ��
   IF EXISTS(SELECT 1 FROM Container
             WHERE Container.DescId = zc_Container_Count()
               AND Container.ObjectId = vbGoodsId
               AND Container.WhereObjectId = vbUnitId
               AND (Container.Amount + vbAmount) >= 0)
   THEN

     SELECT MIN(Container.Id)
     INTO vbContainerRestId
     FROM Container
     WHERE Container.DescId = zc_Container_Count()
       AND Container.ObjectId = vbGoodsId
       AND Container.WhereObjectId = vbUnitId
       AND (Container.Amount + vbAmount) >= 0;

   ELSE

     -- ���� ��� ������ ���� ����������� ������� ����� ������� �� ����� ������ ������

     SELECT Container.Id, - Container.Amount
     INTO vbContainerRestId, vbAmount
     FROM Container
     WHERE Container.DescId = zc_Container_Count()
       AND Container.ObjectId = vbGoodsId
       AND Container.WhereObjectId = vbUnitId
       AND Container.Amount > 0
     ORDER BY Container.Id
     LIMIT 1;

   END IF;

   IF COALESCE (vbContainerRestId, 0) = 0
   THEN
      RAISE EXCEPTION '������. ��� ������� ��� �������� ���������.';
   END IF;


   IF EXISTS(SELECT 1 FROM MovementItemContainer
             WHERE MovementItemContainer.ContainerId = inContainerId
               AND MovementItemContainer.Amount = vbAmount)
   THEN

     SELECT MovementItemContainer.Id
     INTO vbMICID
     FROM MovementItemContainer
     WHERE MovementItemContainer.ContainerId = inContainerId
       AND MovementItemContainer.Amount = vbAmount;


     UPDATE MovementItemContainer SET ContainerId = vbContainerRestId
     WHERE  MovementItemContainer.Id = vbMICID;

   ELSEIF EXISTS(SELECT 1 FROM MovementItemContainer
             WHERE MovementItemContainer.ContainerId = inContainerId
               AND MovementItemContainer.Amount < 0
               AND MovementItemContainer.Amount > vbAmount)
   THEN

     SELECT MAX(MovementItemContainer.Id)
     INTO vbMICID
     FROM MovementItemContainer
     WHERE MovementItemContainer.ContainerId = inContainerId
       AND MovementItemContainer.Amount < 0
       AND MovementItemContainer.Amount > vbAmount;


     UPDATE MovementItemContainer SET ContainerId = vbContainerRestId
     WHERE  MovementItemContainer.Id = vbMICID;

   ELSEIF EXISTS(SELECT 1 FROM MovementItemContainer
             WHERE MovementItemContainer.ContainerId = inContainerId
               AND MovementItemContainer.Amount < vbAmount)
   THEN

     SELECT MAX(MovementItemContainer.Id)
     INTO vbMICID
     FROM MovementItemContainer
     WHERE MovementItemContainer.ContainerId = inContainerId
       AND MovementItemContainer.Amount < vbAmount;

     INSERT INTO MovementItemContainer (descid, movementid, containerid, amount, operdate, movementitemid, parentid,
            isactive, movementdescid, accountid, objectid_analyzer, whereobjectid_analyzer,
            containerid_analyzer, analyzerid, containerintid_analyzer,
            objectintid_analyzer, objectextid_analyzer, accountid_analyzer, price)
     SELECT descid, movementid, vbContainerRestId as containerid, vbAmount AS amount, operdate, movementitemid, parentid,
            isactive, movementdescid, accountid, objectid_analyzer, whereobjectid_analyzer,
            containerid_analyzer, analyzerid, containerintid_analyzer,
            objectintid_analyzer, objectextid_analyzer, accountid_analyzer, price
     FROM MovementItemContainer
     WHERE MovementItemContainer.ID = vbMICID;

     UPDATE MovementItemContainer SET Amount = Amount - vbAmount where MovementItemContainer.ID = vbMICID;

   ELSE
      RAISE EXCEPTION '������. ��� ����� ���� ���������� � �������������.';
   END IF;


   UPDATE Container SET Amount = COALESCE((SELECT Sum(MovementItemContainer.Amount)
                                           FROM MovementItemContainer
                                           WHERE MovementItemContainer.ContainerId = Container.Id ), 0)
   WHERE Container.Id in  (inContainerId, vbContainerRestId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.09.20                                                       *

*/

-- ����
-- select * from gpSelect_ResortCorrection(inContainerId := 7193395 ,  inSession := '3');