-- Function: gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price(
 INOUT ioId                       Integer   ,    -- ���� ������� < ���� >
 INOUT ioStartDate                TDateTime , 
    IN inPrice                    TFloat    ,    -- ����
    IN inMCSValue                 TFloat    ,    -- ����������� �������� �����
    IN inMCSValueSun              TFloat    ,    -- ����������� �������� ����� ��� ���
    IN inMCSValue_min             TFloat    ,    -- ���. ����������� �������� �����
    IN inMCSPeriod                TFloat    ,    -- ���������� ���� ��� ������� ���
    IN inMCSDay                   TFloat    ,    -- ��������� ����� ���� ���
    IN inPercentMarkup            TFloat    ,    -- % �������
    IN inDays                     TFloat    ,    -- ���-�� ���� ������� ���
    IN inGoodsId                  Integer   ,    -- �����
    IN inUnitId                   Integer   ,    -- �������������
    IN inMCSIsClose               Boolean   ,    -- ��� ������
 INOUT ioMCSNotRecalc             Boolean   ,    -- ��� �� ���������������
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
        vbUserId       Integer;
        vbPrice        TFloat;
        vbMCSValue     TFloat;
        vbMCSValueSun  TFloat;
        vbMCSValue_min TFloat;
        vbMCSIsClose   Boolean;
        vbMCSNotRecalc Boolean;
        vbFix          Boolean;
        vbTop          Boolean;
        vbPercentMarkup TFloat;
        vbDate         TDateTime;
    DECLARE vbIsMCSAuto_old  Boolean;
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
    IF inMCSValue is not null AND (inMCSValue<0) OR inMCSValueSun is not null AND (inMCSValueSun<0)
    THEN
        RAISE EXCEPTION '������.����������� �������� ����� <%> �� ����� ���� ������ 0.', inMCSValue;
    END IF;

    IF COALESCE (inisMCSAuto,False) = True AND COALESCE (inDays,0) = 0
    THEN
        RAISE EXCEPTION '������.���-�� ���� ��� ������� ������ ���� ������ 0.';
    END IF;    
    
    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
       AND COALESCE (inDays, 0) > 7
    THEN
      RAISE EXCEPTION '������. ���-�� ���� ��� ������� ������ ���� �� ����� 7.';     
    END IF;         

    -- ��������� ������������ ����
    IF COALESCE (inMCSValue_min, 0) > COALESCE (inMCSValue, 0)
    THEN
        RAISE EXCEPTION '������.��� ���. <%> �� ����� ���� ������ ��� <%>. ���������� <%>', inMCSValue_min, inMCSValue, 
          (SELECT ValueData FROM Object WHERE ID = inGoodsId);
    END IF;
    
    -- ���� ����� ������ ���� - ������� � ����� ����.-�����
    SELECT Id, 
           Price, 
           MCSValue, 
           MCSValueSun, 
           DateChange, 
           MCSDateChange, 
           MCSIsClose, 
           MCSNotRecalc,
           Fix,
           isTop,
           PercentMarkup,
           MCSValueOld,
           MCSValue_min,
           StartDateMCSAuto,
           EndDateMCSAuto,
           isMCSNotRecalcOld,
           isMCSAuto, isMCSAuto
      INTO ioId, 
           vbPrice, 
           vbMCSValue, 
           vbMCSValueSun, 
           outDateChange, 
           outMCSDateChange,
           vbMCSIsClose, 
           vbMCSNotRecalc,
           vbFix,
           vbTop,
           vbPercentMarkup,
           outMCSValueOld,
           vbMCSValue_min,
           outStartDateMCSAuto,
           outEndDateMCSAuto,
           outisMCSNotRecalcOld,
           outisMCSAuto, vbIsMCSAuto_old
    FROM (WITH tmp1 AS (SELECT Object_Price.Id                         AS Id
                             , ROUND(Price_Value.ValueData,2)::TFloat AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , MCS_ValueSun.ValueData                  AS MCSValueSun
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                             , price_datechange.valuedata              AS DateChange
                             , MCS_datechange.valuedata                AS MCSDateChange
                             , COALESCE(MCS_isClose.ValueData,False)   AS MCSIsClose
                             , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
                             , COALESCE(Price_Fix.ValueData,False)     AS Fix
                             , COALESCE(Price_Top.ValueData,False)     AS isTop
                             , COALESCE(Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                             , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat AS MCSValueOld
                             , COALESCE(MCS_Value_min.ValueData, 0)       ::TFloat AS MCSValue_min
                             , MCS_StartDateMCSAuto.ValueData                      AS StartDateMCSAuto
                             , MCS_EndDateMCSAuto.ValueData                        AS EndDateMCSAuto
                             , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
                             , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld
                           FROM Object AS Object_Price
                               INNER JOIN ObjectLink AS Price_Goods
                                                     ON Price_Goods.ObjectId = Object_Price.Id
                                                    AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                    AND Price_Goods.ChildObjectId = inGoodsId
                               INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                     ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                                                    AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                    AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = Object_Price.Id
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                               LEFT JOIN ObjectDate AS Price_DateChange
                                                    ON Price_DateChange.ObjectId = Object_Price.Id
                                                   AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
                               LEFT JOIN ObjectFloat AS MCS_Value
                                                     ON MCS_Value.ObjectId = Object_Price.Id
                                                    AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                               LEFT JOIN ObjectFloat AS MCS_ValueSun
                                                     ON MCS_ValueSun.ObjectId = Object_Price.Id
                                                    AND MCS_ValueSun.DescId = zc_ObjectFloat_Price_MCSValueSun()
                               LEFT JOIN ObjectFloat AS MCS_Value_min
                                                     ON MCS_Value_min.ObjectId = Object_Price.Id
                                                    AND MCS_Value_min.DescId = zc_ObjectFloat_Price_MCSValueMin()
                               LEFT JOIN ObjectFloat AS Price_MCSValueOld
                                                     ON Price_MCSValueOld.ObjectId = Object_Price.Id
                                                    AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()
                               LEFT JOIN ObjectDate AS MCS_DateChange
                                                    ON MCS_DateChange.ObjectId = Object_Price.Id
                                                   AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                               LEFT JOIN ObjectDate AS MCS_StartDateMCSAuto
                                                    ON MCS_StartDateMCSAuto.ObjectId = Object_Price.Id
                                                   AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
                               LEFT JOIN ObjectDate AS MCS_EndDateMCSAuto
                                                    ON MCS_EndDateMCSAuto.ObjectId = Object_Price.Id
                                                   AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()
                               LEFT JOIN ObjectBoolean AS MCS_isClose
                                                       ON MCS_isClose.ObjectId = Object_Price.Id
                                                      AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                               LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                       ON MCS_NotRecalc.ObjectId = Object_Price.Id
                                                      AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                               LEFT JOIN ObjectBoolean AS Price_Fix
                                                       ON Price_Fix.ObjectId = Object_Price.Id
                                                      AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                               LEFT JOIN ObjectBoolean AS Price_Top
                                                       ON Price_Top.ObjectId = Object_Price.Id
                                                      AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                               LEFT JOIN ObjectFloat AS Price_PercentMarkup                                                   
                                                     ON Price_PercentMarkup.ObjectId = Object_Price.Id
                                                    AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                               LEFT JOIN ObjectBoolean AS Price_MCSAuto
                                                       ON Price_MCSAuto.ObjectId = Object_Price.Id
                                                      AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                               LEFT JOIN ObjectBoolean AS Price_MCSNotRecalcOld
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
    IF COALESCE (inisMCSAuto, FALSE) = FALSE
    THEN
        IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
        THEN
            PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), ioId, inMCSValue);
            -- ��������� ��-�� < ���� ��������� ������������ ��������� ������>
            outMCSDateChange := CURRENT_DATE;
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), ioId, outMCSDateChange);
        END IF;
    ELSE
        --  !!!������!!!
        IF 1=1
        THEN
            -- ��������� �������� <��� ��� �������>
            PERFORM lpInsertUpdate_objectBoolean (zc_ObjectBoolean_Price_MCSAuto(), ioId, inisMCSAuto);
            outisMCSAuto := COALESCE (inisMCSAuto,False) ;

            -- !!!������ � ���� ������!!!
            IF COALESCE (vbIsMCSAuto_old, FALSE) = FALSE
            THEN
                -- ��������� ������ �������� ���
                PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_Price_MCSValueOld(), ioId, outMCSValueOld);
                -- ������ ������ �� �������� � ���������
                outisMCSNotRecalcOld := vbMCSNotRecalc;
                PERFORM lpInsertUpdate_objectBoolean (zc_ObjectBoolean_Price_MCSNotRecalcOld(), ioId, outisMCSNotRecalcOld);
            END IF;

            ---
            PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), ioId, inMCSValue);
            -- ��������� ��-�� < ���� ��������� ������������ ��������� ������>
            outMCSDateChange := CURRENT_DATE;
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), ioId, outMCSDateChange);

            --
            outStartDateMCSAuto := CURRENT_DATE;
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_StartDateMCSAuto(), ioId, outStartDateMCSAuto);
            --
            outEndDateMCSAuto := outStartDateMCSAuto + ((inDays - 1) :: TVarChar || ' DAY') :: INTERVAL; 
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_EndDateMCSAuto(), ioId, outEndDateMCSAuto);

            --
            ioMCSNotRecalc := True;
