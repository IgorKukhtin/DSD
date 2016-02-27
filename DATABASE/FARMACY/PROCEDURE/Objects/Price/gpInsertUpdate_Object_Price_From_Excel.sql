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
      vbMCSValue TFloat;
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
    SELECT Id, Price, MCSValue
      INTO vbId, vbPriceValue, vbMCSValue
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
        --��������� �������
        PERFORM
            gpInsertUpdate_ObjectHistory_Price(
                ioId       := 0::Integer,    -- ���� ������� <������� ������� ������>
                inPriceId  := vbId,    -- �����
                inOperDate := CURRENT_TIMESTAMP::TDateTime,  -- ���� �������� ������
                inPrice    := inPriceValue::TFloat,     -- ����
                inMCSValue := vbMCSValue::TFloat,       -- ���
                inMCSPeriod:= COALESCE (ObjectHistoryFloat_MCSPeriod.ValueData, 0) :: TFloat,  -- ���������� ���� ��� ������� ���
                inMCSDay   := COALESCE (ObjectHistoryFloat_MCSDay.ValueData, 0)    :: TFloat,  -- ��������� ����� ���� ���
                inSession  := inSession)
         FROM (SELECT vbId AS Id) AS tmp
             LEFT JOIN ObjectHistory ON ObjectHistory.ObjectId = tmp.Id
                                    AND ObjectHistory.EndDate  = zc_DateEnd() -- !!!�����, �� ����� ���������!!!
                                    AND ObjectHistory.DescId   = zc_ObjectHistory_Price()
             LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriod
                                          ON ObjectHistoryFloat_MCSPeriod.ObjectHistoryId = ObjectHistory.Id
                                         AND ObjectHistoryFloat_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
             LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSDay
                                          ON ObjectHistoryFloat_MCSDay.ObjectHistoryId = ObjectHistory.Id
                                         AND ObjectHistoryFloat_MCSDay.DescId = zc_ObjectHistoryFloat_Price_MCSDay() 
         ;

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
-- SELECT * FROM gpInsertUpdate_Object_Price_From_Excel()
