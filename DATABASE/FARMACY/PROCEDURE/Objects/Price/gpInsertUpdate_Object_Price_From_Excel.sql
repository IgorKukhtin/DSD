-- Function: gpInsertUpdate_Object_Price_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price_From_Excel (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price_From_Excel(
    IN inUnitId     Integer, -- ID �������������
    IN inGoodsCode  Integer, -- Code �����
    IN inPriceValue   TFloat,  -- ����
    IN inSession    TVarChar -- ������ ������������
)
RETURNS VOID AS
$BODY$
    DECLARE
      vbUserId Integer;
      vbGoodsId Integer;
      vbObjectId Integer;
      vbId Integer;
      vbPriceValue TFloat;
BEGIN
    vbUserId := lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    vbGoodsId := 0;
    IF COALESCE(inUnitId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� �������������';
    END IF;
    --�������� ����� �� ����
    Select Id INTO vbGoodsId from Object_Goods_View Where ObjectId = vbObjectId AND GoodsCodeInt = inGoodsCode;
    --���������, � ���� �� ����� ����� � ����
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION '������. � ���� ������ �� ������ ����� � ����� <%>', inGoodsCode;
    END IF;
    
    IF inPriceValue is not null AND (inPriceValue<0)
    THEN
        RAISE EXCEPTION '������. ���� <%> �� ����� ���� ������ ����.', inPriceValue;
    END IF;
   
    -- ���� ����� ������ ���� - ������� �
    SELECT Id, Price
      INTO vbId, vbPriceValue
    from Object_Price_View
    Where
        GoodsId = vbGoodsId
        AND
        UnitId = inUnitID;
    IF COALESCE(vbId,0)=0
    THEN
        -- ���������/�������� <������> �� ��
        vbId := lpInsertUpdate_Object (0, zc_Object_Price(), 0, '');
        -- ��������� ����� � <�����>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), vbId, vbGoodsId);
        -- ��������� ����� � <�������������>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), vbId, inUnitId);
    END IF;
    -- ��������� ��-�� < ���� >
    IF (inPriceValue is not null) AND (inPriceValue <> COALESCE(vbPriceValue,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_Value(), vbId, inPriceValue);
        -- ��������� ��-�� < ���� ��������� ����>
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_DateChange(), vbId, CURRENT_DATE);
    END IF;
    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Price_From_Excel (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 27.07.15                                                           *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Price()
