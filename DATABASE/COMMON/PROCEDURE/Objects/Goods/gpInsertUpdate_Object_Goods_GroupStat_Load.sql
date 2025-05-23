 -- Function: gpInsertUpdate_Object_Goods_GroupStat_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_GroupStat_Load (Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_GroupStat_Load(
    IN inGoodsCode      Integer   , -- ��� ������� <�����>
    IN inGoodsName      TVarChar    , -- 
    IN inGroupStatName  TVarChar    , -- 
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGroupStatId Integer;
   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������ ��� - ����������!!!
     IF COALESCE (inGoodsCode, 0) = 0 THEN
        RAISE EXCEPTION '������.������� ��� = 0, ����� <%>', inGoodsName;
        --RETURN; -- !!!�����!!!
     END IF;

     -- !!!������ ������ ���������� - ����������!!!
     IF COALESCE (TRIM (inGroupStatName), '') = '' THEN
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

     --������� ����� ������ ����������
     vbGroupStatId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroupStat() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inGroupStatName)) );
     IF COALESCE (vbGroupStatId,0) = 0
     THEN
         RAISE EXCEPTION '������.������ ���������� <%> �� �������', inGroupStatName;
     END IF;

    /* IF COALESCE (vbGroupStatId,0) = 0
     THEN
         --�������
         vbGroupStatId := (SELECT tmp.ioId
                           FROM gpInsertUpdate_Object_GoodsGroupDirection (ioId           := 0         :: Integer
                                                                         , inCode         := 0         :: Integer
                                                                         , inName         := TRIM (inGroupStatName) :: TVarChar
                                                                         , inSession      := inSession :: TVarChar
                                                                          ) AS tmp);
     END IF;
     */
     
     
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupStat(), vbGoodsId, vbGroupStatId);

  
     IF vbUserId = 9457 OR vbUserId = 5
     THEN
           RAISE EXCEPTION '����. ��. <%> / <%>', vbGoodsId, vbGroupStatId; 
     END IF;   

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.03.25         *
*/

-- ����
--
