-- Function: gpInsertUpdate_Object_PriceChange (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceChange(
 INOUT ioId                       Integer   ,    -- ���� ������� < ���� >
 INOUT ioStartDate                TDateTime , 
    IN inPriceChange              TFloat    ,    -- ����
    IN inFixValue                 TFloat    ,    -- 
    IN inPercentMarkup            TFloat    ,    -- % �������
    IN inGoodsId                  Integer   ,    -- �����
    IN inRetailId                 Integer   ,    -- �������������
   OUT outDateChange              TDateTime ,    -- ���� ��������� ����
   OUT outStartDate               TDateTime ,    -- ����
    IN inSession                  TVarChar       -- ������ ������������
)
AS
$BODY$
    DECLARE
        vbUserId Integer;
        vbPriceChange TFloat;
        vbFixValue TFloat;
        vbPercentMarkup TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    -- ��������� ������������ ����
    IF inPriceChange = 0
    THEN
        inPriceChange := null;
    END IF;
    IF inPriceChange is not null AND (inPriceChange < 0)
    THEN
        RAISE EXCEPTION '������.���� <%> ������ ���� ������ 0.', inPriceChange;
    END IF;

    -- ���� ����� ������ ���� - ������� � ����� ����.���� - �����
    SELECT Id, 
           PriceChange, 
           FixValue, 
           DateChange, 
           PercentMarkup,

      INTO ioId, 
           vbPriceChange, 
           vbFixValue, 
           outDateChange, 
           vbPercentMarkup,
    FROM (WITH tmp1 AS (SELECT Object_PriceChange.Id                        AS Id
                             , ROUND(PriceChange_Value.ValueData,2)::TFloat AS PriceChange
                             , ObjectFloat_FixValue.ValueData               AS FixValue
                             , PriceChange_Goods.ChildObjectId              AS GoodsId
                             , ObjectLink_PriceChange_Retail.ChildObjectId  AS RetailId
                             , PriceChange_datechange.valuedata             AS DateChange
                             , COALESCE(PriceChange_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                           FROM Object AS Object_PriceChange
                               INNER JOIN ObjectLink AS PriceChange_Goods
                                                     ON PriceChange_Goods.ObjectId = Object_PriceChange.Id
                                                    AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                                                    AND PriceChange_Goods.ChildObjectId = inGoodsId
                               INNER JOIN ObjectLink AS ObjectLink_PriceChange_Retail
                                                     ON ObjectLink_PriceChange_Retail.ObjectId = Object_PriceChange.Id
                                                    AND ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                                                    AND ObjectLink_PriceChange_Retail.ChildObjectId = inRetailId
                               LEFT JOIN ObjectFloat AS PriceChange_Value
                                                     ON PriceChange_Value.ObjectId = Object_PriceChange.Id
                                                    AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                               LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                     ON ObjectFloat_FixValue.ObjectId = Object_PriceChange.Id
                                                    AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
                               LEFT JOIN ObjectDate AS PriceChange_DateChange
                                                    ON PriceChange_DateChange.ObjectId = Object_PriceChange.Id
                                                   AND PriceChange_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                           WHERE  Object_PriceChange.DescId = zc_Object_PriceChange())
          SELECT * FROM tmp1) AS tmp;

    -- ��������� ������������ ������ �� ����
    IF ioStartDate > zc_DateStart()
    THEN
        IF EXISTS (SELECT 1 FROM ObjectHistory WHERE ObjectHistory.ObjectId = @ioId AND ObjectHistory.StartDate > ioStartDate)
        THEN
            RAISE EXCEPTION '������.������� �������� ������ �� <%>.�������� ���� ��������� �� ����� �������.', DATE ((SELECT MAX (ObjectHistory.StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = @ioId AND ObjectHistory.StartDate > ioStartDate));
        END IF;
    END IF;

    IF COALESCE(ioId,0)=0
    THEN
        -- ���������/�������� <������> �� ��
        ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceChange(), 0, '');

        -- ��������� ����� � <�����>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Goods(), ioId, inGoodsId);

        -- ��������� ����� � <�������������>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Retail(), ioId, inRetailId);
    END IF;
    
    -- ��������� ��-�� < ���� >
    IF (inPriceChange is not null) AND (inPriceChange <> COALESCE(vbPriceChange,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_Value(), ioId, inPriceChange);
        -- ��������� ��-�� < ���� ��������� >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_DateChange(), ioId, outDateChange);
    END IF;

    -- ��������� ��-�� < ����������� �������� ����� >
    IF (inFixValue is not null) AND (inFixValue <> COALESCE(vbFixValue,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_FixValue(), ioId, inFixValue);
        -- ��������� ��-�� < ���� ���������>
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_DateChange(), ioId, outDateChange);
    END IF;

    -- ��������� ��-�� < % ������� >
    IF (inPercentMarkup is not null) AND (inPercentMarkup <> COALESCE(vbPercentMarkup,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_PercentMarkup(), ioId, inPercentMarkup);
        -- ��������� ��-�� < ���� ��������� >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_DateChange(), ioId, outDateChange);
    END IF;


    -- ��������� �������
    IF ((inPriceChange is not null) AND (inPriceChange <> COALESCE(vbPriceChange,0))) 
       OR
       ((inFixValue is not null) AND (inFixValue <> COALESCE(vbFixValue,0)))
       
    THEN
        -- ��������� �������
        PERFORM gpInsertUpdate_ObjectHistory_PriceChange(ioId             := 0 :: Integer,    -- ���� ������� <������� �������>
                                                         inPriceChangeId  := ioId,    -- �����
                                                         inOperDate       := CURRENT_TIMESTAMP                       :: TDateTime, -- ���� �������� ������
                                                         inPriceChange    := COALESCE (inPriceChange, vbPriceChange) :: TFloat,    -- ����
                                                         inFixValue       := COALESCE (inFixValue, vbFixValue)       :: TFloat,
                                                         inPercentMarkup:= COALESCE (inPercentMarkup, 0)             :: TFloat,
                                                         inSession  := inSession);
       -- ����������
       ioStartDate:= (SELECT MAX (StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = ioId AND DescId = zc_ObjectHistory_PriceChange());
       outStartDate:= ioStartDate;

    END IF;

    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 16.08.18         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PriceChange()
