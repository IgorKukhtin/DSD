 -- Function: gpInsertUpdate_Object_Goods_Direction_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_Direction_Load (Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_Direction_Load(
    IN inGoodsCode               Integer   , -- ��� ������� <�����>
    IN inGoodsName               TVarChar    , -- 
    IN inGoodsGroupDirectionName TVarChar    , -- 
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsGroupDirectionId Integer;
   
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
        RAISE EXCEPTION '������.�� ������ ����� <(%) %> .', inGoodsCode, inGoodsName;
     END IF;

     --������� ����� GoodsGroupDirection
     vbGoodsGroupDirectionId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroupDirection() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inGoodsGroupDirectionName)) );
     
     IF COALESCE (vbGoodsGroupDirectionId,0) = 0
     THEN
         --�������
         vbGoodsGroupDirectionId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_GoodsGroupDirection (ioId           := 0         :: Integer
                                                                                   , inCode         := 0         :: Integer
                                                                                   , inName         := TRIM (inGoodsGroupDirectionName) :: TVarChar
                                                                                   , inSession      := inSession :: TVarChar
                                                                                    ) AS tmp);
     END IF;
     
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupDirection(), vbGoodsId, vbGoodsGroupDirectionId);

  
     IF vbUserId = 9457 OR vbUserId = 5
     THEN
           RAISE EXCEPTION '����. ��. <%>', vbGoodsId; 
     END IF;   

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.08.24         *
*/

-- ����
--
