-- Function: gpSelect_Object_Unit_ExportPriceForCostless()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_ExportPriceForCostless(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_ExportPriceForCostless(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Address TVarChar, Contacts TVarChar, Description Text) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY
   WITH
     tmpUnit AS                   (
       SELECT 377606 AS UnitId,
              '(063) 360-68-25, (063) 360-62-11, (056) 234-91-84, (056) 796-02-25, (067) 770-26-93, e-mail - aptekakalinovaya11@gmail.com' AS Contacts,
              '���� ������, � 08:00 �� 21:00 ��� �������� (�������� ������ �������� �� ������ ���� �������������. ��������� �� ���������), ���� ��������� ��� ������ ������' AS Description
       UNION ALL
       SELECT 377574,
              '(063) 360-67-32, (056) 796-02-32, e-mail - aptekakirova121@gmail.com',
              '� 8:00 �� 21:00 ��� ��������, ���� ������, ���� ��������� ��� ������ ������')

       SELECT
             Object_Unit_View.Id
           , ObjectString_Unit_Address.ValueData
           , tmpUnit.Contacts::TVarChar
           , tmpUnit.Description
       FROM tmpUnit AS tmpUnit

         INNER JOIN Object_Unit_View AS Object_Unit_View ON Object_Unit_View.Id = tmpUnit.UnitId

         LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                ON ObjectString_Unit_Address.ObjectId  = tmpUnit.UnitId
                               AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address();

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�
 10.09.19                                                                     *

*/

-- ����
-- SELECT * FROM Object WHERE DescId = zc_Object_Unit();
-- SELECT * FROM gpSelect_Object_Unit_ExportPriceForCostless ('3')
