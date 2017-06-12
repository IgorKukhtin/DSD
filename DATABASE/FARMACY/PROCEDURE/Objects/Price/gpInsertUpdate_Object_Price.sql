-- Function: gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price(
 INOUT ioId                       Integer   ,    -- ���� ������� < ���� >
 INOUT ioStartDate                TDateTime , 
    IN inPrice                    TFloat    ,    -- ����
    IN inMCSValue                 TFloat    ,    -- ����������� �������� �����
    IN inMCSPeriod                TFloat    ,    -- ���������� ���� ��� ������� ���
    IN inMCSDay                   TFloat    ,    -- ��������� ����� ���� ���
    IN inPercentMarkup            TFloat    ,    -- % �������
    IN inDays                     TFloat    ,    -- ���-�� ���� ������� ���
    IN inGoodsId                  Integer   ,    -- �����
    IN inUnitId                   Integer   ,    -- �������������
    IN inMCSIsClose               Boolean   ,    -- ��� ������
    IN inMCSNotRecalc             Boolean   ,    -- ��� �� ���������������
    IN inFix                      Boolean   ,    -- ������������� ����
    IN inisTop                    Boolean   ,    -- ��� �������
    IN inisMCSAuto                Boolean   ,    -- ����� - ��� �������� ��������� �� ������
   OUT outisMCSAuto               Boolean   ,    -- ����� - ��� �������� ��������� �� ������

   OUT outDateChange              TDateTime ,    -- ���� ��������� ����
   OUT outMCSDateChange           TDateTime ,    -- ���� ��������� ������������ ��������� ������
   OUT outMCSIsCloseDateChange    TDateTime ,    -- ���� ��������� �������� "����� ���"
   OUT outMCSNotRecalcDateChange  TDateTime ,    -- ���� ��������� �������� "������������ ����"
   OUT outFixDateChange           TDateTime ,    -- ���� ��������� �������� "������������� ����"
   OUT outStartDate               TDateTime ,    -- ����
   OUT outTopDateChange           TDateTime ,    -- ���� ��������� �������� "��� �������"
   OUT outPercentMarkupDateChange TDateTime ,    -- ���� ��������� �������� % �������

   OUT outMCSValueOld             TFloat    ,    -- ��� - �������� ������� �������� �� ��������� �������
   OUT outStartDateMCSAuto        TDateTime ,    -- ���� ���. �������
   OUT outEndDateMCSAuto          TDateTime ,    -- ���� �����. �������
   OUT outisMCSNotRecalcOld       Boolean   ,    -- ������������ ���� - �������� ������� �������� �� ��������� �������

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
        vbDate TDateTime;
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

    IF COALESCE (inisMCSAuto,False) = True AND COALESCE (inDays,0) = 0
    THEN
        RAISE EXCEPTION '������.���-�� ���� ��� ������� ������ ���� ������ 0.';
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
           PercentMarkup,
           MCSValueOld,
           StartDateMCSAuto,
           EndDateMCSAuto,
           isMCSNotRecalcOld,
           isMCSAuto
      INTO ioId, 
           vbPrice, 
           vbMCSValue, 
           outDateChange, 
           outMCSDateChange,
           vbMCSIsClose, 
           vbMCSNotRecalc,
           vbFix,
           vbTop,
           vbPercentMarkup,
           outMCSValueOld,
           outStartDateMCSAuto,
           outEndDateMCSAuto,
           outisMCSNotRecalcOld,
           outisMCSAuto
    FROM (WITH tmp1 AS (SELECT
        Object_Price.Id                         AS Id
      , ROUND(Price_Value.ValueData,2)::TFloat AS Price
      , MCS_Value.ValueData                     AS MCSValue

      , Price_Goods.ChildObjectId               AS GoodsId

      , ObjectLink_Price_Unit.ChildObjectId     AS UnitId

      , price_datechange.valuedata              AS DateChange
      , MCS_datechange.valuedata                AS MCSDateChange
      
      , COALESCE(MCS_isClose.ValueData,False)   AS MCSIsClose
      , MCSIsClose_DateChange.valuedata         AS MCSIsCloseDateChange

      , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
      , MCSNotRecalc_DateChange.valuedata       AS MCSNotRecalcDateChange
      
      , COALESCE(Price_Fix.ValueData,False)     AS Fix
      , Fix_DateChange.valuedata                AS FixDateChange

      , COALESCE(Price_Top.ValueData,False)     AS isTop
      , Price_TOPDateChange.ValueData           AS TopDateChange

      , COALESCE(Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
      , Price_PercentMarkupDateChange.ValueData             AS PercentMarkupDateChange

      , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat AS MCSValueOld
      , MCS_StartDateMCSAuto.ValueData                      AS StartDateMCSAuto
      , MCS_EndDateMCSAuto.ValueData                        AS EndDateMCSAuto
      , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
      , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld
    FROM Object AS Object_Price
        INNER JOIN ObjectLink       AS Price_Goods
                                    ON Price_Goods.ObjectId = Object_Price.Id
                                   AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   AND Price_Goods.ChildObjectId = inGoodsId

        INNER JOIN ObjectLink       AS ObjectLink_Price_Unit
                                    ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                                   AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                   AND ObjectLink_Price_Unit.ChildObjectId = inUnitId

        LEFT JOIN ObjectFloat       AS Price_Value
                                    ON Price_Value.ObjectId = Object_Price.Id
                                   AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
        LEFT JOIN ObjectDate        AS Price_DateChange
                                    ON Price_DateChange.ObjectId = Object_Price.Id
                                   AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
        LEFT JOIN ObjectFloat       AS MCS_Value
                                    ON MCS_Value.ObjectId = Object_Price.Id
                                   AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
        LEFT JOIN ObjectFloat       AS Price_MCSValueOld
                                    ON Price_MCSValueOld.ObjectId = Object_Price.Id
                                   AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()

        LEFT JOIN ObjectDate        AS MCS_DateChange
                                    ON MCS_DateChange.ObjectId = Object_Price.Id
                                   AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()

        LEFT JOIN ObjectDate        AS MCS_StartDateMCSAuto
                                    ON MCS_StartDateMCSAuto.ObjectId = Object_Price.Id
                                   AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
        LEFT JOIN ObjectDate        AS MCS_EndDateMCSAuto
                                    ON MCS_EndDateMCSAuto.ObjectId = Object_Price.Id
                                   AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()
                                   
        LEFT JOIN ObjectBoolean      AS MCS_isClose
                                    ON MCS_isClose.ObjectId = Object_Price.Id
                                   AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
        LEFT JOIN ObjectDate        AS MCSIsClose_DateChange
                                    ON MCSIsClose_DateChange.ObjectId = Object_Price.Id
                                   AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()
        LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                                    ON MCS_NotRecalc.ObjectId = Object_Price.Id
                                   AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
        LEFT JOIN ObjectDate        AS MCSNotRecalc_DateChange
                                    ON MCSNotRecalc_DateChange.ObjectId = Object_Price.Id
                                   AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
        LEFT JOIN ObjectBoolean     AS Price_Fix
                                    ON Price_Fix.ObjectId = Object_Price.Id
                                   AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
        LEFT JOIN ObjectDate        AS Fix_DateChange
                                    ON Fix_DateChange.ObjectId = Object_Price.Id
                                   AND Fix_DateChange.DescId = zc_ObjectDate_Price_FixDateChange()
        LEFT JOIN ObjectBoolean     AS Price_Top
                                    ON Price_Top.ObjectId = Object_Price.Id
                                   AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
        LEFT JOIN ObjectDate        AS Price_TOPDateChange
                                    ON Price_TOPDateChange.ObjectId = Object_Price.Id
                                   AND Price_TOPDateChange.DescId = zc_ObjectDate_Price_TOPDateChange()     

        LEFT JOIN ObjectFloat       AS Price_PercentMarkup                                                      ON Price_PercentMarkup.ObjectId = Object_Price.Id
                                   AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
        LEFT JOIN ObjectDate        AS Price_PercentMarkupDateChange
                                    ON Price_PercentMarkupDateChange.ObjectId = Object_Price.Id
                                   AND Price_PercentMarkupDateChange.DescId = zc_ObjectDate_Price_PercentMarkupDateChange()    

        LEFT JOIN ObjectBoolean     AS Price_MCSAuto
                                    ON Price_MCSAuto.ObjectId = Object_Price.Id
                                   AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
        LEFT JOIN ObjectBoolean     AS Price_MCSNotRecalcOld
                                    ON Price_MCSNotRecalcOld.ObjectId = Object_Price.Id
                                   AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()
       WHERE  Object_Price.DescId = zc_Object_Price())

          SELECT  * FROM tmp1) AS tmp;


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

    -- ����� �������� ��� �� ���.����
    IF COALESCE (inisMCSAuto,False) = True
    THEN
        vbDate := CURRENT_DATE - INTERVAL '1 DAY';
        SELECT ObjectHistoryFloat_MCSValue.ValueData
      INTO outMCSValueOld
        FROM ObjectHistory
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValue
                                             ON ObjectHistoryFloat_MCSValue.ObjectHistoryId = ObjectHistory.Id
                                            AND ObjectHistoryFloat_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()                
        WHERE ObjectHistory.ObjectId = @ioId
          AND ObjectHistory.DescId   = zc_ObjectHistory_Price()
          AND vbDate >= ObjectHistory.StartDate AND CURRENT_DATE < ObjectHistory.EndDate
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
    IF COALESCE (inisMCSAuto,False) = False                 
    THEN
        IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
        THEN
            PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), ioId, inMCSValue);
            -- ��������� ��-�� < ���� ��������� ������������ ��������� ������>
            outMCSDateChange := CURRENT_DATE;
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), ioId, outMCSDateChange);
        END IF;
    ELSE
        IF (inMCSValue is not null) --AND (inMCSValue <> COALESCE(vbMCSValue,0))
        THEN
            -- ��������� �������� <��� ��� �������>
            PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSAuto(), ioId, inisMCSAuto);
            outisMCSAuto := inisMCSAuto;

            -- ��������� ������ �������� ���
            PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValueOld(), ioId, outMCSValueOld);

            ---
            PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), ioId, inMCSValue);
            -- ��������� ��-�� < ���� ��������� ������������ ��������� ������>
            outMCSDateChange := CURRENT_DATE;
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), ioId, outMCSDateChange);

            --
            outStartDateMCSAuto := CURRENT_DATE;
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_StartDateMCSAuto(), ioId, outStartDateMCSAuto);
            --
            outEndDateMCSAuto := outStartDateMCSAuto + (inDays || ' DAY') :: INTERVAL; 
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_EndDateMCSAuto(), ioId, outEndDateMCSAuto);
            --
            outisMCSNotRecalcOld := vbMCSNotRecalc;
            PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSNotRecalcOld(), ioId, outisMCSNotRecalcOld);
        END IF;
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
 09.06.17         *
 04.07.16         *
 22.12.15                                                         *
 29.08.15                                                         *
 08.06.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Price()
