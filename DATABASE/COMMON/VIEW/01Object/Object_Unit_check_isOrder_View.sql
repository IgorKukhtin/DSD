-- View: Object_Unit_check_isOrder_View_two

-- DROP VIEW IF EXISTS Object_Unit_check_isOrder_View_two;

CREATE OR REPLACE VIEW Object_Unit_check_isOrder_View_two AS

   SELECT Object_Unit.Id         AS UnitId
        , Object_Unit.ObjectCode AS UnitCode
        , Object_Unit.ValueData  AS UnitName
   FROM Object AS Object_Unit
   WHERE Object_Unit.Id = 8459 -- ����������� ��������
   --AND 1=0
   ;

ALTER TABLE Object_Unit_check_isOrder_View_two OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.09.22                                        *
*/

-- ����
-- SELECT * FROM Object_Unit_check_isOrder_View_two
