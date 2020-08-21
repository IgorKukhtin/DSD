-- Function: gpSelect_Object_Unit_BookingsForTabletki()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_BookingsForTabletki(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_BookingsForTabletki(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Name TVarChar
             , SerialNumber Integer) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY

     SELECT
           Object_Unit.ID
         , Object_Unit.ValueData
         , ObjectFloat_SerialNumberTabletki.ValueData::Integer   AS SerialNumber
     FROM Object AS Object_Unit

          INNER JOIN ObjectFloat AS ObjectFloat_SerialNumberTabletki
                                 ON ObjectFloat_SerialNumberTabletki.ObjectId = Object_Unit.Id
                                AND ObjectFloat_SerialNumberTabletki.DescId = zc_ObjectFloat_Unit_SerialNumberTabletki()

     WHERE Object_Unit.isErased = False
       AND Object_Unit.descid = zc_Object_Unit()
       AND COALESCE (ObjectFloat_SerialNumberTabletki.ValueData, 0) <> 0
     ORDER BY Object_Unit.Id;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�
 25.03.20                                                                     *

*/

-- ����
--
SELECT * FROM gpSelect_Object_Unit_BookingsForTabletki ('3')