 -- Function: lpUpdate_Object_Price_restore ()

DROP FUNCTION IF EXISTS lpUpdate_Object_Price_restore ();

CREATE OR REPLACE FUNCTION lpUpdate_Object_Price_restore()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������������
     -- SELECT *,
     PERFORM
       gpInsertUpdate_ObjectHistory_Price(
                     ioId       := 0 :: Integer       -- ���� ������� <������� ������� ������>
                   , inPriceId  := tmp.Id             -- �����
                   , inOperDate := CURRENT_TIMESTAMP  -- ���� �������� ������
                   , inPrice    := Price_Value.ValueData      -- ����
                   , inMCSValue := tmp.MCSValueOld    -- ���
                   , inMCSPeriod:= ObjectHistoryFloat_MCSPeriod.ValueData       -- ���������� ���� ��� ������� ���
                   , inMCSDay   := ObjectHistoryFloat_MCSDay.ValueData          -- ��������� ����� ���� ���
                   , inSession  := '4972063'           --  ���� - ���
                    )
     FROM
         (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                 , MCS_Value.ValueData                     AS MCSValue 
                 , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat AS MCSValueOld         
     
                                 , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc 
                                 , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld
     
                                 , MCS_StartDateMCSAuto.ValueData                      AS StartDateMCSAuto
                                 , MCS_EndDateMCSAuto.ValueData                        AS EndDateMCSAuto
     
                                 , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
     
                   -- ��������� �������� <��� ��� �������>
                 , lpInsertUpdate_objectBoolean (zc_ObjectBoolean_Price_MCSAuto(), ObjectLink_Price_Unit.ObjectId, FALSE)
                 -- ��������� �������� ���
                 , lpInsertUpdate_objectFloat (zc_ObjectFloat_Price_MCSValue(), ObjectLink_Price_Unit.ObjectId, COALESCE(Price_MCSValueOld.ValueData,0))
                 -- ��������� 
                 , lpInsertUpdate_objectBoolean (zc_ObjectBoolean_Price_MCSNotRecalc(), ObjectLink_Price_Unit.ObjectId, COALESCE (Price_MCSNotRecalcOld.ValueData, False))
     
                            FROM ObjectLink        AS ObjectLink_Price_Unit
     
                                 LEFT JOIN ObjectFloat       AS MCS_Value
                                         ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                                 LEFT JOIN ObjectFloat       AS Price_MCSValueOld
                                         ON Price_MCSValueOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()
     
                                 LEFT JOIN ObjectDate        AS MCS_StartDateMCSAuto
                                         ON MCS_StartDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
                                 LEFT JOIN ObjectDate        AS MCS_EndDateMCSAuto
                                         ON MCS_EndDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()
     
                                 
                                 LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                                         ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                                 LEFT JOIN ObjectBoolean     AS Price_MCSNotRecalcOld
                                         ON Price_MCSNotRecalcOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()
     
                                 INNER JOIN ObjectBoolean     AS Price_MCSAuto
                                         ON Price_MCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                                        AND Price_MCSAuto.ValueData = TRUE
     
                            WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                              AND MCS_EndDateMCSAuto.ValueData < CURRENT_DATE
     ) AS tmp
     
           LEFT JOIN ObjectHistory ON ObjectHistory.ObjectId = tmp.Id
                                  AND ObjectHistory.EndDate  = zc_DateEnd() -- !!!�����, �� ����� ���������!!!
                                  AND ObjectHistory.DescId   = zc_ObjectHistory_Price()
           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriod
                                        ON ObjectHistoryFloat_MCSPeriod.ObjectHistoryId = ObjectHistory.Id
                                       AND ObjectHistoryFloat_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSDay
                                       ON ObjectHistoryFloat_MCSDay.ObjectHistoryId = ObjectHistory.Id
                                      AND ObjectHistoryFloat_MCSDay.DescId = zc_ObjectHistoryFloat_Price_MCSDay() 
     
           LEFT JOIN ObjectFloat       AS Price_Value
                                       ON Price_Value.ObjectId = tmp.Id
                                      AND Price_Value.DescId = zc_ObjectFloat_Price_Value();


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 30.07.17                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_Object_Price_restore ()
