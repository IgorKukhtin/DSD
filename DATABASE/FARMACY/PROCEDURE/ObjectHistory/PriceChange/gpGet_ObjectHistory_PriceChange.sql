-- Function: gpGet_ObjectHistory_PriceChange ()

DROP FUNCTION IF EXISTS gpGet_ObjectHistory_PriceChange (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_PriceChange(
    IN inPriceChangeId        Integer   , -- ��.����
    IN inOperDate             TDateTime , -- ���� �������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, StartDate TDateTime, 
               PriceChange TFloat, MCSValue TFloat)
AS
$BODY$
BEGIN

    -- �������� ������
    RETURN QUERY
        WITH ObjectHistory_PriceChange AS
        (
            SELECT 
                * 
            FROM 
                ObjectHistory
            WHERE 
                ObjectHistory.ObjectId = inPriceChangeId
                AND 
                ObjectHistory.DescId = zc_ObjectHistory_PriceChange()
                AND 
                inOperDate >= ObjectHistory.StartDate 
                AND 
                inOperDate < ObjectHistory.EndDate
        )
        SELECT
            ObjectHistory_PriceChange.Id                                              AS Id
          , COALESCE(ObjectHistory_PriceChange.StartDate, Empty.StartDate)            AS StartDate
          , ObjectHistoryFloat_PriceChange_MCSValue.ValueData                         AS MCSValue
          , ObjectHistoryFloat_PriceChange_Value.ValueData                            AS PriceChange
        FROM 
            ObjectHistory_PriceChange
            FULL JOIN (
                        SELECT 
                            zc_DateStart() AS StartDate, 
                            inPriceChangeId AS ObjectId 
                      ) AS Empty
                        ON Empty.ObjectId = ObjectHistory_PriceChange.ObjectID
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange_MCSValue
                                         ON ObjectHistoryFloat_PriceChange_MCSValue.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                        AND ObjectHistoryFloat_PriceChange_MCSValue.DescId = zc_ObjectHistoryFloat_PriceChange_MCSValue()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange_Value
                                         ON ObjectHistoryFloat_PriceChange_Value.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                        AND ObjectHistoryFloat_PriceChange_Value.DescId = zc_ObjectHistoryFloat_PriceChange_Value();
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_ObjectHistory_PriceChange (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 24.12.15                                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_ObjectHistory_PriceChange (0, CURRENT_TIMESTAMP)
