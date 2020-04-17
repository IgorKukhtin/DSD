-- Function: gpGet_ObjectHistory_PersentSalary ()

DROP FUNCTION IF EXISTS gpGet_ObjectHistory_PersentSalary (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_PersentSalary(
    IN inRetailId             Integer   , -- �������� ����
    IN inOperDate             TDateTime , -- ���� �������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer
             , StartDate TDateTime
             , PersentSalary TFloat
             )
AS
$BODY$
BEGIN

    -- �������� ������
    RETURN QUERY
        WITH 
        ObjectHistory_PersentSalary AS
           (SELECT * 
            FROM ObjectHistory
            WHERE ObjectHistory.ObjectId = inRetailId
              AND ObjectHistory.DescId = zc_ObjectHistory_PersentSalary()
              AND inOperDate >= ObjectHistory.StartDate 
              AND inOperDate < ObjectHistory.EndDate
            )

        SELECT
            ObjectHistory_PersentSalary.Id                                              AS Id
          , COALESCE(ObjectHistory_PersentSalary.StartDate, Empty.StartDate)            AS StartDate
          , ObjectHistoryFloat_PersentSalary_MCSValue.ValueData                         AS MCSValue
          , ObjectHistoryFloat_PersentSalary_Value.ValueData                            AS PersentSalary
        FROM 
            ObjectHistory_PersentSalary
            FULL JOIN (SELECT zc_DateStart() AS StartDate
                            , inRetailId AS ObjectId 
                      ) AS Empty
                        ON Empty.ObjectId = ObjectHistory_PersentSalary.ObjectId

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PersentSalary_Value
                                         ON ObjectHistoryFloat_PersentSalary_Value.ObjectHistoryId = ObjectHistory_PersentSalary.Id
                                        AND ObjectHistoryFloat_PersentSalary_Value.DescId = zc_ObjectHistoryFloat_PersentSalary_Value();
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 24.12.15                                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_ObjectHistory_PersentSalary (0, CURRENT_TIMESTAMP)
