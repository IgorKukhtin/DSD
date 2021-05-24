-- Function: gpUpdateMovement_Calculated()

DROP FUNCTION IF EXISTS gpUpdateMovement_Calculated (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Calculated(
    IN inId                  Integer   , -- ���� ������� <��������>
 INOUT ioIsCalculated        Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������� �������
     ioIsCalculated:= NOT ioIsCalculated;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Calculated(), inId, ioIsCalculated);


     -- ������ ��� zc_Movement_ProductionSeparate
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inId AND Movement.DescId = zc_Movement_ProductionSeparate())
     THEN
         -- �������� ���� � �������� �����
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), tmp.Id
                                                   , CASE -- ���� ��������� ��� Movement - ������� � ���� MI
                                                          WHEN ioIsCalculated = FALSE THEN FALSE
                                                          -- ���� ��� ��������� � ������ ������ - ���������
                                                          WHEN tmp.isCalculated_exists = TRUE THEN tmp.isCalculated_mi
                                                          -- ����� - �� �����������
                                                          ELSE tmp.isCalculated_goods
                                                     END
                                                    )
         FROM (WITH tmpGoodsSeparate AS (SELECT DISTINCT
                                                ObjectLink_GoodsSeparate_GoodsMaster.ChildObjectId AS GoodsId_master
                                              , ObjectLink_GoodsSeparate_Goods.ChildObjectId       AS GoodsId
                                              , ObjectBoolean_Calculated.ValueData                 AS isCalculated
                                         FROM Object AS Object_GoodsSeparate
                                              INNER JOIN ObjectBoolean AS ObjectBoolean_Calculated
                                                                       ON ObjectBoolean_Calculated.ObjectId  = Object_GoodsSeparate.Id
                                                                      AND ObjectBoolean_Calculated.DescId    = zc_ObjectBoolean_GoodsSeparate_Calculated()
                                                                      AND ObjectBoolean_Calculated.ValueData = TRUE
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsSeparate_GoodsMaster
                                                                   ON ObjectLink_GoodsSeparate_GoodsMaster.ObjectId = Object_GoodsSeparate.Id
                                                                  AND ObjectLink_GoodsSeparate_GoodsMaster.DescId   = zc_ObjectLink_GoodsSeparate_GoodsMaster()
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsSeparate_Goods
                                                                   ON ObjectLink_GoodsSeparate_Goods.ObjectId = Object_GoodsSeparate.Id
                                                                  AND ObjectLink_GoodsSeparate_Goods.DescId   = zc_ObjectLink_GoodsSeparate_Goods()
                                         WHERE Object_GoodsSeparate.DescId   = zc_Object_GoodsSeparate()
                                           AND Object_GoodsSeparate.isErased = FALSE
                                        )
                   , tmpMIChild AS (SELECT MovementItem.Id, MI_Master.ObjectId AS GoodsId_master, MovementItem.ObjectId AS GoodsId, COALESCE (MIBoolean_Calculated.ValueData, FALSE) AS isCalculated
                                    FROM MovementItem
                                         INNER JOIN MovementItem AS MI_Master ON MI_Master.Id       = MovementItem.ParentId
                                                                             AND MI_Master.isErased = FALSE
                                         LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                                       ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                                      AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                    WHERE MovementItem.MovementId = inId
                                      AND MovementItem.DescId     = zc_MI_Child()
                                      AND MovementItem.isErased   = FALSE
                                   )
               SELECT tmpMIChild.Id
                    , tmpMIChild.isCalculated AS isCalculated_mi
                    , COALESCE (tmpGoodsSeparate.isCalculated, FALSE) AS isCalculated_goods
                    , EXISTS (SELECT 1 FROM tmpMIChild AS tmpMIChild_find WHERE tmpMIChild_find.isCalculated = TRUE) AS isCalculated_exists
               FROM tmpMIChild
                    LEFT JOIN tmpGoodsSeparate ON tmpGoodsSeparate.GoodsId_master = tmpMIChild.GoodsId_master
                                              AND tmpGoodsSeparate.GoodsId        = tmpMIChild.GoodsId
              ) AS tmp
         ;
    
    
         -- �������� - ������ ��� ������������ ���� �� ���� �������
         IF ioIsCalculated = TRUE
            AND NOT EXISTS (SELECT 1
                            FROM MovementItem
                                 INNER JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                                ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                               AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                               AND MIBoolean_Calculated.ValueData      = TRUE
                            WHERE MovementItem.MovementId = inId
                              AND MovementItem.isErased   = FALSE
                              AND MovementItem.DescId     = zc_MI_Child())
         THEN
             RAISE EXCEPTION '������.� ��������� �� ������ ����� � ��������� <������ ������ ��� <������ � ������������-����������> = ��>';
         END IF;

     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.10.18         * 
*/


-- ����
-- SELECT * FROM gpUpdateMovement_Calculated (inId:= 275079, ioIsCalculated:= 'False', inSession:= '2')
