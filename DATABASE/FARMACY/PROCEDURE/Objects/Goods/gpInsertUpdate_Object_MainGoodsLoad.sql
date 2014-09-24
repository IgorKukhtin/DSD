-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MainGoodsLoad(Integer, TVarChar, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MainGoodsLoad(
    IN inCode                Integer  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDS                 TFloat     ,    -- ���

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
  DECLARE vbNDSKindId Integer;
  DECLARE vbUserId Integer;                                                                                               	
  DECLARE vbId Integer;
  DECLARE vbLinkId Integer;
BEGIN

    vbUserId := inSession;

    IF inNDS = 20 THEN 
       vbNDSKindId  := zc_Enum_NDSKind_Common();
    ELSE
       vbNDSKindId  := zc_Enum_NDSKind_Medical();
    END IF; 

       SELECT Object_Goods_Main_View.Id INTO vbId
         FROM Object_Goods_Main_View 
        WHERE Object_Goods_Main_View.GoodsCode = inCode;   

    PERFORM lpInsertUpdate_Object_Goods(vbId, inCode::TVarChar, inName, 0, inMeasureId, vbNDSKindId, 0, vbUserId);


END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MainGoodsLoad(Integer, TVarChar, Integer, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.14                        *
 30.07.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