--            PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSNotRecalc(), ioId, True);
        END IF;
    END IF;

    -- ��������� ��-�� < ����������� �������� ����� ��� ��� >
    IF (inMCSValueSun is not null) AND (inMCSValueSun <> COALESCE(vbMCSValueSun,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValueSun(), ioId, inMCSValueSun);
    END IF;

    -- ��������� ��-�� < % ������� >
    IF (inPercentMarkup is not null) AND (inPercentMarkup <> COALESCE(vbPercentMarkup,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_PercentMarkup(), ioId, inPercentMarkup);
        -- ��������� ��-�� < ���� ��������� >
        outPercentMarkupDateChange := CURRENT_DATE;
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
        IF COALESCE(inMCSIsClose, False) = TRUE AND COALESCE (inMCSValue, 0) <> 0
        THEN
           PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), ioId, 0);
        END IF;
    END IF;
    
    IF (ioMCSNotRecalc is not null) AND (COALESCE(vbMCSNotRecalc,False) <> ioMCSNotRecalc)
    THEN
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSNotRecalc(), ioId, ioMCSNotRecalc);
        outMCSNotRecalcDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSNotRecalcDateChange(), ioId, outMCSNotRecalcDateChange);
    END IF;

    IF (inMCSValue_min IS NOT NULL) AND (COALESCE(vbMCSValue_min, 0) <> inMCSValue_min)
    THEN
        -- ��������� ��-�� ��� ���
        PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_Price_MCSValueMin(), ioId, inMCSValue_min);
    END IF;
    
    outisMCSAuto := COALESCE (outisMCSAuto,False);
    outisMCSNotRecalcOld:= COALESCE (outisMCSNotRecalcOld,False);

    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
        
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 21.01.20                                                                      * ���-�� ���� ��� ������� �� ����� 7 ��� �������
 21.12.19                                                                      * ��� ��� ���
 30.11.18         *
 13.06.17         * ��� Object_Price_View
 09.06.17         *
 04.07.16         *
 22.12.15                                                         *
 29.08.15                                                         *
 08.06.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Price()