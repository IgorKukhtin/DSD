-- Function: gpGet_ObjectHistory_PesentSalary ()

DROP FUNCTION IF EXISTS gpGet_ObjectHistory_PesentSalary (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_PesentSalary(
    IN inRetailId             Integer   , -- �������� ����
    IN inOperDate             TDateTime , -- ���� �������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer
             , StartDate TDateTime
             , PesentSalary TFloat
             )
AS
$BODY$
BEGIN

    -- �������� ������
    RETURN QUERY
        WITH 
        ObjectHistory_PesentSalary AS
           (SELECT * 
            FROM ObjectHistory
            WHERE ObjectHistory.ObjectId = inRetailId
              AND ObjectHistory.DescId = zc_ObjectHistory_PesentSalary()
              AND inOperDate >= ObjectHistory.StartDate 
              AND inOperDate < ObjectHistory.EndDate
            )

        SELECT
            ObjectHistory_PesentSalary.Id                                              AS Id
          , COALESCE(ObjectHistory_PesentSalary.StartDate, Empty.StartDate)            AS StartDate
          , ObjectHistoryFloat_PesentSalary_MCSValue.ValueData                         AS MCSValue
          , ObjectHistoryFloat_PesentSalary_Value.ValueData                            AS PesentSalary
        FROM 
            ObjectHistory_PesentSalary
            FULL JOIN (SELECT zc_DateStart() AS StartDate
                            , inRetailId AS ObjectId 
                      ) AS Empty
                        ON Empty.ObjectId = ObjectHistory_PesentSalary.ObjectId

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PesentSalary_Value
                                         ON ObjectHistoryFloat_PesentSalary_Value.ObjectHistoryId = ObjectHistory_PesentSalary.Id
                                        AND ObjectHistoryFloat_PesentSalary_Value.DescId = zc_ObjectHistoryFloat_PesentSalary_Value();
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 24.12.15                                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_ObjectHistory_PesentSalary (0, CURRENT_TIMESTAMP)
