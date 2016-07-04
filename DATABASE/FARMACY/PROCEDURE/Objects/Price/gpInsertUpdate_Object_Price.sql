-- Function: gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price(
 INOUT ioId                       Integer   ,    -- ���� ������� < ���� >
 INOUT ioStartDate                TDateTime , 
    IN inPrice                    TFloat    ,    -- ����
    IN inMCSValue                 TFloat    ,    -- ����������� �������� �����
    IN inMCSPeriod                TFloat    ,    -- ���������� ���� ��� ������� ���
    IN inMCSDay                   TFloat    ,    -- ��������� ����� ���� ���
    IN inPercentMarkup            TFloat    ,    -- % �������
    IN inGoodsId                  Integer   ,    -- �����
    IN inUnitId                   Integer   ,    -- �������������
    IN inMCSIsClose               Boolean   ,    -- ��� ������
    IN inMCSNotRecalc             Boolean   ,    -- ��� �� ���������������
    IN inFix                      Boolean   ,    -- ������������� ����
    IN inisTop                    Boolean   ,    -- ��� �������
   OUT outDateChange              TDateTime ,    -- ���� ��������� ����
   OUT outMCSDateChange           TDateTime ,    -- ���� ��������� ������������ ��������� ������
   OUT outMCSIsCloseDateChange    TDateTime ,    -- ���� ��������� �������� "����� ���"
   OUT outMCSNotRecalcDateChange  TDateTime ,    -- ���� ��������� �������� "������������ ����"
   OUT outFixDateChange           TDateTime ,    -- ���� ��������� �������� "������������� ����"
   OUT outStartDate               TDateTime ,    -- ����
   OUT outTopDateChange           TDateTime ,    -- ���� ��������� �������� "��� �������"
   OUT outPercentMarkupDateChange TDateTime ,    -- ���� ��������� �������� % �������
    IN inSession                  TVarChar       -- ������ ������������
)
AS
$BODY$
    DECLARE
        vbUserId Integer;
        vbPrice TFloat;
        vbMCSValue TFloat;
        vbMCSIsClose Boolean;
        vbMCSNotRecalc Boolean;
        vbFix Boolean;
        vbTop Boolean;
        vbPercentMarkup TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    -- ��������� ������������ ����
    IF inPrice = 0
    THEN
        inPrice := null;
    END IF;
    IF inPrice is not null AND (inPrice<0)
    THEN
        RAISE EXCEPTION '������.���� <%> ������ ���� ������ 0.', inPrice;
    END IF;
    -- ��������� ������������ ����
    IF inMCSValue is not null AND (inMCSValue<0)
    THEN
        RAISE EXCEPTION '������.����������� �������� ����� <%> �� ����� ���� ������ 0.', inMCSValue;
    END IF;

    -- ���� ����� ������ ���� - ������� � ����� ����.-�����
    SELECT Id, 
           Price, 
           MCSValue, 
           DateChange, 
           MCSDateChange, 
           MCSIsClose, 
           MCSNotRecalc,
           Fix,
           isTop,
           PercentMarkup
      INTO ioId, 
           vbPrice, 
           vbMCSValue, 
           outDateChange, 
           outMCSDateChange,
           vbMCSIsClose, 
           vbMCSNotRecalc,
           vbFix,
           vbTop,
           vbPercentMarkup
    FROM Object_Price_View
    WHERE GoodsId = inGoodsId
      AND UnitId = inUnitID;

    -- ����� � ������ ���� ����
    IF COALESCE (inMCSPeriod, 0) = 0 OR COALESCE (inMCSDay, 0) = 0
    THEN
        SELECT ObjectHistoryFloat_MCSPeriod.ValueData
             , ObjectHistoryFloat_MCSDay.ValueData
               INTO inMCSPeriod, inMCSDay
        FROM ObjectHistory
             LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriod
                                          ON ObjectHistoryFloat_MCSPeriod.ObjectHistoryId = ObjectHistory.Id
                                         AND ObjectHistoryFloat_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
             LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSDay
                                          ON ObjectHistoryFloat_MCSDay.ObjectHistoryId = ObjectHistory.Id
                                         AND ObjectHistoryFloat_MCSDay.DescId = zc_ObjectHistoryFloat_Price_MCSDay() 
        WHERE ObjectHistory.ObjectId = @ioId
          AND ObjectHistory.EndDate  = zc_DateEnd() -- !!!�����, �� ����� ���������!!!
          AND ObjectHistory.DescId   = zc_ObjectHistory_Price()
       ;
    END IF;

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
        ioId := lpInsertUpdate_Object (ioId, zc_Object_Price(), 0, '');

        -- ��������� ����� � <�����>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), ioId, inGoodsId);

        -- ��������� ����� � <�������������>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), ioId, inUnitId);
    END IF;
    
    IF vbFix is null or (vbFix <> COALESCE(inFix,FALSE))
    THEN
        -- ��������� �������� <������������� ����>
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_Fix(), ioId, inFix);
        -- ��������� ���� ��������� <������������� ����>
        outFixDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_FixDateChange(), ioId, outFixDateChange);
    END IF;    

    IF vbTop is null or (vbTop <> COALESCE(inisTop,FALSE))
    THEN
        -- ��������� �������� <��� �������>
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_Top(), ioId, inisTop);
        -- ��������� ���� ��������� <��� �������>
        outTopDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_TopDateChange(), ioId, outTopDateChange);
    END IF;    

    -- ��������� ��-�� < ���� >
    IF (inPrice is not null) AND (inPrice <> COALESCE(vbPrice,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_Value(), ioId, inPrice);
        -- ��������� ��-�� < ���� ��������� >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_DateChange(), ioId, outDateChange);
    END IF;
    -- ��������� ��-�� < ����������� �������� ����� >
    IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), ioId, inMCSValue);
        -- ��������� ��-�� < ���� ��������� ������������ ��������� ������>
        outMCSDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), ioId, outMCSDateChange);
    END IF;

    -- ��������� ��-�� < % ������� >
    IF (inPercentMarkup is not null) AND (inPercentMarkup <> COALESCE(vbPercentMarkup,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_PercentMarkup(), ioId, inPercentMarkup);
        -- ��������� ��-�� < ���� ��������� >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_PercentMarkupDateChange(), ioId, outPercentMarkupDateChange);
    END IF;


    -- ��������� �������
    IF ((inPrice is not null) AND (inPrice <> COALESCE(vbPrice,0))) 
       OR
       ((inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0)))
       
    THEN
        -- ��������� �������
        PERFORM gpInsertUpdate_ObjectHistory_Price(
                ioId       := 0 :: Integer,    -- ���� ������� <������� ������� ������>
                inPriceId  := ioId,    -- �����
                inOperDate := CURRENT_TIMESTAMP                 :: TDateTime, -- ���� �������� ������
                inPrice    := COALESCE (inPrice, vbPrice)       :: TFloat,    -- ����
                inMCSValue := COALESCE (inMCSValue, vbMCSValue) :: TFloat,    -- ���
                inMCSPeriod:= COALESCE (inMCSPeriod, 0)         :: TFloat,    -- ���������� ���� ��� ������� ���
                inMCSDay   := COALESCE (inMCSDay, 0)            :: TFloat,    -- ��������� ����� ���� ���
                inSession  := inSession);
       -- ����������
       ioStartDate:= (SELECT MAX (StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = ioId AND DescId = zc_ObjectHistory_Price());
       outStartDate:= ioStartDate;

    END IF;
    IF (inMCSIsClose is not null) AND (COALESCE(vbMCSIsClose,False) <> inMCSIsClose)
    THEN
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSIsClose(), ioId, inMCSIsClose);
        outMCSIsCloseDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSIsCloseDateChange(), ioId, outMCSIsCloseDateChange);
    END IF;
    
    IF (inMCSNotRecalc is not null) AND (COALESCE(vbMCSNotRecalc,False) <> inMCSNotRecalc)
    THEN
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSNotRecalc(), ioId, inMCSNotRecalc);
        outMCSNotRecalcDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSNotRecalcDateChange(), ioId, outMCSNotRecalcDateChange);
    END IF;
    
    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 04.07.16         *
 22.12.15                                                         *
 29.08.15                                                         *
 08.06.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Price()
