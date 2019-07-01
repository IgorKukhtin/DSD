-- Function: lpInsertFind_Object_PartionGoods - PartionDate

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, TDateTime);
DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, TDateTime, TFloat, TFloat);
-- DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, TDateTime, Integer, TFloat, TFloat);
DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, Integer, TDateTime, Integer, Integer, TFloat, TFloat);
DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, Integer, TDateTime, Integer, Integer, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inMovementId       Integer,   -- �������� "������ �� ����������"
    IN inMovementId_send  Integer,   -- �������� zc_Movement_SendPartionDate
    IN inOperDate         TDateTime, -- ���� �������� - �� ���� ���� - ExpirationDate
    IN inUnitId           Integer,   -- �������������
    IN inGoodsId          Integer,   -- �����
    IN inChangePercentMin TFloat,    -- % ������(���� ������ ������)
    IN inChangePercent    TFloat,    -- % ������(���� �� 1 ��� �� 6 ���)
    IN inPriceWithVAT     TFloat     -- ���� ������� � ���
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionGoodsId  Integer;
   DECLARE vbcontainerid_err Integer;
   DECLARE vbOperDate_str    TVarChar;
BEGIN
     -- ������ ��������
     IF COALESCE (inOperDate, zc_DateEnd()) = zc_DateEnd()
     THEN
         vbOperDate_str:= '';
         inOperDate:= NULL;
     ELSE
         -- ����������� � �������
         vbOperDate_str:= COALESCE (TO_CHAR (inOperDate, 'DD.MM.YYYY'), '');
     END IF;

/*   -- ������� �.�. �� ������� � ����������� ����� ���� ��������� ������
     -- �������� - ������ inMovementId � ������ ����� ������������� ������ � ����� ��������� ����
     IF NOT EXISTS(SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId_send AND MB.DescId = zc_MovementBoolean_Transfer() AND MB.ValueData = TRUE) AND
         EXISTS (WITH tmpObject_Partion AS (SELECT CLO_PartionGoods.ContainerId
                                           FROM Object
                                                INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                      ON ObjectLink_Goods.ObjectId      = Object.Id
                                                                     AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                                     AND ObjectLink_Goods.ChildObjectId = inGoodsId
                                                /*INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                      ON ObjectLink_Unit.ObjectId      = Object.Id
                                                                     AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                                     AND ObjectLink_Unit.ChildObjectId = inUnitId*/
                                                INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                               ON CLO_PartionGoods.ObjectId = Object.Id
                                                                              AND CLO_PartionGoods.DescId   = zc_ContainerLinkObject_PartionGoods()
                                           WHERE -- �� ������ "������ �� ����������"
                                                 Object.ObjectCode = inMovementId
                                             AND Object.DescId     = zc_Object_PartionGoods()
                                          -- !!! ��� !!! "���� ��������"
                                          --   AND Object.ValueData  = vbOperDate_str
                                          )
                --
                SELECT Container.Id
                FROM Container
                     INNER JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.ContainerId     = Container.Id
                                                     AND MIContainer.MovementDescId  = zc_Movement_SendPartionDate()
                                                  -- AND MIContainer.MovementId      <> inMovementId_send
                WHERE Container.Id            IN (SELECT DISTINCT tmpObject_Partion.ContainerId FROM tmpObject_Partion)
                  AND Container.DescId        = zc_Container_CountPartionDate()
                  AND Container.WhereObjectId = inUnitId
               )
     THEN 
         vbContainerId_err:=  (WITH tmpObject_Partion AS (SELECT CLO_PartionGoods.ContainerId
                                                          FROM Object
                                                               INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                                     ON ObjectLink_Goods.ObjectId      = Object.Id
                                                                                    AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                                                    AND ObjectLink_Goods.ChildObjectId = inGoodsId
                                                               /*INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                                     ON ObjectLink_Unit.ObjectId      = Object.Id
                                                                                    AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                                                    AND ObjectLink_Unit.ChildObjectId = inUnitId*/
                                                               INNER JOIN ObjectFloat AS ObjectFloat_MovementId
                                                                                      ON ObjectFloat_MovementId.ObjectId = Object.Id
                                                                                     AND ObjectFloat_MovementId.DescId    = zc_ObjectFloat_PartionGoods_MovementId()
                                                               INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                              ON CLO_PartionGoods.ObjectId    = Object.Id
                                                                                             AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                          WHERE -- �� ������ "������ �� ����������"
                                                                Object.ObjectCode = inMovementId
                                                            AND Object.DescId     = zc_Object_PartionGoods()
                                                         -- !!! ��� !!! "���� ��������"
                                                         -- AND Object.ValueData  = vbOperDate_str
                                                         )
                               SELECT Container.Id
                               FROM Container
                                    INNER JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.ContainerId     = Container.Id
                                                                    AND MIContainer.MovementDescId  = zc_Movement_SendPartionDate()
                                                                 -- AND MIContainer.MovementId      <> inMovementId_send
                               WHERE Container.Id            IN (SELECT DISTINCT tmpObject_Partion.ContainerId FROM tmpObject_Partion)
                                 AND Container.DescId        = zc_Container_CountPartionDate()
                                 AND Container.WhereObjectId = inUnitId
                               LIMIT 1
                              );
         --
         RAISE EXCEPTION '������.��� <%> � ������� ������� �� ���������� � <%> �� <%> ��� ������������ ������ ���� � � <%> �� <%>.'
                        , lfGet_Object_ValueData (inGoodsId)
                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = (SELECT Object.ObjectCode FROM ContainerLinkObject AS CLO_PG JOIN Object ON Object.Id = CLO_PG.ObjectId WHERE CLO_PG.ContainerId = vbContainerId_err AND CLO_PG.DescId = zc_ContainerLinkObject_PartionGoods()))
                        , zfConvert_DateToString ((SELECT Movement.OperDate  FROM Movement WHERE Movement.Id = (SELECT Object.ObjectCode FROM ContainerLinkObject AS CLO_PG JOIN Object ON Object.Id = CLO_PG.ObjectId WHERE CLO_PG.ContainerId = vbContainerId_err AND CLO_PG.DescId = zc_ContainerLinkObject_PartionGoods())))
                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = (SELECT ObjectFloat.ValueData :: Integer FROM ContainerLinkObject AS CLO_PG JOIN ObjectFloat ON ObjectFloat.ObjectId = CLO_PG.ObjectId AND ObjectFloat.DescId = zc_ObjectFloat_PartionGoods_MovementId() WHERE CLO_PG.ContainerId = vbContainerId_err AND CLO_PG.DescId = zc_ContainerLinkObject_PartionGoods()))
                        , zfConvert_DateToString ((SELECT Movement.OperDate  FROM Movement WHERE Movement.Id = (SELECT ObjectFloat.ValueData :: Integer FROM ContainerLinkObject AS CLO_PG JOIN ObjectFloat ON ObjectFloat.ObjectId = CLO_PG.ObjectId AND ObjectFloat.DescId = zc_ObjectFloat_PartionGoods_MovementId() WHERE CLO_PG.ContainerId = vbContainerId_err AND CLO_PG.DescId = zc_ContainerLinkObject_PartionGoods())))
                        ;
     END IF;
