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
    SELECT ObjectLink_Price_Unit.ObjectId          AS Id
         , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
         , MCS_Value.ValueData                     AS MCSValue 
   INTO vbId, vbPrice, vbMCSValue
    FROM ObjectLink AS ObjectLink_Price_Unit
         INNER JOIN ObjectLink AS Price_Goods
                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                AND Price_Goods.ChildObjectId = vbGoodsId
         LEFT JOIN ObjectFloat AS Price_Value
                ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
               AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
         LEFT JOIN ObjectFloat AS MCS_Value
                ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
               AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
    WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
      AND ObjectLink_Price_Unit.ChildObjectId = inUnitId;

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
                inMCSValue := inMCSValue::TFloat,  -- ���
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
ALTER FUNCTION gpInsertUpdate_Object_MCS_From_Excel (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 12.06.17         * ������ Object_Price_View
 27.07.15                                                           *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MCS_From_Excel()
