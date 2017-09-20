-- Function: gpUpdate_Object_Price_MCS_byReport (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Price_MCS_byReport (Integer, Integer, TFloat, TFloat,  Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Price_MCS_byReport(
    IN inUnitId                   Integer   ,    -- �������������
    IN inGoodsId                  Integer   ,    -- �����
    IN inMCSValue                 TFloat    ,    -- ����������� �������� �����
    IN inDays                     TFloat    ,    -- ���-�� ���� ������� ���
    IN inisMCSAuto                Boolean   ,    -- ����� - ��� �������� ��������� �� ������
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE
        vbUserId       Integer;
        vbMCSValue     TFloat;
        vbMCSValueOld  TFloat;
        vbMCSIsClose   Boolean;
        vbMCSNotRecalc Boolean;
        vbDate               TDateTime;
        vbEndDateMCSAuto     TDateTime;
    DECLARE vbIsMCSAuto_old  Boolean;
    DECLARE vbPrice   TFloat;
    DECLARE vbPriceId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    IF COALESCE (inMCSValue, 0) = 0
    THEN
        Return;
    END IF;
    
    -- ��������� ������������ ���
    IF inMCSValue is not null AND (inMCSValue<0)
    THEN
        RAISE EXCEPTION '������.����������� �������� ����� <%> �� ����� ���� ������ 0.', inMCSValue;
    END IF;

    IF COALESCE (inisMCSAuto,False) = True AND COALESCE (inDays,0) = 0
    THEN
        RAISE EXCEPTION '������.���-�� ���� ��� ������� ������ ���� ������ 0.';
    END IF;    

    -- ����� ������� ����
    vbPriceId:= (SELECT ObjectLink_Price_Unit.ObjectId AS Id
                 FROM ObjectLink AS ObjectLink_Price_Unit
                      INNER JOIN ObjectLink AS Price_Goods
                                            ON Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                                           AND Price_Goods.DescId        =  zc_ObjectLink_Price_Goods()
                                           AND Price_Goods.ChildObjectId = inGoodsId
                 WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                   AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                );
                
    -- ���� ����� ������ ���� - ������� � ����� ����.-�����
    SELECT Id, 
           Price, 
           MCSValue, 
           MCSNotRecalc,
           MCSValueOld,
           isMCSAuto
      INTO vbPriceId, 
           vbPrice, 
           vbMCSValue, 
           vbMCSNotRecalc,
           vbMCSValueOld,
           vbIsMCSAuto_old
    FROM (WITH tmp1 AS (SELECT Object_Price.Id                         AS Id
                             , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
                             , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat     AS MCSValueOld
                             , COALESCE(Price_MCSAuto.ValueData,False)    :: Boolean   AS isMCSAuto
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
                               LEFT JOIN ObjectFloat       AS MCS_Value
                                      ON MCS_Value.ObjectId = Object_Price.Id
                                     AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                               LEFT JOIN ObjectFloat       AS Price_MCSValueOld
                                      ON Price_MCSValueOld.ObjectId = Object_Price.Id
                                     AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()
                                   LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                                      ON MCS_NotRecalc.ObjectId = Object_Price.Id
                                     AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                               LEFT JOIN ObjectBoolean     AS Price_MCSAuto
                                      ON Price_MCSAuto.ObjectId = Object_Price.Id
                                     AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                              WHERE Object_Price.Id = vbPriceId
                                AND Object_Price.DescId = zc_Object_Price()
                              )
          SELECT  * FROM tmp1) AS tmp;


    -- ����� �������� ��� �� ���.����
    IF COALESCE (inisMCSAuto,False) = True
    THEN
        vbDate := CURRENT_DATE - INTERVAL '1 DAY';
        SELECT ObjectHistoryFloat_MCSValue.ValueData
      INTO vbMCSValueOld
        FROM ObjectHistory
             LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValue
                                          ON ObjectHistoryFloat_MCSValue.ObjectHistoryId = ObjectHistory.Id
                                         AND ObjectHistoryFloat_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()                
        WHERE ObjectHistory.ObjectId = vbPriceId
          AND ObjectHistory.DescId   = zc_ObjectHistory_Price()
          AND vbDate >= ObjectHistory.StartDate AND CURRENT_DATE < ObjectHistory.EndDate
       ;
    END IF;

   
    IF COALESCE(vbPriceId,0) = 0
    THEN
        -- ���������/�������� <������> �� ��
        vbPriceId := lpInsertUpdate_Object (0, zc_Object_Price(), 0, '');

        -- ��������� ����� � <�����>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), vbPriceId, inGoodsId);

        -- ��������� ����� � <�������������>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), vbPriceId, inUnitId);
    END IF;
    
    -- ��������� ��-�� < ����������� �������� ����� >
    IF COALESCE (inisMCSAuto, FALSE) = FALSE
    THEN
        IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
        THEN
            PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), vbPriceId, inMCSValue);
            -- ��������� ��-�� < ���� ��������� ������������ ��������� ������>
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), vbPriceId, CURRENT_DATE);
        END IF;
    ELSE
        --  !!!������!!!
        IF 1=1
        THEN
            -- ��������� �������� <��� ��� �������>
            PERFORM lpInsertUpdate_objectBoolean (zc_ObjectBoolean_Price_MCSAuto(), vbPriceId, inisMCSAuto);
 
            -- !!!������ � ���� ������!!!
            IF COALESCE (vbIsMCSAuto_old, FALSE) = FALSE
            THEN
                -- ��������� ������ �������� ���
                PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_Price_MCSValueOld(), vbPriceId, vbMCSValueOld);
                -- ������ ������ �� �������� � ���������
                PERFORM lpInsertUpdate_objectBoolean (zc_ObjectBoolean_Price_MCSNotRecalcOld(), vbPriceId, vbMCSNotRecalc);
            END IF;

            ---
            PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), vbPriceId, inMCSValue);
            -- ��������� ��-�� < ���� ��������� ������������ ��������� ������>
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), vbPriceId, CURRENT_DATE);

            --
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_StartDateMCSAuto(), vbPriceId, CURRENT_DATE);
            --
            vbEndDateMCSAuto := CURRENT_DATE + ((inDays - 1) :: TVarChar || ' DAY') :: INTERVAL; 
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_EndDateMCSAuto(), vbPriceId, vbEndDateMCSAuto);

        END IF;
    END IF;

    -- ��������� �������
    IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
       
    THEN
        -- ��������� �������
        PERFORM gpInsertUpdate_ObjectHistory_Price(
                ioId       := 0 :: Integer,    -- ���� ������� <������� ������� ������>
                inPriceId  := vbPriceId,       -- �����
                inOperDate := CURRENT_TIMESTAMP                 :: TDateTime, -- ���� �������� ������
                inPrice    := COALESCE (vbPrice, 0)             :: TFloat,    -- ����
                inMCSValue := COALESCE (inMCSValue, vbMCSValue) :: TFloat,    -- ���
                inMCSPeriod:= 0                                 :: TFloat,    -- ���������� ���� ��� ������� ���
                inMCSDay   := 0                                 :: TFloat,    -- ��������� ����� ���� ���
                inSession  := inSession);
    END IF;
    
    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (vbPriceId, vbUserId);
    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 20.09.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Price_MCS_byReport()
