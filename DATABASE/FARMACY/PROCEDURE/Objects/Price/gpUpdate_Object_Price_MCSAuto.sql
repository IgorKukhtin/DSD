-- Function: gpUpdate_Object_Price_MCSAuto (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Price_MCSAuto (TFloat, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Price_MCSAuto(
    IN inMCSValue                 TFloat    ,    -- ����������� �������� �����
    IN inGoodsId                  Integer   ,    -- �����
    IN inDays                     TFloat    ,    -- ���-�� ���� ������� ���

   OUT outMCSValueOld             TFloat    ,    -- ��� - �������� ������� �������� �� ��������� �������
   OUT outMCSDateChange           TDateTime ,    -- ���� ��������� ������������ ��������� ������
   OUT outStartDateMCSAuto        TDateTime ,    -- ���� ���. �������� ��� (����)
   OUT outEndDateMCSAuto          TDateTime ,    -- ���� �����. �������� ��� (����)
   OUT outMCSNotRecalcDateChange  TDateTime ,    -- ���� ��������� �������� "������������ ����"
   OUT outIsMCSNotRecalc          Boolean   ,    -- ������������ ���� - ���������� ��������
   OUT outIsMCSNotRecalcOld       Boolean   ,    -- ������������ ���� - �������� ������� �������� �� ��������� �������
   OUT outIsMCSAuto               Boolean   ,    -- ����� - ��� �� ������

    IN inSession                  TVarChar       -- ������ ������������
)
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbUnitId  Integer;
    DECLARE vbPriceId Integer;
    DECLARE vbPrice   TFloat;

    DECLARE vbMCSValue       TFloat;
    DECLARE vbMCSNotRecalc   Boolean;
    DECLARE vbDate           TDateTime;
    DECLARE vbIsMCSAuto_old  Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
 
    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
       AND COALESCE (inDays, 0) > 7
    THEN
      RAISE EXCEPTION '������. ���-�� ���� ��� ������� ������ ���� �� ����� 7.';     
    END IF;         

    -- ��������� 
    IF inMCSValue is not null AND (inMCSValue<0)
    THEN
        RAISE EXCEPTION '������.����������� �������� ����� <%> �� ����� ���� ������ 0.', inMCSValue;
    END IF;

    IF COALESCE (inDays,0) = 0
    THEN
        RAISE EXCEPTION '������.���-�� ���� ��� ������� ������ ���� ������ 0.';
    END IF;   

    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
       AND COALESCE (inDays, 0) > 7
    THEN
      RAISE EXCEPTION '������. ���-�� ���� ��� ������� ������ ���� �� ����� 7.';     
    END IF;         

    -- ����� UnitId
    vbUnitId:= COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '0') :: Integer;

    IF EXISTS (SELECT 1 FROM ObjectBoolean AS ObjectBoolean_NotCashMCS
               WHERE ObjectBoolean_NotCashMCS.ObjectId = vbUnitId
                 AND ObjectBoolean_NotCashMCS.DescId = zc_ObjectBoolean_Unit_NotCashMCS()
                 AND ObjectBoolean_NotCashMCS.ValueData = TRUE)
    THEN
        RAISE EXCEPTION '������.��������� ��� �� ������������� ���������.';
    END IF;   
    
    -- ����� ������� ����
    vbPriceId:= (SELECT ObjectLink_Price_Unit.ObjectId AS Id
                 FROM ObjectLink AS ObjectLink_Price_Unit
                      INNER JOIN ObjectLink AS Price_Goods
                                            ON Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                                           AND Price_Goods.DescId        =  zc_ObjectLink_Price_Goods()
                                           AND Price_Goods.ChildObjectId = inGoodsId
                 WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                );
    
    
    -- ���� ����� ������ ���� - ������� � ����� ����.-�����
    SELECT Id, 
           Price, 
           MCSValue, 
           MCSDateChange, 
           MCSNotRecalc,

           MCSValueOld,
           StartDateMCSAuto,
           EndDateMCSAuto,
           isMCSNotRecalcOld,
           isMCSAuto, isMCSAuto
      INTO vbPriceId, 
           vbPrice,
           vbMCSValue, 
           outMCSDateChange,
           vbMCSNotRecalc,

           outMCSValueOld,
           outStartDateMCSAuto,
           outEndDateMCSAuto,
           outisMCSNotRecalcOld,
           outisMCSAuto, vbIsMCSAuto_old
    FROM (WITH tmp1 AS (SELECT Object_Price.Id                         AS Id
                             , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                             , MCS_datechange.valuedata                AS MCSDateChange
                             , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
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
                                      AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                               LEFT JOIN ObjectFloat       AS Price_Value
                                      ON Price_Value.ObjectId = Object_Price.Id
                                     AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
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
                               LEFT JOIN ObjectBoolean     AS MCS_isClose
                                      ON MCS_isClose.ObjectId = Object_Price.Id
                                     AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                               LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                                      ON MCS_NotRecalc.ObjectId = Object_Price.Id
                                     AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()

                               LEFT JOIN ObjectBoolean     AS Price_MCSAuto
                                      ON Price_MCSAuto.ObjectId = Object_Price.Id
                                     AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                               LEFT JOIN ObjectBoolean     AS Price_MCSNotRecalcOld
                                      ON Price_MCSNotRecalcOld.ObjectId = Object_Price.Id
                                     AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()
                              WHERE Object_Price.Id = vbPriceId
                                AND Object_Price.DescId = zc_Object_Price() )
          SELECT  * FROM tmp1) AS tmp;



      -- ����� �������� ��� �� ���.����
      vbDate := CURRENT_DATE - INTERVAL '1 DAY';
      SELECT ObjectHistoryFloat_MCSValue.ValueData
             INTO outMCSValueOld
        FROM ObjectHistory
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValue
                                             ON ObjectHistoryFloat_MCSValue.ObjectHistoryId = ObjectHistory.Id
                                            AND ObjectHistoryFloat_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()                
        WHERE ObjectHistory.ObjectId = vbPriceId
          AND ObjectHistory.DescId   = zc_ObjectHistory_Price()
          AND vbDate >= ObjectHistory.StartDate AND CURRENT_DATE < ObjectHistory.EndDate;


        -- ��������� �������� <��� ��� �������>
        outisMCSAuto := TRUE;
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSAuto(), vbPriceId, outisMCSAuto);
    

        -- !!!������ � ���� ������!!!
        IF COALESCE (vbIsMCSAuto_old, FALSE) = FALSE
        THEN
             -- ��������� ������� �������� ���
             PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_Price_MCSValueOld(), vbPriceId, outMCSValueOld);
             -- ������ ������ �� �������� � ���������
             outisMCSNotRecalcOld := vbMCSNotRecalc;
             PERFORM lpInsertUpdate_objectBoolean (zc_ObjectBoolean_Price_MCSNotRecalcOld(), vbPriceId, outisMCSNotRecalcOld);
        END IF;
             

        ---
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), vbPriceId, inMCSValue);
        -- ��������� ��-�� < ���� ��������� ������������ ��������� ������>
        outMCSDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), vbPriceId, outMCSDateChange);

        --
        outStartDateMCSAuto := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_StartDateMCSAuto(), vbPriceId, outStartDateMCSAuto);
        --
        outEndDateMCSAuto := outStartDateMCSAuto + ((inDays - 1) :: TVarChar || ' DAY') :: INTERVAL; 
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_EndDateMCSAuto(), vbPriceId, outEndDateMCSAuto);

        -- 
        outisMCSNotRecalc := TRUE;
        IF (COALESCE(vbMCSNotRecalc,False) <> outisMCSNotRecalc)
        THEN
          PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSNotRecalc(), vbPriceId, outisMCSNotRecalc);
          outMCSNotRecalcDateChange := CURRENT_DATE;
          PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSNotRecalcDateChange(), vbPriceId, outMCSNotRecalcDateChange);
        END IF;


        -- ��������� �������
        IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
        THEN
            -- ��������� �������
            PERFORM gpInsertUpdate_ObjectHistory_Price(
                ioId       := 0 :: Integer,    -- ���� ������� <������� ������� ������>
                inPriceId  := vbPriceId   ,    -- �����
                inOperDate := CURRENT_TIMESTAMP                 :: TDateTime, -- ���� �������� ������
                inPrice    := COALESCE (vbPrice,0)              :: TFloat,    -- ����
                inMCSValue := COALESCE (inMCSValue, vbMCSValue) :: TFloat,    -- ���
                inMCSPeriod:= 0                                 :: TFloat,    -- ���������� ���� ��� ������� ���
                inMCSDay   := 0                                 :: TFloat,    -- ��������� ����� ���� ���
                inSession  := inSession);
           -- ����������
           --outStartDate:= (SELECT MAX (StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = vbPriceId AND DescId = zc_ObjectHistory_Price());
 
        END IF;

    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (vbPriceId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 21.01.20                                                                      * ���-�� ���� ��� ������� �� ����� 7 ��� �������
 19.06.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Price_MCSAuto()
--select * from gpUpdate_Object_Price_MCSAuto(inMCSValue := 4 ::TFloat , inGoodsId := 652, inDays := 3 ::TFloat,  inSession := '3'::TVarChar);
