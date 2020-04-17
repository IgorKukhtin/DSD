-- Function: gpSelect_ObjectHistory_PriceChange ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PersentSalary (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PersentSalary(
    IN inRetailId       Integer   , -- �������� ����
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, StartDate TDateTime
             , PersentSalary TFloat
             , RetailId Integer
             , RetailName TVarChar
               )
AS
$BODY$
BEGIN
     -- �������� ������
    RETURN QUERY
        WITH ObjectHistory_PersentSalary AS
        (
            SELECT * 
            FROM ObjectHistory
            WHERE (ObjectHistory.ObjectId = inRetailId OR inRetailId = 0)
              AND ObjectHistory.DescId = zc_ObjectHistory_PersentSalary()
        )
        SELECT
            ObjectHistory_PersentSalary.Id                                   AS Id
          , COALESCE(ObjectHistory_PersentSalary.StartDate, Empty.StartDate) AS StartDate
          , ObjectHistoryFloat_PersentSalary_Value.ValueData                 AS PersentSalary

          , Object_Retail.Id        AS RetailId
          , Object_Retail.ValueData AS RetailName
        FROM 
            ObjectHistory_PersentSalary
            FULL JOIN (
                        SELECT 
                            zc_DateStart() AS StartDate, 
                            inRetailId AS ObjectId 
                        WHERE COALESCE (inRetailId,0) <> 0
                      ) AS Empty
                        ON Empty.ObjectId = ObjectHistory_PersentSalary.ObjectId

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PersentSalary_Value
                                         ON ObjectHistoryFloat_PersentSalary_Value.ObjectHistoryId = ObjectHistory_PersentSalary.Id
                                        AND ObjectHistoryFloat_PersentSalary_Value.DescId = zc_ObjectHistoryFloat_PersentSalary_Value()

            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectHistory_PersentSalary.ObjectId

           ;


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 16.04.20         *
*/

-- ����
-- SELECT * FROM gpSelect_ObjectHistory_PersentSalary (0, '')
