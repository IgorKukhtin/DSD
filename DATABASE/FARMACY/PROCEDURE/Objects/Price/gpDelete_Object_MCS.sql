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
    -- ������� ������ �� ���
	DELETE FROM ObjectFloat
    WHERE 
	    DescId = zc_ObjectFloat_Price_MCSValue()
		AND
	    ObjectId in (SELECT ID FROM Object_Price_View WHERE UnitId = inUnitID);
	
	-- ������� ������ �� ����� ��� / 
	DELETE FROM ObjectDate
    WHERE 
	    DescId in (zc_ObjectDate_Price_MCSDateChange()
                  ,zc_ObjectDate_Price_MCSIsCloseDateChange()
                  ,zc_ObjectDate_Price_MCSNotRecalcDateChange())
	    AND
	    ObjectId in (SELECT ID FROM Object_Price_View WHERE UnitId = inUnitID);
	
	-- ������� ������ �� ������ "�������" � "�� �������������" ���
	DELETE FROM ObjectBoolean
    WHERE 
	    DescId in (zc_ObjectBoolean_Price_MCSIsClose(),zc_ObjectBoolean_Price_MCSNotRecalc())
	    AND
	    ObjectId in (SELECT ID FROM Object_Price_View WHERE UnitId = inUnitID);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_MCS (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 27.10.15                                                           *
*/

