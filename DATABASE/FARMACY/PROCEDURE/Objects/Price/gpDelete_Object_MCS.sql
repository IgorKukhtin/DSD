-- Function: gpDelete_Object_MCS (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_MCS (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_MCS(
    IN inUnitId     Integer, -- ID �������������
    IN inSession    TVarChar -- ������ ������������
)
RETURNS VOID AS
$BODY$
    DECLARE
        vbUserId Integer;
BEGIN
    vbUserId := lpGetUserBySession (inSession);
    IF COALESCE(inUnitId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� �������������';
    END IF;

    --
    CREATE TEMP TABLE tmpObject_Price (Id Integer, Price TFloat, MCSValue TFloat) ON COMMIT DROP;
    INSERT INTO tmpObject_Price (Id, MCSValue, MCSValue)
        SELECT ObjectLink_Price_Unit.ObjectId          AS Id
             , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
             , MCS_Value.ValueData                     AS MCSValue 
        FROM ObjectLink AS ObjectLink_Price_Unit
             LEFT JOIN ObjectFloat AS Price_Value
                                   ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
             LEFT JOIN ObjectFloat AS MCS_Value
                                   ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
        WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
          AND ObjectLink_Price_Unit.ChildObjectId = inUnitId;

    -- ���������� � ������� 
    PERFORM
        gpInsertUpdate_ObjectHistory_Price(
            ioId       := 0::Integer,    -- ���� ������� <������� ������� ������>
            inPriceId  := tmpObject_Price.ID::Integer,    -- �����
            inOperDate := CURRENT_TIMESTAMP::TDateTime,  -- ���� �������� ������
            inPrice    := tmpObject_Price.Price::TFloat,     -- ����
            inMCSValue := NULL :: TFloat,  -- ���
            inMCSPeriod:= NULL :: TFloat,  -- ���������� ���� ��� ������� ���
            inMCSDay   := NULL :: TFloat,  -- ��������� ����� ���� ���
            inSession  := inSession)
    FROM tmpObject_Price 
    WHERE tmpObject_Price.MCSValue is not null;
        
    -- ������� ������ �� ���
    DELETE FROM ObjectFloat
    WHERE DescId = zc_ObjectFloat_Price_MCSValue()
      AND ObjectId in (SELECT tmpObject_Price.Id FROM tmpObject_Price);
	               
    -- ������� ������ �� ����� ��� / 
    DELETE FROM ObjectDate
    WHERE DescId in (zc_ObjectDate_Price_MCSDateChange()
                   , zc_ObjectDate_Price_MCSIsCloseDateChange()
                   , zc_ObjectDate_Price_MCSNotRecalcDateChange())
      AND ObjectId in (SELECT tmpObject_Price.Id FROM tmpObject_Price);
	
    -- ������� ������ �� ������ "�������" � "�� �������������" ���
    DELETE FROM ObjectBoolean
    WHERE DescId in (zc_ObjectBoolean_Price_MCSIsClose(),zc_ObjectBoolean_Price_MCSNotRecalc())
      AND ObjectId in (SELECT tmpObject_Price.Id FROM tmpObject_Price);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_MCS (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 12.06.17         * ���� �� Object_Price_View
 27.10.15                                                           *
*/

