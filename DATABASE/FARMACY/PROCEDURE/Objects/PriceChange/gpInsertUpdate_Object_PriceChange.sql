-- Function: gpInsertUpdate_Object_PriceChange (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceChange(
 INOUT ioId                       Integer   ,    -- ���� ������� < ���� >
    IN inGoodsId                  Integer   ,    -- �����
    IN inRetailId                 Integer   ,    -- ����. ����
    IN inUnitId                   Integer   ,    -- �������������
 INOUT ioStartDate                TDateTime , 
   OUT outDateChange              TDateTime ,    -- ���� ��������� ����
   OUT outStartDate               TDateTime ,    -- ����
   OUT outPriceChange             TFloat    ,    -- ����
    IN inFixValue                 TFloat    ,    -- 
    IN inFixPercent               TFloat    ,    -- 
    IN inPercentMarkup            TFloat    ,    -- % �������
    IN inSession                  TVarChar       -- ������ ������������
)
AS
$BODY$
    DECLARE
        vbUserId Integer;
        vbPriceChange TFloat;
        vbFixValue TFloat;
        vbFixPercent TFloat;
        vbPercentMarkup TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    
/*    -- ��������� ������������ ����
    IF inPriceChange = 0
    THEN
        inPriceChange := null;
    END IF;
    IF inPriceChange is not null AND (inPriceChange < 0)
    THEN
        RAISE EXCEPTION '������.���� <%> ������ ���� ������ 0.', inPriceChange;
    END IF;
*/
    -- ��������
    IF COALESCE (inRetailId, 0) <> 0 AND COALESCE (inUnitId, 0) <> 0
    THEN
         RAISE EXCEPTION '������.������ ���� ������ ���� �� ���������� ����.���� ��� �������������';
    END IF;

    -- ���� ����� ������ ���� - ������� � ����� ����.���� - ����� ��� ������������� - �����
    SELECT Id, 
           PriceChange, 
           FixValue, 
           DateChange, 
           PercentMarkup,
           FixPercent

      INTO ioId, 
           vbPriceChange, 
           vbFixValue, 
           outDateChange, 
           vbPercentMarkup,
           vbFixPercent
    FROM (WITH tmp1 AS (SELECT Object_PriceChange.Id                        AS Id
                             , ROUND(ObjectFloat_Value.ValueData,2)::TFloat AS PriceChange
                             , ObjectFloat_FixValue.ValueData               AS FixValue
                             , ObjectFloat_FixPercent.ValueData             AS FixPercent
                             , PriceChange_Goods.ChildObjectId              AS GoodsId
                             , ObjectLink_Retail.ChildObjectId              AS RetailId
                             , ObjectDate_DateChange.valuedata              AS DateChange
                             , COALESCE(ObjectFloat_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                        FROM Object AS Object_PriceChange
                            INNER JOIN ObjectLink AS PriceChange_Goods
                                                  ON PriceChange_Goods.ObjectId = Object_PriceChange.Id
                                                 AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                                                 AND PriceChange_Goods.ChildObjectId = inGoodsId
                            LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                 ON ObjectLink_Retail.ObjectId = Object_PriceChange.Id
                                                AND ObjectLink_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId = Object_PriceChange.Id
                                                AND ObjectLink_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = Object_PriceChange.Id
                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                            LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                  ON ObjectFloat_FixValue.ObjectId = Object_PriceChange.Id
                                                 AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
                            LEFT JOIN ObjectFloat AS ObjectFloat_FixPercent
                                                  ON ObjectFloat_FixPercent.ObjectId = Object_PriceChange.Id
                                                 AND ObjectFloat_FixPercent.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                            LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                                  ON ObjectFloat_PercentMarkup.ObjectId = Object_PriceChange.Id
                                                 AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()
                            LEFT JOIN ObjectDate AS ObjectDate_DateChange
                                                 ON ObjectDate_DateChange.ObjectId = Object_PriceChange.Id
                                                AND ObjectDate_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                        WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
                          AND ((ObjectLink_Retail.ChildObjectId = inRetailId AND inRetailId <> 0)
                            OR (ObjectLink_Unit.ChildObjectId = inUnitId AND inUnitId <> 0)
                              )
                       )
          -- 
          SELECT * FROM tmp1
         ) AS tmp;


    -- ������ ���� �� �������
    IF COALESCE (inFixValue, 0) <> 0
    THEN
        -- ��������� - ������������� ����
        outPriceChange := inFixValue;
    ELSEIF COALESCE (inFixValue, 0) = 0 AND COALESCE (inPercentMarkup, 0) = 0
    THEN
        -- � ���� ������ - ��������, ���� �������
        outPriceChange := 0;
    ELSE
        -- ����� ��������� �������� ����� ����
        outPriceChange := vbPriceChange;
    END IF;


    -- ��������� ������������ ������ �� ����
    IF ioStartDate > zc_DateStart()
    THEN
        IF EXISTS (SELECT 1 FROM ObjectHistory WHERE ObjectHistory.ObjectId = @ioId AND ObjectHistory.StartDate > ioStartDate)
        THEN
            RAISE EXCEPTION '������.������� �������� ������ �� <%>.�������� ���� ��������� �� ����� �������.', DATE ((SELECT MAX (ObjectHistory.StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = @ioId AND ObjectHistory.StartDate > ioStartDate));
        END IF;
    END IF;

    -- ���� �� ����� - ��������
    IF COALESCE (ioId, 0) = 0
    THEN
        -- ��������
        ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceChange(), 0, '');

        -- ��������� ����� � <�����>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Goods(), ioId, inGoodsId);

        -- ��������� ���� �� ������� 
        IF COALESCE(inRetailId, 0) <> 0
        THEN
            -- ��������� ����� � <�������� ���� >
            PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Retail(), ioId, inRetailId);
        END IF;
        IF COALESCE(inUnitId, 0) <> 0
        THEN
            -- ��������� ����� � <�������������>
            PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Unit(), ioId, inUnitId);
        END IF;
    END IF;
    
    -- ��������� ��-�� <��������� ����>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_Value(), ioId, outPriceChange);
    -- ��������� ��-�� <������������� ����>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_FixValue(), ioId, inFixValue);
    -- ��������� ��-�� <������������� % ������>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_FixPercent(), ioId, inFixPercent);
    -- ��������� ��-�� <% ������� >
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_PercentMarkup(), ioId, inPercentMarkup);


    -- ��������� �������
    IF  COALESCE (inPercentMarkup, 0) <> COALESCE (vbPercentMarkup, 0)
     OR COALESCE (inFixValue, 0)      <> COALESCE (vbFixValue, 0)
     OR COALESCE (inFixPercent, 0)    <> COALESCE (vbFixPercent, 0)
    THEN
        -- ��������� ��-�� < ���� ��������� >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_DateChange(), ioId, outDateChange);

        -- ��������� �������
        PERFORM gpInsertUpdate_ObjectHistory_PriceChange(ioId             := 0 :: Integer,    -- ���� ������� <������� �������>
                                                         inPriceChangeId  := ioId,    -- �����
                                                         inOperDate       := CURRENT_TIMESTAMP                       :: TDateTime, -- ���� �������� ������
                                                         inPriceChange    := COALESCE (outPriceChange, vbPriceChange) :: TFloat,    -- ����
                                                         inFixValue       := COALESCE (inFixValue, vbFixValue)       :: TFloat,
                                                         inFixPercent     := COALESCE (inFixPercent, vbFixPercent)   :: TFloat,
                                                         inPercentMarkup  := COALESCE (inPercentMarkup, 0)           :: TFloat,
                                                         inSession        := inSession
                                                        );

        -- ��������� ��������
        PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

    END IF;

    -- ����������
    ioStartDate:= (SELECT MAX (StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = ioId AND DescId = zc_ObjectHistory_PriceChange());
    outStartDate:= ioStartDate;

    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 08.02.19         *
 16.08.18         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PriceChange()
