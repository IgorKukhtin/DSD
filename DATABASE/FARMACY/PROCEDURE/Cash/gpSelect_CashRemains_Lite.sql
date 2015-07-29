-- Function: gpSelect_CashRemains_Lite()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_Lite (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_Lite(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, Remains TFloat)
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbUnitKey TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    RETURN QUERY
        SELECT 
            container.objectid,
            SUM(Amount)::TFloat AS Remains
        FROM container
            INNER JOIN containerlinkobject AS CLO_Unit
                                           ON CLO_Unit.containerid = container.id 
                                          AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                          AND CLO_Unit.objectid = vbUnitId
        WHERE 
            container.descid = zc_container_count() 
            AND 
            Amount<>0
        GROUP BY 
            container.objectid;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_Lite (TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 29.07.15                                                                       *
*/
-- ����
-- SELECT * FROM gpSelect_CashRemains_Lite (inSession:= '308120')