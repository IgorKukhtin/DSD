-- Function: gpInsertUpdate_Object_MCS_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MCS_From_Excel (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MCS_From_Excel(
    IN inUnitId     Integer, -- ID �������������
    IN inGoodsCode  Integer, -- Code �����
    IN inMCSValue   TFloat,  -- ����������� �������� �����
    IN inSession    TVarChar -- ������ ������������
)
RETURNS VOID AS
$BODY$
    DECLARE
        vbUserId Integer;
        vbGoodsId Integer;
        vbObjectId Integer;
        vbId Integer;
        vbMCSValue TFloat;
        vbPrice TFloat;
BEGIN
    vbUserId := lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    vbGoodsId := 0;
    IF COALESCE(inUnitId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� �������������';
    END IF;
    --�������� ����� �� ����
    Select 
        ID 
    INTO 
        vbGoodsId 
    FROM 
        Object_Goods_View 
    WHERE 
        ObjectId = vbObjectId 
        AND 
        GoodsCodeInt = inGoodsCode;
    --���������, � ���� �� ����� ����� � ����
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION '������. � ���� ������ �� ������ ����� � ����� <%>', inGoodsCode;
    END IF;
    
    IF inMCSValue is not null AND (inMCSValue<0)
    THEN
        RAISE EXCEPTION '������.����������� �������� ����� <%> �� ����� ���� ������ ����.', inMCSValue;
    END IF;
   
    -- ���� ����� ������ ���� - ������� �
    SELECT 
        Id, 
        MCSValue,
        Price
    INTO 
        vbId, 
        vbMCSValue,
        vbPrice
    FROM 
        Object_Price_View
    WHERE
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
    -- ��������� ��-�� < ����������� �������� ����� >
    IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), vbId, inMCSValue);
        -- ��������� ��-�� < ���� ��������� ������������ ��������� ������>
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), vbId, CURRENT_DATE);
        -- ��������� �������
        PERFORM
            gpInsertUpdate_ObjectHistory_Price(
                ioId       := 0::Integer,    -- ���� ������� <������� ������� ������>
                inPriceId  := vbId,    -- �����
                inOperDate := CURRENT_TIMESTAMP::TDateTime,  -- ���� �������� ������
                inPrice    := vbPrice::TFloat,     -- ����
                inMCSValue := inMCSValue::TFloat,     -- ���
                inSession  := inSession);
    END IF;
    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MCS_From_Excel (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 27.07.15                                                           *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Price()
