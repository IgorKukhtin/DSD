-- Function: gpUpdate_Object_PartionGoods_Cat_5

DROP FUNCTION IF EXISTS gpUpdate_Object_PartionGoods_Cat_5 (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PartionGoods_Cat_5(
    IN inPartionGoodsId   Integer,   -- ������ ������
    IN inCat_5            Boolean,   -- ������� ���������
   OUT outCat_5           Boolean,   -- ������� ���������
    IN inSession          TVarChar   -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbcontainerid_err Integer;
   DECLARE vbOperDate_str    TVarChar;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbGoodsId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Send());
     vbUserId := inSession::Integer;

     -- �������� - ����� ���� ������ ���� ������
     IF NOT EXISTS (SELECT 1
             FROM Object
             WHERE Object.ID      = inPartionGoodsId
               AND Object.DescId  = zc_Object_PartionGoods())
     THEN 
         RAISE EXCEPTION '������.������ �� �������.';
     END IF;
           
     SELECT Container.WhereObjectId, Container.ObjectId
     INTO vbUnitId, vbGoodsId
     FROM ContainerLinkObject 
                                          
            LEFT JOIN Container ON Container.ID = ContainerLinkObject.ContainerId
            
     WHERE ContainerLinkObject.ObjectId = inPartionGoodsId
       AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods();  
       
     IF  NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       --CURRENT_DATE <> '12.04.2021'  OR vbUnitId <> 375626 OR vbGoodsId NOT IN (8806871)
     THEN
       -- ���� ������ ���������� � 5 ���������
       IF NOT inCat_5 AND
          EXISTS(SELECT * FROM ObjectDate 
                 WHERE ObjectDate.DescID = zc_ObjectDate_PartionGoods_Cat_5() 
                   AND ObjectDate.ObjectID = inPartionGoodsId
                   AND ObjectDate.ValueData < CURRENT_DATE - INTERVAL '30 DAY') --AND
  /*        NOT EXISTS(SELECT 1 FROM ContainerLinkObject
                                   INNER JOIN MovementItemContainer ON MovementItemContainer.MovementDescId =  zc_Movement_Check() 
                                                                   AND MovementItemContainer.ContainerId = ContainerLinkObject.ContainerId
                                   INNER JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemID
                                   INNER JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.ParentId
                                                                    AND MovementItemLinkObject.DescId = zc_MILinkObject_PartionDateKind()
                                                                    AND MovementItemLinkObject.ObjectId = zc_Enum_PartionDateKind_Cat_5() 
                     WHERE ContainerLinkObject.ObjectId = inPartionGoodsId
                       AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods())
  */     THEN     
          RAISE EXCEPTION '������. ��� ������� ��������� ���������� � 5 ���, ��������� ��� ��� ���������� 30 ���� � ��������� � 4 ���';     
       END IF;
     END IF;
     

     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PartionGoods_Cat_5(), inPartionGoodsId, NOT inCat_5);

     -- ��������� - ���� ������� �������� � 5 ���������
     IF NOT EXISTS(SELECT * FROM ObjectDate WHERE ObjectDate.DescID = zc_ObjectDate_PartionGoods_Cat_5() AND ObjectDate.ObjectID = inPartionGoodsId)
     THEN     
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Cat_5(), inPartionGoodsId, CURRENT_TIMESTAMP);
     END IF;
     

     -- ���������� ��������
     outCat_5 := COALESCE ((SELECT ValueData FROM ObjectBoolean WHERE DescID = zc_ObjectBoolean_PartionGoods_Cat_5() AND ObjectId = inPartionGoodsId), FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.08.19                                                       *
 17.07.19                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_PartionGoods_Cat_5 (inMovementId:= 1, inOperDate:= NULL);