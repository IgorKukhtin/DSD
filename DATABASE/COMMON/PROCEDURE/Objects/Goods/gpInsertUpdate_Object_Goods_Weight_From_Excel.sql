 -- Function: gpInsertUpdate_Object_Goods_Weight_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_Weight_From_Excel (Integer, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_Weight_From_Excel(
    IN inGoodsCode           Integer   , -- ��� ������� <�����>
    IN inWeight              TFloat    , -- ���
    IN inWeightTare          TFloat    , -- ��� ������
    IN inCountForWeight      TFloat    , -- ���-�� ��� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������ ��� - ����������!!!
     IF COALESCE (inGoodsCode, 0) = 0 THEN
        RETURN; -- !!!�����!!!
     END IF;


     -- !!!����� �� ������!!!
     vbGoodsId:= (SELECT Object_Goods.Id
                  FROM Object AS Object_Goods
                  WHERE Object_Goods.ObjectCode = inGoodsCode
                    AND Object_Goods.DescId     = zc_Object_Goods()
                    AND inGoodsCode > 0
                 );
     -- ��������
     IF COALESCE (vbGoodsId, 0) = 0 THEN
        RETURN;
        RAISE EXCEPTION '������.�� ������ ����� � ��� = <%> .', inGoodsCode;
     END IF;


     -- ��������� �������� <���>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Weight(), vbGoodsId, inWeight);
     -- ��������� �������� <��� ������>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_WeightTare(), vbGoodsId, inWeightTare);
     -- ��������� �������� <��� ��� ����>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountForWeight(), vbGoodsId, inCountForWeight);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.10.197         *
*/

-- ����
--
