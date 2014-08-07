-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MainGoodsLoad(Integer, Integer, TVarChar, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MainGoodsLoad(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                Integer   ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDS                 TFloat     ,    -- ���

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS integer AS
$BODY$
  DECLARE vbNDSKindId Integer;
  DECLARE vbUserId Integer;
BEGIN

    vbUserId := inSession;

    IF inNDS = 20 THEN 
       vbNDSKindId  := zc_Enum_NDSKind_Common();
    ELSE
       vbNDSKindId  := zc_Enum_NDSKind_Medical();
    END IF; 

    IF COALESCE(ioId, 0) = 0 THEN
       SELECT Object_Goods_View.Id INTO ioId
         FROM Object_Goods_View 
        WHERE Object_Goods_View.ObjectId IS NULL
          AND Object_Goods_View.GoodsCode = inCode::TVarChar;   
    END IF; 

    ioId := lpInsertUpdate_Object_Goods(ioId, inCode::TVarChar, inName, 0, inMeasureId, vbNDSKindId, 0, 0, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MainGoodsLoad(Integer, Integer, TVarChar, Integer, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.07.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