*/

     -- �������� - ����� ���� ������ ���� ������
     IF 1 < (SELECT COUNT(*)
             FROM Object
                  INNER JOIN ObjectLink AS ObjectLink_Goods
                                        ON ObjectLink_Goods.ObjectId      = Object.Id
                                       AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                       AND ObjectLink_Goods.ChildObjectId = inGoodsId
                  INNER JOIN ObjectLink AS ObjectLink_Unit
                                        ON ObjectLink_Unit.ObjectId      = Object.Id
                                       AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                       AND ObjectLink_Unit.ChildObjectId = inUnitId
                                       
                  INNER JOIN ObjectFloat AS ObjectFloat_MovementId
                                         ON ObjectFloat_MovementId.ObjectId = Object.Id
                                        AND ObjectFloat_MovementId.DescId    = zc_ObjectFloat_PartionGoods_MovementId()
             WHERE -- �� ������ "������ �� ����������"
                   Object.ObjectCode = inMovementId
                  -- �� "���� ��������"
               AND Object.ValueData  = vbOperDate_str
               AND Object.DescId     = zc_Object_PartionGoods()
            )
     THEN 
         RAISE EXCEPTION '������.������� ��������� ������ � ���������� inMovementId = <%> + OperDate =  <%>.', inMovementId, vbOperDate_str;
     END IF;


     -- ������� �� ��-���: ������ �������� ������
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object
                              INNER JOIN ObjectLink AS ObjectLink_Goods
                                                    ON ObjectLink_Goods.ObjectId      = Object.Id
                                                   AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                   AND ObjectLink_Goods.ChildObjectId = inGoodsId
                              INNER JOIN ObjectLink AS ObjectLink_Unit
                                                    ON ObjectLink_Unit.ObjectId      = Object.Id
                                                   AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                   AND ObjectLink_Unit.ChildObjectId = inUnitId
                              INNER JOIN ObjectFloat AS ObjectFloat_MovementId
                                                     ON ObjectFloat_MovementId.ObjectId = Object.Id
                                                    AND ObjectFloat_MovementId.DescId    = zc_ObjectFloat_PartionGoods_MovementId()
                         WHERE -- �� ������ "������ �� ����������"
                               Object.ObjectCode = inMovementId
                           AND Object.DescId     = zc_Object_PartionGoods()
                              -- �� "���� ��������"
                           AND Object.ValueData  = vbOperDate_str
                        );
                        


     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- ��������� <������ �������� ������>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), inMovementId, vbOperDate_str);

         -- ��������� <�����>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, inGoodsId);
         -- ��������� <�������������>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Unit(), vbPartionGoodsId, inUnitId);
         

         -- ��������� - ���� �������� - �� ���� ���� - ExpirationDate
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, inOperDate);

         -- ��������� - % ������(���� ������ ������)
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_ValueMin(), vbPartionGoodsId, inChangePercentMin);

         -- ��������� - % ������(���� �� 1 ��� �� 6 ���)
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Value(), vbPartionGoodsId, inChangePercent);
         
         -- ��������� - ���� ������� � ���
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_PriceWithVAT(), vbPartionGoodsId, inPriceWithVAT);

         -- ��������� - ������ ��������� ����
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_MovementId(), vbPartionGoodsId, inMovementId_send);

     ELSE
         -- ��������� - ������ ��������� ����
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_MovementId(), vbPartionGoodsId, inMovementId_send);

         -- ��������� - % ������(���� ������ ������)
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_ValueMin(), vbPartionGoodsId, inChangePercentMin);

         -- ��������� - % ������(���� �� 1 ��� �� 6 ���)
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Value(), vbPartionGoodsId, inChangePercent);

         -- ��������� - ���� ������� � ���
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_PriceWithVAT(), vbPartionGoodsId, inPriceWithVAT);
     END IF;

     -- ���������� ��������
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.06.19                                                       *
 19.04.19                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inMovementId:= 1, inOperDate:= NULL);
