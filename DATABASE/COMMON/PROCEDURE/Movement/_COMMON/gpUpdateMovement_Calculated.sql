-- Function: gpUpdateMovement_Calculated()

DROP FUNCTION IF EXISTS gpUpdateMovement_Calculated (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Calculated(
    IN inId                  Integer   , -- ���� ������� <��������>
 INOUT ioisCalculated        Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= inSession;

     -- ���������� �������
     ioisCalculated:= NOT ioisCalculated;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Calculated(), inId, ioisCalculated);

     -- �������� ���� � �������� �����
     WITH tmpGoodsSeparate AS (SELECT DISTINCT ObjectLink_GoodsSeparate_Goods.ChildObjectId AS GoodsId
                               FROM Object AS Object_GoodsSeparate
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Calculated
                                                             ON ObjectBoolean_Calculated.ObjectId  = Object_GoodsSeparate.ObjectId
                                                            AND ObjectBoolean_Calculated.DescId    = zc_ObjectBoolean_GoodsSeparate_Calculated()
                                                            AND ObjectBoolean_Calculated.ValueData = TRUE
                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsSeparate_Goods
                                                         ON ObjectLink_GoodsSeparate_Goods.ObjectId = Object_GoodsSeparate.ObjectId
                                                        AND ObjectLink_GoodsSeparate_Goods.DescId   = zc_ObjectLink_GoodsSeparate_Goods()
                               WHERE Object_GoodsSeparate.DescId   = zc_Object_GoodsSeparate()
                                 AND Object_GoodsSeparate.isErased = FALSE
                              )
         , tmpMIChild AS (SELECT MovementItem.Id, MovementItem.ObjectId AS GoodsId, COALESCE (MIBoolean_Calculated.ValueData, FALSE) AS isCalculated
                          FROM MovementItem
                               LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                             ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                            AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                          WHERE MovementItem.MovementId = inId
                            AND MovementItem.DescId     = zc_MI_Child()
                         )
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), tmpMIChild.Id
                                          , CASE -- ���� ��������� - ������� � ����
                                                 WHEN ioisCalculated = FALSE THEN FALSE
                                                 -- ���� ��� ��������� � ������ ������ - ���������
                                                 WHEN EXISTS (SELECT 1 FROM tmpMIChild AS tmpMIChild_find WHERE tmpMIChild_find.isCalculated = TRUE) THEN tmpMIChild.isCalculated
                                                 -- ����� - �� �����������
                                                 ELSE COALESCE (tmpGoodsSeparate.isCalculated, FALSE)
                                            END
                                           )
     FROM tmpMIChild
          LEFT JOIN tmpGoodsSeparate ON tmpGoodsSeparate.GoodsId = tmpMIChild.GoodsId
     ;


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
-- SELECT * FROM gpUpdateMovement_Calculated (inId:= 275079, ioisCalculated:= 'False', inSession:= '2')
